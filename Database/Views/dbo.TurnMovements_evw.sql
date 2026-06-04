SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TurnMovements_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.TurnID,b.PSRCJunctID,b.FrEdgeID,b.ToEdgeID,b.InServiceDate,b.OutServiceDate,b.FunctionAM,b.FunctionMD,b.FunctionPM,b.FunctionEV,b.FunctionNI,b.user1AM,b.user1MD,b.user1PM,b.user1EV,b.user1NI,b.user2AM,b.user2MD,b.user2PM,b.user2EV,b.user2NI,b.user3AM,b.user3MD,b.user3PM,b.user3EV,b.user3NI,b.ModesProhibited,b.ProjID,b.ProjDBS,b.dateLastUpdated,b.DateCreated,b.LastEditor,b.EditNotes,b.Processing,b.Enabled,b.Shape,b.GDB_GEOMATTR_DATA,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.TURNMOVEMENTS b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d37 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.TurnID,a.PSRCJunctID,a.FrEdgeID,a.ToEdgeID,a.InServiceDate,a.OutServiceDate,a.FunctionAM,a.FunctionMD,a.FunctionPM,a.FunctionEV,a.FunctionNI,a.user1AM,a.user1MD,a.user1PM,a.user1EV,a.user1NI,a.user2AM,a.user2MD,a.user2PM,a.user2EV,a.user2NI,a.user3AM,a.user3MD,a.user3PM,a.user3EV,a.user3NI,a.ModesProhibited,a.ProjID,a.ProjDBS,a.dateLastUpdated,a.DateCreated,a.LastEditor,a.EditNotes,a.Processing,a.Enabled,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID FROM DBO.a37 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d37 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v37_delete]  ON [dbo].[TurnMovements_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d37 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a37 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d37 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d37 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TURNMOVEMENTS WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d37 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d37 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a37
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 37) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 37, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v37_insert] ON [dbo].[TurnMovements_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i37_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i37_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TURNMOVEMENTS
  (OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA)
  SELECT 
  @next_row_id,i.TurnID,i.PSRCJunctID,i.FrEdgeID,i.ToEdgeID,i.InServiceDate,i.OutServiceDate,i.FunctionAM,i.FunctionMD,i.FunctionPM,i.FunctionEV,i.FunctionNI,i.user1AM,i.user1MD,i.user1PM,i.user1EV,i.user1NI,i.user2AM,i.user2MD,i.user2PM,i.user2EV,i.user2NI,i.user3AM,i.user3MD,i.user3PM,i.user3EV,i.user3NI,i.ModesProhibited,i.ProjID,i.ProjDBS,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.Shape,NULL  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a37
  (OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.TurnID,i.PSRCJunctID,i.FrEdgeID,i.ToEdgeID,i.InServiceDate,i.OutServiceDate,i.FunctionAM,i.FunctionMD,i.FunctionPM,i.FunctionEV,i.FunctionNI,i.user1AM,i.user1MD,i.user1PM,i.user1EV,i.user1NI,i.user2AM,i.user2MD,i.user2PM,i.user2EV,i.user2NI,i.user3AM,i.user3MD,i.user3PM,i.user3EV,i.user3NI,i.ModesProhibited,i.ProjID,i.ProjDBS,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.Shape,NULL,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 int
  DECLARE @col3 int
  DECLARE @col4 int
  DECLARE @col5 int
  DECLARE @col6 smallint
  DECLARE @col7 smallint
  DECLARE @col8 smallint
  DECLARE @col9 smallint
  DECLARE @col10 smallint
  DECLARE @col11 smallint
  DECLARE @col12 smallint
  DECLARE @col13 int
  DECLARE @col14 int
  DECLARE @col15 int
  DECLARE @col16 int
  DECLARE @col17 int
  DECLARE @col18 numeric(7,2) 
  DECLARE @col19 numeric(7,2) 
  DECLARE @col20 numeric(7,2) 
  DECLARE @col21 numeric(7,2) 
  DECLARE @col22 numeric(7,2) 
  DECLARE @col23 int
  DECLARE @col24 int
  DECLARE @col25 int
  DECLARE @col26 int
  DECLARE @col27 int
  DECLARE @col28 nvarchar(25) 
  DECLARE @col29 nvarchar(25) 
  DECLARE @col30 nvarchar(25) 
  DECLARE @col31 datetime2
  DECLARE @col32 datetime2
  DECLARE @col33 nvarchar(50) 
  DECLARE @col34 nvarchar(256) 
  DECLARE @col35 int
  DECLARE @col36 smallint
  DECLARE @col37 geometry
  DECLARE @col38 varbinary(max) 
  DECLARE @col39 bigint
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i37_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i37_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.TURNMOVEMENTS
      (OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,NULL )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a37
      (OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,NULL,@current_state )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 37) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 37, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v37_update]  ON [dbo].[TurnMovements_evw] INSTEAD OF UPDATE AS 
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
 i.TurnID,
 i.PSRCJunctID,
 i.FrEdgeID,
 i.ToEdgeID,
 i.InServiceDate,
 i.OutServiceDate,
 i.FunctionAM,
 i.FunctionMD,
 i.FunctionPM,
 i.FunctionEV,
 i.FunctionNI,
 i.user1AM,
 i.user1MD,
 i.user1PM,
 i.user1EV,
 i.user1NI,
 i.user2AM,
 i.user2MD,
 i.user2PM,
 i.user2EV,
 i.user2NI,
 i.user3AM,
 i.user3MD,
 i.user3PM,
 i.user3EV,
 i.user3NI,
 i.ModesProhibited,
 i.ProjID,
 i.ProjDBS,
 i.dateLastUpdated,
 i.DateCreated,
 i.LastEditor,
 i.EditNotes,
 i.Processing,
 i.Enabled,
 i.GDB_GEOMATTR_DATA
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_TurnID int
DECLARE @upd_PSRCJunctID int
DECLARE @upd_FrEdgeID int
DECLARE @upd_ToEdgeID int
DECLARE @upd_InServiceDate smallint
DECLARE @upd_OutServiceDate smallint
DECLARE @upd_FunctionAM smallint
DECLARE @upd_FunctionMD smallint
DECLARE @upd_FunctionPM smallint
DECLARE @upd_FunctionEV smallint
DECLARE @upd_FunctionNI smallint
DECLARE @upd_user1AM int
DECLARE @upd_user1MD int
DECLARE @upd_user1PM int
DECLARE @upd_user1EV int
DECLARE @upd_user1NI int
DECLARE @upd_user2AM numeric(7,2) 
DECLARE @upd_user2MD numeric(7,2) 
DECLARE @upd_user2PM numeric(7,2) 
DECLARE @upd_user2EV numeric(7,2) 
DECLARE @upd_user2NI numeric(7,2) 
DECLARE @upd_user3AM int
DECLARE @upd_user3MD int
DECLARE @upd_user3PM int
DECLARE @upd_user3EV int
DECLARE @upd_user3NI int
DECLARE @upd_ModesProhibited nvarchar(25) 
DECLARE @upd_ProjID nvarchar(25) 
DECLARE @upd_ProjDBS nvarchar(25) 
DECLARE @upd_dateLastUpdated datetime2
DECLARE @upd_DateCreated datetime2
DECLARE @upd_LastEditor nvarchar(50) 
DECLARE @upd_EditNotes nvarchar(256) 
DECLARE @upd_Processing int
DECLARE @upd_Enabled smallint
DECLARE @upd_GDB_GEOMATTR_DATA varbinary(max) 
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_GDB_GEOMATTR_DATA
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a37 (
OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a37 (
OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @new_spatial_column, NULL, @current_state)

     INSERT INTO DBO.d37 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a37 SET TurnID = @upd_TurnID,PSRCJunctID = @upd_PSRCJunctID,FrEdgeID = @upd_FrEdgeID,ToEdgeID = @upd_ToEdgeID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,FunctionAM = @upd_FunctionAM,FunctionMD = @upd_FunctionMD,FunctionPM = @upd_FunctionPM,FunctionEV = @upd_FunctionEV,FunctionNI = @upd_FunctionNI,user1AM = @upd_user1AM,user1MD = @upd_user1MD,user1PM = @upd_user1PM,user1EV = @upd_user1EV,user1NI = @upd_user1NI,user2AM = @upd_user2AM,user2MD = @upd_user2MD,user2PM = @upd_user2PM,user2EV = @upd_user2EV,user2NI = @upd_user2NI,user3AM = @upd_user3AM,user3MD = @upd_user3MD,user3PM = @upd_user3PM,user3EV = @upd_user3EV,user3NI = @upd_user3NI,ModesProhibited = @upd_ModesProhibited,ProjID = @upd_ProjID,ProjDBS = @upd_ProjDBS,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a37 SET TurnID = @upd_TurnID,PSRCJunctID = @upd_PSRCJunctID,FrEdgeID = @upd_FrEdgeID,ToEdgeID = @upd_ToEdgeID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,FunctionAM = @upd_FunctionAM,FunctionMD = @upd_FunctionMD,FunctionPM = @upd_FunctionPM,FunctionEV = @upd_FunctionEV,FunctionNI = @upd_FunctionNI,user1AM = @upd_user1AM,user1MD = @upd_user1MD,user1PM = @upd_user1PM,user1EV = @upd_user1EV,user1NI = @upd_user1NI,user2AM = @upd_user2AM,user2MD = @upd_user2MD,user2PM = @upd_user2PM,user2EV = @upd_user2EV,user2NI = @upd_user2NI,user3AM = @upd_user3AM,user3MD = @upd_user3MD,user3PM = @upd_user3PM,user3EV = @upd_user3EV,user3NI = @upd_user3NI,ModesProhibited = @upd_ModesProhibited,ProjID = @upd_ProjID,ProjDBS = @upd_ProjDBS,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
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
           FROM DBO.d37 WITH (TABLOCKX,HOLDLOCK)
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
INSERT INTO DBO.a37 (
OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a37 (
OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @new_spatial_column, NULL, @current_state)

        INSERT INTO DBO.d37 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.TURNMOVEMENTS SET TurnID = @upd_TurnID,PSRCJunctID = @upd_PSRCJunctID,FrEdgeID = @upd_FrEdgeID,ToEdgeID = @upd_ToEdgeID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,FunctionAM = @upd_FunctionAM,FunctionMD = @upd_FunctionMD,FunctionPM = @upd_FunctionPM,FunctionEV = @upd_FunctionEV,FunctionNI = @upd_FunctionNI,user1AM = @upd_user1AM,user1MD = @upd_user1MD,user1PM = @upd_user1PM,user1EV = @upd_user1EV,user1NI = @upd_user1NI,user2AM = @upd_user2AM,user2MD = @upd_user2MD,user2PM = @upd_user2PM,user2EV = @upd_user2EV,user2NI = @upd_user2NI,user3AM = @upd_user3AM,user3MD = @upd_user3MD,user3PM = @upd_user3PM,user3EV = @upd_user3EV,user3NI = @upd_user3NI,ModesProhibited = @upd_ModesProhibited,ProjID = @upd_ProjID,ProjDBS = @upd_ProjDBS,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id 
     ELSE
     UPDATE DBO.TURNMOVEMENTS SET TurnID = @upd_TurnID,PSRCJunctID = @upd_PSRCJunctID,FrEdgeID = @upd_FrEdgeID,ToEdgeID = @upd_ToEdgeID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,FunctionAM = @upd_FunctionAM,FunctionMD = @upd_FunctionMD,FunctionPM = @upd_FunctionPM,FunctionEV = @upd_FunctionEV,FunctionNI = @upd_FunctionNI,user1AM = @upd_user1AM,user1MD = @upd_user1MD,user1PM = @upd_user1PM,user1EV = @upd_user1EV,user1NI = @upd_user1NI,user2AM = @upd_user2AM,user2MD = @upd_user2MD,user2PM = @upd_user2PM,user2EV = @upd_user2EV,user2NI = @upd_user2NI,user3AM = @upd_user3AM,user3MD = @upd_user3MD,user3PM = @upd_user3PM,user3EV = @upd_user3EV,user3NI = @upd_user3NI,ModesProhibited = @upd_ModesProhibited,ProjID = @upd_ProjID,ProjDBS = @upd_ProjDBS,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
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
INSERT INTO DBO.a37 (
OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
         VALUES(  @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state)

     ELSE
INSERT INTO DBO.a37 (
OBJECTID,TurnID,PSRCJunctID,FrEdgeID,ToEdgeID,InServiceDate,OutServiceDate,FunctionAM,FunctionMD,FunctionPM,FunctionEV,FunctionNI,user1AM,user1MD,user1PM,user1EV,user1NI,user2AM,user2MD,user2PM,user2EV,user2NI,user3AM,user3MD,user3PM,user3EV,user3NI,ModesProhibited,ProjID,ProjDBS,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
          VALUES(  @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @new_spatial_column, NULL, @current_state)

        INSERT INTO DBO.d37 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a37 SET TurnID = @upd_TurnID,PSRCJunctID = @upd_PSRCJunctID,FrEdgeID = @upd_FrEdgeID,ToEdgeID = @upd_ToEdgeID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,FunctionAM = @upd_FunctionAM,FunctionMD = @upd_FunctionMD,FunctionPM = @upd_FunctionPM,FunctionEV = @upd_FunctionEV,FunctionNI = @upd_FunctionNI,user1AM = @upd_user1AM,user1MD = @upd_user1MD,user1PM = @upd_user1PM,user1EV = @upd_user1EV,user1NI = @upd_user1NI,user2AM = @upd_user2AM,user2MD = @upd_user2MD,user2PM = @upd_user2PM,user2EV = @upd_user2EV,user2NI = @upd_user2NI,user3AM = @upd_user3AM,user3MD = @upd_user3MD,user3PM = @upd_user3PM,user3EV = @upd_user3EV,user3NI = @upd_user3NI,ModesProhibited = @upd_ModesProhibited,ProjID = @upd_ProjID,ProjDBS = @upd_ProjDBS,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL  
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a37 SET TurnID = @upd_TurnID,PSRCJunctID = @upd_PSRCJunctID,FrEdgeID = @upd_FrEdgeID,ToEdgeID = @upd_ToEdgeID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,FunctionAM = @upd_FunctionAM,FunctionMD = @upd_FunctionMD,FunctionPM = @upd_FunctionPM,FunctionEV = @upd_FunctionEV,FunctionNI = @upd_FunctionNI,user1AM = @upd_user1AM,user1MD = @upd_user1MD,user1PM = @upd_user1PM,user1EV = @upd_user1EV,user1NI = @upd_user1NI,user2AM = @upd_user2AM,user2MD = @upd_user2MD,user2PM = @upd_user2PM,user2EV = @upd_user2EV,user2NI = @upd_user2NI,user3AM = @upd_user3AM,user3MD = @upd_user3MD,user3PM = @upd_user3PM,user3EV = @upd_user3EV,user3NI = @upd_user3NI,ModesProhibited = @upd_ModesProhibited,ProjID = @upd_ProjID,ProjDBS = @upd_ProjDBS,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state

      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_TurnID, @upd_PSRCJunctID, @upd_FrEdgeID, @upd_ToEdgeID, @upd_InServiceDate, @upd_OutServiceDate, @upd_FunctionAM, @upd_FunctionMD, @upd_FunctionPM, @upd_FunctionEV, @upd_FunctionNI, @upd_user1AM, @upd_user1MD, @upd_user1PM, @upd_user1EV, @upd_user1NI, @upd_user2AM, @upd_user2MD, @upd_user2PM, @upd_user2EV, @upd_user2NI, @upd_user3AM, @upd_user3MD, @upd_user3PM, @upd_user3EV, @upd_user3NI, @upd_ModesProhibited, @upd_ProjID, @upd_ProjDBS, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_GDB_GEOMATTR_DATA
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 37) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 37, @current_state
END
GO
