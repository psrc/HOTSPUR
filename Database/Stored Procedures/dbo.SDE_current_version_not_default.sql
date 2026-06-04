SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_current_version_not_default] @current_state BIGINT AS 
SET NOCOUNT ON BEGIN
--This is a private support procedure for SDE versioned views.
--Check for default version.
  DECLARE @count INTEGER
  SELECT @count = count(*)
  FROM   dbo.SDE_versions 
  WHERE  name = 'DEFAULT' AND owner = 'dbo' AND state_id = @current_state
IF @count = 1
BEGIN
  DECLARE @error_string NVARCHAR(256)
  SET @error_string = 'You may not update this view on an ' +
                      'archiving table in the DEFAULT version.'
  RAISERROR (@error_string,16,-1)
  RETURN -1
END
RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[SDE_current_version_not_default] TO [public]
GO
