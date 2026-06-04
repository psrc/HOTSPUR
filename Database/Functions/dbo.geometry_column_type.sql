SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[geometry_column_type]
(@owner NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128))
RETURNS VARCHAR(128)
AS BEGIN
DECLARE @spatial_type VARCHAR(128)
SELECT @spatial_type = CAST (t.name AS VARCHAR(128)) 
  FROM sys.objects o INNER JOIN sys.columns c INNER JOIN sys.types t
  ON c.user_type_id = t.user_type_id AND c.user_type_id = t.user_type_id 
  ON c.object_id = o.object_id 
  WHERE c.object_id = OBJECT_ID(@owner + '.' + @table) AND c.name = @column

if (@spatial_type != 'geometry' AND @spatial_type != 'geography')
  set @spatial_type = NULL

RETURN @spatial_type
END

GO
GRANT EXECUTE ON  [dbo].[geometry_column_type] TO [public]
GO
