SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_dbtune_def_truncate]       AS SET NOCOUNT ON DELETE FROM dbo.SDE_dbtune 
GO
GRANT EXECUTE ON  [dbo].[SDE_dbtune_def_truncate] TO [public]
GO
