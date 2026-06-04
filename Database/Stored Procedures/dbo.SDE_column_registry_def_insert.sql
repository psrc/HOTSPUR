SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_column_registry_def_insert]          @dbNameVal NVARCHAR(128), @tabNameVal sysname, @ownerVal NVARCHAR(128),         @colNameVal NVARCHAR(128), @sdeTypeVal INTEGER, @colSizeVal INTEGER,          @decDigitVal INTEGER, @descVal NVARCHAR(65), @objFlagsVal INTEGER,         @objIdVal INTEGER, @objFlags2Val INTEGER = NULL AS SET NOCOUNT ON         INSERT INTO dbo.SDE_column_registry (table_name, owner, column_name, sde_type,          column_size, decimal_digits,description,object_flags, object_flags2, object_id )          VALUES (@tabNameVal, @ownerVal, @colNameVal, @sdeTypeVal,          @colSizeVal ,@decDigitVal, @descVal, @objFlagsVal, @objFlags2Val, @objIdVal)
GO
GRANT EXECUTE ON  [dbo].[SDE_column_registry_def_insert] TO [public]
GO
