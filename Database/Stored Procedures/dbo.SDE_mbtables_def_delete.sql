SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_mbtables_def_delete] 
@regIdVal INTEGER  AS SET NOCOUNT ON
DELETE FROM dbo.SDE_multibranch_tables WHERE registration_id = @regIdVal
GO
GRANT EXECUTE ON  [dbo].[SDE_mbtables_def_delete] TO [public]
GO
