SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GDB_TABLES_def_update]
@fromDBVal NVARCHAR(128), @toDBVal NVARCHAR(128) AS SET NOCOUNT ON 
BEGIN 
DECLARE @doc_xml XML 
DECLARE @def_xml XML 
DECLARE @item_xml XML 
DECLARE @attributes XML 
DECLARE @Name NVARCHAR(226) 
DECLARE @physicalname NVARCHAR(226) 
DECLARE @Path NVARCHAR(512) 
DECLARE @datasetInfo2 NVARCHAR(255) 
DECLARE @toDB NVARCHAR(129) 
DECLARE @targetDBVal NVARCHAR(129) 
DECLARE @len INT 
DECLARE @fromDataSetName NVARCHAR(257) 
DECLARE @fromDBWithOwner NVARCHAR(257) 
DECLARE @toDBWithOwner NVARCHAR(257) 
DECLARE @fromTargetDBWithOwner NVARCHAR(257) 
DECLARE @update INT 
if (@fromDBVal IS NULL)
  set @fromDBVal = db_name()
if (@toDBVal IS NOT NULL) 
  set @toDB = @toDBVal + '.'
else
  set @toDB = ''
set @len = LEN(@fromDBVal) + 1 

-- Update GDB_ITEMELATIONSHIPS 
DECLARE itemrelationships_cursor CURSOR FOR 
select Attributes, Name from dbo.GDB_ITEMRELATIONSHIPS rels WITH (TABLOCKX, HOLDLOCK), dbo.GDB_ITEMS items WITH (TABLOCKX, HOLDLOCK) 
    where rels.originID = items.UUID AND 
    Attributes IS NOT NULL FOR UPDATE OF Attributes 
OPEN itemrelationships_cursor 
FETCH NEXT FROM itemrelationships_cursor INTO @attributes, @Name 
WHILE @@FETCH_STATUS = 0
BEGIN
  if (@Name IS NOT NULL AND @Name like @fromDBVal+'.%.[^ ]%' AND @Name NOT LIKE @fromDBVal+ '.%.%.%') 
  BEGIN 
    set @fromDBWithOwner = @fromDBVal + '.' + SUBSTRING(@Name,@len+1, LEN(SUBSTRING(@Name, @len+1, CHARINDEX('.', @Name, @len+1)-(@len+1)))) 
    set @toDBWithOwner =  @toDB + SUBSTRING(@Name,@len+1, LEN(SUBSTRING(@Name, @len+1, CHARINDEX('.', @Name, @len+1)-(@len+1)))) 
    set @attributes = REPLACE(CAST(@attributes as NVARCHAR(max)), @fromDBWithOwner, @toDBWithOwner)
    UPDATE dbo.GDB_ITEMRELATIONSHIPS SET Attributes = @attributes WHERE CURRENT OF itemrelationships_cursor 
  END
  FETCH NEXT FROM itemrelationships_cursor INTO @attributes, @Name
END
CLOSE itemrelationships_cursor
DEALLOCATE itemrelationships_cursor

-- Update GDB_ITEMS table 
DECLARE items_cursor CURSOR FOR 
select Name, PhysicalName, Path, DatasetInfo2, Definition, Documentation, ItemInfo from dbo.GDB_ITEMS WITH (TABLOCKX, HOLDLOCK) WHERE 
 definition.value('(/*/Name/text())[1]', 'NVARCHAR(255)') = name OR 
 definition.value('(/*/DatasetName/text())[1]', 'NVARCHAR(255)') = PhysicalName OR 
 definition.value('(/GPReplica/Name/text())[1]', 'NVARCHAR(255)') = PhysicalName
