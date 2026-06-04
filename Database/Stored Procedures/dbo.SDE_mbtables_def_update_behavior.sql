SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_mbtables_def_update_behavior] 
@regIdVal INTEGER,
@behaviorMapVal BINARY(16) AS SET NOCOUNT ON
UPDATE dbo.SDE_multibranch_tables SET behavior_map = @behaviorMapVal WHERE registration_id = @regIdVal
GO
GRANT EXECUTE ON  [dbo].[SDE_mbtables_def_update_behavior] TO [public]
GO
