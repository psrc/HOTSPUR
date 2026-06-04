SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SDE_get_version_access] (
@status INTEGER,
@version_owner NVARCHAR (128)) 
RETURNS CHAR(1) 
BEGIN
--This is a private support function for SDE versioned views.

-- Get the current login & user name
DECLARE @user      NVARCHAR (128)
DECLARE @protected CHAR (1)
DECLARE @is_dba INTEGER
DECLARE @delimiter INTEGER
SELECT @user = user_name()
SET @delimiter = PATINDEX('"%', @version_owner)
IF @delimiter > 0
BEGIN
 SET @user = N'"' + user_name() + N'"' 
END
SET @is_dba = dbo.SDE_is_user_sde_dba ()
SET @status = @status - floor (@status / 4) * 4
IF @status = 0 -- private version
BEGIN
  IF ((@is_dba = 0) AND (@user <> @version_owner))
    SET @protected = '2' -- no permission
  ELSE
    SET @protected = '0'; -- full permission
END
ELSE IF @status = 2 -- protected version
BEGIN
  IF ((@is_dba = 0) AND (@user <> @version_owner))
    SET @protected = '1' -- read only permission
  ELSE
    SET @protected = '0' -- full permission
END
ELSE
  SET @protected = '0' -- must be a public version
RETURN @protected
END

GO
GRANT EXECUTE ON  [dbo].[SDE_get_version_access] TO [public]
GO
