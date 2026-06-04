SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_clean_no_date_match] 
@branchIdVal INTEGER, @regIdVal INTEGER 
WITH EXECUTE AS OWNER 
AS SET NOCOUNT ON 
BEGIN 
DECLARE 
@rTableName NVARCHAR(226), 
@sql NVARCHAR(512) 

SET @rTableName = dbo.SDE_get_registered_table_name(@regIdVal) 

IF @rTableName IS NOT NULL 
BEGIN 
SET @sql = N'DELETE A FROM dbo.SDE_branch_tables_modified A ' + 
N'WHERE registration_id = ' + CAST(@regIdVal AS NVARCHAR(10)) + N' AND ' + 
N'branch_id = ' + CAST(@branchIdVal AS NVARCHAR(10)) + N' AND ' + 
N'edit_moment NOT IN ' + 
N'(SELECT DISTINCT gdb_from_date ' + 
N'FROM ' + @rTableName + N' B ' + 
N'WHERE B.gdb_branch_id = A.branch_id) ' + 
N'OPTION(MAXDOP 4)' 
EXEC (@sql) 
END 
END 

GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_clean_no_date_match] TO [public]
GO