FOR UPDATE OF Name, PhysicalName, Path, DatasetInfo2, Definition, Documentation, ItemInfo 
OPEN items_cursor 
FETCH NEXT FROM items_cursor INTO @Name, @physicalname, @Path, @datasetInfo2, @def_xml, @doc_xml, @item_xml 
WHILE @@FETCH_STATUS = 0 
BEGIN  
  set @update = 0
  IF (@Name IS NOT NULL AND @Name like @fromDBVal+'.%.[^ ]%' AND @Name NOT LIKE @fromDBVal+ '.%.%.%') 
  BEGIN 
    set @fromDBWithOwner = @fromDBVal + '.' + SUBSTRING(@Name,@len+1, LEN(SUBSTRING(@Name, @len+1, CHARINDEX('.', @Name, @len+1)-(@len+1)))) 
    set @toDBWithOwner =  @toDB + SUBSTRING(@Name,@len+1, LEN(SUBSTRING(@Name, @len+1, CHARINDEX('.', @Name, @len+1)-(@len+1)))) 
    set @Name = REPLACE(@Name, @fromDBWithOwner, @toDBWithOwner)
    set @update = 1 
  END
  ELSE IF (@PhysicalName IS NOT NULL AND @def_xml IS NOT NULL AND @def_xml.value('(/GPReplica/Name/text())[1]','NVARCHAR(255)')=@PhysicalName) 
  BEGIN
    set @fromDataSetName = @def_xml.value('(/*/Name/text())[1]', 'NVARCHAR(255)')
    set @targetDBVal = @def_xml.value('(/GPReplica/GPReplicaDescription/GPReplicaDatasets/GPReplicaDataset/ParentDBase/text())[1]', 'NVARCHAR(255)')
    set @fromDBWithOwner = @fromDBVal + '.' + SUBSTRING(@fromDataSetName,1, CHARINDEX('.', @fromDataSetName)-1)
    set @fromTargetDBWithOwner = @targetDBVal + '.' + SUBSTRING(@fromDataSetName,1, CHARINDEX('.', @fromDataSetName)-1)
    set @toDBWithOwner =  @toDB + SUBSTRING(@fromDataSetName,1, CHARINDEX('.', @fromDataSetName)-1) 
    set @update = 1 
  END
  ELSE IF (@PhysicalName IS NOT NULL AND @def_xml IS NOT NULL AND @def_xml.value('(/*/DatasetName/text())[1]', 'NVARCHAR(255)') = @PhysicalName AND 
       @PhysicalName like @fromDBVal+'.%.[^ ]%' AND @PhysicalName NOT LIKE @fromDBVal+ '.%.%.%')
  BEGIN
    set @fromDataSetName = @def_xml.value('(/*/DatasetName/text())[1]', 'NVARCHAR(255)')
    set @fromDBWithOwner = @fromDBVal + '.' + SUBSTRING(@fromDataSetName,@len+1, LEN(SUBSTRING(@fromDataSetName, @len+1, CHARINDEX('.', @fromDataSetName, @len+1)-(@len+1)))) 
    set @toDBWithOwner =  @toDB + SUBSTRING(@fromDataSetName,@len+1, LEN(SUBSTRING(@fromDataSetName, @len+1, CHARINDEX('.', @fromDataSetName, @len+1)-(@len+1)))) 
    set @update = 1 
  END
  IF @update = 1
  BEGIN 
    if (@Path IS NOT NULL) set @Path = REPLACE(@Path, @fromDBWithOwner, @toDBWithOwner) 
    if (@doc_xml IS NOT NULL) 
    BEGIN 
      set @doc_xml = REPLACE(CAST(@doc_xml as NVARCHAR(max)), @fromDBWithOwner, @toDBWithOwner) 
      if (@toDBVal IS NOT NULL) 
        set @doc_xml = REPLACE(CAST(@doc_xml as NVARCHAR(max)), 'database='+@fromDBVal, 'database='+@toDBVal) 
--    else 
--      set @doc_xml = REPLACE(CAST(@doc_xml as NVARCHAR(max)), 'database='+@fromDBVal, '') 
    END 
    if (@datasetInfo2 IS NOT NULL AND @def_xml IS NOT NULL AND @datasetInfo2 = @def_xml.value('(/*/ControllerMemberships/ControllerMembership/TopologyName/text())[1]', 'NVARCHAR(255)'))
      set @datasetInfo2 = REPLACE(@datasetInfo2, @fromDBWithOwner, @toDBWithOwner) 
    if (@def_xml IS NOT NULL) 
    BEGIN
      set @def_xml = REPLACE(CAST(@def_xml as NVARCHAR(max)), @fromDBWithOwner, @toDBWithOwner) 
      set @def_xml = REPLACE(CAST(@def_xml as NVARCHAR(max)), '<ParentDBase>'+@fromDBVal+'</ParentDBase>','<ParentDBase/>') 
      IF (@targetDBVal IS NOT NULL) 
      BEGIN
        set @def_xml = REPLACE(CAST(@def_xml as NVARCHAR(max)), @fromTargetDBWithOwner, @toDBWithOwner) 
        set @def_xml = REPLACE(CAST(@def_xml as NVARCHAR(max)), '<ParentDBase>'+@targetDBVal+'</ParentDBase>','<ParentDBase/>') 
      END
    END
    if (@item_xml IS NOT NULL) set @item_xml = REPLACE(CAST(@item_xml as NVARCHAR(max)), @fromDBWithOwner, @toDBWithOwner) 
    if (@physicalname IS NOT NULL) set @physicalname = REPLACE(@physicalname, @fromDBWithOwner, @toDBWithOwner) 
    UPDATE dbo.GDB_ITEMS SET Name = @Name, PhysicalName = UPPER(@physicalname), Path = @Path, DatasetInfo2 = @datasetInfo2, 
     Definition = @def_xml, Documentation = @doc_xml, ItemInfo = @item_xml WHERE CURRENT OF items_cursor 
  END
  FETCH NEXT FROM items_cursor INTO @Name, @physicalname, @Path, @datasetInfo2, @def_xml, @doc_xml, @item_xml 
END 
CLOSE items_cursor
DEALLOCATE items_cursor 
END
GO
GRANT EXECUTE ON  [dbo].[GDB_TABLES_def_update] TO [public]
GO
