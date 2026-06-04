SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_def_update_name] 
@branchIdVal INTEGER, @nameVal NVARCHAR(128) 
AS SET NOCOUNT ON 
DECLARE @result INTEGER, @resultCount INTEGER 
SET @result = 0 /* SE_SUCCESS */ 
IF @branchIdVal = 0 
  SET @result = -25 /* SE_NO_PERMISSIONS */ 
ELSE
BEGIN
  BEGIN TRY
    UPDATE dbo.SDE_branches SET name = @nameVal WHERE branch_id = @branchIdVal 
    SELECT @resultCount = @@ROWCOUNT 
    IF @resultCount = 0 
      SET @result = -587 /* SE_BRANCH_NOEXIST */ 
  END TRY 
  BEGIN CATCH 
   IF ERROR_NUMBER() = 2627 /* unique constraint violation */ 
     SET @result = -586 /* SE_BRANCH_EXISTS */ 
  END CATCH 
END
RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_def_update_name] TO [public]
GO
