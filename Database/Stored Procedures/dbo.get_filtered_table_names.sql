SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[get_filtered_table_names]
AS SET NOCOUNT ON
BEGIN
SELECT SCHEMA_NAME(o.schema_id) + '.' + o.name
FROM sys.objects o
WHERE o.type IN ('U','V') AND 
  (has_perms_by_name (SCHEMA_NAME(o.schema_id) + '.' + o.name,'OBJECT','SELECT') = 1)
  AND o.name NOT LIKE 'GDB_%%'
  AND o.name NOT LIKE 'f[1-9]%%'
  AND o.name NOT LIKE 's[1-9]%%'
  AND o.name NOT LIKE 'a[1-9]%%'
  AND o.name NOT LIKE 'd[1-9]%%'
  AND o.name NOT LIKE 'i[1-9]%%'
  AND o.name NOT LIKE 'sde_%%'
  AND o.name NOT LIKE '%%_H'
  AND o.name NOT LIKE 'ST_%%'
  AND o.name != 'dbtune'
END

GO
GRANT EXECUTE ON  [dbo].[get_filtered_table_names] TO [public]
GO
