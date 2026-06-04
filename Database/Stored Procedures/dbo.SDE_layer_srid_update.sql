SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_srid_update]              @sridVal INTEGER, @layeridVal INTEGER AS SET NOCOUNT ON BEGIN              DECLARE @g_table sysname              SET @g_table = N'f' + cast(@layeridVal as NVARCHAR)              UPDATE dbo.SDE_layers SET srid = @sridVal WHERE layer_id = @layeridVal 
 UPDATE             dbo.SDE_geometry_columns SET srid = @sridVal WHERE g_table_name = @g_table END
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_srid_update] TO [public]
GO
