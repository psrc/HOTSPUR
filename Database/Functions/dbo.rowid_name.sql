SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[rowid_name](
@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS NVARCHAR(128)
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
    RETURN NULL -- layer not found, but can't raise errors in a function!

DECLARE @pos INT
DECLARE @pos2 INT
SET @pos = charindex ('<OIDFieldName>', @def)
SET @pos2 = charindex('</OIDFieldName>', @def, @pos)
IF @pos >= @pos2
    RETURN NULL -- no rowid column in this table

SET @pos = @pos + 14

DECLARE @rowid_name NVARCHAR(128)
SET @rowid_name = substring(@def,@pos,@pos2 - @pos)
RETURN @rowid_name
END

GO
GRANT EXECUTE ON  [dbo].[rowid_name] TO [public]
GO
