SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_trim_pre_delete]
@highStateIdVal BIGINT, @lowStateIdVal BIGINT AS SET NOCOUNT ON
BEGIN
  IF @lowStateIdVal = 0
  BEGIN
    -- We need to delete any modified flags before changing the high
    -- state to be the base state, or the states<->mvtables_modified
    -- integrity constraint will be violated, aborting the following.
    -- UPDATE. Similarly, we must also remove old state_lineages entries.

    DELETE FROM dbo.SDE_mvtables_modified
    WHERE  state_id  = @highStateIdVal
    DELETE FROM dbo.SDE_state_lineages
    WHERE  lineage_id  = @highStateIdVal

    -- We need to insert a 0,0 entry in the state_lineages table
    -- if it doesn't exist.
    DECLARE @baseIdExists INTEGER
    SELECT @baseIdExists = count(*) FROM dbo.SDE_state_lineages
      WHERE lineage_name = 0 AND lineage_id = 0
    IF (@baseIdExists = 0)
    BEGIN
      INSERT INTO dbo.SDE_state_lineages (lineage_name,lineage_id) VALUES (0,0)
    END
    -- Make sure the base state is closed and proper.
    UPDATE dbo.SDE_states
      SET parent_state_id = 0,
          owner = 'dbo',
          closing_time = ISNULL (closing_time,GETDATE()),
          lineage_name = 0
      WHERE state_id = 0
    -- Make the lineage_name negative of any immediate child state
    -- of the state becoming the base state, so that when we update
    -- the parent_state_id to become the base_state_id, we don't
    -- violate the states_uk constraint on parent_state_id and
    -- lineage_name.
    UPDATE dbo.SDE_states
      SET    lineage_name = -lineage_name
      WHERE  parent_state_id = @highStateIdVal
    -- Update the parent_id of any immediate child state of the state
    -- becoming the base state to be the base state.
    UPDATE dbo.SDE_states
      SET    parent_state_id = 0
      WHERE  parent_state_id = @highStateIdVal
    -- Update any versions based on the state becoming the base state
    -- to point at the base state instead.
    UPDATE dbo.SDE_versions
      SET    state_id = 0
      WHERE  state_id = @highStateIdVal
    -- Remove the high_state now that it has been compressed.
    DELETE FROM dbo.SDE_states
    WHERE  state_id = @highStateIdVal
  END
  ELSE
  BEGIN
    -- Update the parent_id but also invert the lineage id to avoid
    -- violating states_uk.
    UPDATE dbo.SDE_states
    SET    parent_state_id = (SELECT parent_state_id
                              FROM  dbo.SDE_states
                              WHERE  state_id = @lowStateIdVal),
           lineage_name = -lineage_name
    WHERE  state_id = @highStateIdVal
  END
END
GO
GRANT EXECUTE ON  [dbo].[SDE_state_trim_pre_delete] TO [public]
GO
