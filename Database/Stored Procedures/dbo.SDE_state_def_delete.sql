SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_def_delete]
@id1 BIGINT, @id2 BIGINT, @id3 BIGINT, @id4 BIGINT, @id5 BIGINT,
@id6 BIGINT, @id7 BIGINT, @id8 BIGINT AS SET NOCOUNT ON
BEGIN
  DECLARE @ret_code INTEGER
  SET @ret_code = 0
  -- If we are deleting a single state, we add an additional check
  -- to make sure that this state has no child states.  This
  -- prevents some potential timing problems with compress.
  IF @id2 = -1
  BEGIN
    DECLARE @SE_STATE_HAS_CHILDREN INTEGER
    SET @SE_STATE_HAS_CHILDREN = 50175

    DECLARE @childCount INTEGER
    SELECT @childCount = COUNT(*) FROM dbo.SDE_states
      WHERE  parent_state_id = @id1
    IF @childCount <> 0
    BEGIN
      SET @ret_code = @SE_STATE_HAS_CHILDREN
      RETURN @ret_code
    END
  END

  DELETE FROM dbo.SDE_mvtables_modified WHERE state_id IN
    (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)

  -- Delete any lineages about to be orphaned
  DELETE FROM dbo.SDE_state_lineages WHERE lineage_name IN
    (SELECT lineage_name FROM dbo.SDE_states S1 WHERE state_id in
         (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)
     AND NOT EXISTS (SELECT * FROM dbo.SDE_states S2
     WHERE S1.lineage_name = ABS(S2.lineage_name) AND S2.state_id NOT IN
         (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)))

  -- Delete the states
  DELETE FROM dbo.SDE_states WHERE state_id IN
    (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)

  -- Delete any automatically placed exclusive state locks.
  DELETE FROM dbo.SDE_state_locks WHERE  state_id IN
    (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8) AND  state_id <> 0 AND
    autolock = 'Y' AND lock_type = 'E'
  RETURN @ret_code
END
GO
GRANT EXECUTE ON  [dbo].[SDE_state_def_delete] TO [public]
GO
