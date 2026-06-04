SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_archives_def_delete]
@archivingRegIdVal INTEGER AS SET NOCOUNT ON
BEGIN
DELETE FROM dbo.SDE_archives WHERE archiving_regid =  @archivingRegIdVal
END

GO
GRANT EXECUTE ON  [dbo].[SDE_archives_def_delete] TO [public]
GO
