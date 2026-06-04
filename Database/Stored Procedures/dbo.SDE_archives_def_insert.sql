SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_archives_def_insert]
@archivingRegIdVal INTEGER, @historyRegIdVal INTEGER,
@fromDateVal NVARCHAR(128),
@toDateVal NVARCHAR(128),
@archiveDateVal BIGINT, @archiveFlagsVal BIGINT
AS SET NOCOUNT ON
BEGIN
INSERT INTO dbo.SDE_archives
  (archiving_regid,history_regid,from_date,to_date,archive_date,archive_flags) VALUES
  (@archivingRegIdVal,@historyRegIdVal,@fromDateVal,@toDateVal,@archiveDateVal,@archiveFlagsVal)
END

GO
GRANT EXECUTE ON  [dbo].[SDE_archives_def_insert] TO [public]
GO
