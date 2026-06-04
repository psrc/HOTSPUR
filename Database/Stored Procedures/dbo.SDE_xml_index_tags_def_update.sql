SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_xml_index_tags_def_update]
@indexIdVal INTEGER, @tagNameVal NVARCHAR(1024),
@tagAliasVal INTEGER, @descriptionVal NVARCHAR(64),
@isExcludedVal INTEGER AS
SET NOCOUNT ON
BEGIN
  UPDATE dbo.SDE_xml_index_tags SET tag_alias = @tagAliasVal,
    description = @descriptionVal, is_excluded = @isExcludedVal
    WHERE index_id = @indexIdVal AND tag_name = @tagNameVal
END
GO
GRANT EXECUTE ON  [dbo].[SDE_xml_index_tags_def_update] TO [public]
GO
