SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_def_purge] 
@branchIdVal INTEGER, @regIdVal INTEGER 
AS SET NOCOUNT ON 
DELETE btm FROM dbo.SDE_branch_tables_modified AS btm WITH (FORCESEEK, INDEX(1)) 
WHERE  registration_id = @regIdVal AND branch_id = @branchIdVal 

GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_def_purge] TO [public]
GO
