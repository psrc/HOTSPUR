SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_rascol_spatial_reference_update]             @rastercolumn_idVal INTEGER, @srTextVal VARCHAR(2048),            @xycluster_tolVal FLOAT,            @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT AS            SET NOCOUNT ON UPDATE dbo.SDE_spatial_references SET             srtext = @srTextVal, xycluster_tol = @xycluster_tolVal,            zcluster_tol = @zcluster_tolVal, mcluster_tol = @mcluster_tolVal            WHERE srid  in (SELECT srid from dbo.SDE_raster_columns             WHERE rastercolumn_id = @rastercolumn_idVal)
GO
GRANT EXECUTE ON  [dbo].[SDE_rascol_spatial_reference_update] TO [public]
GO
