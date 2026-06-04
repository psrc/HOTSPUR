SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TransRefJunctions_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.ANCILLARYROLE,b.ENABLED,b.PSRCjunctID,b.JunctionType,b.TRANSITSTOPID,b.P_RStalls,b.Modes,b.FTRdescription,b.inServiceDate,b.outServiceDate,b.dateLastUpdated,b.EMME2nodeID,b.EMME2nodeLabel,b.DateCreated,b.LastEditor,b.EditNotes,b.Processing,b.EMME2Dir,b.EMME2HOV,b.Shape,b.GDB_GEOMATTR_DATA,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.TRANSREFJUNCTIONS b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d48 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.ANCILLARYROLE,a.ENABLED,a.PSRCjunctID,a.JunctionType,a.TRANSITSTOPID,a.P_RStalls,a.Modes,a.FTRdescription,a.inServiceDate,a.outServiceDate,a.dateLastUpdated,a.EMME2nodeID,a.EMME2nodeLabel,a.DateCreated,a.LastEditor,a.EditNotes,a.Processing,a.EMME2Dir,a.EMME2HOV,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID FROM DBO.a48 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d48 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v48_delete]  ON [dbo].[TransRefJunctions_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d48 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a48 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d48 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d48 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TRANSREFJUNCTIONS WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d48 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d48 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a48
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 48) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 48, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v48_insert] ON [dbo].[TransRefJunctions_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i48_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i48_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TRANSREFJUNCTIONS
  (OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA)
  SELECT 
  @next_row_id,i.ANCILLARYROLE,i.ENABLED,i.PSRCjunctID,i.JunctionType,i.TRANSITSTOPID,i.P_RStalls,i.Modes,i.FTRdescription,i.inServiceDate,i.outServiceDate,i.dateLastUpdated,i.EMME2nodeID,i.EMME2nodeLabel,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.EMME2Dir,i.EMME2HOV,i.Shape,NULL  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a48
  (OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.ANCILLARYROLE,i.ENABLED,i.PSRCjunctID,i.JunctionType,i.TRANSITSTOPID,i.P_RStalls,i.Modes,i.FTRdescription,i.inServiceDate,i.outServiceDate,i.dateLastUpdated,i.EMME2nodeID,i.EMME2nodeLabel,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.EMME2Dir,i.EMME2HOV,i.Shape,NULL,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 smallint
  DECLARE @col3 smallint
  DECLARE @col4 int
  DECLARE @col5 int
  DECLARE @col6 int
  DECLARE @col7 int
  DECLARE @col8 nvarchar(25) 
  DECLARE @col9 nvarchar(254) 
  DECLARE @col10 smallint
  DECLARE @col11 smallint
  DECLARE @col12 datetime2
  DECLARE @col13 int
  DECLARE @col14 nvarchar(75) 
  DECLARE @col15 datetime2
  DECLARE @col16 nvarchar(50) 
  DECLARE @col17 nvarchar(50) 
  DECLARE @col18 int
  DECLARE @col19 nvarchar(2) 
  DECLARE @col20 int
  DECLARE @col21 geometry
  DECLARE @col22 varbinary(max) 
  DECLARE @col23 bigint
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i48_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i48_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.TRANSREFJUNCTIONS
      (OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,NULL )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a48
      (OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,NULL,@current_state )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 48) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 48, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v48_update]  ON [dbo].[TransRefJunctions_evw] INSTEAD OF UPDATE AS 
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
 i.ANCILLARYROLE,
 i.ENABLED,
 i.PSRCjunctID,
 i.JunctionType,
 i.TRANSITSTOPID,
 i.P_RStalls,
 i.Modes,
 i.FTRdescription,
 i.inServiceDate,
 i.outServiceDate,
 i.dateLastUpdated,
 i.EMME2nodeID,
 i.EMME2nodeLabel,
 i.DateCreated,
 i.LastEditor,
 i.EditNotes,
 i.Processing,
 i.EMME2Dir,
 i.EMME2HOV,
 i.GDB_GEOMATTR_DATA
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_ANCILLARYROLE smallint
DECLARE @upd_ENABLED smallint
DECLARE @upd_PSRCjunctID int
DECLARE @upd_JunctionType int
DECLARE @upd_TRANSITSTOPID int
DECLARE @upd_P_RStalls int
DECLARE @upd_Modes nvarchar(25) 
DECLARE @upd_FTRdescription nvarchar(254) 
DECLARE @upd_inServiceDate smallint
DECLARE @upd_outServiceDate smallint
DECLARE @upd_dateLastUpdated datetime2
DECLARE @upd_EMME2nodeID int
DECLARE @upd_EMME2nodeLabel nvarchar(75) 
DECLARE @upd_DateCreated datetime2
DECLARE @upd_LastEditor nvarchar(50) 
DECLARE @upd_EditNotes nvarchar(50) 
DECLARE @upd_Processing int
DECLARE @upd_EMME2Dir nvarchar(2) 
DECLARE @upd_EMME2HOV int
DECLARE @upd_GDB_GEOMATTR_DATA varbinary(max) 
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @upd_GDB_GEOMATTR_DATA
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a48 (
OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a48 (
OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @new_spatial_column, NULL, @current_state)

     INSERT INTO DBO.d48 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a48 SET ANCILLARYROLE = @upd_ANCILLARYROLE,ENABLED = @upd_ENABLED,PSRCjunctID = @upd_PSRCjunctID,JunctionType = @upd_JunctionType,TRANSITSTOPID = @upd_TRANSITSTOPID,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,FTRdescription = @upd_FTRdescription,inServiceDate = @upd_inServiceDate,outServiceDate = @upd_outServiceDate,dateLastUpdated = @upd_dateLastUpdated,EMME2nodeID = @upd_EMME2nodeID,EMME2nodeLabel = @upd_EMME2nodeLabel,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,EMME2Dir = @upd_EMME2Dir,EMME2HOV = @upd_EMME2HOV,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a48 SET ANCILLARYROLE = @upd_ANCILLARYROLE,ENABLED = @upd_ENABLED,PSRCjunctID = @upd_PSRCjunctID,JunctionType = @upd_JunctionType,TRANSITSTOPID = @upd_TRANSITSTOPID,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,FTRdescription = @upd_FTRdescription,inServiceDate = @upd_inServiceDate,outServiceDate = @upd_outServiceDate,dateLastUpdated = @upd_dateLastUpdated,EMME2nodeID = @upd_EMME2nodeID,EMME2nodeLabel = @upd_EMME2nodeLabel,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,EMME2Dir = @upd_EMME2Dir,EMME2HOV = @upd_EMME2HOV,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
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
           FROM DBO.d48 WITH (TABLOCKX,HOLDLOCK)
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
INSERT INTO DBO.a48 (
OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a48 (
OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @new_spatial_column, NULL, @current_state)

        INSERT INTO DBO.d48 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.TRANSREFJUNCTIONS SET ANCILLARYROLE = @upd_ANCILLARYROLE,ENABLED = @upd_ENABLED,PSRCjunctID = @upd_PSRCjunctID,JunctionType = @upd_JunctionType,TRANSITSTOPID = @upd_TRANSITSTOPID,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,FTRdescription = @upd_FTRdescription,inServiceDate = @upd_inServiceDate,outServiceDate = @upd_outServiceDate,dateLastUpdated = @upd_dateLastUpdated,EMME2nodeID = @upd_EMME2nodeID,EMME2nodeLabel = @upd_EMME2nodeLabel,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,EMME2Dir = @upd_EMME2Dir,EMME2HOV = @upd_EMME2HOV,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id 
     ELSE
     UPDATE DBO.TRANSREFJUNCTIONS SET ANCILLARYROLE = @upd_ANCILLARYROLE,ENABLED = @upd_ENABLED,PSRCjunctID = @upd_PSRCjunctID,JunctionType = @upd_JunctionType,TRANSITSTOPID = @upd_TRANSITSTOPID,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,FTRdescription = @upd_FTRdescription,inServiceDate = @upd_inServiceDate,outServiceDate = @upd_outServiceDate,dateLastUpdated = @upd_dateLastUpdated,EMME2nodeID = @upd_EMME2nodeID,EMME2nodeLabel = @upd_EMME2nodeLabel,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,EMME2Dir = @upd_EMME2Dir,EMME2HOV = @upd_EMME2HOV,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
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
INSERT INTO DBO.a48 (
OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a48 (
OBJECTID,ANCILLARYROLE,ENABLED,PSRCjunctID,JunctionType,TRANSITSTOPID,P_RStalls,Modes,FTRdescription,inServiceDate,outServiceDate,dateLastUpdated,EMME2nodeID,EMME2nodeLabel,DateCreated,LastEditor,EditNotes,Processing,EMME2Dir,EMME2HOV,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @new_spatial_column, NULL, @current_state)

        INSERT INTO DBO.d48 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a48 SET ANCILLARYROLE = @upd_ANCILLARYROLE,ENABLED = @upd_ENABLED,PSRCjunctID = @upd_PSRCjunctID,JunctionType = @upd_JunctionType,TRANSITSTOPID = @upd_TRANSITSTOPID,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,FTRdescription = @upd_FTRdescription,inServiceDate = @upd_inServiceDate,outServiceDate = @upd_outServiceDate,dateLastUpdated = @upd_dateLastUpdated,EMME2nodeID = @upd_EMME2nodeID,EMME2nodeLabel = @upd_EMME2nodeLabel,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,EMME2Dir = @upd_EMME2Dir,EMME2HOV = @upd_EMME2HOV,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a48 SET ANCILLARYROLE = @upd_ANCILLARYROLE,ENABLED = @upd_ENABLED,PSRCjunctID = @upd_PSRCjunctID,JunctionType = @upd_JunctionType,TRANSITSTOPID = @upd_TRANSITSTOPID,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,FTRdescription = @upd_FTRdescription,inServiceDate = @upd_inServiceDate,outServiceDate = @upd_outServiceDate,dateLastUpdated = @upd_dateLastUpdated,EMME2nodeID = @upd_EMME2nodeID,EMME2nodeLabel = @upd_EMME2nodeLabel,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,EMME2Dir = @upd_EMME2Dir,EMME2HOV = @upd_EMME2HOV,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state

      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_ANCILLARYROLE, @upd_ENABLED, @upd_PSRCjunctID, @upd_JunctionType, @upd_TRANSITSTOPID, @upd_P_RStalls, @upd_Modes, @upd_FTRdescription, @upd_inServiceDate, @upd_outServiceDate, @upd_dateLastUpdated, @upd_EMME2nodeID, @upd_EMME2nodeLabel, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_EMME2Dir, @upd_EMME2HOV, @upd_GDB_GEOMATTR_DATA
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 48) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 48, @current_state
END
GO
