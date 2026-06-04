SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_versions_def_delete]       @ownerVal NVARCHAR(128), @nameVal  NVARCHAR(64) AS SET NOCOUNT ON      DECLARE @result INTEGER      SET @result = 0      IF UPPER(@ownerVal) = UPPER('dbo') AND UPPER(@nameVal) = 'DEFAULT'        SET @result = -25 /* SE_NO_PERMISSIONS */      ELSE        DELETE FROM dbo.SDE_versions WHERE owner = @ownerVal AND name = @nameVal      RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_versions_def_delete] TO [public]
GO
