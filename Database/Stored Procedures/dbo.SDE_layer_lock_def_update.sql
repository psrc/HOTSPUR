SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_lock_def_update]
@sdeIdVal INTEGER,
@layerIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@minxVal BIGINT,
@minyVal BIGINT,
@maxxVal BIGINT,
@maxyVal BIGINT AS SET NOCOUNT ON
DECLARE @isConflictVal INTEGER
DECLARE @ret_val INTEGER
BEGIN TRAN layer_lock_tran
/* Delete the lock we are to update.  If it doesn't exist, we will
   report an error.  If it does exist, this will
   get it out of the way so we can test for conflicts.*/
  EXECUTE @ret_val = dbo.SDE_layer_lock_def_delete @sdeIdVal, @layerIdVal, @autoLockVal
  IF @ret_val <> 0
    RETURN @ret_val
/* check for conflicts */
EXECUTE dbo.SDE_layer_check_lock_conflicts @sdeIdVal,@layerIdVal,@autoLockVal,@lockTypeVal,@minxVal,
        @minyVal,@maxxVal,@maxyVal, @isConflictVal OUTPUT
IF (@isConflictVal = 0)
BEGIN
  INSERT INTO dbo.SDE_layer_locks
         (sde_id,layer_id,autolock,lock_type,minx,miny,maxx,maxy)
  VALUES (@sdeIdVal,@layerIdVal,@autoLockVal,@lockTypeVal,@minxVal,
          @minyVal,@maxxVal,@maxyVal)
  SET @ret_val = 0 /* SE_SUCCESS */
  COMMIT TRAN layer_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN layer_lock_tran
END
RETURN @ret_val
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_lock_def_update] TO [public]
GO
