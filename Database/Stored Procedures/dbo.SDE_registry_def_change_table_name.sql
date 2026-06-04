SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_registry_def_change_table_name]       @tabNameVal sysname, @regIdVal INTEGER AS SET NOCOUNT ON
      UPDATE m set m.object_name = @tabNameVal from dbo.SDE_metadata m 
       INNER JOIN dbo.SDE_table_registry r ON 
       m.object_name = r.table_name AND 
       m.object_owner = r.owner 
       WHERE  r.registration_id = @regIdVal AND m.object_type = 1 
      UPDATE dbo.SDE_table_registry SET table_name = @tabNameVal WHERE registration_id = @regIdVal
GO
GRANT EXECUTE ON  [dbo].[SDE_registry_def_change_table_name] TO [public]
GO
