SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_def_delete_regid] 
@regIdVal INTEGER AS SET NOCOUNT ON
DELETE FROM dbo.SDE_branch_tables_modified WITH(TABLOCKX) WHERE registration_id = @regIdVal
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_def_delete_regid] TO [public]
GO
