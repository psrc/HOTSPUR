SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_layer_def_mask_update]              @maskVal INTEGER, @layeridVal INTEGER AS              SET NOCOUNT ON              BEGIN             BEGIN TRAN layer_mask_update             UPDATE dbo.SDE_layers              SET layer_mask = @maskVal              WHERE layer_id = @layeridVal             COMMIT TRAN layer_mask_update             END
GO
GRANT EXECUTE ON  [dbo].[SDE_layer_def_mask_update] TO [public]
GO
