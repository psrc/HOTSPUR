SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_locator_def_delete] @id1        INTEGER AS SET NOCOUNT ON DELETE FROM dbo.SDE_locators WHERE locator_id = @id1
GO
GRANT EXECUTE ON  [dbo].[SDE_locator_def_delete] TO [public]
GO
