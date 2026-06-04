SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_versions_def_change_state] @newStateIdVal BIGINT,      @nameVal NVARCHAR(64), @ownerVal NVARCHAR(128), @oldStateIdVal BIGINT AS      SET NOCOUNT OFF      UPDATE dbo.SDE_versions SET       state_id = @newStateIdVal WHERE name = @nameVal and owner = @ownerVal AND       state_id = @oldStateIdVal
GO
GRANT EXECUTE ON  [dbo].[SDE_versions_def_change_state] TO [public]
GO
