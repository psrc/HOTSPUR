SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_object_lock_def_delete] @sdeIdVal INTEGER, @objectIdVal INTEGER,     @objectTypeVal INTEGER, @applicationIdVal INTEGER,     @autoLockVal VARCHAR(1) AS SET NOCOUNT ON     DECLARE @ret_val INTEGER     DELETE FROM dbo.SDE_object_locks WHERE  sde_id = @sdeIdVal AND     object_id = @objectIdVal AND object_type = @objectTypeVal     AND application_id = @applicationIdVal AND autolock = @autoLockVal     IF @@ROWCOUNT = 0 SET @ret_val = -48 /* SE_NO_LOCKS */     ELSE SET @ret_val = 0 /* SE_SUCCESS */     RETURN @ret_val
GO
GRANT EXECUTE ON  [dbo].[SDE_object_lock_def_delete] TO [public]
GO
