SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_last_modified_def_update]
@tableNameVal sysname,
@newTimeVal DATETIME OUTPUT AS SET NOCOUNT ON
BEGIN TRAN last_modified_tran
DECLARE @current_time DATETIME
SELECT @current_time = time_last_modified
  FROM dbo.SDE_tables_modified WITH (TABLOCKX, HOLDLOCK)
  WHERE table_name = @tableNameVal
IF @@ROWCOUNT = 0
BEGIN
  /* Insert a value for this table */
  INSERT INTO dbo.SDE_tables_modified (table_name,time_last_modified)
VALUES (@tableNameVal, @newTimeVal)
END
ELSE
BEGIN
  /* Never let the last_time_modifed remain the same or decrement */
  IF DATEDIFF (second, @current_time, @newTimeVal) <= 0
    SET @newTimeVal = DATEADD(second, 1, @current_time)
  UPDATE dbo.SDE_tables_modified SET time_last_modified = @newTimeVal
    WHERE table_name = @tableNameVal
END
COMMIT TRAN last_modified_tran
GO
GRANT EXECUTE ON  [dbo].[SDE_last_modified_def_update] TO [public]
GO
