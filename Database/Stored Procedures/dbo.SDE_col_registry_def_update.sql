SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_col_registry_def_update] 
@dbNameVal NVARCHAR(128), @tabNameVal sysname, @ownerVal NVARCHAR(128),
@colNameVal NVARCHAR(128), @sdeTypeVal INTEGER, @colSizeVal INTEGER, 
@decDigitVal INTEGER, @descVal NVARCHAR(65), @objFlagsVal INTEGER, 
@objIdVal INTEGER, @oldColNameVal NVARCHAR(128), @objFlags2Val INTEGER = NULL,
@oldClient INTEGER = 1 
AS SET NOCOUNT ON 
IF (@oldClient = 0)
BEGIN 
  UPDATE dbo.SDE_column_registry SET column_name = @colNameVal, sde_type = @sdeTypeVal, column_size = @colSizeVal, 
     decimal_digits = @decDigitVal, description = @descVal,
     object_flags = @objFlagsVal, object_flags2 = @objFlags2Val, object_id = @objIdVal 
  WHERE table_name = @tabNameVal AND owner = @ownerVal AND column_name = @OldColNameVal 
END
ELSE
BEGIN
  /* Update column from BIGINT to DOUBLE is not allowed for pre-3.2 client */ 
  IF (@sdeTypeVal = 4 AND @colSizeVal > 0 AND @colSizeVal <= 19 AND @decDigitVal = 0) 
  BEGIN
    DECLARE @ori_sde_type INTEGER 
    SELECT @ori_sde_type = sde_type FROM dbo.SDE_column_registry 
    WHERE table_name = @tabNameVal AND owner = @ownerVal AND column_name = @OldColNameVal 
    IF (@ori_sde_type <> 11) /* SE_INT64_TYPE */ 
      UPDATE dbo.SDE_column_registry SET column_name = @colNameVal, sde_type = @sdeTypeVal, column_size = @colSizeVal, 
        decimal_digits = @decDigitVal, description = @descVal, object_flags = @objFlagsVal,
        object_flags2 = @objFlags2Val,object_id = @objIdVal 
      WHERE table_name = @tabNameVal AND  owner = @ownerVal AND column_name = @oldColNameVal 
  END 
  ELSE 
  BEGIN 
    UPDATE dbo.SDE_column_registry SET column_name = @colNameVal, sde_type = @sdeTypeVal, column_size = @colSizeVal, 
      decimal_digits = @decDigitVal, description = @descVal, object_flags = @objFlagsVal,
      object_flags2 = @objFlags2Val, object_id = @objIdVal 
    WHERE table_name = @tabNameVal AND owner = @ownerVal AND column_name = @OldColNameVal 
  END 
END
GO
GRANT EXECUTE ON  [dbo].[SDE_col_registry_def_update] TO [public]
GO
