SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_xml_index_tags_def_insert]
@index_id INTEGER, @tagNameVal NVARCHAR(1024),
@dataTypeVal INTEGER, @tagAliasVal INTEGER,
@descriptionVal NVARCHAR(64), @excluded  INTEGER
AS SET NOCOUNT ON
BEGIN
  INSERT INTO dbo.SDE_xml_index_tags
   (index_id, tag_name, data_type, tag_alias, description, is_excluded)   VALUES (@index_id, @tagNameVal, @dataTypeVal, @tagAliasVal,
           @descriptionVal, @excluded)
  DECLARE @tag_id INTEGER
  SELECT @tag_id = @@IDENTITY
  RETURN @tag_id
END

GO
GRANT EXECUTE ON  [dbo].[SDE_xml_index_tags_def_insert] TO [public]
GO
