SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_def_update_status] 
@branchIdVal INTEGER, @statusVal INTEGER AS SET NOCOUNT ON 
DECLARE @result INTEGER
DECLARE @user NVARCHAR(128)
SET @result = 0 /* SE_SUCCESS */ 
SELECT @user = user_name()
IF @branchIdval = 0 AND @user <> 'dbo' 
  SET @result = -25 /* SE_NO_PERMISSIONS */ 
ELSE IF @branchIdval = 0 AND (@statusVal < 1 OR @statusVal > 3) 
  SET @result = -296 /* SE_OPERATION_NOT_ALLOWEd */ 
ELSE
BEGIN
  UPDATE dbo.SDE_branches SET status = @statusVal WHERE branch_id = @branchIdVal 
  IF @@ROWCOUNT = 0 
    SET @result = -587 /* SE_BRANCH_NOEXIST */ 
END
RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_def_update_status] TO [public]
GO
