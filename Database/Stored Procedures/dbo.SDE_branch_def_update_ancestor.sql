SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_def_update_ancestor] 
@branchIdVal INTEGER, @ancestorVal DATETIME2 AS SET NOCOUNT ON 
DECLARE @result INTEGER
SET @result = 0 /* SE_SUCCESS */ 
IF @branchIdval = 0
  SET @result = -25 /* SE_NO_PERMISSIONS */ 
ELSE 
BEGIN
  UPDATE dbo.SDE_branches SET previous_ancestor_moment = ancestor_moment, 
 ancestor_moment = @ancestorVal WHERE branch_id = @branchIdVal 
  IF @@ROWCOUNT = 0 
    SET @result = -587 /* SE_BRANCH_NOEXIST */ 
END
RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_def_update_ancestor] TO [public]
GO
