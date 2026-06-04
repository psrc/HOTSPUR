SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_stats_def_update]
@layerIdVal INTEGER, @versionIdVal INTEGER,
@minxVal FLOAT,@minyVal FLOAT, @maxxVal FLOAT, @maxyVal FLOAT,
@minzVal FLOAT, @maxzVal FLOAT,@minmVal FLOAT, @maxmVal FLOAT,
@totalFeaturesVal INTEGER, @totalPointsVal INTEGER AS
SET NOCOUNT ON
BEGIN
BEGIN TRAN layer_stats_update
IF @versionIdVal IS NULL
BEGIN
  UPDATE dbo.SDE_layer_stats  SET minx = @minxVal, miny = @minyVal, maxx = @maxxVal, maxy = @maxyVal,
      minz = @minzVal, maxz = @maxzVal, minm = @minmVal, maxm = @maxmVal,
      total_features = @totalFeaturesVal, total_points = @totalPointsVal,
      last_analyzed = GETDATE()
  WHERE layer_id = @layerIdVal AND version_id IS NULL
END
ELSE
BEGIN
  UPDATE dbo.SDE_layer_stats  SET minx = @minxVal, miny = @minyVal, maxx = @maxxVal, maxy = @maxyVal,
      minz = @minzVal, maxz = @maxzVal, minm = @minmVal, maxm = @maxmVal,
      total_features = @totalFeaturesVal, total_points = @totalPointsVal,
      last_analyzed = GETDATE()
  WHERE layer_id = @layerIdVal AND version_id = @versionIdVal
END
COMMIT TRAN layer_stats_update
END
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_stats_def_update] TO [public]
GO
