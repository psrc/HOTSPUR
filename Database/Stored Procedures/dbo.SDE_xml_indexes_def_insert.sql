SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_xml_indexes_def_insert]
@ownerVal NVARCHAR(128),@indexNameVal NVARCHAR(128),
@indexTypeVal INTEGER, @descriptionVal NVARCHAR(64) AS
SET NOCOUNT ON BEGIN
INSERT INTO dbo.SDE_xml_indexes(index_name, owner, index_type, description) VALUES 
  (@indexNameVal, @ownerVal, @indexTypeVal, @descriptionVal)
DECLARE @index_id INTEGER
SELECT @index_id = @@IDENTITY
RETURN @index_id
END

GO
GRANT EXECUTE ON  [dbo].[SDE_xml_indexes_def_insert] TO [public]
GO
