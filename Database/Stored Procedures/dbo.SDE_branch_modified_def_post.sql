SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_def_post] 
@branchIdVal INTEGER, @postMomentVal DATETIME2 AS SET NOCOUNT ON
UPDATE btm SET branch_id = 0, edit_moment = @postMomentVal 
FROM dbo.SDE_branch_tables_modified btm WITH (FORCESEEK, INDEX(1)) 
WHERE branch_id = @branchIdVal 
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_def_post] TO [public]
GO
