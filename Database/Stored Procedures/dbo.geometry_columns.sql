SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[geometry_columns]
@owner NVARCHAR(128), @table NVARCHAR(128)
AS SET NOCOUNT ON
BEGIN
SELECT c.name column_name FROM sys.objects o INNER JOIN sys.columns c
  INNER JOIN sys.types t
  ON c.user_type_id = t.user_type_id AND c.user_type_id = t.user_type_id
  ON c.object_id = o.object_id 
  WHERE t.name in ('geometry','geography')
  AND c.object_id = OBJECT_ID(@owner + '.' + @table)
END

GO
GRANT EXECUTE ON  [dbo].[geometry_columns] TO [public]
GO
