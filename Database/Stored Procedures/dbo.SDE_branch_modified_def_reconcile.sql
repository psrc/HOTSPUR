SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_def_reconcile] 
@branchIdVal INTEGER, @reconcileMomentVal DATETIME2 AS SET NOCOUNT ON 
DELETE btm FROM dbo.SDE_branch_tables_modified AS btm WITH (FORCESEEK, INDEX(1)) INNER JOIN 
(SELECT * FROM 
(SELECT *, ROW_NUMBER() OVER (PARTITION BY registration_id ORDER BY edit_moment DESC) rn 
FROM dbo.SDE_branch_tables_modified WHERE branch_id = @branchIdVal) __a 
WHERE __a.rn > 1) b 
ON btm.branch_id = b.branch_id 
AND btm.registration_id = b.registration_id 
AND btm.edit_moment = b.edit_moment 

UPDATE btm SET edit_moment = @reconcileMomentVal 
FROM dbo.SDE_branch_tables_modified btm WITH (FORCESEEK, INDEX(1)) 
WHERE branch_id = @branchIdVal

GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_def_reconcile] TO [public]
GO
