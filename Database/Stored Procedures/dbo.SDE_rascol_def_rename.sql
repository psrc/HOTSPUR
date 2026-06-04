SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_rascol_def_rename] @table_nameVal sysname,      @rastercolumn_idVal INTEGER       AS SET NOCOUNT ON UPDATE dbo.SDE_raster_columns SET table_name = @table_nameVal       WHERE rastercolumn_id = @rastercolumn_idVal
GO
GRANT EXECUTE ON  [dbo].[SDE_rascol_def_rename] TO [public]
GO
