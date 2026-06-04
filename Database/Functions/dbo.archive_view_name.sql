SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[archive_view_name]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
DECLARE @view_name NVARCHAR(128)
SELECT @view_name = imv_view_name FROM dbo.SDE_table_registry  WHERE owner = @owner AND table_name = @table AND 
(object_flags & 8) = 0 AND (object_flags & 262144) > 0 
RETURN @view_name
END

GO
GRANT EXECUTE ON  [dbo].[archive_view_name] TO [public]
GO
