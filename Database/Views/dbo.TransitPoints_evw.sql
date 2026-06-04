SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TransitPoints_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.LineID,b.PointOrder,b.PSRCJunctID,b.timeFuncID,b.DwtStop,b.User1,b.User2,b.User3,b.UseGPOnly,b.isTimePoint,b.dateLastUpdated,b.LastEditor,b.EditNotes,b.Processing,b.Enabled,b.DWT,b.txtDWT,b.created_user,b.created_date,b.last_edited_user,b.last_edited_date,b.Shape,b.GDB_GEOMATTR_DATA,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.TRANSITPOINTS b LEFT HASH JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d39 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.LineID,a.PointOrder,a.PSRCJunctID,a.timeFuncID,a.DwtStop,a.User1,a.User2,a.User3,a.UseGPOnly,a.isTimePoint,a.dateLastUpdated,a.LastEditor,a.EditNotes,a.Processing,a.Enabled,a.DWT,a.txtDWT,a.created_user,a.created_date,a.last_edited_user,a.last_edited_date,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID FROM DBO.a39 a LEFT HASH JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d39 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v39_delete]  ON [dbo].[TransitPoints_evw] INSTEAD OF DELETE AS 
BEGIN
IF @@rowcount = 0 RETURN
DECLARE @ret INTEGER
DECLARE @current_state BIGINT
-- Check if we are already in an edit session.
DECLARE @g_state_id BIGINT
DECLARE @g_protected CHAR(1)
DECLARE @g_is_default CHAR(1)
DECLARE @g_version_id INTEGER
DECLARE @state_is_set INTEGER
EXECUTE dbo.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT,@state_is_set OUTPUT
IF (@g_version_id = -1) AND (@g_is_default = '0')
BEGIN
  RAISERROR ('User must call edit_version before editing the view.',16,-1)
  RETURN
END

IF (@g_version_id = -1) AND (@g_is_default = '1') AND (@state_is_set = 1)
BEGIN
  RAISERROR ('Cannot call set_current_version before editing default version. Call set_default before editing.',16,-1)
  RETURN
END

IF @g_version_id != -1  -- standard editing
BEGIN
  EXECUTE @ret = dbo.SDE_current_version_writable @current_state OUTPUT
  IF @ret <> 0 RETURN
END
ELSE -- default version editing
  SET @current_state = @g_state_id
DECLARE @row_id INTEGER
DECLARE @old_state_id BIGINT
DECLARE @new_state BIGINT
DECLARE @current_lineage BIGINT
DECLARE @spatial_column INTEGER
DECLARE @edit_cnt INTEGER
DECLARE @error_string NVARCHAR(256)

SELECT @current_lineage = lineage_name  FROM dbo.SDE_states
  WHERE state_id = @current_state
DECLARE del_cursor CURSOR FOR SELECT OBJECTID,SDE_STATE_ID FROM deleted
OPEN del_cursor
FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
      INSERT INTO DBO.d39 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a39 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
    END
  END
  ELSE
  BEGIN -- editing default version
    SELECT @edit_cnt = COUNT(*)
    FROM dbo.SDE_state_lineages
    WHERE lineage_id = @current_state AND lineage_id IN
      (SELECT DISTINCT lineage_id
       FROM dbo.SDE_state_lineages
       WHERE lineage_name IN
        (SELECT lineage_name
         FROM dbo.SDE_state_lineages
         WHERE lineage_id IN
          (SELECT DELETED_AT
           FROM DBO.d39 WITH (TABLOCKX,HOLDLOCK)
           WHERE SDE_DELETES_ROW_ID = @row_id
             AND DELETED_AT > @current_state)))

    if @current_state = 0
    BEGIN
      IF @edit_cnt > 0
      BEGIN
        EXECUTE @ret = dbo.SDE_new_branch_state @current_state, @current_lineage, @new_state OUTPUT
        IF @ret <> 0
        BEGIN
          CLOSE del_cursor
          DEALLOCATE del_cursor
          SET @error_string = 'The DEFAULT version continues to be modified, commit, rollback or re-execute the last statement to proceed.'
          RAISERROR (@error_string,16,-1)
          RETURN
        END
        SET @current_state = @new_state
        INSERT INTO DBO.d39 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TRANSITPOINTS WHERE OBJECTID = @row_id
    END
    ELSE -- @current_state > 0
    BEGIN
      IF @old_state_id != @current_state
      BEGIN
        IF @edit_cnt > 0
        BEGIN
          EXECUTE @ret = dbo.SDE_new_branch_state @current_state, @current_lineage, @new_state OUTPUT
          IF @ret <> 0
          BEGIN
            CLOSE del_cursor
            DEALLOCATE del_cursor
            SET @error_string = 'The DEFAULT version continues to be modified, commit, rollback or re-execute the last statement to proceed.'
            RAISERROR (@error_string,16,-1)
            RETURN
          END
          SET @current_state = @new_state
        END
        INSERT INTO DBO.d39 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @edit_cnt > 0
        BEGIN
          EXECUTE @ret = dbo.SDE_new_branch_state @current_state, @current_lineage, @new_state OUTPUT
          IF @ret <> 0
          BEGIN
            CLOSE del_cursor
            DEALLOCATE del_cursor
            SET @error_string = 'The DEFAULT version continues to be modified, commit, rollback or re-execute the last statement to proceed.'
            RAISERROR (@error_string,16,-1)
            RETURN
          END
          SET @current_state = @new_state
          INSERT INTO DBO.d39 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a39
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 39) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 39, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v39_insert] ON [dbo].[TransitPoints_evw] INSTEAD OF INSERT AS 
BEGIN
DECLARE @rowcount INTEGER
SET @rowcount = @@rowcount
IF @rowcount = 0 RETURN
-- Check if we are already in an edit session.
DECLARE @g_state_id BIGINT
DECLARE @g_protected CHAR(1)
DECLARE @g_is_default CHAR(1)
DECLARE @g_version_id INTEGER
DECLARE @state_is_set INTEGER
EXECUTE dbo.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT,@state_is_set OUTPUT
IF (@g_version_id = -1) AND (@g_is_default = '0')
BEGIN
  RAISERROR ('User must call edit_version before editing the view.',16,-1)
  RETURN
