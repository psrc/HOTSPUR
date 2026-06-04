SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_rascol_srid_update]              @sridVal INTEGER, @rastercolumn_idVal INTEGER AS             SET NOCOUNT ON UPDATE dbo.SDE_raster_columns               SET srid = @sridVal WHERE rastercolumn_id = @rastercolumn_idVal
GO
GRANT EXECUTE ON  [dbo].[SDE_rascol_srid_update] TO [public]
GO
