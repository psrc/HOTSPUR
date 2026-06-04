SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_rascol_def_delete] @rascol_idVal        INTEGER AS SET NOCOUNT ON DELETE FROM dbo.SDE_raster_columns WHERE rastercolumn_id =       @rascol_idVal
GO
GRANT EXECUTE ON  [dbo].[SDE_rascol_def_delete] TO [public]
GO
