SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_geocol_def_change_table_name]                @tabNameVal sysname, @layerIdVal INTEGER AS SET NOCOUNT ON               UPDATE dbo.SDE_geometry_columns SET f_table_name = @tabNameVal FROM dbo.SDE_geometry_columns INNER JOIN dbo.SDE_layers ON (              (dbo.SDE_geometry_columns.f_table_schema = dbo.SDE_layers.owner) AND               (dbo.SDE_geometry_columns.f_table_name = dbo.SDE_layers.table_name) AND               (dbo.SDE_geometry_columns.f_geometry_column =  dbo.SDE_layers.spatial_column) )                WHERE layer_id= @layerIdVal
GO
GRANT EXECUTE ON  [dbo].[SDE_geocol_def_change_table_name] TO [public]
GO
