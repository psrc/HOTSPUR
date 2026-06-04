SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[evtPointProjectOutcomes_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.projRteID,b.projDBS,b.projID,b.version,b.PSRCJunctID,b.InServiceDate,b.OutServiceDate,b.CompletedDate,b.M,b.P_RStalls,b.Modes,b.NewOwner,b.NewMaintainer,b.dateLastUpdated,b.DateCreated,b.LastEditor,b.EditNotes,b.Processing,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.EVTPOINTPROJECTOUTCOMES b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d20 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.projRteID,a.projDBS,a.projID,a.version,a.PSRCJunctID,a.InServiceDate,a.OutServiceDate,a.CompletedDate,a.M,a.P_RStalls,a.Modes,a.NewOwner,a.NewMaintainer,a.dateLastUpdated,a.DateCreated,a.LastEditor,a.EditNotes,a.Processing,a.SDE_STATE_ID FROM DBO.a20 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d20 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v20_delete]  ON [dbo].[evtPointProjectOutcomes_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d20 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a20 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d20 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d20 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.EVTPOINTPROJECTOUTCOMES WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d20 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d20 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a20
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 20) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 20, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v20_insert] ON [dbo].[evtPointProjectOutcomes_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i20_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i20_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.EVTPOINTPROJECTOUTCOMES
  (OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing)
  SELECT 
  @next_row_id,i.projRteID,i.projDBS,i.projID,i.version,i.PSRCJunctID,i.InServiceDate,i.OutServiceDate,i.CompletedDate,i.M,i.P_RStalls,i.Modes,i.NewOwner,i.NewMaintainer,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a20
  (OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.projRteID,i.projDBS,i.projID,i.version,i.PSRCJunctID,i.InServiceDate,i.OutServiceDate,i.CompletedDate,i.M,i.P_RStalls,i.Modes,i.NewOwner,i.NewMaintainer,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,SDE_STATE_ID
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 int
  DECLARE @col3 nvarchar(25) 
  DECLARE @col4 nvarchar(25) 
  DECLARE @col5 smallint
  DECLARE @col6 int
  DECLARE @col7 smallint
  DECLARE @col8 smallint
  DECLARE @col9 datetime2
  DECLARE @col10 numeric(9,2) 
  DECLARE @col11 int
  DECLARE @col12 nvarchar(25) 
  DECLARE @col13 smallint
  DECLARE @col14 smallint
  DECLARE @col15 datetime2
  DECLARE @col16 datetime2
  DECLARE @col17 nvarchar(50) 
  DECLARE @col18 nvarchar(256) 
  DECLARE @col19 int
  DECLARE @col20 bigint
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i20_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i20_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.EVTPOINTPROJECTOUTCOMES
      (OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19 )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a20
      (OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,SDE_STATE_ID)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@current_state )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 20) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 20, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v20_update]  ON [dbo].[evtPointProjectOutcomes_evw] INSTEAD OF UPDATE AS 
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
DECLARE updt_cursor CURSOR FOR SELECT d.OBJECTID,d.SDE_STATE_ID,
 i.OBJECTID,
 i.projRteID,
 i.projDBS,
 i.projID,
 i.version,
 i.PSRCJunctID,
 i.InServiceDate,
 i.OutServiceDate,
 i.CompletedDate,
 i.M,
 i.P_RStalls,
 i.Modes,
 i.NewOwner,
 i.NewMaintainer,
 i.dateLastUpdated,
 i.DateCreated,
 i.LastEditor,
 i.EditNotes,
 i.Processing
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_projRteID int
DECLARE @upd_projDBS nvarchar(25) 
DECLARE @upd_projID nvarchar(25) 
DECLARE @upd_version smallint
DECLARE @upd_PSRCJunctID int
DECLARE @upd_InServiceDate smallint
DECLARE @upd_OutServiceDate smallint
DECLARE @upd_CompletedDate datetime2
DECLARE @upd_M numeric(9,2) 
DECLARE @upd_P_RStalls int
DECLARE @upd_Modes nvarchar(25) 
DECLARE @upd_NewOwner smallint
DECLARE @upd_NewMaintainer smallint
DECLARE @upd_dateLastUpdated datetime2
DECLARE @upd_DateCreated datetime2
DECLARE @upd_LastEditor nvarchar(50) 
DECLARE @upd_EditNotes nvarchar(256) 
DECLARE @upd_Processing int
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PSRCJunctID, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletedDate, @upd_M, @upd_P_RStalls, @upd_Modes, @upd_NewOwner, @upd_NewMaintainer, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     INSERT INTO DBO.a20 (
OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PSRCJunctID, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletedDate, @upd_M, @upd_P_RStalls, @upd_Modes, @upd_NewOwner, @upd_NewMaintainer, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @current_state)

     INSERT INTO DBO.d20 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     UPDATE DBO.a20 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PSRCJunctID = @upd_PSRCJunctID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletedDate = @upd_CompletedDate,M = @upd_M,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,NewOwner = @upd_NewOwner,NewMaintainer = @upd_NewMaintainer,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing 
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
           FROM DBO.d20 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.a20 (
OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PSRCJunctID, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletedDate, @upd_M, @upd_P_RStalls, @upd_Modes, @upd_NewOwner, @upd_NewMaintainer, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @current_state)

        INSERT INTO DBO.d20 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.EVTPOINTPROJECTOUTCOMES SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PSRCJunctID = @upd_PSRCJunctID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletedDate = @upd_CompletedDate,M = @upd_M,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,NewOwner = @upd_NewOwner,NewMaintainer = @upd_NewMaintainer,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing 
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
        INSERT INTO DBO.a20 (
OBJECTID,projRteID,projDBS,projID,version,PSRCJunctID,InServiceDate,OutServiceDate,CompletedDate,M,P_RStalls,Modes,NewOwner,NewMaintainer,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PSRCJunctID, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletedDate, @upd_M, @upd_P_RStalls, @upd_Modes, @upd_NewOwner, @upd_NewMaintainer, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @current_state)

        INSERT INTO DBO.d20 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.a20 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PSRCJunctID = @upd_PSRCJunctID,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletedDate = @upd_CompletedDate,M = @upd_M,P_RStalls = @upd_P_RStalls,Modes = @upd_Modes,NewOwner = @upd_NewOwner,NewMaintainer = @upd_NewMaintainer,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PSRCJunctID, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletedDate, @upd_M, @upd_P_RStalls, @upd_Modes, @upd_NewOwner, @upd_NewMaintainer, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 20) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 20, @current_state
END
GO
