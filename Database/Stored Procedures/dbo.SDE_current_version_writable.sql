SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_current_version_writable] @current_state BIGINT OUTPUT AS 
SET NOCOUNT ON BEGIN
--This is a private support procedure for SDE versioned views.
DECLARE @context_info VARCHAR(128)
SELECT @context_info = CAST (context_info AS VARCHAR(128))
FROM sys.dm_exec_requests
WHERE session_id = @@SPID AND CAST (context_info AS VARCHAR(128)) like 'SDE%'
DECLARE @protected CHAR (1)
DECLARE @delimiter INTEGER
IF @context_info IS NULL
  SET @delimiter = 0
ELSE
BEGIN
  SET @delimiter = charindex (',', @context_info)
  IF @delimiter != 0 -- move past the SDE token
    SET @delimiter = charindex (',', @context_info, @delimiter + 1)
END
IF @delimiter = 0
BEGIN
  -- No context info set, so we're working off the default version.
  DECLARE @status INTEGER
  SELECT @current_state = v.state_id, @status = v.status
  FROM   dbo.SDE_versions v
  WHERE  v.name = 'DEFAULT' AND v.owner = 'dbo'
  SET @protected = dbo.SDE_get_version_access (@status, 'dbo')
END
ELSE
BEGIN
  SET @protected = substring (@context_info, @delimiter + 1, 1)
  DECLARE @sde_delimiter INTEGER
  SET @sde_delimiter = charindex (',', @context_info)
  SET @current_state = CAST (substring (@context_info, @sde_delimiter + 1,
      @delimiter - @sde_delimiter - 1) AS BIGINT)
END
DECLARE @error_string NVARCHAR(256)
IF @protected = '1'
BEGIN
    SET @error_string = 'Current version is protected, and you ' +
                        'are not the owner.'
    RAISERROR (@error_string,16,-1)
    RETURN -1
END
-- Make sure that the state exists, and that the current user can write 
-- to it.
DECLARE @owner NVARCHAR (128)
DECLARE @closing_time DATETIME
SELECT @owner = owner, @closing_time = closing_time
FROM dbo.SDE_states
WHERE state_id = @current_state
IF (@owner IS NULL)
BEGIN
  SET @error_string = 'State ' + cast (@current_state AS VARCHAR (20)) +
                      ' not found.'
  RAISERROR (@error_string,16,-1)
  RETURN -1
END
DECLARE @user NVARCHAR (128)
EXECUTE dbo.SDE_get_current_user_name @user OUTPUT 
IF @user != @owner
BEGIN
  DECLARE @is_dba INTEGER
  SET @is_dba = dbo.SDE_is_user_sde_dba ()
  IF @is_dba = 0
  BEGIN
    SET @error_string = 'Not owner of state ' +
                        CAST (@current_state AS VARCHAR (20)) + '.'
    RAISERROR (@error_string,16,-1)
    RETURN -1
  END
END
IF @closing_time IS NOT NULL 
BEGIN
  SET @error_string = 'State ' + CAST (@current_state AS VARCHAR (20)) +
                      ' is closed.'
  RAISERROR (@error_string,16,-1)
  RETURN -1
END
RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[SDE_current_version_writable] TO [public]
GO
