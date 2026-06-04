SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_registry_def_update]        @rowidColVal NVARCHAR(128), @descVal NVARCHAR(65), @objFlagsVal INTEGER,       @conKeyWordVal  NVARCHAR(32), @minIdVal INTEGER, @regIdVal INTEGER,       @imvNameVal NVARCHAR (128), @objFlags2Val INTEGER = NULL AS SET NOCOUNT ON       UPDATE dbo.SDE_table_registry SET rowid_column = @rowidColVal, description = @descVal,       object_flags = @objFlagsVal, object_flags2 = @objFlags2Val, config_keyword = @conKeyWordVal,       minimum_id = @minIdVal, imv_view_name = @imvNameVal       WHERE registration_id = @regIdVal
GO
GRANT EXECUTE ON  [dbo].[SDE_registry_def_update] TO [public]
GO
