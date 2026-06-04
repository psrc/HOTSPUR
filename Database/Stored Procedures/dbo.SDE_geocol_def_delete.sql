SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_geocol_def_delete]                 @fTableCatalogVal NVARCHAR(128), @fTableSchemaVal NVARCHAR(128),                @fTableNameVal sysname, @fGeometryColumnVal NVARCHAR(128) AS                 SET NOCOUNT ON                BEGIN                BEGIN TRAN geocol_delete                DELETE FROM dbo.SDE_geometry_columns WHERE                 f_table_schema = @fTableSchemaVal AND                 f_table_name = @fTableNameVal AND                 f_geometry_column = @fGeometryColumnVal                COMMIT TRAN geocol_delete                END
GO
GRANT EXECUTE ON  [dbo].[SDE_geocol_def_delete] TO [public]
GO
