SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_registry_def_insert]          @regIdVal INTEGER, @dbNameVal NVARCHAR(128), @tabNameVal sysname, @ownerVal NVARCHAR(128),         @rowidColVal NVARCHAR(128), @descVal NVARCHAR(65), @objFlagsVal INTEGER,         @regDate INTEGER, @conKeyWordVal  NVARCHAR(32), @minIdVal INTEGER,          @imvNameVal NVARCHAR(128), @objFlags2Val INTEGER = NULL AS SET NOCOUNT ON         INSERT INTO dbo.SDE_table_registry (registration_id, table_name, owner,         rowid_column,description,object_flags,object_flags2,registration_date,         config_keyword,minimum_id,imv_view_name) VALUES ( @regIdVal, @tabNameVal,         @ownerVal,@rowidColVal, @descVal, @objFlagsVal, @objFlags2Val, @regDate, @conKeyWordVal,         @minIdVal, @imvNameVal)
GO
GRANT EXECUTE ON  [dbo].[SDE_registry_def_insert] TO [public]
GO
