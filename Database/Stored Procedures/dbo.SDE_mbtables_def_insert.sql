SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_mbtables_def_insert] 
@regIdVal INTEGER AS SET NOCOUNT ON
INSERT INTO dbo.SDE_multibranch_tables (registration_id) values(@regIdVal)

GO
GRANT EXECUTE ON  [dbo].[SDE_mbtables_def_insert] TO [public]
GO
