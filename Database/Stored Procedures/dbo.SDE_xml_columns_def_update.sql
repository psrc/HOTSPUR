SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_xml_columns_def_update]
@columnIdVal INTEGER, @indexIdVal INTEGER, @minimumIdVal INTEGER,
@configKeywordVal NVARCHAR(32), @xflagsVal INTEGER
AS SET NOCOUNT ON
BEGIN
-- Either we're updating all three columns, or just the index
IF @minimumIdVal IS NOT NULL
BEGIN
  UPDATE dbo.SDE_xml_columns
  SET index_id =  @indexIdVal,
  minimum_id =  @minimumIdVal,
  config_keyword =  @configKeywordVal,
  xflags =  @xflagsVal
  WHERE column_id =  @columnIdVal
END
ELSE
BEGIN
  UPDATE dbo.SDE_xml_columns
  SET index_id =  @indexIdVal
  WHERE column_id =  @columnIdVal
END
END

GO
GRANT EXECUTE ON  [dbo].[SDE_xml_columns_def_update] TO [public]
GO
