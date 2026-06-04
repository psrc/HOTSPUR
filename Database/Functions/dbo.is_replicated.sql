SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[is_replicated]
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

DECLARE @intval INT
SELECT TOP 1 @intval = 1 
FROM (SELECT UUID, Type FROM dbo.GDB_Items
      WHERE PhysicalName = @qualified_table) objclass 
  INNER JOIN dbo.GDB_Itemrelationships rel1
  ON rel1.destid = objclass.uuid
WHERE ((rel1.type = '{D022DE33-45BD-424C-88BF-5B1B6B957BD3}') OR
       (rel1.type = '{8DB31AF1-DF7C-4632-AA10-3CC44B0C6914}'))
IF @@ROWCOUNT = 0
  RETURN 'FALSE'
RETURN 'TRUE'
END

GO
GRANT EXECUTE ON  [dbo].[is_replicated] TO [public]
GO
