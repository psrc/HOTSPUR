SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_table_lock_def_insert]
@sdeIdVal INTEGER,
@registrationIdVal INTEGER,
@lockTypeVal VARCHAR(1) AS SET NOCOUNT ON
DECLARE @isConflictVal INTEGER
DECLARE @ret_val INTEGER
BEGIN TRAN table_lock_tran

IF (@lockTypeVal = 'E')
  SELECT 1 FROM dbo.SDE_table_locks WITH (TABLOCKX) WHERE 1 = 0
ELSE
  SELECT 1 FROM dbo.SDE_table_locks WITH (HOLDLOCK) WHERE 1 = 0

/* Delete any existing lock on this table owned by this user.*/
/* This gets it out of the way during conflict checking (it will be*/
/* restored via rollback if a conflict is detected).*/
EXECUTE dbo.SDE_table_lock_def_delete @sdeIdVal, @registrationIdVal

/* check for conflicts */
EXECUTE dbo.SDE_table_check_lock_conflicts @sdeIdVal,@registrationIdVal,@lockTypeVal,@isConflictVal OUTPUT
IF (@isConflictVal = 0)
BEGIN
  INSERT INTO dbo.SDE_table_locks
         (sde_id,registration_id,lock_type)
  VALUES (@sdeIdVal,@registrationIdVal,@lockTypeVal)
  SET @ret_val = 0 /* SE_SUCCESS */ 
  COMMIT TRAN table_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN table_lock_tran
END
RETURN @ret_val

GO
GRANT EXECUTE ON  [dbo].[SDE_table_lock_def_insert] TO [public]
GO
