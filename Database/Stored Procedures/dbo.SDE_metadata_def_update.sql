SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_metadata_def_update]       @record_idVal INTEGER, @class_nameVal      NVARCHAR(32), @propertyVal NVARCHAR(32), @prop_valueVal NVARCHAR(255),        @descriptionVal NVARCHAR(64), @creation_dateVal DATETIME AS      SET NOCOUNT ON UPDATE dbo.SDE_metadata      SET class_name = @class_nameVal,property = @propertyVal,      prop_value = @prop_valueVal,description = @descriptionVal,      creation_date = @creation_dateVal WHERE record_id = @record_idVal
GO
GRANT EXECUTE ON  [dbo].[SDE_metadata_def_update] TO [public]
GO
