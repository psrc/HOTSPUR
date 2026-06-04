SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[globalid_name]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS VARCHAR(14)
AS BEGIN
-- check if the object is a multiversioned view
DECLARE @base_table NVARCHAR(128)
DECLARE @qualified_table NVARCHAR (200)
SET @qualified_table = db_name() + '.' + @owner + '.'

SELECT @base_table = table_name FROM dbo.SDE_table_registry 
  WHERE owner = @owner AND imv_view_name = @table
IF @@ROWCOUNT = 0
  SET @qualified_table = @qualified_table + @table
ELSE
  SET @qualified_table = @qualified_table + @base_table

DECLARE @def VARCHAR(max)
DECLARE @properties int
SELECT @def = CAST (definition AS VARCHAR(max)), @properties = properties
  FROM dbo.GDB_Items WHERE physicalname = @qualified_table
IF @@ROWCOUNT = 0
    RETURN 'NOT REGISTERED'
DECLARE @pos INT
DECLARE @pos2 INT
SET @pos = charindex ('<HasGlobalID>', @def)
SET @pos2 = charindex('</HasGlobalID>', @def, @pos)
IF @pos >= @pos2
    RETURN 'FALSE'
SET @pos = @pos + 13

DECLARE @str_val NVARCHAR(128)
SET @str_val = substring(@def,@pos,@pos2 - @pos)
IF @str_val = 'TRUE'
BEGIN
  SET @pos = charindex ('<GlobalIDFieldName>', @def)
  SET @pos2 = charindex('</GlobalIDFieldName>', @def, @pos)
  IF @pos >= @pos2
      RETURN NULL -- no global id in this table

  SET @pos = @pos + 19
  SET @str_val = substring(@def,@pos,@pos2 - @pos)
END
ELSE
  RETURN NULL
RETURN @str_val
END

GO
GRANT EXECUTE ON  [dbo].[globalid_name] TO [public]
GO
