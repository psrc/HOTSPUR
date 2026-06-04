SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_table_lock_def_delete_user] @sdeIdVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN table_lock_tran     DELETE FROM dbo.SDE_table_locks WHERE  sde_id = @sdeIdVal     COMMIT TRAN table_lock_tran
GO
GRANT EXECUTE ON  [dbo].[SDE_table_lock_def_delete_user] TO [public]
GO
