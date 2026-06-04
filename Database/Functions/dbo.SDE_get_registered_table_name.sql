SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SDE_get_registered_table_name] (@regIdVal INTEGER) RETURNS NVARCHAR(226)
AS BEGIN
--This is a private support function.
DECLARE @rTableName sysname,
@rOwner NVARCHAR(128)

SELECT @rTableName = table_name, @rOwner = owner
FROM dbo.SDE_table_registry
WHERE registration_id = @regIdVal

IF @rTableName IS NOT NULL
RETURN @rOwner + N'.' + @rTableName
RETURN NULL
END

GO
GRANT EXECUTE ON  [dbo].[SDE_get_registered_table_name] TO [public]
GO
