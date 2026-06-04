SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_last_lineage_mod_def_insert]
@lineageNameVal BIGINT,
@newTimeVal DATETIME AS SET NOCOUNT ON
BEGIN TRAN last_lineage_mod_tran
DECLARE @current_time DATETIME
SELECT @current_time = time_last_modified
  FROM dbo.SDE_lineages_modified WITH (TABLOCKX, HOLDLOCK)
  WHERE lineage_name = @lineageNameVal
IF @@ROWCOUNT > 0
BEGIN
/* Never let the last_time_modifed remain the same or decrement */
  IF DATEDIFF (second, @current_time, @newTimeVal) <= 0
    SET @newTimeVal = DATEADD(second, 1, @current_time)
  UPDATE dbo.SDE_lineages_modified SET time_last_modified = @newTimeVal
    WHERE lineage_name = @lineageNameVal
END
ELSE
  INSERT INTO dbo.SDE_lineages_modified (lineage_name, time_last_modified)    VALUES(@lineageNameVal,@newTimeVal)

COMMIT TRAN last_lineage_mod_tran
GO
GRANT EXECUTE ON  [dbo].[SDE_last_lineage_mod_def_insert] TO [public]
GO
