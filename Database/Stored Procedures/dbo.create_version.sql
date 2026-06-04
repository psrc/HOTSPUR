SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[create_version] 
@parent_name NVARCHAR (97),
@name NVARCHAR (64) OUTPUT,
@name_rule INTEGER,
@access INTEGER,
@description NVARCHAR(64) AS SET NOCOUNT ON
BEGIN
  /* This is a public procedure to create an SDE version.
  The new version will be a child of the given parent version name.
  The new version may have a unique name generated, depending on the
  value of the name_rule parameter. Valid name rules are:
  1 - generate a new name if there's already a version with the given name.
    In this case, the new name will be returned in the @name parameter, 
    as long as the caller supplied the OUTPUT keyword with the parameter.
  2 - Only use the name supplied, return an error if it already exists.

  The access parameter specified the new version's access as follows:
  0 - private version.
  1 - public version.
  2 - protected version. */

  -- Setup possible return codes

  DECLARE @SE_NO_PERMISSIONS INTEGER
  SET @SE_NO_PERMISSIONS = 50025

  DECLARE @SE_LOCK_CONFLICT INTEGER
  SET @SE_LOCK_CONFLICT = 50049

  DECLARE @SE_INVALID_PARAM_VALUE INTEGER
  SET @SE_INVALID_PARAM_VALUE = 50066

  DECLARE @SE_VERSION_NOEXIST INTEGER
  SET @SE_VERSION_NOEXIST = 50126

  DECLARE @SE_INVALID_VERSION_NAME INTEGER
  SET @SE_INVALID_VERSION_NAME = 50171

  DECLARE @SE_STATE_NOEXIST INTEGER
  SET @SE_STATE_NOEXIST = 50172

  DECLARE @SE_INVALID_VERSION_ID INTEGER
  SET @SE_INVALID_VERSION_ID = 50298

  -- Check arguments.

  IF @parent_name IS NULL

  BEGIN
    RAISERROR ('Parent version can not be NULL.',16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  DECLARE @parsed_name NVARCHAR(64)
  DECLARE @parsed_owner NVARCHAR(128)
  DECLARE @current_user NVARCHAR(128)
  DECLARE @error_string NVARCHAR(256)
  DECLARE @node_name  NVARCHAR(256)
  DECLARE @ret_code INTEGER

  EXECUTE dbo.SDE_get_current_user_name @current_user OUTPUT 
  EXECUTE @ret_code = dbo.SDE_parse_version_name @name,
                      @parsed_name OUTPUT, 
                      @parsed_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  IF @parsed_owner <> @current_user
  BEGIN
    RAISERROR ('The new version must be in the current user''s schema.', 16,-1)
    RETURN @SE_INVALID_VERSION_NAME
  END

  IF @access IS NULL
  BEGIN
    RAISERROR ('NULL is not a valid access type code.',16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END
  ELSE IF @access < 0 OR @access > 2
  BEGIN
    SET @error_string = cast (@access AS VARCHAR (10)) + 
                       ' is not a valid access type code.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  IF @name_rule IS NULL
  BEGIN
    RAISERROR ('NULL is not a valid name rule.',16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END
  ELSE IF @name_rule < 1 OR @name_rule > 2
  BEGIN
   SET @error_string = cast (@name_rule AS VARCHAR (10)) + 
                       ' is not a valid name rule.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  -- Fetch the proposed parent version.

  DECLARE @parsed_parent_name NVARCHAR(64)
  DECLARE @parsed_parent_owner NVARCHAR(128)
  DECLARE @parent_version_id INTEGER
  DECLARE @parent_state_id BIGINT
  DECLARE @parent_status INTEGER

  EXECUTE @ret_code = dbo.SDE_parse_version_name @parent_name,
                      @parsed_parent_name OUTPUT,
                      @parsed_parent_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  SELECT @parent_version_id = version_id, @parent_state_id = state_id,
         @parent_status = status
  FROM   dbo.SDE_versions
  WHERE  name = @parsed_parent_name AND
         owner = @parsed_parent_owner

  IF @parent_version_id IS NULL
  BEGIN
    SET @error_string = 'Version ' + @parent_name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  -- Check permissions.  At least one of the following must be true for this
  -- operation:  (1) The parent version must be public or protected, or
  --             (2) The current user is the parent version's owner, or
  --             (3) The current user is the SDE DBA user.

  DECLARE @protected CHAR (1)

  SET @protected = dbo.SDE_get_version_access (@parent_status,
                    @parsed_parent_owner)
  IF @protected = '2'
  BEGIN
    SET @error_string = 'Insufficient access to version ' + @parent_name
    RAISERROR (@error_string,16,-1)
    RETURN @SE_NO_PERMISSIONS
  END

  -- Get an sde connection id for locking purposes

  DECLARE @connection_id INTEGER
  EXECUTE dbo.SDE_get_primary_oid 12, 1, @connection_id OUTPUT

  -- We also need to insert into the process info table, otherwise if
  -- another process detects a lock conflict, this lock will be dropped
  -- since it doesn't belong to a valid SDE connection in the
  -- process info table.

  DECLARE @server_id INTEGER
  DECLARE @conn_tab NVARCHAR(95)
  DECLARE @conntab_unqualified  NVARCHAR(95)
  DECLARE @admin_db NVARCHAR(128) = db_name()
  SET @conntab_unqualified = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
    + N'_' + @admin_db 
  DECLARE @sql AS NVARCHAR (256)
  SET @sql = N'CREATE TABLE ' + @conntab_unqualified + N' (keycol INTEGER)'
  EXEC (@sql)
  SET @conn_tab = N'tempdb.' + @current_user + N'.' + @conntab_unqualified
  SET @node_name = HOST_NAME()
  SET @server_id = HOST_ID()
  EXECUTE dbo.SDE_pinfo_def_insert @connection_id, @server_id,'Y',
    'Win32',@node_name,'F',@conn_tab

  -- Lock the underlying state, to make sure it stays still.

  EXECUTE @ret_code = dbo.SDE_state_lock_def_insert @connection_id,
                      @parent_state_id, 'Y', 'S'
  IF @ret_code = -49
    SET @ret_code = @SE_LOCK_CONFLICT
  IF @ret_code != 0
  BEGIN
    EXECUTE dbo.SDE_pinfo_def_delete @connection_id
    SET @sql = N'DROP TABLE ' + @conntab_unqualified
    EXEC (@sql)
    RETURN @ret_code
  END

  -- Now that we have a lock, we safely check to see if the parent
  -- version's state still exists.

  DECLARE @state_id BIGINT

  SELECT @state_id = state_id
  FROM   dbo.SDE_states
  WHERE  state_id = @parent_state_id

  IF @state_id IS NULL
  BEGIN
    EXECUTE dbo.SDE_pinfo_def_delete @connection_id
    SET @sql = N'DROP TABLE ' + @conntab_unqualified
    EXEC (@sql)
    SET @error_string = 'State ' + cast (@parent_state_id AS VARCHAR (20))
                        + ' from version ' + @parent_name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_STATE_NOEXIST
  END

  -- Get a version ID.

  DECLARE @version_id INTEGER
  EXECUTE dbo.SDE_get_primary_oid 9, 1, @version_id OUTPUT

  IF @version_id IS NULL
  BEGIN
    EXECUTE dbo.SDE_pinfo_def_delete @connection_id
    SET @sql = N'DROP TABLE ' + @conntab_unqualified
    EXEC (@sql)
    SET @error_string = 'Unable to generate a version ID for ' +  @name
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_VERSION_ID
  END

  -- Insert the new version.

  DECLARE @current_date DATETIME
  SET @current_date = GETDATE ()

  EXECUTE @ret_code = dbo.SDE_versions_def_insert @parsed_name OUTPUT,
       @current_user, @version_id, @access, @parent_state_id, @description,
       @parsed_parent_name, @parsed_parent_owner, @parent_version_id,
       @current_date, @name_rule

  -- Set the returned name, in case we changed it.
  SET @name = @parsed_name

  -- It's now safe to remove the state lock and pinfo entry.

  SET @sql = N'DROP TABLE ' + @conntab_unqualified
  EXEC (@sql)
  EXECUTE dbo.SDE_pinfo_def_delete @connection_id

  -- do a hard commit, even if called within a transaction.
  WHILE @@TRANCOUNT > 0
    COMMIT

  RETURN @ret_code
END

GO
GRANT EXECUTE ON  [dbo].[create_version] TO [public]
GO
