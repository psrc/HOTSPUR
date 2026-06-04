SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_versions_def_rename_parent] @newNameVal     NVARCHAR(64), @oldNameVal NVARCHAR(64), @ownerVal NVARCHAR(128) AS    SET NOCOUNT OFF    UPDATE dbo.SDE_versions     SET parent_name = @newNameVal WHERE parent_name = @oldNameVal    AND parent_owner = @ownerVal
GO
GRANT EXECUTE ON  [dbo].[SDE_versions_def_rename_parent] TO [public]
GO
