SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SDE_get_cad_table_name]
(@owner NVARCHAR(128),@table NVARCHAR(128),@spatial_column NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
DECLARE @layer_id INTEGER
DECLARE @qualified_table NVARCHAR(200)
DECLARE @cad_mask BIGINT
DECLARE @layer_eflags INTEGER
/* set SE_CAD_TYPE_MASK defined sdecomn.h */
SELECT @cad_mask = 1 * POWER(2,22)
SET @qualified_table = db_name() + '.' + @owner + '.SDE_GEOMETRY'
SELECT @layer_id = layer_id, @layer_eflags = eflags FROM dbo.SDE_layers
 WHERE owner = @owner AND table_name = @table AND spatial_column = @spatial_column
IF @@ROWCOUNT = 0
  SET @qualified_table =  NULL
ELSE
BEGIN
  IF @layer_eflags & @cad_mask = @cad_mask
    SET @qualified_table = @qualified_table + CONVERT(NVARCHAR(10),@layer_id)
  ELSE
    SET @qualified_table =  NULL
END
RETURN @qualified_table
END

GO
GRANT EXECUTE ON  [dbo].[SDE_get_cad_table_name] TO [public]
GO
