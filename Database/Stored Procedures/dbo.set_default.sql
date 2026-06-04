SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[set_default] 
AS SET NOCOUNT ON
BEGIN
  /* This is a public procedure to set multi version views
  to point to the default version, even as other processes
  might be moving the default version to new states.*/

  -- Check if we are already in an edit session.
  DECLARE @g_state_id BIGINT
  DECLARE @g_protected CHAR(1)
  DECLARE @g_is_default CHAR(1)
  DECLARE @g_version_id INTEGER
  EXECUTE dbo.SDE_get_globals   @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
  IF @g_version_id != -1
  BEGIN
    -- Check that version and state still exist (e.g. may have been rolled back)
    DECLARE @exists INTEGER
    SELECT @exists = count(*) from dbo.SDE_versions
      WHERE version_id = @g_version_id
    IF @exists > 0
    BEGIN
      SELECT @exists = count(*) from dbo.SDE_states
        WHERE state_id = @g_state_id
      IF @exists > 0
      BEGIN
        DECLARE @error_string NVARCHAR(256)
        SET @error_string = 'Cannot set default with an open transaction to another version.'
        RAISERROR (@error_string,16,-1)
        RETURN
      END
    END
  END

  SET CONTEXT_INFO 0x0
END

GO
GRANT EXECUTE ON  [dbo].[set_default] TO [public]
GO
