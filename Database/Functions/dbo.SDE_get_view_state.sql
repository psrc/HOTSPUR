SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SDE_get_view_state] () RETURNS BIGINT
BEGIN
--This is a private support function for SDE versioned views.
DECLARE @state_id BIGINT
DECLARE @context_info VARCHAR(128)
SELECT @context_info = CAST (context_info AS VARCHAR(128))
FROM sys.dm_exec_requests
WHERE session_id = @@SPID AND CAST (context_info AS VARCHAR(128)) like 'SDE%'
IF @context_info IS NULL
  SET @state_id = -1  -- version has not been set.
ELSE
BEGIN
  DECLARE @delimiter INTEGER
  SET @delimiter = charindex (',', @context_info)
  IF @delimiter = 0
    SET @state_id = -1  -- version has not been set.
  ELSE
  BEGIN
    DECLARE @next_delimiter INTEGER
    SET @next_delimiter = charindex (',', @context_info, @delimiter + 1)
    SET @context_info = substring (@context_info, @delimiter + 1,
        @next_delimiter - @delimiter - 1)
    SET @state_id = CAST (@context_info as bigint)
  END
END
IF @state_id < 0
  -- Set to default version's state id
  SELECT @state_id = state_id FROM dbo.SDE_versions
    WHERE name = 'DEFAULT' AND owner = 'dbo'
RETURN @state_id
END

GO
GRANT EXECUTE ON  [dbo].[SDE_get_view_state] TO [public]
GO
