SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_get_current_user_name]
@current_user NVARCHAR (128) OUTPUT AS SET NOCOUNT ON
BEGIN
 DECLARE @delimiter INTEGER
 DECLARE @owner NVARCHAR(128)
 -- Get current user name. Format the user name as quoted identifier
 -- if the current user name does not comply with the rules for the format of
 -- regular identifiers

 SET @current_user = user_name()
 SET @delimiter = charindex('~', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('.', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('%', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('^', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('(', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex (')', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('-', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('{', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('}', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex (' ', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('\', @current_user)
 IF  @delimiter <> 0
 BEGIN
   SET  @current_user = N'"' + user_name() + N'"'
 END
 -- This stored prcedure will return current user name in upper case format 
 -- if the database is case insenstive. In order to know if the database is case
 -- sensitive, here to compare the @current_user to the same string but in upper 
 -- case. If they are equal, then the database is case insenstive and uppercase 
 -- format of current user name will be returned. 
 SET  @owner = UPPER(@current_user)
 IF  @current_user = @owner 
   SET  @current_user = @owner
END

GO
GRANT EXECUTE ON  [dbo].[SDE_get_current_user_name] TO [public]
GO
