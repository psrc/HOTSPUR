SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[is_archive_enabled]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
DECLARE @oflags INTEGER
SELECT @oflags = object_flags FROM dbo.SDE_table_registry  WHERE owner = @owner AND table_name = @table 
IF @@ROWCOUNT = 0
  RETURN 'NOT REGISTERED'
IF (@oflags & 262144) > 0 
  RETURN 'TRUE'
RETURN 'FALSE'
END

GO
GRANT EXECUTE ON  [dbo].[is_archive_enabled] TO [public]
GO
