SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Transportation_Topology_point_evw] AS SELECT b.OID + 0 OID,b.OriginObjectClassName,b.OriginObjectID,b.DestinationObjectClassName,b.DestinationObjectID,b.RuleType,b.RuleDescription,b.isException,b.Shape,b.GDB_GEOMATTR_DATA,b.OID - b.OID SDE_STATE_ID FROM DBO.TRANSPORTATION_TOPOLOGY_POINT b LEFT HASH JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d36 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OID + 0 OID,a.OriginObjectClassName,a.OriginObjectID,a.DestinationObjectClassName,a.DestinationObjectID,a.RuleType,a.RuleDescription,a.isException,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID FROM DBO.a36 a LEFT HASH JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d36 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v36_delete]  ON [dbo].[Transportation_Topology_point_evw] INSTEAD OF DELETE AS 
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
DECLARE del_cursor CURSOR FOR SELECT OID,SDE_STATE_ID FROM deleted
OPEN del_cursor
FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
      INSERT INTO DBO.d36 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a36 WHERE OID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d36 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d36 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TRANSPORTATION_TOPOLOGY_POINT WHERE OID = @row_id
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
        INSERT INTO DBO.d36 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d36 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a36
            WHERE OID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 36) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 36, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v36_insert] ON [dbo].[Transportation_Topology_point_evw] INSTEAD OF INSERT AS 
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
  SELECT @next_row_id = OID FROM inserted
    IF (@next_row_id IS NULL)
    BEGIN
    EXECUTE DBO.i36_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i36_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TRANSPORTATION_TOPOLOGY_POINT
  (OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA)
  SELECT 
  @next_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,NULL  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a36
  (OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,NULL,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
CREATE TABLE #temp36(
OID int
,OriginObjectClassName nvarchar(255) 
,OriginObjectID int
,DestinationObjectClassName nvarchar(255) 
,DestinationObjectID int
,RuleType nvarchar(255) 
,RuleDescription nvarchar(255) 
,isException int
,Shape geometry
,GDB_GEOMATTR_DATA varbinary(max) 
)
INSERT INTO #temp36(
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA) SELECT 
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA FROM inserted
DECLARE ins_cursor CURSOR FOR SELECT OID FROM #temp36 FOR UPDATE OF OID
OPEN ins_cursor
DECLARE @rowid INTEGER
FETCH NEXT FROM ins_cursor INTO @rowid
WHILE @@FETCH_STATUS = 0
BEGIN
    EXECUTE DBO.i36_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i36_return_ids 2, @return_row_id, @num_return_ids
    END
  UPDATE #temp36 SET OID = @next_row_id WHERE CURRENT OF ins_cursor
  FETCH NEXT FROM ins_cursor INTO @rowid
END
  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

