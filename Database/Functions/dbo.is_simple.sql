SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[is_simple](
@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS VARCHAR(14)
AS BEGIN
-- check if the object is a multiversioned view
DECLARE @base_table NVARCHAR(128)
DECLARE @qualified_table NVARCHAR (200)
DECLARE @is_reg INT
DECLARE @int_val INT

SET @qualified_table = @owner + '.'

SELECT @base_table = table_name FROM dbo.SDE_table_registry 
  WHERE owner = @owner AND imv_view_name = @table
IF @@ROWCOUNT = 0
  SET @qualified_table = @qualified_table + @table
ELSE
  SET @qualified_table = @qualified_table + @base_table

-- Check ArcSDE metadata first
SET @is_reg = 0
SELECT @is_reg = 1 FROM dbo.SDE_table_registry WHERE owner = @owner AND table_name = @table

-- Get XML string from view. Return NOT REGISTERED when not found.
DECLARE @def VARCHAR(max)
DECLARE @datasetsubtype1 int
SELECT @def = CAST (definition AS VARCHAR(max)), @datasetsubtype1 = datasetsubtype1
  FROM dbo.GDB_Items WHERE physicalname = @qualified_table
IF @@ROWCOUNT = 0
BEGIN
  IF @is_reg = 1
    RETURN 'TRUE'
  ELSE
      RETURN 'NOT REGISTERED'
END

IF @datasetsubtype1 != 1
  RETURN 'FALSE'

-- Check FeatureType for esriFTSimple. This check also 
-- covers checks for:
--
--   * Dimension feature classes
--   * Annotation eature classes
--   * Schematics, Locators, and Toolboxes

DECLARE @pos INT
DECLARE @pos2 INT
SET @pos = charindex('<FeatureType>',@def);
IF @pos > 0
BEGIN
  SET @pos2 = charindex('</FeatureType>', @def, @pos)
  SET @pos = @pos + 13
  IF substring(@def,@pos,@pos2 - @pos) != 'ESRIFTSIMPLE'
    RETURN 'FALSE'
END

SET @int_val = 0
SELECT @int_val = 1 FROM dbo.GDB_Items a
  WHERE a.PhysicalName = @qualified_table and a.Type IN
    (SELECT b.UUID FROM dbo.GDB_ItemTypes b WHERE b.Name in ('Feature Class','Feature Dataset','Table'))
IF @int_val != 1
  RETURN 'FALSE'

-- Check if the object participates in a	Parcel Fabric, Networkdataset,
-- Geometric Network, Terrain, Networkdataset, Topology or Relationship.

SET @int_val = 0
SELECT TOP 1 @int_val = 1
FROM (SELECT b.originid FROM dbo.GDB_Items a INNER JOIN dbo.GDB_ItemRelationships b
        ON a.uuid = b.destid WHERE a.physicalname = @qualified_table) objclass
  INNER JOIN dbo.GDB_Items origin_items
    ON origin_items.uuid = objclass.originid
  INNER JOIN dbo.GDB_ItemRelationships  rel1
    ON rel1.originid = origin_items.uuid
  INNER JOIN dbo.GDB_ItemRelationships rel2
    ON rel2.destid = rel1.destid
WHERE origin_items.physicalname IS NOT NULL AND
  ((rel2.type = '{583A5BAA-3551-41AE-8AA8-1185719F3889}') OR 
   (rel2.type = '{DC739A70-9B71-41E8-868C-008CF46F16D7}') OR
   (rel2.type = '{55D2F4DC-CB17-4E32-A8C7-47591E8C71DE}') OR
   (rel2.type = '{B32B8563-0B96-4D32-92C4-086423AE9962}') OR
   (rel2.type = '{D088B110-190B-4229-BDF7-89FDDD14D1EA}') OR
   (rel2.type = '{725BADAB-3452-491B-A795-55F32D67229C}'))
IF @int_val = 1
  RETURN 'FALSE'

-- Check if Dataset has dependent objects that participate in a Parcel Fabric
-- Networkdataset, Geometric Network, Terrain, Networkdataset, Topology or Relationship.

SET @int_val = 0
SELECT TOP 1 @int_val = 1
FROM (SELECT rel2.uuid FROM (SELECT UUID, Type FROM dbo.GDB_Items WHERE PhysicalName = @qualified_table) src_items
  INNER JOIN dbo.GDB_Itemrelationships rel1 ON src_items.uuid = rel1.originid
  INNER JOIN dbo.GDB_Itemrelationships rel2 ON rel2.originid = rel1.destid 
WHERE ((rel2.type = '{583A5BAA-3551-41AE-8AA8-1185719F3889}') OR
       (rel2.type = '{DC739A70-9B71-41E8-868C-008CF46F16D7}') OR
       (rel2.type = '{55D2F4DC-CB17-4E32-A8C7-47591E8C71DE}') OR
       (rel2.type = '{B32B8563-0B96-4D32-92C4-086423AE9962}') OR
       (rel2.type = '{D088B110-190B-4229-BDF7-89FDDD14D1EA}') OR
       (rel2.type = '{725BADAB-3452-491B-A795-55F32D67229C}')) ) expr
IF @int_val = 1
  RETURN 'FALSE'

-- Check if Object (No Dataset) has dependent objects that participate in a Parcel Fabric
-- Networkdataset, Geometric Network, Terrain, Networkdataset, Topology or Relationship.

SET @int_val = 0
SELECT TOP 1 @int_val = 1
FROM (SELECT rel1.type FROM (SELECT UUID, Type FROM dbo.GDB_Items WHERE PhysicalName = @qualified_table) src_items
  INNER JOIN dbo.GDB_Itemrelationships rel1 ON rel1.originid = src_items.uuid
  INNER JOIN dbo.GDB_Itemrelationships rel2 ON rel2.destid = rel1.destid
WHERE ((rel2.type = '{583A5BAA-3551-41AE-8AA8-1185719F3889}') OR
       (rel2.type = '{DC739A70-9B71-41E8-868C-008CF46F16D7}') OR
       (rel2.type = '{55D2F4DC-CB17-4E32-A8C7-47591E8C71DE}') OR
       (rel2.type = '{B32B8563-0B96-4D32-92C4-086423AE9962}') OR
       (rel2.type = '{D088B110-190B-4229-BDF7-89FDDD14D1EA}') OR
       (rel2.type = '{725BADAB-3452-491B-A795-55F32D67229C}')) ) expr
IF @int_val = 1
  RETURN 'FALSE'

-- Check XML Definition
SET @pos = charindex ('<ControllerMemberships>', @def)
IF @pos = 0
  SET @pos = charindex ('<ControllerMemberships ', @def)
IF @pos > 0
BEGIN
  SET @pos = charindex ('<GeometricNetworkMembership>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<TopologyMembership>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<NetworkDatasetMembership>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<NetworkDatasetName>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<TerrainMembership>', @def)
  IF @pos = 0
    SET @pos = charindex ('<TerrainName>', @def)
  IF @pos > 0
    RETURN 'FALSE'
END

-- Check for Editor Tracking enabled.

SET @pos = charindex('<EditorTrackingEnabled>',@def);
IF @pos > 0
BEGIN
  SET @pos2 = charindex('</EditorTrackingEnabled>', @def, @pos)
  SET @pos = @pos + 23
  IF substring(@def,@pos,@pos2 - @pos) = 'TRUE'
    RETURN 'FALSE'
END

-- Check for Custom Class Extensions. 

SET @pos = charindex('<EXTCLSID>',@def);
IF @pos > 0
BEGIN
  SET @pos2 = charindex('</EXTCLSID>', @def, @pos)
  IF @pos2 != (@pos + 10)
    RETURN 'FALSE'
END

RETURN 'TRUE'
END

GO
GRANT EXECUTE ON  [dbo].[is_simple] TO [public]
GO