END

IF (@g_version_id = -1) AND (@g_is_default = '1') AND (@state_is_set = 1)
BEGIN
  RAISERROR ('Cannot call set_current_version before editing default version. Call set_default before editing.',16,-1)
  RETURN
END

DECLARE @ret INTEGER
DECLARE @current_state BIGINT
IF @g_version_id != -1  -- standard editing
BEGIN
  EXECUTE @ret = dbo.SDE_current_version_writable @current_state OUTPUT
  IF @ret <> 0 RETURN
END
ELSE -- default version editing
  SET @current_state = @g_state_id
DECLARE @next_row_id BIGINT
DECLARE @num_ids INTEGER
DECLARE @return_row_id BIGINT
DECLARE @num_return_ids INTEGER
DECLARE @archive_oid BIGINT
IF @rowcount = 1
BEGIN
  SELECT @next_row_id = OBJECTID FROM inserted
    IF (@next_row_id IS NULL)
    BEGIN
    EXECUTE DBO.i39_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i39_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TRANSITPOINTS
  (OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA)
  SELECT 
  @next_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,NULL  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a39
  (OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,NULL,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
CREATE TABLE #temp39(
OBJECTID int
,LineID int
,PointOrder smallint
,PSRCJunctID int
,timeFuncID smallint
,DwtStop smallint
,User1 smallint
,User2 smallint
,User3 smallint
,UseGPOnly smallint
,isTimePoint smallint
,dateLastUpdated datetime2
,LastEditor nvarchar(50) 
,EditNotes nvarchar(50) 
,Processing int
,Enabled smallint
,DWT numeric(38,8) 
,txtDWT nvarchar(50) 
,created_user nvarchar(255) 
,created_date datetime2
,last_edited_user nvarchar(255) 
,last_edited_date datetime2
,Shape geometry
,GDB_GEOMATTR_DATA varbinary(max) 
)
INSERT INTO #temp39(
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA) SELECT 
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA FROM inserted
DECLARE ins_cursor CURSOR FOR SELECT OBJECTID FROM #temp39 FOR UPDATE OF OBJECTID
OPEN ins_cursor
DECLARE @rowid INTEGER
FETCH NEXT FROM ins_cursor INTO @rowid
WHILE @@FETCH_STATUS = 0
BEGIN
    EXECUTE DBO.i39_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i39_return_ids 2, @return_row_id, @num_return_ids
    END
  UPDATE #temp39 SET OBJECTID = @next_row_id WHERE CURRENT OF ins_cursor
  FETCH NEXT FROM ins_cursor INTO @rowid
END
  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

