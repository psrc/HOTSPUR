SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[isGeoDatabase]
@isgdb VARCHAR(5) OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @intval INT
-- check if current database is a gdb
SELECT @intval = 1 FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'GDB_TABLES_LAST_MODIFIED' AND TABLE_SCHEMA IN ('sde','dbo')
IF @@ROWCOUNT = 0
BEGIN
  BEGIN TRY
    -- check if this database is part of a multi-db sde database. We need to wrap
    -- this statement in an execute block, since try/catch does not catch name
    -- resolution errors.
    DECLARE @count int
    DECLARE @sql NVARCHAR(256)
    SET @sql = N'SELECT @intval = count(*) FROM sde.sde.SDE_table_registry
                 WHERE database_name = ''' +  DB_NAME() + N''''
    EXECUTE sp_executesql @sql, N'@intval integer output', @intval = @count output
    IF @count > 0
      SET @isgdb = 'TRUE'
    ELSE
      SET @isgdb = 'FALSE'
  END TRY
  BEGIN CATCH
    -- sde database doesn't exist or we don't have login permission
    SET @isgdb = 'FALSE'
  END CATCH
END
ELSE
  SET @isgdb = 'TRUE'
END

GO
GRANT EXECUTE ON  [dbo].[isGeoDatabase] TO [public]
GO
