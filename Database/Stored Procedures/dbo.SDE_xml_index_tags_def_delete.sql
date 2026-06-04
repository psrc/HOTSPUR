SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_xml_index_tags_def_delete]
@indexIdVal INTEGER, @id1 INTEGER, @id2 INTEGER, @id3 INTEGER,
@id4 INTEGER, @id5 INTEGER, @id6 INTEGER, @id7 INTEGER, @id8 INTEGER AS
SET NOCOUNT ON
BEGIN
  DELETE FROM dbo.SDE_xml_index_tags WHERE index_id = @indexIdVal
  AND tag_id IN (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)
END
GO
GRANT EXECUTE ON  [dbo].[SDE_xml_index_tags_def_delete] TO [public]
GO
