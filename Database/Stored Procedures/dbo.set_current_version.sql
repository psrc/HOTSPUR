SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[set_current_version] 
@version_name NVARCHAR (97) AS SET NOCOUNT ON
BEGIN
-- This is a public support function for SDE versioned views. When working with
-- versioned views, call this procedure with the version name you wish the views to
-- reflect. Failure to call this procedure will cause versioned views to be based
-- on version 'sde.default'.

DECLARE @error_string NVARCHAR(256)
DECLARE @ret_code INTEGER
DECLARE @version_id INTEGER
DECLARE @parsed_name NVARCHAR (64)
DECLARE @parsed_owner NVARCHAR (128)

-- Parse the version name.
EXECUTE @ret_code = dbo.SDE_parse_version_name @version_name,
                    @parsed_name OUTPUT,  @parsed_owner OUTPUT
IF (@ret_code != 0)
  RETURN
-- Fetch the state id.
DECLARE @state_id BIGINT
DECLARE @status INTEGER
SELECT @state_id = v.state_id, @status = v.status, @version_id = v.version_id
FROM   dbo.SDE_versions v
WHERE  v.name = @parsed_name AND
       v.owner = @parsed_owner;
IF @state_id IS NULL
BEGIN
  SET @error_string = 'Version ' + @version_name + ' not found.'
  RAISERROR (@error_string,16,-1)
  RETURN
END
-- Check the version status: if private, we must be owner to continue,
-- if protected, note for future use.
DECLARE @protected CHAR (1)
SET @protected = dbo.SDE_get_version_access (@status, @parsed_owner)
IF @protected = '2'
BEGIN
  DECLARE @login  NVARCHAR (128)
  SELECT @login = suser_sname()
  SET @error_string = @login + ' is not the owner of version ' + 
                      @version_name + '.'
  RAISERROR (@error_string,16,-1)
  RETURN
END

-- Check if we are already in an edit session.
DECLARE @g_state_id BIGINT
DECLARE @g_protected CHAR(1)
DECLARE @g_is_default CHAR(1)
DECLARE @g_version_id INTEGER
EXECUTE dbo.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
IF @g_version_id != -1 AND @g_version_id != @version_id
BEGIN
  -- Check that version and state still exist (e.g. may have been rolled back)
  DECLARE @exists INTEGER
  SELECT @exists = count(*) from dbo.SDE_versions
    WHERE version_id = @g_version_id
  IF @exists > 0
  BEGIN
    SELECT @exists = count(*) from dbo.SDE_states
      WHERE state_id = @g_state_id
    IF @exists > 0
    BEGIN
      SET @error_string = 'Cannot set version with an open transaction to another version.'
      RAISERROR (@error_string,16,-1)
     RETURN
    END
  END
  -- state or version do not exist, clear any edit session we were in
  SET @g_version_id = -1
END

-- Finally, set the global info
DECLARE @is_default CHAR(1)
IF @parsed_owner = 'dbo' AND @parsed_name = 'DEFAULT'
  SET @is_default = '1'
ELSE
  SET @is_default = '0'
EXECUTE dbo.SDE_set_globals @state_id,@protected,@is_default,@g_version_id 
END

GO
GRANT EXECUTE ON  [dbo].[set_current_version] TO [public]
GO
