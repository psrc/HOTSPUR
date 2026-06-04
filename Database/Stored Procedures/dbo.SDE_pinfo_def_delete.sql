SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_pinfo_def_delete] @sdeIdVal INTEGER AS SET NOCOUNT ON
BEGIN TRAN pinfo_tran
DELETE FROM dbo.SDE_process_information WHERE sde_id = @sdeIdVal
COMMIT TRAN pinfo_tran
GO
GRANT EXECUTE ON  [dbo].[SDE_pinfo_def_delete] TO [public]
GO
