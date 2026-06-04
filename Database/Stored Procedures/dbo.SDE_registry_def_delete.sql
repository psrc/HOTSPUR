SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_registry_def_delete]       @regIdVal INTEGER AS SET NOCOUNT ON      DELETE FROM dbo.SDE_mvtables_modified WHERE registration_id = @regIdVal 
      DELETE FROM dbo.SDE_table_registry WHERE registration_id = @regIdVal 
GO
GRANT EXECUTE ON  [dbo].[SDE_registry_def_delete] TO [public]
GO
