SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_lock_def_insert]
@sdeIdVal INTEGER,
@stateIdVal BIGINT,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1) AS SET NOCOUNT ON
DECLARE @isConflictVal INTEGER
DECLARE @ret_val INTEGER
BEGIN TRAN state_lock_tran

IF (@lockTypeVal = 'E' OR @lockTypeVal = 'X')
  SELECT 1 FROM dbo.SDE_state_locks WITH (TABLOCKX) WHERE 1 = 0
ELSE
  SELECT 1 FROM dbo.SDE_state_locks WITH (HOLDLOCK) WHERE 1 = 0

/* Marks don't conflict and it doesn't hurt if they are duplicates, */
/* so skip all that for them */
IF @lockTypeVal <> 'M' 
BEGIN
/* Delete any existing lock on this state owned by this user. */
/* This gets it out of the way during conflict checking (it will be */
/* restored via rollback if a conflict is detected).*/
  EXECUTE dbo.SDE_state_lock_def_delete @sdeIdVal, @stateIdVal, @autoLockVal,0

/* check for conflicts */
  EXECUTE dbo.SDE_state_check_lock_conflicts @sdeIdVal,@stateIdVal,@autoLockVal,@lockTypeVal,@isConflictVal OUTPUT
END
ELSE
BEGIN
  SET @isConflictVal = 0
END

IF (@isConflictVal = 0)
BEGIN
  INSERT INTO dbo.SDE_state_locks
         (sde_id,state_id,autolock,lock_type)
  VALUES (@sdeIdVal,@stateIdVal,@autoLockVal,@lockTypeVal)
  SET @ret_val = 0 /* SE_SUCCESS */ 
  COMMIT TRAN state_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN state_lock_tran
END
RETURN @ret_val
GO
GRANT EXECUTE ON  [dbo].[SDE_state_lock_def_insert] TO [public]
GO
