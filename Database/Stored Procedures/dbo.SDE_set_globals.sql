SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_set_globals] 
@current_state BIGINT,
@protected CHAR(1),
@is_default CHAR(1),
@edit_version_id INTEGER
AS SET NOCOUNT ON
BEGIN
  -- This is a private support procedure for SDE versioned views.
  -- 
  -- Context info contains: SDE,current state id,protected,is_default_version,edit_version_id;
  DECLARE @context_info VARCHAR(128)
  DECLARE @varbin_context_info VARBINARY(128)
  SET @context_info = 'SDE,' + CAST (@current_state AS VARCHAR(21)) + ',' +
    @protected + ',' + @is_default + ',' + CAST (@edit_version_id AS VARCHAR(10)) + ';'
  SET @varbin_context_info = CAST (@context_info AS VARBINARY(128) )
  SET CONTEXT_INFO @varbin_context_info
END

GO
GRANT EXECUTE ON  [dbo].[SDE_set_globals] TO [public]
GO
