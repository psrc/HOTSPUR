SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_check_lock_conflicts]
@sdeIdVal INTEGER,
@layerIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@minxVal BIGINT,
@minyVal BIGINT,
@maxxVal BIGINT,
@maxyVal BIGINT,
@lock_conflict INTEGER OUTPUT AS SET NOCOUNT ON
DECLARE @count INTEGER
BEGIN
  SET @lock_conflict = 0

  /* Find any conflicting locks.  The query we use is sensitive about
     whether we are trying to place an exclusive lock (in which case we
     have to consider all locks as possibly conflicting), or a shared lock
     (in which case we only have to worry about conflicting with exclusive
     locks).  In either case, the query will include a range expression so
     composed that a lock with NULL envelope variables will always match
     any other lock.  This is because a NULL envelope indicates a layer-
     wide lock.  With all of the about constraints in place, if any rows
     are returned, we probably have a conflict.*/ 

  SELECT @count = COUNT(*) FROM tempdb.sys.objects SO INNER JOIN 
    dbo.SDE_process_information PR ON object_id (PR.table_name) = SO.object_id INNER JOIN 
    dbo.SDE_layer_locks LL ON PR.sde_id = LL.sde_id 
    WHERE  LL.layer_id = @layerIdVal AND
           (LL.sde_id <> @sdeIdVal OR
           LL.autolock = @autoLockVal) AND
           (LL.lock_type = 'E' /* E: Exclusive lock */ OR
            @lockTypeVal = 'E') AND
           ((LL.maxx >= @minxVal AND LL.maxy >= @minyVal AND
             @maxxVal >= LL.minx AND @maxyVal >= LL.miny) OR
             (LL.minx IS NULL OR @minxVal IS NULL))
 /* we have a lock conflict! */
 IF @count > 0
   SET @lock_conflict = 1
END

GO
GRANT EXECUTE ON  [dbo].[SDE_layer_check_lock_conflicts] TO [public]
GO
