SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_def_delete_regid_moment] 
@branchIdVal INTEGER, @momentVal DATETIME2, @regIdVal INTEGER 
AS SET NOCOUNT ON 
DELETE btm FROM dbo.SDE_branch_tables_modified AS btm WITH (FORCESEEK, INDEX(1)) 
WHERE branch_id = @branchIdVal AND edit_moment = @momentVal AND registration_id = @regIdVal 

GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_def_delete_regid_moment] TO [public]
GO
