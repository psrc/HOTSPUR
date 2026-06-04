SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_versions_def_rename] @newNameVal     NVARCHAR(64), @oldNameVal NVARCHAR(64), @ownerVal NVARCHAR(128) AS    DECLARE @result INTEGER    SET @result = 0    IF UPPER(@ownerVal) = 'dbo' AND UPPER(@oldNameVal) = 'DEFAULT'      SET @result = -25 /* SE_NO_PERMISSIONS */    ELSE    BEGIN      SET NOCOUNT OFF      UPDATE dbo.SDE_versions SET name = @newNameVal        WHERE name = @oldNameVal and owner = @ownerVal    END    RETURN @result
GO
GRANT EXECUTE ON  [dbo].[SDE_versions_def_rename] TO [public]
GO
