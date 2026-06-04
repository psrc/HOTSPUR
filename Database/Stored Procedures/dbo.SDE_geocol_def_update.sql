SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_geocol_def_update]             @layerIdVal INTEGER, @srTextVal VARCHAR(2048), @xycluster_tolVal FLOAT,            @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT AS SET NOCOUNT ON            UPDATE dbo.SDE_spatial_references SET srtext = @srTextVal,            xycluster_tol = @xycluster_tolVal, zcluster_tol = @zcluster_tolVal,            mcluster_tol = @mcluster_tolVal WHERE srid  in (SELECT srid            FROM dbo.SDE_layers WHERE layer_id = @layerIdVal)
GO
GRANT EXECUTE ON  [dbo].[SDE_geocol_def_update] TO [public]
GO
