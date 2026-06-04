SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_versions_def_insert]
@nameVal NVARCHAR(64) OUTPUT, @ownerVal NVARCHAR(128), @versionIdVal INTEGER,
@statusVal INTEGER, @stateIdVal BIGINT, @descVal NVARCHAR(64),
@pNameVal NVARCHAR(64), @pOwnerVal NVARCHAR(128), @pVersionIdVal INTEGER,
@dateVal DATETIME, @nameRuleVal INTEGER AS SET NOCOUNT ON
BEGIN
  DECLARE @suffix INTEGER
  DECLARE @ret_code INTEGER
  DECLARE @err_code INTEGER
  DECLARE @error_string NVARCHAR(256)
  DECLARE @local_version_name NVARCHAR(65)
  DECLARE @done INTEGER

  DECLARE @SE_VERSION_EXIST INTEGER
  SET @SE_VERSION_EXIST = 50177

  SET @local_version_name = RTRIM (@nameVal)
  SET @done = 0
  SET @suffix = 0

  WHILE @done = 0
  BEGIN 
    INSERT INTO dbo.SDE_versions (name, owner, version_id, status,
      state_id, description, parent_name, parent_owner,
      parent_version_id, creation_time) VALUES (
      @local_version_name,@ownerVal,@versionIdVal,@statusVal,@stateIdVal,
      @descVal,@pNameVal,@pOwnerVal,@pVersionIdVal,@dateVal)
    SET @err_code = @@error
    IF @err_code = 0
    BEGIN
      -- Insert worked, exit loop
      SET @done = 1
      SET @ret_code = 0
    END
    ELSE
    BEGIN
      IF @err_code = 2627
      BEGIN
        IF @nameRuleVal = 1
        BEGIN
          -- Unique constraint violation, let's try to generate a
          -- unique name
          SET @suffix = @suffix + 1
          SET @local_version_name = RTRIM (@nameVal) +
                                    cast (@suffix AS NVARCHAR(10))
          IF LEN (@local_version_name) > 64
          BEGIN
            SET @done = 1
            SET @ret_code = @SE_VERSION_EXIST
            SET @error_string = N'Unable to generate a name for ' + @nameVal
            RAISERROR (@error_string,16,-1)
          END
        END
        ELSE
        BEGIN
          -- Unique constraint violation, and we are not generating
          -- unique names
          SET @done = 1
          SET @ret_code = @SE_VERSION_EXIST
          SET @error_string = N'Version ' +  @nameVal + N' already exists.'
          RAISERROR (@error_string,16,-1)
        END
      END
      ELSE
      BEGIN
        -- Some other error occurred
        SET @done = 1
        SET @ret_code = @err_code
        SET @error_string = N'Unable to create version ' +  @nameVal
        RAISERROR (@error_string,16,-1)
      END
    END
  END

  -- Set the returned name, in case we changed it.
  SET @nameVal = @local_version_name

  RETURN @ret_code
END

GO
GRANT EXECUTE ON  [dbo].[SDE_versions_def_insert] TO [public]
GO
