SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_stats_def_delete]
@layerIdVal INTEGER, @versionIdVal INTEGER AS
SET NOCOUNT ON
BEGIN
BEGIN TRAN layer_stats_delete
IF @versionIdVal <= 0
BEGIN
  DELETE FROM dbo.SDE_layer_stats  WHERE layer_id = @layerIdVal AND version_id IS NULL
END
ELSE
BEGIN
  DELETE FROM dbo.SDE_layer_stats  WHERE layer_id = @layerIdVal AND version_id = @versionIdVal
END
COMMIT TRAN layer_stats_delete
END
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_stats_def_delete] TO [public]
GO
