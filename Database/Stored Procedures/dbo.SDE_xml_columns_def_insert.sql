SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_xml_columns_def_insert]
@regIdVal INTEGER, @colNameVal NVARCHAR(128),
@indexIdVal INTEGER, @minimumIdVal INTEGER,
@configKeywordVal NVARCHAR(32), @xflagsVal INTEGER
AS SET NOCOUNT ON
BEGIN
INSERT INTO dbo.SDE_xml_columns
  (registration_id, column_name, index_id, minimum_id, config_keyword, xflags) VALUES
  (@regIdVal, @colNameVal, @indexIdVal, @minimumIdVal, @configKeywordVal, @xflagsVal)
DECLARE @column_id INTEGER
SELECT @column_id = @@IDENTITY
RETURN @column_id
END

GO
GRANT EXECUTE ON  [dbo].[SDE_xml_columns_def_insert] TO [public]
GO
