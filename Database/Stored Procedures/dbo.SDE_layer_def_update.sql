SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_def_update]
@descVal NVARCHAR(65), @g1Val FLOAT, @g2Val FLOAT, @g3Val FLOAT,
@minxVal FLOAT, @minyVal FLOAT, @maxxVal FLOAT, @maxyVal FLOAT,
@minzVal FLOAT, @maxzVal FLOAT, @minmVal FLOAT, @maxmVal FLOAT,
@efVal INTEGER, @layerMaskVal INTEGER, @layerConVal  NVARCHAR(32),
@optArrSize INTEGER, @statDateVal INTEGER, @minIdVal INTEGER,
@layerIdVal INTEGER, @geometryTypeVal INTEGER, @secondarySridVal INTEGER AS
SET NOCOUNT ON
DECLARE @eflag_mask INTEGER
DECLARE @layer_mask INTEGER
DECLARE @cad_mask INTEGER
DECLARE @geom_attr_data_mask INTEGER
DECLARE @spatial_type_mask INTEGER
DECLARE @owner NVARCHAR(128)
DECLARE @sql NVARCHAR(320)

-- @cad_mask = SE_CAD_TYPE_MASK (1L << 22)
SELECT @cad_mask = POWER(2,22)

-- @geom_attr_data_mask = DB_HAS_GEOM_COL_MASK (1L << 25)
SELECT @geom_attr_data_mask = POWER(2,25)

-- @spatial_type_mask = SE_STORAGE_GEOMETRY_TYPE (1L<<27) | SE_STORAGE_GEOGRAPHY_TYPE (1L<<15)
--                    =134250496
SET @spatial_type_mask = POWER(2, 15) | POWER (2,27)

SELECT @owner = owner, @eflag_mask = eflags, @layer_mask = layer_mask from dbo.SDE_layers where layer_id = @layerIdVal
IF @@ROWCOUNT > 0
BEGIN
IF @eflag_mask & @spatial_type_mask = @spatial_type_mask AND 
   @eflag_mask & @cad_mask = @cad_mask AND
   @layer_mask & @geom_attr_data_mask = @geom_attr_data_mask
BEGIN
  SET @sql= 'DROP TABLE ' + db_name() + '.' + @owner + '.SDE_GEOMETRY' + CONVERT(NVARCHAR(10),@layerIdVal)
  EXECUTE (@sql)
END
END

UPDATE dbo.SDE_layers
SET description = @descVal, gsize1 = @g1Val, gsize2 = @g2Val,
  gsize3 = @g3Val, minx = @minxVal, miny = @minyVal, maxx = @maxxVal,
  maxy = @maxyVal, minz = @minzVal, maxz = @maxzVal, minm = @minmVal,
  maxm = @maxmVal, eflags = @efVal, layer_mask = @layerMaskVal,
  layer_config = @layerConVal, optimal_array_size = @optArrSize,
  stats_date = @statDateVal, minimum_id = @minIdVal, secondary_srid = @secondarySridVal 
WHERE layer_id = @layerIdVal
UPDATE dbo.SDE_geometry_columns
SET geometry_type = @geometryTypeVal
FROM dbo.SDE_layers l
WHERE l.layer_id = @layerIdVal
  AND l.owner = f_table_schema AND l.table_name = f_table_name AND
  l.spatial_column = f_geometry_column
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_def_update] TO [public]
GO
