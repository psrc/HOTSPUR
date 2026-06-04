SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[tblLineProjects_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.projRteID,b.projDBS,b.projID,b.version,b.InServiceDate,b.OutServiceDate,b.CompletionDate,b.Modes,b.IJLanesGPAM,b.IJLanesGPMD,b.IJLanesGPPM,b.IJLanesGPEV,b.IJLanesGPNI,b.JILanesGPAM,b.JILanesGPMD,b.JILanesGPPM,b.JILanesGPEV,b.JILanesGPNI,b.IJlanesGPadjust,b.JIlanesGPadjust,b.IJLanesHOVAM,b.IJLanesHOVMD,b.IJLanesHOVPM,b.IJLanesHOVEV,b.IJLanesHOVNI,b.JILanesHOVAM,b.JILanesHOVMD,b.JILanesHOVPM,b.JILanesHOVEV,b.JILanesHOVNI,b.IJSpeedLimit,b.JISpeedLimit,b.IJVDFunc,b.JIVDFunc,b.IJLaneCapGP,b.IJLaneCapHOV,b.JILaneCapGP,b.JILaneCapHOV,b.IJSideWalks,b.JISideWalks,b.IJBikeLanes,b.JIBikeLanes,b.IJLanesTR,b.JILanesTR,b.IJLanesTK,b.JILanesTK,b.dateLastUpdated,b.DateCreated,b.LastEditor,b.EditNotes,b.Processing,b.IJBikeFacility,b.JIBikeFacility,b.IJBikeType,b.JIBikeType,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.TBLLINEPROJECTS b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d29 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.projRteID,a.projDBS,a.projID,a.version,a.InServiceDate,a.OutServiceDate,a.CompletionDate,a.Modes,a.IJLanesGPAM,a.IJLanesGPMD,a.IJLanesGPPM,a.IJLanesGPEV,a.IJLanesGPNI,a.JILanesGPAM,a.JILanesGPMD,a.JILanesGPPM,a.JILanesGPEV,a.JILanesGPNI,a.IJlanesGPadjust,a.JIlanesGPadjust,a.IJLanesHOVAM,a.IJLanesHOVMD,a.IJLanesHOVPM,a.IJLanesHOVEV,a.IJLanesHOVNI,a.JILanesHOVAM,a.JILanesHOVMD,a.JILanesHOVPM,a.JILanesHOVEV,a.JILanesHOVNI,a.IJSpeedLimit,a.JISpeedLimit,a.IJVDFunc,a.JIVDFunc,a.IJLaneCapGP,a.IJLaneCapHOV,a.JILaneCapGP,a.JILaneCapHOV,a.IJSideWalks,a.JISideWalks,a.IJBikeLanes,a.JIBikeLanes,a.IJLanesTR,a.JILanesTR,a.IJLanesTK,a.JILanesTK,a.dateLastUpdated,a.DateCreated,a.LastEditor,a.EditNotes,a.Processing,a.IJBikeFacility,a.JIBikeFacility,a.IJBikeType,a.JIBikeType,a.SDE_STATE_ID FROM DBO.a29 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d29 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v29_delete]  ON [dbo].[tblLineProjects_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d29 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a29 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d29 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d29 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TBLLINEPROJECTS WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d29 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d29 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a29
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 29) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 29, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v29_insert] ON [dbo].[tblLineProjects_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i29_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i29_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TBLLINEPROJECTS
  (OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
  SELECT 
  @next_row_id,i.projRteID,i.projDBS,i.projID,i.version,i.InServiceDate,i.OutServiceDate,i.CompletionDate,i.Modes,i.IJLanesGPAM,i.IJLanesGPMD,i.IJLanesGPPM,i.IJLanesGPEV,i.IJLanesGPNI,i.JILanesGPAM,i.JILanesGPMD,i.JILanesGPPM,i.JILanesGPEV,i.JILanesGPNI,i.IJlanesGPadjust,i.JIlanesGPadjust,i.IJLanesHOVAM,i.IJLanesHOVMD,i.IJLanesHOVPM,i.IJLanesHOVEV,i.IJLanesHOVNI,i.JILanesHOVAM,i.JILanesHOVMD,i.JILanesHOVPM,i.JILanesHOVEV,i.JILanesHOVNI,i.IJSpeedLimit,i.JISpeedLimit,i.IJVDFunc,i.JIVDFunc,i.IJLaneCapGP,i.IJLaneCapHOV,i.JILaneCapGP,i.JILaneCapHOV,i.IJSideWalks,i.JISideWalks,i.IJBikeLanes,i.JIBikeLanes,i.IJLanesTR,i.JILanesTR,i.IJLanesTK,i.JILanesTK,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.IJBikeFacility,i.JIBikeFacility,i.IJBikeType,i.JIBikeType  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a29
  (OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.projRteID,i.projDBS,i.projID,i.version,i.InServiceDate,i.OutServiceDate,i.CompletionDate,i.Modes,i.IJLanesGPAM,i.IJLanesGPMD,i.IJLanesGPPM,i.IJLanesGPEV,i.IJLanesGPNI,i.JILanesGPAM,i.JILanesGPMD,i.JILanesGPPM,i.JILanesGPEV,i.JILanesGPNI,i.IJlanesGPadjust,i.JIlanesGPadjust,i.IJLanesHOVAM,i.IJLanesHOVMD,i.IJLanesHOVPM,i.IJLanesHOVEV,i.IJLanesHOVNI,i.JILanesHOVAM,i.JILanesHOVMD,i.JILanesHOVPM,i.JILanesHOVEV,i.JILanesHOVNI,i.IJSpeedLimit,i.JISpeedLimit,i.IJVDFunc,i.JIVDFunc,i.IJLaneCapGP,i.IJLaneCapHOV,i.JILaneCapGP,i.JILaneCapHOV,i.IJSideWalks,i.JISideWalks,i.IJBikeLanes,i.JIBikeLanes,i.IJLanesTR,i.JILanesTR,i.IJLanesTK,i.JILanesTK,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.IJBikeFacility,i.JIBikeFacility,i.IJBikeType,i.JIBikeType,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType,SDE_STATE_ID
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 int
  DECLARE @col3 nvarchar(25) 
  DECLARE @col4 nvarchar(25) 
  DECLARE @col5 int
  DECLARE @col6 smallint
  DECLARE @col7 smallint
  DECLARE @col8 datetime2
  DECLARE @col9 nvarchar(30) 
  DECLARE @col10 int
  DECLARE @col11 int
  DECLARE @col12 int
  DECLARE @col13 int
  DECLARE @col14 int
  DECLARE @col15 int
  DECLARE @col16 int
  DECLARE @col17 int
  DECLARE @col18 int
  DECLARE @col19 int
  DECLARE @col20 numeric(6,2) 
  DECLARE @col21 numeric(6,2) 
  DECLARE @col22 int
  DECLARE @col23 int
  DECLARE @col24 int
  DECLARE @col25 int
  DECLARE @col26 int
  DECLARE @col27 int
  DECLARE @col28 int
  DECLARE @col29 int
  DECLARE @col30 int
  DECLARE @col31 int
  DECLARE @col32 int
  DECLARE @col33 int
  DECLARE @col34 int
  DECLARE @col35 int
  DECLARE @col36 int
  DECLARE @col37 int
  DECLARE @col38 int
  DECLARE @col39 int
  DECLARE @col40 int
  DECLARE @col41 int
  DECLARE @col42 int
  DECLARE @col43 int
  DECLARE @col44 int
  DECLARE @col45 int
  DECLARE @col46 int
  DECLARE @col47 int
  DECLARE @col48 datetime2
  DECLARE @col49 datetime2
  DECLARE @col50 nvarchar(50) 
  DECLARE @col51 nvarchar(256) 
  DECLARE @col52 int
  DECLARE @col53 int
  DECLARE @col54 int
  DECLARE @col55 int
  DECLARE @col56 int
  DECLARE @col57 bigint
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i29_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i29_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.TBLLINEPROJECTS
      (OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56 )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a29
      (OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType,SDE_STATE_ID)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@current_state )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 29) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 29, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v29_update]  ON [dbo].[tblLineProjects_evw] INSTEAD OF UPDATE AS 
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
 i.InServiceDate,
 i.OutServiceDate,
 i.CompletionDate,
 i.Modes,
 i.IJLanesGPAM,
 i.IJLanesGPMD,
 i.IJLanesGPPM,
 i.IJLanesGPEV,
 i.IJLanesGPNI,
 i.JILanesGPAM,
 i.JILanesGPMD,
 i.JILanesGPPM,
 i.JILanesGPEV,
 i.JILanesGPNI,
 i.IJlanesGPadjust,
 i.JIlanesGPadjust,
 i.IJLanesHOVAM,
 i.IJLanesHOVMD,
 i.IJLanesHOVPM,
 i.IJLanesHOVEV,
 i.IJLanesHOVNI,
 i.JILanesHOVAM,
 i.JILanesHOVMD,
 i.JILanesHOVPM,
 i.JILanesHOVEV,
 i.JILanesHOVNI,
 i.IJSpeedLimit,
 i.JISpeedLimit,
 i.IJVDFunc,
 i.JIVDFunc,
 i.IJLaneCapGP,
 i.IJLaneCapHOV,
 i.JILaneCapGP,
 i.JILaneCapHOV,
 i.IJSideWalks,
 i.JISideWalks,
 i.IJBikeLanes,
 i.JIBikeLanes,
 i.IJLanesTR,
 i.JILanesTR,
 i.IJLanesTK,
 i.JILanesTK,
 i.dateLastUpdated,
 i.DateCreated,
 i.LastEditor,
 i.EditNotes,
 i.Processing,
 i.IJBikeFacility,
 i.JIBikeFacility,
 i.IJBikeType,
 i.JIBikeType
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_projRteID int
DECLARE @upd_projDBS nvarchar(25) 
DECLARE @upd_projID nvarchar(25) 
DECLARE @upd_version int
DECLARE @upd_InServiceDate smallint
DECLARE @upd_OutServiceDate smallint
DECLARE @upd_CompletionDate datetime2
DECLARE @upd_Modes nvarchar(30) 
DECLARE @upd_IJLanesGPAM int
DECLARE @upd_IJLanesGPMD int
DECLARE @upd_IJLanesGPPM int
DECLARE @upd_IJLanesGPEV int
DECLARE @upd_IJLanesGPNI int
DECLARE @upd_JILanesGPAM int
DECLARE @upd_JILanesGPMD int
DECLARE @upd_JILanesGPPM int
DECLARE @upd_JILanesGPEV int
DECLARE @upd_JILanesGPNI int
DECLARE @upd_IJlanesGPadjust numeric(6,2) 
DECLARE @upd_JIlanesGPadjust numeric(6,2) 
DECLARE @upd_IJLanesHOVAM int
DECLARE @upd_IJLanesHOVMD int
DECLARE @upd_IJLanesHOVPM int
DECLARE @upd_IJLanesHOVEV int
DECLARE @upd_IJLanesHOVNI int
DECLARE @upd_JILanesHOVAM int
DECLARE @upd_JILanesHOVMD int
DECLARE @upd_JILanesHOVPM int
DECLARE @upd_JILanesHOVEV int
DECLARE @upd_JILanesHOVNI int
DECLARE @upd_IJSpeedLimit int
DECLARE @upd_JISpeedLimit int
DECLARE @upd_IJVDFunc int
DECLARE @upd_JIVDFunc int
DECLARE @upd_IJLaneCapGP int
DECLARE @upd_IJLaneCapHOV int
DECLARE @upd_JILaneCapGP int
DECLARE @upd_JILaneCapHOV int
DECLARE @upd_IJSideWalks int
DECLARE @upd_JISideWalks int
DECLARE @upd_IJBikeLanes int
DECLARE @upd_JIBikeLanes int
DECLARE @upd_IJLanesTR int
DECLARE @upd_JILanesTR int
DECLARE @upd_IJLanesTK int
DECLARE @upd_JILanesTK int
DECLARE @upd_dateLastUpdated datetime2
DECLARE @upd_DateCreated datetime2
DECLARE @upd_LastEditor nvarchar(50) 
DECLARE @upd_EditNotes nvarchar(256) 
DECLARE @upd_Processing int
DECLARE @upd_IJBikeFacility int
DECLARE @upd_JIBikeFacility int
DECLARE @upd_IJBikeType int
DECLARE @upd_JIBikeType int
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     INSERT INTO DBO.a29 (
OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType, @current_state)

     INSERT INTO DBO.d29 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     UPDATE DBO.a29 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
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
           FROM DBO.d29 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.a29 (
OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType, @current_state)

        INSERT INTO DBO.d29 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.TBLLINEPROJECTS SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
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
        INSERT INTO DBO.a29 (
OBJECTID,projRteID,projDBS,projID,version,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType, @current_state)

        INSERT INTO DBO.d29 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.a29 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 29) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 29, @current_state
END
GO
