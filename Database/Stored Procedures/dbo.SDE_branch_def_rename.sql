SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_def_rename] 
@ownerVal NVARCHAR(255), @oldNameVal NVARCHAR(64), @newNameVal NVARCHAR(64)
AS SET NOCOUNT ON
DECLARE @result INTEGER 
SET @result = 0 /* SE_SUCCESS */ 
IF @ownerVal = 'sde' AND @oldNameVal = 'DEFAULT' 
    SET @result = -25 /* SE_NO_PERMISSIONS */ 
ELSE 
BEGIN 
  DECLARE @rowCount INTEGER 
  SELECT @rowCount = COUNT(branch_id) from dbo.SDE_branches WHERE owner = @ownerVal AND name = @oldNameVal 
  IF @rowCount > 1 
    SET @result = -591 /* SE_INVALID_BRANCH_NAME */ 
  ELSE IF @rowCount = 0 
      SET @result = -587 /* SE_BRANCH_NOEXIST */ 
  ELSE 
  BEGIN 
   BEGIN TRY 
     UPDATE dbo.SDE_branches SET name = @newNameVal WHERE owner = @ownerVal AND name = @oldNameVal 
   END TRY 
   BEGIN CATCH 
     IF ERROR_NUMBER() = 2627 /* unique constraint violation */ 
       SET @result = -586 /* SE_BRANCH_EXISTS */ 
   END CATCH 
  END 
END 
RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_def_rename] TO [public]
GO
