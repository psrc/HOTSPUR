SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_rascol_def_update] @rastercolumn_idVal INTEGER,      @descriptionVal NVARCHAR(65), @config_keywordVal NVARCHAR(32),       @minimum_idVal INTEGER, @rastercolumn_maskVal INTEGER      AS SET NOCOUNT ON UPDATE dbo.SDE_raster_columns SET description = @descriptionVal,      config_keyword = @config_keywordVal,       minimum_id = @minimum_idVal, rastercolumn_mask = @rastercolumn_maskVal       WHERE rastercolumn_id = @rastercolumn_idVal
GO
GRANT EXECUTE ON  [dbo].[SDE_rascol_def_update] TO [public]
GO