IF @current_state = 0
BEGIN
INSERT INTO DBO.TRANSITPOINTS(
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA) SELECT 
t.OBJECTID,t.LineID,t.PointOrder,t.PSRCJunctID,t.timeFuncID,t.DwtStop,t.User1,t.User2,t.User3,t.UseGPOnly,t.isTimePoint,t.dateLastUpdated,t.LastEditor,t.EditNotes,t.Processing,t.Enabled,t.DWT,t.txtDWT,t.created_user,t.created_date,t.last_edited_user,t.last_edited_date,t.Shape,t.GDB_GEOMATTR_DATA FROM #temp39 t 
END
ELSE
BEGIN
INSERT INTO DBO.a39(
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID) SELECT 
t.OBJECTID,t.LineID,t.PointOrder,t.PSRCJunctID,t.timeFuncID,t.DwtStop,t.User1,t.User2,t.User3,t.UseGPOnly,t.isTimePoint,t.dateLastUpdated,t.LastEditor,t.EditNotes,t.Processing,t.Enabled,t.DWT,t.txtDWT,t.created_user,t.created_date,t.last_edited_user,t.last_edited_date,t.Shape,t.GDB_GEOMATTR_DATA,@current_state FROM #temp39 t 
END
CLOSE ins_cursor
DEALLOCATE ins_cursor
DROP TABLE #temp39
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 39) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 39, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v39_update]  ON [dbo].[TransitPoints_evw] INSTEAD OF UPDATE AS 
BEGIN
IF @@rowcount = 0 RETURN
DECLARE @current_state BIGINT
DECLARE @ret INTEGER
-- Check if we are already in an edit session.
DECLARE @g_state_id BIGINT
DECLARE @g_protected CHAR(1)
DECLARE @g_is_default CHAR(1)
DECLARE @g_version_id INTEGER
DECLARE @state_is_set INTEGER
EXECUTE dbo.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT,@state_is_set OUTPUT
IF (@g_version_id = -1) AND (@g_is_default = '0')
BEGIN
  RAISERROR ('User must call edit_version before editing the view.',16,-1)
  RETURN
END

IF (@g_version_id = -1) AND (@g_is_default = '1') AND (@state_is_set = 1)
BEGIN
  RAISERROR ('Cannot call set_current_version before editing default version. Call set_default before editing.',16,-1)
  RETURN
END

IF @g_version_id != -1  -- standard editing
BEGIN
  EXECUTE @ret = dbo.SDE_current_version_writable @current_state OUTPUT
  IF @ret <> 0 RETURN
END
ELSE -- default version editing
  SET @current_state = @g_state_id
DECLARE @new_state BIGINT
DECLARE @current_lineage BIGINT
DECLARE @edit_cnt INTEGER
DECLARE @error_string NVARCHAR(256)

SELECT @current_lineage = lineage_name  FROM dbo.SDE_states
  WHERE state_id = @current_state
IF UPDATE(OBJECTID)
BEGIN
  DECLARE @row_count INTEGER
  SELECT @row_count = COUNT(*) FROM deleted
  IF @row_count > 1 OR (SELECT COUNT(*) FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID) != @row_count
  BEGIN
    RAISERROR ('Attempted update of SDE row id column.',16,-1)
    RETURN
  END
