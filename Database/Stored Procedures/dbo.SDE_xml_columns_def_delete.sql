SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_xml_columns_def_delete]
@columnIdVal INTEGER AS SET NOCOUNT ON
BEGIN
DELETE FROM dbo.SDE_xml_columns WHERE column_id =  @columnIdVal
END

GO
GRANT EXECUTE ON  [dbo].[SDE_xml_columns_def_delete] TO [public]
GO
