SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_new_branch_state] 
@current_state_id BIGINT,
@current_lineage_name BIGINT,
@new_state_id BIGINT OUTPUT AS SET NOCOUNT ON
BEGIN
  --This is a private support procedure for SDE versioned views.

  DECLARE @ret INTEGER
  DECLARE @i INTEGER
  DECLARE @l_current_state_id BIGINT
  DECLARE @l_current_lineage_name BIGINT
  DECLARE @new_lineage_name BIGINT
  DECLARE @new_state_time DATETIME
  DECLARE @connection_id INTEGER
  DECLARE @user NVARCHAR (128)
  SET @i = 1
  SET @ret = 0
  SET @l_current_state_id = @current_state_id
  SET @l_current_lineage_name = @current_lineage_name
  WHILE @i < 4
  BEGIN
    -- insert a new state and point the default version to it.
    EXECUTE dbo.SDE_get_primary_oid 8,1,@new_state_id OUTPUT
    SET @new_lineage_name = @l_current_lineage_name
    EXECUTE dbo.SDE_get_primary_oid 12, 1, @connection_id OUTPUT
    EXECUTE dbo.SDE_get_current_user_name @user OUTPUT 
    EXECUTE dbo.SDE_state_def_insert @new_state_id,
      @user, @l_current_state_id, @new_lineage_name OUTPUT,
      @connection_id, 2, @new_state_time OUTPUT

    SET NOCOUNT OFF
    EXECUTE dbo.SDE_versions_def_change_state @new_state_id, 'DEFAULT',
      'dbo', @l_current_state_id
    IF @@ROWCOUNT = 0
    BEGIN
      SET @ret = -1
      EXECUTE dbo.SDE_state_def_delete @new_state_id,-1,-1,-1,-1,-1,-1,-1
      SELECT @l_current_state_id = state_id, @l_current_lineage_name = lineage_name
      FROM   dbo.SDE_states
      WHERE  state_id = (SELECT state_id FROM dbo.SDE_versions
        WHERE name = 'DEFAULT' AND owner = 'dbo')
      SET @i = @i + 1
    END
    ELSE
    BEGIN
      SET @i = 4
      SET @ret = 0
    END
  END --while loop

  SET NOCOUNT ON
  IF @ret != 0
    RETURN @ret

  EXECUTE dbo.SDE_state_lock_def_delete_user @connection_id

  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[SDE_new_branch_state] TO [public]
GO
