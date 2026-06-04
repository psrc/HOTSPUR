SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_def_delete] 
@branchIdVal INTEGER, @editMomentVal DATETIME2 AS SET NOCOUNT ON
DELETE btm FROM dbo.SDE_branch_tables_modified AS btm WITH (FORCESEEK, INDEX(1)) 
WHERE branch_id = @branchIdVal AND edit_moment > @editMomentVal
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_def_delete] TO [public]
GO
