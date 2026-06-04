SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_locator_def_update] @locator_idVal INTEGER,      @categoryVal NVARCHAR(128), @typeVal INTEGER, @descriptionVal NVARCHAR(64),      @nameVal NVARCHAR(32) AS SET NOCOUNT ON      UPDATE dbo.SDE_locators SET name = @nameVal, category = @categoryVal,type = @typeVal,      description = @descriptionVal WHERE locator_id = @locator_idVal
GO
GRANT EXECUTE ON  [dbo].[SDE_locator_def_update] TO [public]
GO
