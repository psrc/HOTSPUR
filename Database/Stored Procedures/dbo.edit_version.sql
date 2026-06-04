SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[edit_version] 
@name NVARCHAR (97),
@edit_action INTEGER AS SET NOCOUNT ON
BEGIN

  /* This is a public procedure to toggle an SDE version's editability.
  If edit_action is 1, the version will be made editable by creating
  a new state as the child of the version's current state. The version
  will then point to this new state. The version will also be made the
  current version for versioned views.
  If edit_action is 2, the version will no longer be editable. The state
  it is pointing to will be closed. */
  -- Setup possible return codes

  DECLARE @SE_NO_PERMISSIONS INTEGER
  SET @SE_NO_PERMISSIONS = 50025

  DECLARE @SE_LOCK_CONFLICT INTEGER
  SET @SE_LOCK_CONFLICT = 50049

  DECLARE @SE_INVALID_PARAM_VALUE INTEGER
  SET @SE_INVALID_PARAM_VALUE = 50066

  DECLARE @SE_VERSION_NOEXIST INTEGER
  SET @SE_VERSION_NOEXIST = 50126

  DECLARE @SE_STATE_NOEXIST INTEGER
  SET @SE_STATE_NOEXIST = 50172

  DECLARE @SE_VERSION_HAS_MOVED INTEGER
  SET @SE_VERSION_HAS_MOVED = 50174

  DECLARE @SE_PARENT_NOT_CLOSED INTEGER
  SET @SE_PARENT_NOT_CLOSED = 50176

  DECLARE @SE_TRANS_IN_PROGRESS INTEGER
  SET @SE_TRANS_IN_PROGRESS = 50068

  DECLARE @SE_MVV_IN_EDIT_MODE INTEGER
  SET @SE_MVV_IN_EDIT_MODE = 50501

  DECLARE @SE_MVV_NAMEVER_NOT_CURRVER INTEGER
  SET @SE_MVV_NAMEVER_NOT_CURRVER = 50503

  DECLARE @parsed_name NVARCHAR(64)
  DECLARE @parsed_owner NVARCHAR(128)
  DECLARE @node_name  NVARCHAR(256)
  DECLARE @error_string NVARCHAR(256)
  DECLARE @ret_code INTEGER

  DECLARE @sql AS NVARCHAR (256)
  -- Check arguments.

  IF @edit_action IS NULL
  BEGIN
    RAISERROR ('Edit action may not be NULL.',16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END
  ELSE IF @edit_action < 1 OR @edit_action > 2
  BEGIN
    SET @error_string = cast (@edit_action AS VARCHAR (10)) + 
                       ' is not a valid edit action code.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  -- Parse the version name
  EXECUTE @ret_code = dbo.SDE_parse_version_name @name,
          @parsed_name OUTPUT, @parsed_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  -- Do not allow editing of default version.

  IF (@parsed_name = 'DEFAULT') AND (@parsed_owner = 'dbo')
  BEGIN
    SET @error_string = 'Cannot edit the DEFAULT version in STANDARD transaction mode.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  -- Get the information we need from the version.

  DECLARE @version_id INTEGER
  DECLARE @state_id BIGINT
  DECLARE @status INTEGER

  DECLARE @current_user NVARCHAR(128)
  EXECUTE dbo.SDE_get_current_user_name @current_user OUTPUT

  SELECT @version_id = version_id, @state_id = state_id,
         @status = status
  FROM   dbo.SDE_versions
  WHERE  name = @parsed_name AND
         owner = @parsed_owner

  IF @version_id IS NULL
  BEGIN
    SET @error_string = 'Version ' + @name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  -- Check if we are already in an edit session.
  DECLARE @g_state_id BIGINT
  DECLARE @g_protected CHAR(1)
  DECLARE @g_is_default CHAR(1)
  DECLARE @g_version_id INTEGER
  EXECUTE dbo.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
  IF @edit_action = 1
  BEGIN
    DECLARE @exists INTEGER
    IF (@g_version_id != -1) AND (@g_version_id != @version_id)
    BEGIN
      -- Check that version and state still exist (e.g. may have been rolled back)
      SELECT @exists = count(*) from dbo.SDE_versions
        WHERE version_id = @g_version_id
      IF @exists > 0
      BEGIN
        SELECT @exists = count(*) from dbo.SDE_states
          WHERE state_id = @g_state_id
        IF @exists > 0
        BEGIN
          SET @error_string = 'Cannot start edit on a new version with an open edit session to another version.'
          RAISERROR (@error_string,16,-1)
          RETURN @SE_MVV_IN_EDIT_MODE
        END
      END
    END
    IF @g_version_id = @version_id
    BEGIN
      SELECT @exists = count(*) from dbo.SDE_states
        WHERE state_id = @g_state_id
      IF @exists > 0
        RETURN 0 -- no-op
    END
  END
  ELSE
  BEGIN
    IF @g_version_id != @version_id
    BEGIN
      IF @g_version_id = -1
        SET @error_string = 'Not currently editing a version, cannot stop edit.'
      ELSE
        SET @error_string = 'Cannot stop edit on ' + @name + ' while version id ' + 
          cast (@g_version_id AS VARCHAR(10)) + ' is the current edit version.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_MVV_NAMEVER_NOT_CURRVER
    END
  END

  -- Check permissions.  At least one of the following must be true for this
  -- operation:  (1) The version must be public, or
  --             (2) The current user is the version's owner, or
  --             (3) The current user is the SDE DBA user.

  DECLARE @protected CHAR (1)

  SET @protected = dbo.SDE_get_version_access (@status, @parsed_owner)
  IF @protected = '1' OR @protected = '2'
  BEGIN
    SET @error_string = 'Insufficient access to version ' + @name
    RAISERROR (@error_string,16,-1)
    RETURN @SE_NO_PERMISSIONS
  END

  -- Get an sde connection id for locking purposes

  DECLARE @connection_id INTEGER
  DECLARE @conn_tab NVARCHAR(95)
  DECLARE @conntab_unqualified  NVARCHAR(95)
  DECLARE @admin_db NVARCHAR(128) = db_name()
  IF @edit_action = 2
  BEGIN
    SELECT @connection_id = sde_id from dbo.SDE_process_information WHERE spid = @@spid
    SET @conntab_unqualified = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_' + @admin_db 
  END
  IF @edit_action = 1 OR @connection_id IS NULL
  BEGIN
    EXECUTE dbo.SDE_get_primary_oid 12, 1, @connection_id OUTPUT

  -- We also need to insert into the process info table, otherwise if
  -- another process detects a lock conflict, this lock will be dropped
  -- since it doesn't belong to a valid SDE connection in the
  -- process info table.

    DECLARE @server_id INTEGER
    SET @conntab_unqualified = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_' + @admin_db 
    SET @sql = N'CREATE TABLE ' + @conntab_unqualified + N' (keycol INTEGER)'
    EXEC (@sql)
    SET @conn_tab = N'tempdb.' + @current_user + N'.' + @conntab_unqualified
    SET @node_name = HOST_NAME()
    SET @server_id = HOST_ID()
    EXECUTE dbo.SDE_pinfo_def_insert @connection_id, @server_id,
      'Y','Win32',@node_name,'F',@conn_tab

  END
  -- Lock the version's state if this is a open edit.

  IF @edit_action = 1
  BEGIN
    EXECUTE @ret_code = dbo.SDE_state_lock_def_insert @connection_id,
                       @state_id, 'Y', 'S'

    IF @ret_code = -49
      SET @ret_code = @SE_LOCK_CONFLICT
    IF @ret_code != 0
    BEGIN
      SET @sql = N'DROP TABLE ' + @conntab_unqualified
      EXEC (@sql)
      EXECUTE dbo.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'Lock conflict detected for state ' + cast(@state_id as varchar(10))
      RAISERROR (@error_string,16,-1)
      RETURN @ret_code
    END
  END

  DECLARE @state_owner NVARCHAR(128)
  DECLARE @closing_time DATETIME
  DECLARE @parent_lineage_name BIGINT

  DECLARE @current_date DATETIME
  SET @current_date = GETDATE ()

  -- Perform version open or close for editing.

  IF @edit_action = 2
  BEGIN
    -- If we are done editing, close the state.
    -- Make sure that the state exists, and that the current user can 
    -- write to it.
    SELECT @state_owner = owner, @closing_time = closing_time
    FROM   dbo.SDE_states
    WHERE  state_id = @state_id
    IF @state_owner IS NULL
    BEGIN
      SET @sql = N'DROP TABLE ' + @conntab_unqualified
      EXEC (@sql)
      EXECUTE dbo.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'State ' + cast (@state_id AS VARCHAR (20)) +
                          ' from version ' + @name + ' not found.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_STATE_NOEXIST
    END

    DECLARE @is_dba INTEGER
    SET @is_dba = dbo.SDE_is_user_sde_dba ()

    IF @is_dba = 0
    BEGIN
      IF @current_user != @state_owner
      BEGIN
        SET @sql = N'DROP TABLE ' + @conntab_unqualified
        EXEC (@sql)
        EXECUTE dbo.SDE_pinfo_def_delete @connection_id
        SET @error_string = 'Not owner of state ' +
                            cast (@state_id AS VARCHAR (20)) + '.'
        RAISERROR (@error_string,16,-1)
        RETURN @SE_NO_PERMISSIONS
      END
    END

    BEGIN TRAN edit_version
    UPDATE dbo.SDE_states
    SET    closing_time = @current_date
    WHERE  state_id = @state_id

    -- The change is made, we can release our locks (incl. mark state locks).

    SET @sql = N'DROP TABLE ' + @conntab_unqualified
    EXEC (@sql)
    EXECUTE dbo.SDE_pinfo_def_delete @connection_id

    -- Update globals to mark that we're done editing.
    EXECUTE dbo.SDE_set_globals @g_state_id,@g_protected,@g_is_default,-1 
  END
  ELSE
  BEGIN
    -- If we starting editing, we will create a child of the current state,
    -- and move this version on to it.

    -- Fetch the information from the version's current state that we need
    -- to create the child state.

    SELECT @state_owner = owner, @closing_time = closing_time,
           @parent_lineage_name = lineage_name
    FROM   dbo.SDE_states
    WHERE  state_id = @state_id

    IF @state_owner IS NULL
    BEGIN
      SET @sql = N'DROP TABLE ' + @conntab_unqualified
      EXEC (@sql)
      EXECUTE dbo.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'State ' + cast (@state_id AS VARCHAR (20)) +
                          ' from version ' + @name + ' not found.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_STATE_NOEXIST
    END

    -- If the version's current state is open, try to close it

    IF @closing_time IS NULL
    BEGIN
      UPDATE dbo.SDE_states
      SET    closing_time = @current_date
      WHERE  state_id = @state_id

    END

    -- Get a state ID.

    DECLARE @new_state_id BIGINT
    EXECUTE dbo.SDE_get_primary_oid 8, 1, @new_state_id OUTPUT

    -- Create the new state.

    EXECUTE dbo.SDE_state_def_insert  @new_state_id, @current_user,
                       @state_id, @parent_lineage_name,
                      @connection_id, 1, @current_date

    -- Unlock the parent state -- we don't need it any longer.

    EXECUTE dbo.SDE_state_lock_def_delete @connection_id, @state_id, 'Y', 0
    -- Move the version to the new state.

    EXECUTE dbo.SDE_versions_def_change_state @new_state_id, @parsed_name,
            @parsed_owner, @state_id
    IF @@ROWCOUNT = 0
    BEGIN
      -- determine if the version has been deleted or if it has
      -- already been changed
      SET @version_id = NULL
      SELECT @version_id = version_id
      FROM   dbo.SDE_versions
      WHERE  name = @parsed_name AND
            owner = @parsed_owner

      IF @version_id IS NULL
      BEGIN
        SET @sql = N'DROP TABLE ' + @conntab_unqualified
        EXEC (@sql)
        EXECUTE dbo.SDE_pinfo_def_delete @connection_id
        SET @error_string = 'Version ' + @name + ' not found.'
        RAISERROR (@error_string,16,-1)
        RETURN @SE_VERSION_NOEXIST
      END
      ELSE
      BEGIN
        SET @sql = N'DROP TABLE ' + @conntab_unqualified
        EXEC (@sql)
        EXECUTE dbo.SDE_pinfo_def_delete @connection_id
        SET @error_string = 'Version ' + @name + ' is no longer state ' +
                            cast (@state_id AS VARCHAR (10)) + '.'
        RAISERROR (@error_string,16,-1)
        RETURN @SE_VERSION_HAS_MOVED
      END
    END

    -- Now lock the new state with a persistent lock
    EXECUTE @ret_code = dbo.SDE_state_lock_def_insert @connection_id,
                       @new_state_id, 'Y', 'E'

    IF @ret_code = -49
      SET @ret_code = @SE_LOCK_CONFLICT
    IF @ret_code != 0
    BEGIN
      SET @sql = N'DROP TABLE ' + @conntab_unqualified
      EXEC (@sql)
      EXECUTE dbo.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'Lock conflict detected for state ' + cast(@new_state_id as varchar(10))
      RAISERROR (@error_string,16,-1)
      RETURN @ret_code
    END
    -- Set the now editable version as the current version.

  EXECUTE dbo.SDE_set_globals @new_state_id,@protected,'0',@version_id 
  END

  -- do a hard commit, even if called within a transaction.
  while @@TRANCOUNT > 0
    COMMIT

END

GO
GRANT EXECUTE ON  [dbo].[edit_version] TO [public]
GO
