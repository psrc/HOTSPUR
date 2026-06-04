SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_def_envelope_update]              @minxVal FLOAT, @minyVal FLOAT, @maxxVal FLOAT,              @maxyVal FLOAT, @minzVal FLOAT, @maxzVal FLOAT,              @minmVal FLOAT, @maxmVal FLOAT, @layeridVal INTEGER AS              SET NOCOUNT ON              BEGIN             BEGIN TRAN layer_env_update             UPDATE dbo.SDE_layers              SET minx = @minxVal,              miny = @minyVal,              maxx = @maxxVal,              maxy = @maxyVal,              minz = @minzVal,              maxz = @maxzVal,              minm = @minmVal,              maxm = @maxmVal              WHERE layer_id = @layeridVal             COMMIT TRAN layer_env_update             END
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_def_envelope_update] TO [public]
GO
