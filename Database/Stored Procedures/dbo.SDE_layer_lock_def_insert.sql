SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_lock_def_insert]
@sdeIdVal INTEGER,
@layerIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@minxVal BIGINT,
@minyVal BIGINT,
@maxxVal BIGINT,
@maxyVal BIGINT AS SET NOCOUNT ON
DECLARE @lock_conflict INTEGER
DECLARE @ret_val INTEGER
/* If this is not an autolock, delete any existing regular lock on this
   layer owned by this user.
   The lock is to be removed even if we subsequently encounter a lock
   conflict (this behavior is unique to layer locks).*/
BEGIN TRAN layer_lock_tran
IF (@lockTypeVal = 'E')
  SELECT 1 FROM dbo.SDE_layer_locks WITH (TABLOCKX) WHERE 1 = 0
ELSE
  SELECT 1 FROM dbo.SDE_layer_locks WITH (HOLDLOCK) WHERE 1 = 0

IF @autoLockVal <> 'Y'
  EXECUTE dbo.SDE_layer_lock_def_delete @sdeIdVal, @layerIdVal, @autoLockVal
/* check for conflicts */
EXECUTE dbo.SDE_layer_check_lock_conflicts @sdeIdVal,@layerIdVal,@autoLockVal,@lockTypeVal,@minxVal,
        @minyVal,@maxxVal,@maxyVal, @lock_conflict OUTPUT
IF (@lock_conflict = 0)
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
GRANT EXECUTE ON  [dbo].[SDE_layer_lock_def_insert] TO [public]
GO
