SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[geometry_type]
@owner NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128)
AS SET NOCOUNT ON
BEGIN
DECLARE @eflags INT
DECLARE @type_tab AS TABLE (type_names NVARCHAR(128))
DECLARE @type AS NVARCHAR(128)
DECLARE @zm AS NVARCHAR(3)
DECLARE @multi AS NVARCHAR(5)

-- Check if it's a registered layer
SELECT @eflags = eflags FROM dbo.SDE_layers 
WHERE owner = @owner AND table_name = @table AND spatial_column = @column

IF @@ROWCOUNT = 1
BEGIN
  -- Decode eflags to determine shape type
  IF (@eflags & 262144) > 0
    SET @multi = N'MULTI'
  ELSE
    SET @multi = N''

  SET @zm = N''
  IF (@eflags & 65536) > 0
    SET @zm = @zm + N' Z'
  IF (@eflags & 524288) > 0
  BEGIN
    IF @zm = ''
      SET @zm = @zm + N' M'
    ELSE
      SET @zm = @zm + N'M'
  END

  IF (@eflags & 1) > 0
    INSERT INTO @type_tab (type_names) VALUES (N'NIL')

  IF (@eflags & 2) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'POINT' + @zm)

  IF (@eflags & 4) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'LINESTRING' + @zm)

  IF (@eflags & 8) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'SIMPLELINESTRING' + @zm)

  IF (@eflags & 16) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'POLYGON' + @zm)

  SELECT type_names AS geometry_type from @type_tab

END
ELSE
BEGIN
  -- Not a registered layer, check if it's a spatial column
  DECLARE @spatial_type VARCHAR(128)
  SELECT @spatial_type = CAST (t.name AS VARCHAR(128)) 
    FROM sys.objects o INNER JOIN sys.columns c INNER JOIN sys.types t
    ON c.user_type_id = t.user_type_id AND c.user_type_id = t.user_type_id 
    ON c.object_id = o.object_id 
    WHERE c.object_id = OBJECT_ID(@owner + '.' + @table) AND c.name = @column

  IF (@spatial_type IS NULL OR (@spatial_type != 'geometry' AND @spatial_type != 'geography'))
  BEGIN
    DECLARE @errstr varchar (256)
    SET @errstr = 'Spatial column ' + @owner + '.' + @table + '.' + @column + ' does not exist.'
    RAISERROR (@errstr,16,-1)
    RETURN
  END

  -- Let's fetch the first shape
  DECLARE @sql NVARCHAR (1024)
  SET @sql = 'SELECT TOP 1 UPPER (' + @column + '.STGeometryType()) AS geometry_type FROM ' + @owner + '.' + @table +
             ' WHERE ' + @column + ' IS NOT NULL'
  EXEC (@sql)
END
END

GO
GRANT EXECUTE ON  [dbo].[geometry_type] TO [public]
GO
