SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_sref_def_update]       @sridVal INTEGER, @falsexVal FLOAT, @falseyVal FLOAT, @xyunitsVal FLOAT,      @falsezVal FLOAT, @zunitsVal FLOAT, @falsemVal FLOAT,       @munitsVal FLOAT, @object_flagsVal INTEGER,       @srtextVal VARCHAR(2048), @descriptionVal NVARCHAR(64),       @auth_nameVal NVARCHAR(255), @auth_sridVal INTEGER,       @xycluster_tolVal FLOAT, @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT      AS SET NOCOUNT ON UPDATE dbo.SDE_spatial_references SET falsex = @falsexVal,       falsey = @falseyVal,xyunits = @xyunitsVal,falsez = @falsezVal,       zunits = @zunitsVal,falsem = @falsemVal,munits = @munitsVal,       object_flags = @object_flagsVal, srtext = @srtextVal,       description = @descriptionVal,       auth_name = @auth_nameVal, auth_srid = @auth_sridVal,      xycluster_tol = @xycluster_tolVal,zcluster_tol = @zcluster_tolVal,      mcluster_tol = @mcluster_tolVal      WHERE srid = @sridVal
GO
GRANT EXECUTE ON  [dbo].[SDE_sref_def_update] TO [public]
GO