IF @current_state = 0
BEGIN
INSERT INTO DBO.TRANSPORTATION_TOPOLOGY_POINT(
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA) SELECT 
t.OID,t.OriginObjectClassName,t.OriginObjectID,t.DestinationObjectClassName,t.DestinationObjectID,t.RuleType,t.RuleDescription,t.isException,t.Shape,t.GDB_GEOMATTR_DATA FROM #temp36 t 
END
ELSE
BEGIN
INSERT INTO DBO.a36(
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID) SELECT 
t.OID,t.OriginObjectClassName,t.OriginObjectID,t.DestinationObjectClassName,t.DestinationObjectID,t.RuleType,t.RuleDescription,t.isException,t.Shape,t.GDB_GEOMATTR_DATA,@current_state FROM #temp36 t 
END
CLOSE ins_cursor
DEALLOCATE ins_cursor
DROP TABLE #temp36
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 36) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 36, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v36_update]  ON [dbo].[Transportation_Topology_point_evw] INSTEAD OF UPDATE AS 
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
IF UPDATE(OID)
BEGIN
  DECLARE @row_count INTEGER
  SELECT @row_count = COUNT(*) FROM deleted
  IF @row_count > 1 OR (SELECT COUNT(*) FROM inserted i INNER JOIN deleted d
  ON i.OID = d.OID) != @row_count
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
DECLARE updt_cursor CURSOR FOR SELECT i.OID,d.OID,d.SDE_STATE_ID,i.SHAPE,d.SHAPE
  FROM inserted i INNER JOIN deleted d
  ON i.OID = d.OID
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @new_row_id, @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a36 (
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OID = @new_row_id

     ELSE
INSERT INTO DBO.a36 (
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OID = @new_row_id

    INSERT INTO DBO.d36 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.A36 SET OriginObjectClassName = i.OriginObjectClassName,OriginObjectID = i.OriginObjectID,DestinationObjectClassName = i.DestinationObjectClassName,DestinationObjectID = i.DestinationObjectID,RuleType = i.RuleType,RuleDescription = i.RuleDescription,isException = i.isException,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.A36  a INNER JOIN inserted i  ON (a.OID = i.OID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OID = @old_row_id AND a.SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.A36 SET OriginObjectClassName = i.OriginObjectClassName,OriginObjectID = i.OriginObjectID,DestinationObjectClassName = i.DestinationObjectClassName,DestinationObjectID = i.DestinationObjectID,RuleType = i.RuleType,RuleDescription = i.RuleDescription,isException = i.isException,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.A36  a INNER JOIN inserted i  ON (a.OID = i.OID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OID = @old_row_id AND a.SDE_STATE_ID = @current_state

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
           FROM DBO.d36 WITH (TABLOCKX,HOLDLOCK)
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
INSERT INTO DBO.a36 (
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OID = @new_row_id

     ELSE
INSERT INTO DBO.a36 (
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OID = @new_row_id

        INSERT INTO DBO.d36 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.TRANSPORTATION_TOPOLOGY_POINT SET OriginObjectClassName = i.OriginObjectClassName,OriginObjectID = i.OriginObjectID,DestinationObjectClassName = i.DestinationObjectClassName,DestinationObjectID = i.DestinationObjectID,RuleType = i.RuleType,RuleDescription = i.RuleDescription,isException = i.isException,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.TRANSPORTATION_TOPOLOGY_POINT  b INNER JOIN inserted i  ON (b.OID = i.OID) 
     WHERE b.OID = @old_row_id 
     ELSE
     UPDATE DBO.TRANSPORTATION_TOPOLOGY_POINT SET OriginObjectClassName = i.OriginObjectClassName,OriginObjectID = i.OriginObjectID,DestinationObjectClassName = i.DestinationObjectClassName,DestinationObjectID = i.DestinationObjectID,RuleType = i.RuleType,RuleDescription = i.RuleDescription,isException = i.isException,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.TRANSPORTATION_TOPOLOGY_POINT  b INNER JOIN inserted i  ON (b.OID = i.OID) 
     WHERE b.OID = @old_row_id 

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
INSERT INTO DBO.a36 (
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OID = @new_row_id

     ELSE
INSERT INTO DBO.a36 (
OID,OriginObjectClassName,OriginObjectID,DestinationObjectClassName,DestinationObjectID,RuleType,RuleDescription,isException,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.OriginObjectClassName,i.OriginObjectID,i.DestinationObjectClassName,i.DestinationObjectID,i.RuleType,i.RuleDescription,i.isException,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OID = @new_row_id

        INSERT INTO DBO.d36 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.A36 SET OriginObjectClassName = i.OriginObjectClassName,OriginObjectID = i.OriginObjectID,DestinationObjectClassName = i.DestinationObjectClassName,DestinationObjectID = i.DestinationObjectID,RuleType = i.RuleType,RuleDescription = i.RuleDescription,isException = i.isException,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.A36  a INNER JOIN inserted i  ON (a.OID = i.OID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OID = @old_row_id AND a.SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.A36 SET OriginObjectClassName = i.OriginObjectClassName,OriginObjectID = i.OriginObjectID,DestinationObjectClassName = i.DestinationObjectClassName,DestinationObjectID = i.DestinationObjectID,RuleType = i.RuleType,RuleDescription = i.RuleDescription,isException = i.isException,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.A36  a INNER JOIN inserted i  ON (a.OID = i.OID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OID = @old_row_id AND a.SDE_STATE_ID = @current_state

      END
    END

  END
  FETCH NEXT FROM updt_cursor INTO @new_row_id, @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 36) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 36, @current_state
END
GO
