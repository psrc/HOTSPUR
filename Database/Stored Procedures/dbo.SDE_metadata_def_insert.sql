SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_metadata_def_insert]           @record_idVal INTEGER, @object_nameVal NVARCHAR(160), @object_databaseVal NVARCHAR(128),           @object_ownerVal NVARCHAR(128),@object_typeVal INTEGER, @class_nameVal          NVARCHAR(32), @propertyVal NVARCHAR(32), @prop_valueVal NVARCHAR(255),            @descriptionVal NVARCHAR(64), @creation_dateVal DATETIME AS SET NOCOUNT ON          INSERT INTO dbo.SDE_metadata          (record_id,object_name,object_owner,object_type,class_name,property,          prop_value,description,creation_date) VALUES (@record_idVal, @object_nameVal,          @object_ownerVal, @object_typeVal, @class_nameVal, @propertyVal,          @prop_valueVal, @descriptionVal, @creation_dateVal)
GO
GRANT EXECUTE ON  [dbo].[SDE_metadata_def_insert] TO [public]
GO
