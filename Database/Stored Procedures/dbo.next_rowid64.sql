SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[next_rowid64]
@owner NVARCHAR(128), @table NVARCHAR(128), @rowid BIGINT OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @regid INT
DECLARE @newid BIGINT
DECLARE @oflags INT
DECLARE @SE_REGISTRATION_HAS_64BIT_ROWID BIGINT = 1 * POWER(2,4)
DECLARE @sql NVARCHAR (1024)
SELECT @regid = registration_id, @oflags = object_flags FROM dbo.SDE_table_registry  WHERE owner = @owner AND table_name = @table
IF @@ROWCOUNT = 0
BEGIN
  SELECT @regid = registration_id, @oflags = object_flags FROM dbo.SDE_table_registry    WHERE owner = @owner AND imv_view_name = @table
  IF @@ROWCOUNT = 0
  BEGIN
    DECLARE @errstr VARCHAR (256)
    SET @errstr = 'Class ' + @table + ' not registered to the Geodatabase.'
    RAISERROR (@errstr,16,-1)
    RETURN
  END
END
IF (@oflags & @SE_REGISTRATION_HAS_64BIT_ROWID) > 0
  SET @sql = 
'  DECLARE @num_ids INT ' +
'  EXEC ' + @owner + '.i' +cast (@regid AS VARCHAR(10)) + '_get_ids 2,1,@newid OUTPUT,@num_ids OUTPUT, 1'
ELSE
  SET @sql = 
'  DECLARE @num_ids INT ' +
'  EXEC ' + @owner + '.i' +cast (@regid AS VARCHAR(10)) + '_get_ids 2,1,@newid OUTPUT,@num_ids OUTPUT'

EXECUTE sp_executesql @sql, N'@newid BIGINT OUTPUT', @newid = @rowid OUTPUT
END

GO
GRANT EXECUTE ON  [dbo].[next_rowid64] TO [public]
GO
