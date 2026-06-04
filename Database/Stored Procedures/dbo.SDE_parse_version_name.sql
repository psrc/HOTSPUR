SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_parse_version_name] 
@version_name NVARCHAR (97),
@parsed_name NVARCHAR (64) OUTPUT,
@parsed_owner NVARCHAR (128) OUTPUT AS SET NOCOUNT ON
BEGIN
  --This is a private support function for SDE versioned views.

  DECLARE @error_string NVARCHAR(256)
  DECLARE @delimiter INTEGER
  DECLARE @SE_INVALID_VERSION_NAME INTEGER
  SET @SE_INVALID_VERSION_NAME = 50171

  -- Parse the version name.
  SET @delimiter = PATINDEX ('%".%', @version_name)
  IF @delimiter <> 0
  BEGIN
    SET @parsed_owner = substring (@version_name, 1, @delimiter)
    SET @parsed_name = substring (@version_name, @delimiter + 2, 64)
  END
  ELSE
  BEGIN
    SET @delimiter = charindex ('.', @version_name)
    IF @delimiter <> 0
    BEGIN
      SET @parsed_owner = substring (@version_name, 1, @delimiter - 1)
      SET @parsed_name = substring (@version_name, @delimiter + 1, 64)
    END
    ELSE
    BEGIN
      SET @parsed_name = @version_name
      EXECUTE dbo.SDE_get_current_user_name @parsed_owner OUTPUT
    END
  END

  IF RTRIM (@parsed_name) IS NULL OR LEN (@parsed_name) = 0 OR
     RTRIM (@parsed_owner) IS NULL OR LEN (@parsed_owner) = 0
  BEGIN
    SET @error_string = ISNULL (@version_name, '(null)') +
                       ' is not a valid version name.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_VERSION_NAME
  END

  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[SDE_parse_version_name] TO [public]
GO
