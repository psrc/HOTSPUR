SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_locator_def_insert]       @locator_idVal INTEGER,@categoryVal NVARCHAR(128),@typeVal INTEGER,       @descriptionVal NVARCHAR(64), @nameVal NVARCHAR(32),       @ownerVal NVARCHAR(128) AS SET NOCOUNT ON INSERT INTO dbo.SDE_locators      (locator_id,category,type,description,name,owner) VALUES (      @locator_idVal,@categoryVal,@typeVal,@descriptionVal,@nameVal,@ownerVal)
GO
GRANT EXECUTE ON  [dbo].[SDE_locator_def_insert] TO [public]
GO
