SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_def_insert] 
@nameVal NVARCHAR(64), @ownerVal NVARCHAR(255),
@descVal NVARCHAR(64), @statusVal INTEGER,
@serviceVal NVARCHAR(512), @branchGuidVal NVARCHAR(38)
AS SET NOCOUNT ON
DECLARE @result INTEGER 
SET @result = 0 /* SE_SUCCESS */ 
  INSERT INTO dbo.SDE_branches (name, owner, description, status, service_name, branch_guid) 
  VALUES(RTRIM(@nameVal),@ownerVal,@descVal,@statusVal,@serviceVal,@branchGuidVal) 
  IF @@ERROR > 0 
    SET @result = -586  /* SE_BRANCH_EXISTS */ 
RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_def_insert] TO [public]
GO
