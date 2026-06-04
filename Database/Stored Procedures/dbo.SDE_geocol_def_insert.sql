SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_geocol_def_insert] @fTabCatVal NVARCHAR(128),       @fTabSchVal NVARCHAR(128), @fTabNameVal sysname, @fGeoColVal NVARCHAR(128), @gTabCatVal       NVARCHAR(128), @gTabSchVal NVARCHAR(128), @gTabNameVal sysname,      @storageTypeVal INTEGER, @geometryTypeVal INTEGER,      @CoordDimensionVal INTEGER, @sridVal INTEGER AS      SET NOCOUNT ON      BEGIN      BEGIN TRAN geocol_insert      INSERT INTO dbo.SDE_geometry_columns (f_table_schema,f_table_name, f_geometry_column,       g_table_schema,g_table_name,storage_type, geometry_type,      coord_dimension, srid) VALUES ( @fTabSchVal,      @fTabNameVal, @fGeoColVal, @gTabSchVal, @gTabNameVal,      @storageTypeVal, @geometryTypeVal, @CoordDimensionVal, @sridVal)      COMMIT TRAN geocol_insert      END
GO
GRANT EXECUTE ON  [dbo].[SDE_geocol_def_insert] TO [public]
GO
