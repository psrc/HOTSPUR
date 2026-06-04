SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_get_globals] 
@current_state BIGINT OUTPUT,
@protected CHAR(1) OUTPUT,
@is_default CHAR(1) OUTPUT,
@edit_version_id INTEGER OUTPUT,
@state_is_set INTEGER = -1 OUTPUT --optional param
AS SET NOCOUNT ON
BEGIN
  -- This is a private support procedure for SDE versioned views.
  -- 
  -- Context info contains: SDE,current state id,protected,is_default_version,edit_version_id;
  DECLARE @context_info VARCHAR(128)
  DECLARE  @delimiter INTEGER
  SELECT @context_info = CAST (context_info AS VARCHAR(128))
  FROM sys.dm_exec_requests
  WHERE session_id = @@SPID AND CAST (context_info AS VARCHAR(128)) like 'SDE%'
  IF @context_info IS NULL
    SET @delimiter = 0
  ELSE
  BEGIN
    IF substring (@context_info, 1, 3) != 'SDE'
      SET @delimiter = 0 -- unknown context info
    ELSE
    BEGIN
      SET @delimiter = charindex (',', @context_info)
      IF @delimiter != 0
        -- move past the state id
        SET @delimiter = charindex (',', @context_info, @delimiter + 1)
    END
  END
  IF @delimiter = 0
  BEGIN
    -- No context info set, so we're working off the default version.
    DECLARE @status INTEGER
    SELECT @current_state = v.state_id, @status = v.status
      FROM   dbo.SDE_versions v
      WHERE  v.name = 'DEFAULT' AND v.owner = 'dbo'
    SET @protected = dbo.SDE_get_version_access (@status, 'dbo')
    SET @is_default = '1'
    SET @edit_version_id = -1 -- not in edit version mode
    IF (@state_is_set != -1) OR (@state_is_set IS NULL)
      SET @state_is_set = 0 -- not a fixed state
  END
  ELSE
  BEGIN
    SET @current_state = CAST (substring (@context_info, 5,
      @delimiter - 5) AS BIGINT)
    SET @protected = substring (@context_info, @delimiter + 1, 1)
    SET @is_default = substring (@context_info, @delimiter + 3, 1)
    SET @edit_version_id = CAST (substring (@context_info, @delimiter + 5,
      charindex (';', @context_info, @delimiter + 5) - @delimiter - 5 ) AS INTEGER) 
    IF (@state_is_set != -1) OR (@state_is_set IS NULL)
      SET @state_is_set = 1 -- working with a fixed state
  END
END

GO
GRANT EXECUTE ON  [dbo].[SDE_get_globals] TO [public]
GO
