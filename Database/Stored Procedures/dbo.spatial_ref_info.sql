SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spatial_ref_info]
@owner NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128),
@wkid INT OUTPUT, @wkt NVARCHAR(4000) OUTPUT, @st_srid INT OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @layer_table NVARCHAR (128)
DECLARE @get_meta_spref INT

SET @get_meta_spref = 0 --Assume no metadata
SET @layer_table = @table

SELECT @layer_table = table_name FROM dbo.SDE_table_registry
  WHERE owner = @owner AND table_name = @table
IF @@ROWCOUNT = 0
BEGIN
  SELECT @layer_table = table_name FROM dbo.SDE_table_registry
    WHERE owner = @owner AND imv_view_name = @table
  IF @@ROWCOUNT > 0
    SET @get_meta_spref = 1
END
ELSE
  SET @get_meta_spref = 1

IF @get_meta_spref = 1
BEGIN
  -- table is registered, see if it's in the layers table
  SELECT @wkid = s.auth_srid, @wkt = s.srtext, @st_srid = s.srid 
  FROM dbo.SDE_layers l INNER JOIN dbo.SDE_spatial_references s
  ON l.srid = s.srid
  WHERE l.owner = @owner and l.table_name = @layer_table AND l.spatial_column = @column
  IF @@ROWCOUNT > 0
    RETURN -- we're done!
END

-- Need to get the spatial info from first shape
DECLARE @sql NVARCHAR(256)
SET @sql = N'SELECT TOP 1 @intval = ' + @column + '.STSrid FROM ' + @owner +  '.' + @layer_table +
           ' WHERE ' + @column + ' IS NOT NULL'
EXECUTE sp_executesql @sql, N'@intval integer output', @intval = @st_srid output

SELECT @wkid = spatial_reference_id, @wkt = well_known_text FROM sys.spatial_reference_systems
  WHERE spatial_reference_id = @st_srid
END

GO
GRANT EXECUTE ON  [dbo].[spatial_ref_info] TO [public]
GO
