SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_logfile_pool_get_id]
@sdeIdVal INTEGER,
@checkOrphansVal INTEGER,
@useTruncateVal INTEGER
AS
BEGIN TRAN logfile_tran
DECLARE @table_id INTEGER
SET @table_id = 0
SELECT TOP 1 @table_id = table_id
  FROM dbo.SDE_logfile_pool WITH (TABLOCKX, HOLDLOCK)
  WHERE sde_id IS NULL
IF @@ROWCOUNT > 0
BEGIN
  /* Grab this table */
  UPDATE dbo.SDE_logfile_pool SET sde_id = @sdeIdVal
    WHERE table_id = @table_id
END
ELSE
BEGIN
  IF @checkOrphansVal = 1
  BEGIN
    /* Check if any of the tables are orphaned */
    DECLARE @sql NVARCHAR(512)
    SET @sql = N'SELECT TOP 1 @table_id = LP.table_id FROM dbo.SDE_logfile_pool LP
    LEFT JOIN (SELECT PR.sde_id FROM dbo.SDE_process_information PR 
    INNER JOIN tempdb.sys.objects SO      ON object_id (PR.table_name) = SO.object_id WHERE SO.object_id IS NOT NULL) SPR 
      ON LP.sde_id = SPR.sde_id WHERE SPR.sde_id IS NULL' 
    EXECUTE(@sql)

    IF @@ROWCOUNT > 0
    BEGIN
      /* Grab this orphaned table */
      UPDATE dbo.SDE_logfile_pool SET sde_id = @sdeIdVal
        WHERE table_id = @table_id
    END
  END
END
/* If we got a table, truncate it in case the last user did
   not clean it up properly. */
IF @table_id > 0
BEGIN
  DECLARE @sqlstmt AS VARCHAR (64)
  IF @useTruncateVal = 1
  BEGIN
    SET @sqlstmt = 'TRUNCATE TABLE dbo.SDE_logpool_' + cast (@table_id as varchar(10))
  END
  ELSE
  BEGIN
    SET @sqlstmt = 'DELETE FROM dbo.SDE_logpool_' + cast (@table_id as varchar(10))
  END
  EXEC (@sqlstmt)
END
COMMIT TRAN logfile_tran
RETURN @table_id
GO
GRANT EXECUTE ON  [dbo].[SDE_logfile_pool_get_id] TO [public]
GO
