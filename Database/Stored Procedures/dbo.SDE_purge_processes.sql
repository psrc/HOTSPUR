SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_purge_processes] AS SET NOCOUNT ON
BEGIN TRAN pinfo_tran 
  DELETE dbo.SDE_process_information FROM dbo.SDE_process_information PR JOIN 
   (SELECT DISTINCT PR.sde_id, SO.object_id FROM dbo.SDE_process_information PR LEFT JOIN tempdb.sys.objects SO WITH (FORCESEEK)
     ON object_id(PR.table_name) = SO.object_id) DEL 
   ON PR.sde_id = DEL.sde_id WHERE DEL.object_id IS NULL 

COMMIT TRAN pinfo_tran
GO
GRANT EXECUTE ON  [dbo].[SDE_purge_processes] TO [public]
GO
