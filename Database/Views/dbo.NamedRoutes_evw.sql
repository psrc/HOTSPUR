SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[NamedRoutes_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.NRouteID,b.Route_Name,b.Processing,b.dateLastUpdated,b.Enabled,b.Shape,b.GDB_GEOMATTR_DATA,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.NAMEDROUTES b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d34 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.NRouteID,a.Route_Name,a.Processing,a.dateLastUpdated,a.Enabled,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID FROM DBO.a34 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d34 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v34_delete]  ON [dbo].[NamedRoutes_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d34 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a34 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d34 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d34 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.NAMEDROUTES WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d34 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d34 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a34
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 34) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 34, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v34_insert] ON [dbo].[NamedRoutes_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i34_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i34_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.NAMEDROUTES
  (OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA)
  SELECT 
  @next_row_id,i.NRouteID,i.Route_Name,i.Processing,i.dateLastUpdated,i.Enabled,i.Shape,NULL  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a34
  (OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.NRouteID,i.Route_Name,i.Processing,i.dateLastUpdated,i.Enabled,i.Shape,NULL,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 int
  DECLARE @col3 nvarchar(50) 
  DECLARE @col4 int
  DECLARE @col5 datetime2
  DECLARE @col6 smallint
  DECLARE @col7 geometry
  DECLARE @col8 varbinary(max) 
  DECLARE @col9 bigint
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i34_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i34_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.NAMEDROUTES
      (OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,NULL )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a34
      (OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,NULL,@current_state )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 34) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 34, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v34_update]  ON [dbo].[NamedRoutes_evw] INSTEAD OF UPDATE AS 
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
DECLARE updt_cursor CURSOR FOR SELECT d.OBJECTID,d.SDE_STATE_ID,i.SHAPE,d.SHAPE,
 i.OBJECTID,
 i.NRouteID,
 i.Route_Name,
 i.Processing,
 i.dateLastUpdated,
 i.Enabled,
 i.GDB_GEOMATTR_DATA
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_NRouteID int
DECLARE @upd_Route_Name nvarchar(50) 
DECLARE @upd_Processing int
DECLARE @upd_dateLastUpdated datetime2
DECLARE @upd_Enabled smallint
DECLARE @upd_GDB_GEOMATTR_DATA varbinary(max) 
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @upd_GDB_GEOMATTR_DATA
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a34 (
OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a34 (
OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @new_spatial_column, NULL, @current_state)

     INSERT INTO DBO.d34 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a34 SET NRouteID = @upd_NRouteID,Route_Name = @upd_Route_Name,Processing = @upd_Processing,dateLastUpdated = @upd_dateLastUpdated,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a34 SET NRouteID = @upd_NRouteID,Route_Name = @upd_Route_Name,Processing = @upd_Processing,dateLastUpdated = @upd_dateLastUpdated,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state

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
           FROM DBO.d34 WITH (TABLOCKX,HOLDLOCK)
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
INSERT INTO DBO.a34 (
OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a34 (
OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @new_spatial_column, NULL, @current_state)

        INSERT INTO DBO.d34 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.NAMEDROUTES SET NRouteID = @upd_NRouteID,Route_Name = @upd_Route_Name,Processing = @upd_Processing,dateLastUpdated = @upd_dateLastUpdated,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id 
     ELSE
     UPDATE DBO.NAMEDROUTES SET NRouteID = @upd_NRouteID,Route_Name = @upd_Route_Name,Processing = @upd_Processing,dateLastUpdated = @upd_dateLastUpdated,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
WHERE OBJECTID = @old_row_id 

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
INSERT INTO DBO.a34 (
OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a34 (
OBJECTID,NRouteID,Route_Name,Processing,dateLastUpdated,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @new_spatial_column, NULL, @current_state)

        INSERT INTO DBO.d34 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a34 SET NRouteID = @upd_NRouteID,Route_Name = @upd_Route_Name,Processing = @upd_Processing,dateLastUpdated = @upd_dateLastUpdated,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a34 SET NRouteID = @upd_NRouteID,Route_Name = @upd_Route_Name,Processing = @upd_Processing,dateLastUpdated = @upd_dateLastUpdated,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state

      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_NRouteID, @upd_Route_Name, @upd_Processing, @upd_dateLastUpdated, @upd_Enabled, @upd_GDB_GEOMATTR_DATA
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 34) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 34, @current_state
END
GO
