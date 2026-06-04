SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_def_trim_states]
@highStateIdVal BIGINT, @lowStateIdVal BIGINT AS SET NOCOUNT ON
BEGIN
  IF @lowStateIdVal = 0
  BEGIN
    -- Uninvert the inverted lineage names; once the delete is done
    -- it is safe to put them back. Make sure to use RC so that
    -- we don't update another process's negative lineages.
    UPDATE dbo.SDE_states WITH (READCOMMITTED)
    SET    lineage_name = -lineage_name
    WHERE  lineage_name < 0 AND parent_state_id = 0
  END
  ELSE
  BEGIN
    -- Return the lineage id to a positive number.
    UPDATE dbo.SDE_states
    SET    lineage_name = -lineage_name
    WHERE  state_id = @highStateIdVal
  END
END
GO
GRANT EXECUTE ON  [dbo].[SDE_state_def_trim_states] TO [public]
GO
