SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SDE_is_user_sde_dba] () RETURNS INTEGER
BEGIN
  --This is a private support function for SDE versioned views.
  DECLARE @user  NVARCHAR (128)
  DECLARE @is_dba INTEGER

  SELECT @user = user_name()
  IF ((@user <> 'dbo') AND (IS_SRVROLEMEMBER ('sysadmin') <> 1)) 
  BEGIN
    IF (IS_MEMBER('db_owner') <> 1) 
      SET @is_dba = 0 -- is not dba
    ELSE
      SET @is_dba = 1 -- is dba
  END
  ELSE
    SET @is_dba = 1 -- is dba

  RETURN @is_dba
END

GO
GRANT EXECUTE ON  [dbo].[SDE_is_user_sde_dba] TO [public]
GO
