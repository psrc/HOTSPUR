SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_check_lock_conflicts]
@sdeIdVal INTEGER,
@stateIdVal BIGINT,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@lock_conflict INTEGER OUTPUT AS SET NOCOUNT ON
DECLARE @count INTEGER
BEGIN
  SET @lock_conflict = 0

  /* Find any conflicting locks.  The query we use is sensitive about
     whether we are trying to place an exclusive lock (in which case we
     have to consider all locks as possibly conflicting), or a shared lock
     (in which case we only have to worry about conflicting with exclusive
     locks).  With all of the about constraints in place, if any rows
     are returned, we probably have a conflict. */ 

  SELECT @count = COUNT(*) FROM  tempdb.sys.objects SO INNER JOIN 
    dbo.SDE_process_information PR ON object_id (PR.table_name) = SO.object_id INNER JOIN 
    dbo.SDE_state_locks SL ON PR.sde_id = SL.sde_id 
    WHERE ((SL.state_id = @stateIdVal AND
           (SL.sde_id <> @sdeIdVal OR 
            SL.autolock = @autoLockVal) AND
           (SL.lock_type = 'E' /* E: Exclusive lock */ OR 
            @lockTypeVal = 'E')) OR
          (SL.lock_type = 'X' /* X: Exclusive lock all */ OR
           @lockTypeVal = 'X')) AND
          SL.lock_type <> 'M'
 /* we have a lock conflict! */
 IF @count > 0
   SET @lock_conflict = 1
END

GO
GRANT EXECUTE ON  [dbo].[SDE_state_check_lock_conflicts] TO [public]
GO
