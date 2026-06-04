SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_table_check_lock_conflicts]
@sdeIdVal INTEGER,
@registrationIdVal INTEGER,
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
     are returned, we probably have a conflict.  */

  SELECT @count = COUNT(*) FROM tempdb.sys.objects SO INNER JOIN 
    dbo.SDE_process_information PR ON object_id (PR.table_name) = SO.object_id INNER JOIN 
    dbo.SDE_table_locks TL ON PR.sde_id = TL.sde_id
    WHERE TL.registration_id = @registrationIdVal AND
           (TL.lock_type = 'E' /* E: Exclusive lock */ OR
           @lockTypeVal = 'E')
 /* we have a lock conflict! */
 IF @count > 0
  SET @lock_conflict = 1
END

GO
GRANT EXECUTE ON  [dbo].[SDE_table_check_lock_conflicts] TO [public]
GO
