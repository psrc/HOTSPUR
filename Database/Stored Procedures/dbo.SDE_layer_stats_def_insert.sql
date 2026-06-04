SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_stats_def_insert]
@layerIdVal INTEGER, @versionIdVal INTEGER,
@minxVal FLOAT,@minyVal FLOAT, @maxxVal FLOAT, @maxyVal FLOAT,
@minzVal FLOAT, @maxzVal FLOAT,@minmVal FLOAT, @maxmVal FLOAT,
@totalFeaturesVal INTEGER, @totalPointsVal INTEGER AS
SET NOCOUNT ON
BEGIN
BEGIN TRAN layer_stats_insert
INSERT INTO dbo.SDE_layer_stats (layer_id,version_id, 
  minx, miny, maxx, maxy, minz, maxz, minm, maxm, 
  total_features, total_points, last_analyzed)
 VALUES (@layerIdVal, @versionIdVal, @minxVal, @minyVal, @maxxVal, @maxyVal,
  @minzVal, @maxzVal, @minmVal, @maxmVal, @totalFeaturesVal, @totalPointsVal,
  GETDATE())
COMMIT TRAN layer_stats_insert
END
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_stats_def_insert] TO [public]
GO