END
DECLARE @new_row_id INTEGER
DECLARE @old_row_id INTEGER
DECLARE @old_state_id BIGINT
DECLARE @new_spatial_column geometry
DECLARE @old_spatial_column geometry
DECLARE updt_cursor CURSOR FOR SELECT i.OBJECTID,d.OBJECTID,d.SDE_STATE_ID,i.SHAPE,d.SHAPE
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @new_row_id, @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a39 (
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

     ELSE
INSERT INTO DBO.a39 (
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

    INSERT INTO DBO.d39 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.A39 SET LineID = i.LineID,PointOrder = i.PointOrder,PSRCJunctID = i.PSRCJunctID,timeFuncID = i.timeFuncID,DwtStop = i.DwtStop,User1 = i.User1,User2 = i.User2,User3 = i.User3,UseGPOnly = i.UseGPOnly,isTimePoint = i.isTimePoint,dateLastUpdated = i.dateLastUpdated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,DWT = i.DWT,txtDWT = i.txtDWT,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.A39  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OBJECTID = @old_row_id AND a.SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.A39 SET LineID = i.LineID,PointOrder = i.PointOrder,PSRCJunctID = i.PSRCJunctID,timeFuncID = i.timeFuncID,DwtStop = i.DwtStop,User1 = i.User1,User2 = i.User2,User3 = i.User3,UseGPOnly = i.UseGPOnly,isTimePoint = i.isTimePoint,dateLastUpdated = i.dateLastUpdated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,DWT = i.DWT,txtDWT = i.txtDWT,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.A39  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OBJECTID = @old_row_id AND a.SDE_STATE_ID = @current_state

    END
  END
  ELSE
  BEGIN
    SELECT @edit_cnt = COUNT(*)
    FROM dbo.SDE_state_lineages
    WHERE lineage_id = @current_state AND lineage_id IN
      (SELECT DISTINCT lineage_id
       FROM dbo.SDE_state_lineages
       WHERE lineage_name IN
        (SELECT lineage_name
         FROM dbo.SDE_state_lineages
         WHERE lineage_id IN
          (SELECT DELETED_AT
           FROM DBO.d39 WITH (TABLOCKX,HOLDLOCK)
           WHERE SDE_DELETES_ROW_ID = @old_row_id
             AND DELETED_AT > @current_state)))

    IF @current_state = 0
    BEGIN
      IF @edit_cnt > 0
      BEGIN
        EXECUTE @ret = dbo.SDE_new_branch_state @current_state, @current_lineage, @new_state OUTPUT
        IF @ret <> 0
        BEGIN
          CLOSE updt_cursor
          DEALLOCATE updt_cursor
          SET @error_string = 'The DEFAULT version continues to be modified, commit, rollback or re-execute the last statement to proceed.'
          RAISERROR (@error_string,16,-1)
          RETURN
        END
        SET @current_state = @new_state
        IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a39 (
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

     ELSE
INSERT INTO DBO.a39 (
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

        INSERT INTO DBO.d39 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.TRANSITPOINTS SET LineID = i.LineID,PointOrder = i.PointOrder,PSRCJunctID = i.PSRCJunctID,timeFuncID = i.timeFuncID,DwtStop = i.DwtStop,User1 = i.User1,User2 = i.User2,User3 = i.User3,UseGPOnly = i.UseGPOnly,isTimePoint = i.isTimePoint,dateLastUpdated = i.dateLastUpdated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,DWT = i.DWT,txtDWT = i.txtDWT,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.TRANSITPOINTS  b INNER JOIN inserted i  ON (b.OBJECTID = i.OBJECTID) 
     WHERE b.OBJECTID = @old_row_id 
     ELSE
     UPDATE DBO.TRANSITPOINTS SET LineID = i.LineID,PointOrder = i.PointOrder,PSRCJunctID = i.PSRCJunctID,timeFuncID = i.timeFuncID,DwtStop = i.DwtStop,User1 = i.User1,User2 = i.User2,User3 = i.User3,UseGPOnly = i.UseGPOnly,isTimePoint = i.isTimePoint,dateLastUpdated = i.dateLastUpdated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,DWT = i.DWT,txtDWT = i.txtDWT,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.TRANSITPOINTS  b INNER JOIN inserted i  ON (b.OBJECTID = i.OBJECTID) 
     WHERE b.OBJECTID = @old_row_id 

      END
    END
    ELSE
    BEGIN
      IF (@old_state_id != @current_state)
      BEGIN
        IF @edit_cnt > 0
        BEGIN
          EXECUTE @ret = dbo.SDE_new_branch_state @current_state, @current_lineage, @new_state OUTPUT
          IF @ret <> 0
          BEGIN
            CLOSE updt_cursor
            DEALLOCATE updt_cursor
            SET @error_string = 'The DEFAULT version continues to be modified, commit, rollback or re-execute the last statement to proceed.'
            RAISERROR (@error_string,16,-1)
            RETURN
          END
          SET @current_state = @new_state
        END
        IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a39 (
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

     ELSE
INSERT INTO DBO.a39 (
OBJECTID,LineID,PointOrder,PSRCJunctID,timeFuncID,DwtStop,User1,User2,User3,UseGPOnly,isTimePoint,dateLastUpdated,LastEditor,EditNotes,Processing,Enabled,DWT,txtDWT,created_user,created_date,last_edited_user,last_edited_date,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.PointOrder,i.PSRCJunctID,i.timeFuncID,i.DwtStop,i.User1,i.User2,i.User3,i.UseGPOnly,i.isTimePoint,i.dateLastUpdated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.DWT,i.txtDWT,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

        INSERT INTO DBO.d39 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.A39 SET LineID = i.LineID,PointOrder = i.PointOrder,PSRCJunctID = i.PSRCJunctID,timeFuncID = i.timeFuncID,DwtStop = i.DwtStop,User1 = i.User1,User2 = i.User2,User3 = i.User3,UseGPOnly = i.UseGPOnly,isTimePoint = i.isTimePoint,dateLastUpdated = i.dateLastUpdated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,DWT = i.DWT,txtDWT = i.txtDWT,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.A39  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OBJECTID = @old_row_id AND a.SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.A39 SET LineID = i.LineID,PointOrder = i.PointOrder,PSRCJunctID = i.PSRCJunctID,timeFuncID = i.timeFuncID,DwtStop = i.DwtStop,User1 = i.User1,User2 = i.User2,User3 = i.User3,UseGPOnly = i.UseGPOnly,isTimePoint = i.isTimePoint,dateLastUpdated = i.dateLastUpdated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,DWT = i.DWT,txtDWT = i.txtDWT,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.A39  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OBJECTID = @old_row_id AND a.SDE_STATE_ID = @current_state

      END
    END

  END
  FETCH NEXT FROM updt_cursor INTO @new_row_id, @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 39) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 39, @current_state
END
GO
