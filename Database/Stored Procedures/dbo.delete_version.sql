SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[delete_version]
@name NVARCHAR (97) AS SET NOCOUNT ON
BEGIN
  -- This is a public procedure to delete an SDE version.

  -- Setup possible return codes

  DECLARE @SE_NO_PERMISSIONS INTEGER
  SET @SE_NO_PERMISSIONS = 50025

  DECLARE @SE_VERSION_NOEXIST INTEGER
  SET @SE_VERSION_NOEXIST = 50126

  DECLARE @SE_VERSION_HAS_CHILDREN INTEGER
  SET @SE_VERSION_HAS_CHILDREN = 50175

  DECLARE @SE_MVV_VERSION_IN_USE INTEGER
  SET @SE_MVV_VERSION_IN_USE = 50553

  DECLARE @SE_LOCK_CONFLICT INTEGER
  SET @SE_LOCK_CONFLICT = 50049

  DECLARE @parsed_name NVARCHAR(64)
  DECLARE @parsed_owner NVARCHAR(128)
  DECLARE @error_string NVARCHAR(256)
  DECLARE @ret_code INTEGER

  -- Parse the version name.

  EXECUTE @ret_code = dbo.SDE_parse_version_name @name,
          @parsed_name OUTPUT, @parsed_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  -- Make sure this is not the default version.

  IF @parsed_owner = 'dbo' AND @parsed_name = 'DEFAULT'
  BEGIN
    RAISERROR ('The default version may not be deleted.',16,-1)
    RETURN @SE_NO_PERMISSIONS
  END

  -- If we are not the DBA, make sure that we are the owner.

  DECLARE @current_user NVARCHAR(128)
  DECLARE @is_dba INTEGER
  SET @is_dba = dbo.SDE_is_user_sde_dba ()
  EXECUTE dbo.SDE_get_current_user_name @current_user OUTPUT

  IF @is_dba = 0
  BEGIN
    IF @current_user != @parsed_owner
    BEGIN
      SET @error_string = @current_user + ' not owner of version ' +
                          @name + '.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_NO_PERMISSIONS
    END
  END

  -- Make sure that the version exists.

  DECLARE @version_id INTEGER

  DECLARE @state_id INTEGER

  SELECT @version_id = version_id, @state_id = state_id
  FROM   dbo.SDE_versions
  WHERE  name = @parsed_name AND
         owner = @parsed_owner

  IF @version_id IS NULL
  BEGIN
    SET @error_string = 'Version ' + @name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  -- Make sure that this version has no children.

  DECLARE @parent_version_id INTEGER

  SET @parent_version_id = NULL

  SELECT @parent_version_id = version_id
  FROM   dbo.SDE_versions
  WHERE  parent_name = @parsed_name AND
         parent_owner = @parsed_owner

  IF @parent_version_id IS NOT NULL
  BEGIN
    SET @error_string = 'Version ' + @name +
                        ' can not be deleted, as it has children.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_HAS_CHILDREN
  END

  -- Check if we set this version in the current session.
  DECLARE @g_state_id BIGINT
  DECLARE @g_protected CHAR(1)
  DECLARE @g_is_default CHAR(1)
  DECLARE @g_version_id INTEGER
  EXECUTE dbo.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
  IF (@g_version_id = @version_id) OR
     (@g_state_id = @state_id AND @g_is_default = '0')
  BEGIN
    SET @error_string = 'Version ' + @name +
                        ' can not be deleted, as it is in use.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_MVV_VERSION_IN_USE
  END

  -- Place an object lock on the version to be deleted to be sure 
  -- it isn't currently in use.

  DECLARE @connection_id INTEGER

  -- Get an sde connection id for locking purposes

  EXECUTE dbo.SDE_get_primary_oid 12, 1, @connection_id OUTPUT

  -- We also need to insert into the process info table, otherwise if
  -- another process detects a lock conflict, this lock will be dropped
  -- since it doesn't belong to a valid SDE connection in the
  -- process info table.

  DECLARE @conn_tab NVARCHAR(95)
  DECLARE @conntab_unqualified  NVARCHAR(95)
  DECLARE @server_id INTEGER
  DECLARE @node_name NVARCHAR(256)
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

  -- Lock the underlying object, to make sure it stays still.

  EXECUTE @ret_code = dbo.SDE_object_lock_def_insert @connection_id,
                      @version_id,1,999, 'Y', 'E'
  IF @ret_code = -49
    SET @ret_code = @SE_LOCK_CONFLICT
  IF @ret_code != 0
  BEGIN
    EXECUTE dbo.SDE_pinfo_def_delete @connection_id
    SET @sql = N'DROP TABLE ' + @conntab_unqualified
    EXEC (@sql)
    SET @error_string = 'Unable to delete version ' +  @name + 
           ' which may be currently referenced by other object'
    RAISERROR (@error_string,16,-1)
    RETURN @ret_code
  END

  -- Perform the delete.

  EXECUTE dbo.SDE_versions_def_delete @parsed_owner, @parsed_name

  -- Remove the lock.
  EXECUTE dbo.SDE_object_lock_def_delete            @connection_id,@version_id,1,999,'Y'

  -- It's now safe to remove pinfo entry.

  SET @sql = N'DROP TABLE ' + @conntab_unqualified
  EXEC (@sql)
  EXECUTE dbo.SDE_pinfo_def_delete @connection_id

END

GO
GRANT EXECUTE ON  [dbo].[delete_version] TO [public]
GO
