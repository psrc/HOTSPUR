SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_object_lock_def_delete_user] @sdeIdVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN object_lock_tran     DELETE FROM dbo.SDE_object_locks WHERE  sde_id = @sdeIdVal     COMMIT TRAN object_lock_tran
GO
GRANT EXECUTE ON  [dbo].[SDE_object_lock_def_delete_user] TO [public]
GO
