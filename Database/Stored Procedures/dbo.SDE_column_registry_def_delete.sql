SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_column_registry_def_delete]                           @dbNameVal NVARCHAR(128), @tabNameVal sysname,                           @ownerVal NVARCHAR(128), @colNameVal NVARCHAR(128) AS                           SET NOCOUNT ON DELETE FROM dbo.SDE_column_registry WHERE                           table_name = @tabNameVal AND                           owner = @ownerVal AND column_name = @colNameVal 
GO
GRANT EXECUTE ON  [dbo].[SDE_column_registry_def_delete] TO [public]
GO
