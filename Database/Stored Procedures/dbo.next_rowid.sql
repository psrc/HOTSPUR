SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[next_rowid]
@owner NVARCHAR(128), @table NVARCHAR(128), @rowid INTEGER OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @newid BIGINT
DECLARE @max_int INTEGER
SET @max_int = 2147483647
EXEC dbo.next_rowid64 @owner, @table, @newid OUTPUT
IF (@newid > @max_int)
  RAISERROR (N'INTEGER OVERFLOW', 16, -1)
ELSE
  SET @rowid = @newid
END

GO
GRANT EXECUTE ON  [dbo].[next_rowid] TO [public]
GO
