SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_mbtables_def_insert_start_moment] 
@regIdVal INTEGER, @startMomentVal DATETIME2 AS SET NOCOUNT ON 
INSERT INTO dbo.SDE_multibranch_tables (registration_id, start_moment) VALUES (@regIdVal, @startMomentVal)

GO
GRANT EXECUTE ON  [dbo].[SDE_mbtables_def_insert_start_moment] TO [public]
GO
