SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_keyset_remove]
@tableNameVal sysname
AS
BEGIN
BEGIN TRAN keyset_tran
DECLARE @sql AS NVARCHAR(256)
SET @sql = N'DROP TABLE dbo.' + @tableNameVal
EXECUTE (@sql)
COMMIT TRAN keyset_tran
END

GO
GRANT EXECUTE ON  [dbo].[SDE_keyset_remove] TO [public]
GO
