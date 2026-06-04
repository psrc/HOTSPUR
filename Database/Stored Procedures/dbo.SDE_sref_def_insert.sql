SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_sref_def_insert]       @sridVal INTEGER, @falsexVal FLOAT, @falseyVal FLOAT,       @xyunitsVal FLOAT, @falsezVal FLOAT, @zunitsVal FLOAT,       @falsemVal FLOAT, @munitsVal FLOAT, @object_flagsVal INTEGER,       @srtextVal VARCHAR(2048), @descriptionVal NVARCHAR(64),       @auth_nameVal NVARCHAR(255), @auth_sridVal INTEGER,       @xycluster_tolVal FLOAT, @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT      AS SET NOCOUNT ON INSERT INTO dbo.SDE_spatial_references       (srid,falsex,falsey,xyunits,falsez,zunits,falsem,munits,object_flags,       srtext, description,auth_name,auth_srid,xycluster_tol,zcluster_tol,      mcluster_tol) VALUES (@sridVal, @falsexVal, @falseyVal,       @xyunitsVal, @falsezVal, @zunitsVal, @falsemVal, @munitsVal,       @object_flagsVal, @srtextVal, @descriptionVal, @auth_nameVal,      @auth_sridVal, @xycluster_tolVal, @zcluster_tolVal, @mcluster_tolVal)
GO
GRANT EXECUTE ON  [dbo].[SDE_sref_def_insert] TO [public]
GO
