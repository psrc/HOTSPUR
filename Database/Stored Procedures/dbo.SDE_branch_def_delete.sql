SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_def_delete] 
 @branchIdVal INTEGER AS SET NOCOUNT ON 
DECLARE @result INTEGER 
SET @result = 0 /* SE_SUCCESS */ 
IF @branchIdval = 0 
  SET @result = -25 /* SE_NO_PERMISSIONS */ 
ELSE 
  DELETE FROM dbo.SDE_branches WHERE branch_id = @branchIdVal 
  IF @@ROWCOUNT = 0 
    SET @result = -587  /* SE_BRANCH_NOEXIST */ 
RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_def_delete] TO [public]
GO
