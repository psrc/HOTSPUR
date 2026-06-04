SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ProjectRoutes_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.projRteID,b.projDBS,b.projID,b.version,b.PhaseID,b.withEvents,b.Flag_area,b.Change_Type,b.Inode,b.Jnode,b.dateLastUpdated,b.DateCreated,b.LastEditor,b.EditNotes,b.Processing,b.Enabled,b.intProjID,b.OnewayChange,b.Oneway,b.Shape,b.GDB_GEOMATTR_DATA,b.OBJECTID - b.OBJECTID SDE_STATE_ID,b.projRteID_1,b.projDBS_1,b.projID_1,b.version_1,b.InServiceDate,b.OutServiceDate,b.CompletionDate,b.Modes,b.IJLanesGPAM,b.IJLanesGPMD,b.IJLanesGPPM,b.IJLanesGPEV,b.IJLanesGPNI,b.JILanesGPAM,b.JILanesGPMD,b.JILanesGPPM,b.JILanesGPEV,b.JILanesGPNI,b.IJlanesGPadjust,b.JIlanesGPadjust,b.IJLanesHOVAM,b.IJLanesHOVMD,b.IJLanesHOVPM,b.IJLanesHOVEV,b.IJLanesHOVNI,b.JILanesHOVAM,b.JILanesHOVMD,b.JILanesHOVPM,b.JILanesHOVEV,b.JILanesHOVNI,b.IJSpeedLimit,b.JISpeedLimit,b.IJVDFunc,b.JIVDFunc,b.IJLaneCapGP,b.IJLaneCapHOV,b.JILaneCapGP,b.JILaneCapHOV,b.IJSideWalks,b.JISideWalks,b.IJBikeLanes,b.JIBikeLanes,b.IJLanesTR,b.JILanesTR,b.IJLanesTK,b.JILanesTK,b.dateLastUpdated_1,b.DateCreated_1,b.LastEditor_1,b.EditNotes_1,b.Processing_1,b.IJBikeFacility,b.JIBikeFacility,b.IJBikeType,b.JIBikeType FROM DBO.PROJECTROUTES b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d40 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.projRteID,a.projDBS,a.projID,a.version,a.PhaseID,a.withEvents,a.Flag_area,a.Change_Type,a.Inode,a.Jnode,a.dateLastUpdated,a.DateCreated,a.LastEditor,a.EditNotes,a.Processing,a.Enabled,a.intProjID,a.OnewayChange,a.Oneway,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID,a.projRteID_1,a.projDBS_1,a.projID_1,a.version_1,a.InServiceDate,a.OutServiceDate,a.CompletionDate,a.Modes,a.IJLanesGPAM,a.IJLanesGPMD,a.IJLanesGPPM,a.IJLanesGPEV,a.IJLanesGPNI,a.JILanesGPAM,a.JILanesGPMD,a.JILanesGPPM,a.JILanesGPEV,a.JILanesGPNI,a.IJlanesGPadjust,a.JIlanesGPadjust,a.IJLanesHOVAM,a.IJLanesHOVMD,a.IJLanesHOVPM,a.IJLanesHOVEV,a.IJLanesHOVNI,a.JILanesHOVAM,a.JILanesHOVMD,a.JILanesHOVPM,a.JILanesHOVEV,a.JILanesHOVNI,a.IJSpeedLimit,a.JISpeedLimit,a.IJVDFunc,a.JIVDFunc,a.IJLaneCapGP,a.IJLaneCapHOV,a.JILaneCapGP,a.JILaneCapHOV,a.IJSideWalks,a.JISideWalks,a.IJBikeLanes,a.JIBikeLanes,a.IJLanesTR,a.JILanesTR,a.IJLanesTK,a.JILanesTK,a.dateLastUpdated_1,a.DateCreated_1,a.LastEditor_1,a.EditNotes_1,a.Processing_1,a.IJBikeFacility,a.JIBikeFacility,a.IJBikeType,a.JIBikeType FROM DBO.a40 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d40 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v40_delete]  ON [dbo].[ProjectRoutes_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d40 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a40 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d40 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d40 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.PROJECTROUTES WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d40 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d40 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a40
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 40) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 40, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v40_insert] ON [dbo].[ProjectRoutes_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i40_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i40_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.PROJECTROUTES
  (OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
  SELECT 
  @next_row_id,i.projRteID,i.projDBS,i.projID,i.version,i.PhaseID,i.withEvents,i.Flag_area,i.Change_Type,i.Inode,i.Jnode,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.intProjID,i.OnewayChange,i.Oneway,i.Shape,NULL,i.projRteID_1,i.projDBS_1,i.projID_1,i.version_1,i.InServiceDate,i.OutServiceDate,i.CompletionDate,i.Modes,i.IJLanesGPAM,i.IJLanesGPMD,i.IJLanesGPPM,i.IJLanesGPEV,i.IJLanesGPNI,i.JILanesGPAM,i.JILanesGPMD,i.JILanesGPPM,i.JILanesGPEV,i.JILanesGPNI,i.IJlanesGPadjust,i.JIlanesGPadjust,i.IJLanesHOVAM,i.IJLanesHOVMD,i.IJLanesHOVPM,i.IJLanesHOVEV,i.IJLanesHOVNI,i.JILanesHOVAM,i.JILanesHOVMD,i.JILanesHOVPM,i.JILanesHOVEV,i.JILanesHOVNI,i.IJSpeedLimit,i.JISpeedLimit,i.IJVDFunc,i.JIVDFunc,i.IJLaneCapGP,i.IJLaneCapHOV,i.JILaneCapGP,i.JILaneCapHOV,i.IJSideWalks,i.JISideWalks,i.IJBikeLanes,i.JIBikeLanes,i.IJLanesTR,i.JILanesTR,i.IJLanesTK,i.JILanesTK,i.dateLastUpdated_1,i.DateCreated_1,i.LastEditor_1,i.EditNotes_1,i.Processing_1,i.IJBikeFacility,i.JIBikeFacility,i.IJBikeType,i.JIBikeType  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a40
  (OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
  SELECT 
  @next_row_id,i.projRteID,i.projDBS,i.projID,i.version,i.PhaseID,i.withEvents,i.Flag_area,i.Change_Type,i.Inode,i.Jnode,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.intProjID,i.OnewayChange,i.Oneway,i.Shape,NULL,@current_state,i.projRteID_1,i.projDBS_1,i.projID_1,i.version_1,i.InServiceDate,i.OutServiceDate,i.CompletionDate,i.Modes,i.IJLanesGPAM,i.IJLanesGPMD,i.IJLanesGPPM,i.IJLanesGPEV,i.IJLanesGPNI,i.JILanesGPAM,i.JILanesGPMD,i.JILanesGPPM,i.JILanesGPEV,i.JILanesGPNI,i.IJlanesGPadjust,i.JIlanesGPadjust,i.IJLanesHOVAM,i.IJLanesHOVMD,i.IJLanesHOVPM,i.IJLanesHOVEV,i.IJLanesHOVNI,i.JILanesHOVAM,i.JILanesHOVMD,i.JILanesHOVPM,i.JILanesHOVEV,i.JILanesHOVNI,i.IJSpeedLimit,i.JISpeedLimit,i.IJVDFunc,i.JIVDFunc,i.IJLaneCapGP,i.IJLaneCapHOV,i.JILaneCapGP,i.JILaneCapHOV,i.IJSideWalks,i.JISideWalks,i.IJBikeLanes,i.JIBikeLanes,i.IJLanesTR,i.JILanesTR,i.IJLanesTK,i.JILanesTK,i.dateLastUpdated_1,i.DateCreated_1,i.LastEditor_1,i.EditNotes_1,i.Processing_1,i.IJBikeFacility,i.JIBikeFacility,i.IJBikeType,i.JIBikeType  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 int
  DECLARE @col3 nvarchar(25) 
  DECLARE @col4 nvarchar(25) 
  DECLARE @col5 smallint
  DECLARE @col6 nvarchar(25) 
  DECLARE @col7 int
  DECLARE @col8 smallint
  DECLARE @col9 nvarchar(25) 
  DECLARE @col10 int
  DECLARE @col11 int
  DECLARE @col12 datetime2
  DECLARE @col13 datetime2
  DECLARE @col14 nvarchar(50) 
  DECLARE @col15 nvarchar(256) 
  DECLARE @col16 int
  DECLARE @col17 smallint
  DECLARE @col18 smallint
  DECLARE @col19 int
  DECLARE @col20 int
  DECLARE @col21 geometry
  DECLARE @col22 varbinary(max) 
  DECLARE @col23 bigint
  DECLARE @col24 int
  DECLARE @col25 nvarchar(25) 
  DECLARE @col26 nvarchar(25) 
  DECLARE @col27 int
  DECLARE @col28 smallint
  DECLARE @col29 smallint
  DECLARE @col30 datetime2
  DECLARE @col31 nvarchar(30) 
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
  DECLARE @col42 numeric(6,2) 
  DECLARE @col43 numeric(6,2) 
  DECLARE @col44 int
  DECLARE @col45 int
  DECLARE @col46 int
  DECLARE @col47 int
  DECLARE @col48 int
  DECLARE @col49 int
  DECLARE @col50 int
  DECLARE @col51 int
  DECLARE @col52 int
  DECLARE @col53 int
  DECLARE @col54 int
  DECLARE @col55 int
  DECLARE @col56 int
  DECLARE @col57 int
  DECLARE @col58 int
  DECLARE @col59 int
  DECLARE @col60 int
  DECLARE @col61 int
  DECLARE @col62 int
  DECLARE @col63 int
  DECLARE @col64 int
  DECLARE @col65 int
  DECLARE @col66 int
  DECLARE @col67 int
  DECLARE @col68 int
  DECLARE @col69 int
  DECLARE @col70 datetime2
  DECLARE @col71 datetime2
  DECLARE @col72 nvarchar(50) 
  DECLARE @col73 nvarchar(256) 
  DECLARE @col74 int
  DECLARE @col75 int
  DECLARE @col76 int
  DECLARE @col77 int
  DECLARE @col78 int
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i40_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i40_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.PROJECTROUTES
      (OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,NULL,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78 )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a40
      (OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,NULL,@current_state,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78 )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 40) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 40, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v40_update]  ON [dbo].[ProjectRoutes_evw] INSTEAD OF UPDATE AS 
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
 i.projRteID,
 i.projDBS,
 i.projID,
 i.version,
 i.PhaseID,
 i.withEvents,
 i.Flag_area,
 i.Change_Type,
 i.Inode,
 i.Jnode,
 i.dateLastUpdated,
 i.DateCreated,
 i.LastEditor,
 i.EditNotes,
 i.Processing,
 i.Enabled,
 i.intProjID,
 i.OnewayChange,
 i.Oneway,
 i.GDB_GEOMATTR_DATA,
 i.projRteID_1,
 i.projDBS_1,
 i.projID_1,
 i.version_1,
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
 i.dateLastUpdated_1,
 i.DateCreated_1,
 i.LastEditor_1,
 i.EditNotes_1,
 i.Processing_1,
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
DECLARE @upd_version smallint
DECLARE @upd_PhaseID nvarchar(25) 
DECLARE @upd_withEvents int
DECLARE @upd_Flag_area smallint
DECLARE @upd_Change_Type nvarchar(25) 
DECLARE @upd_Inode int
DECLARE @upd_Jnode int
DECLARE @upd_dateLastUpdated datetime2
DECLARE @upd_DateCreated datetime2
DECLARE @upd_LastEditor nvarchar(50) 
DECLARE @upd_EditNotes nvarchar(256) 
DECLARE @upd_Processing int
DECLARE @upd_Enabled smallint
DECLARE @upd_intProjID smallint
DECLARE @upd_OnewayChange int
DECLARE @upd_Oneway int
DECLARE @upd_GDB_GEOMATTR_DATA varbinary(max) 
DECLARE @upd_projRteID_1 int
DECLARE @upd_projDBS_1 nvarchar(25) 
DECLARE @upd_projID_1 nvarchar(25) 
DECLARE @upd_version_1 int
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
DECLARE @upd_dateLastUpdated_1 datetime2
DECLARE @upd_DateCreated_1 datetime2
DECLARE @upd_LastEditor_1 nvarchar(50) 
DECLARE @upd_EditNotes_1 nvarchar(256) 
DECLARE @upd_Processing_1 int
DECLARE @upd_IJBikeFacility int
DECLARE @upd_JIBikeFacility int
DECLARE @upd_IJBikeType int
DECLARE @upd_JIBikeType int
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @upd_GDB_GEOMATTR_DATA, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a40 (
OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
         VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType)

     ELSE
INSERT INTO DBO.a40 (
OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
          VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @new_spatial_column, NULL, @current_state, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType)

     INSERT INTO DBO.d40 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a40 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PhaseID = @upd_PhaseID,withEvents = @upd_withEvents,Flag_area = @upd_Flag_area,Change_Type = @upd_Change_Type,Inode = @upd_Inode,Jnode = @upd_Jnode,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,intProjID = @upd_intProjID,OnewayChange = @upd_OnewayChange,Oneway = @upd_Oneway,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL ,projRteID_1 = @upd_projRteID_1,projDBS_1 = @upd_projDBS_1,projID_1 = @upd_projID_1,version_1 = @upd_version_1,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,EditNotes_1 = @upd_EditNotes_1,Processing_1 = @upd_Processing_1,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a40 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PhaseID = @upd_PhaseID,withEvents = @upd_withEvents,Flag_area = @upd_Flag_area,Change_Type = @upd_Change_Type,Inode = @upd_Inode,Jnode = @upd_Jnode,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,intProjID = @upd_intProjID,OnewayChange = @upd_OnewayChange,Oneway = @upd_Oneway,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA,projRteID_1 = @upd_projRteID_1,projDBS_1 = @upd_projDBS_1,projID_1 = @upd_projID_1,version_1 = @upd_version_1,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,EditNotes_1 = @upd_EditNotes_1,Processing_1 = @upd_Processing_1,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
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
           FROM DBO.d40 WITH (TABLOCKX,HOLDLOCK)
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
INSERT INTO DBO.a40 (
OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
         VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType)

     ELSE
INSERT INTO DBO.a40 (
OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
          VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @new_spatial_column, NULL, @current_state, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType)

        INSERT INTO DBO.d40 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.PROJECTROUTES SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PhaseID = @upd_PhaseID,withEvents = @upd_withEvents,Flag_area = @upd_Flag_area,Change_Type = @upd_Change_Type,Inode = @upd_Inode,Jnode = @upd_Jnode,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,intProjID = @upd_intProjID,OnewayChange = @upd_OnewayChange,Oneway = @upd_Oneway,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL ,projRteID_1 = @upd_projRteID_1,projDBS_1 = @upd_projDBS_1,projID_1 = @upd_projID_1,version_1 = @upd_version_1,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,EditNotes_1 = @upd_EditNotes_1,Processing_1 = @upd_Processing_1,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
WHERE OBJECTID = @old_row_id 
     ELSE
     UPDATE DBO.PROJECTROUTES SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PhaseID = @upd_PhaseID,withEvents = @upd_withEvents,Flag_area = @upd_Flag_area,Change_Type = @upd_Change_Type,Inode = @upd_Inode,Jnode = @upd_Jnode,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,intProjID = @upd_intProjID,OnewayChange = @upd_OnewayChange,Oneway = @upd_Oneway,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA,projRteID_1 = @upd_projRteID_1,projDBS_1 = @upd_projDBS_1,projID_1 = @upd_projID_1,version_1 = @upd_version_1,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,EditNotes_1 = @upd_EditNotes_1,Processing_1 = @upd_Processing_1,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
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
INSERT INTO DBO.a40 (
OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
         VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType)

     ELSE
INSERT INTO DBO.a40 (
OBJECTID,projRteID,projDBS,projID,version,PhaseID,withEvents,Flag_area,Change_Type,Inode,Jnode,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,intProjID,OnewayChange,Oneway,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,projRteID_1,projDBS_1,projID_1,version_1,InServiceDate,OutServiceDate,CompletionDate,Modes,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,dateLastUpdated_1,DateCreated_1,LastEditor_1,EditNotes_1,Processing_1,IJBikeFacility,JIBikeFacility,IJBikeType,JIBikeType)
          VALUES(  @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @new_spatial_column, NULL, @current_state, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType)

        INSERT INTO DBO.d40 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a40 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PhaseID = @upd_PhaseID,withEvents = @upd_withEvents,Flag_area = @upd_Flag_area,Change_Type = @upd_Change_Type,Inode = @upd_Inode,Jnode = @upd_Jnode,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,intProjID = @upd_intProjID,OnewayChange = @upd_OnewayChange,Oneway = @upd_Oneway,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL ,projRteID_1 = @upd_projRteID_1,projDBS_1 = @upd_projDBS_1,projID_1 = @upd_projID_1,version_1 = @upd_version_1,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,EditNotes_1 = @upd_EditNotes_1,Processing_1 = @upd_Processing_1,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a40 SET projRteID = @upd_projRteID,projDBS = @upd_projDBS,projID = @upd_projID,version = @upd_version,PhaseID = @upd_PhaseID,withEvents = @upd_withEvents,Flag_area = @upd_Flag_area,Change_Type = @upd_Change_Type,Inode = @upd_Inode,Jnode = @upd_Jnode,dateLastUpdated = @upd_dateLastUpdated,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Processing = @upd_Processing,Enabled = @upd_Enabled,intProjID = @upd_intProjID,OnewayChange = @upd_OnewayChange,Oneway = @upd_Oneway,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA,projRteID_1 = @upd_projRteID_1,projDBS_1 = @upd_projDBS_1,projID_1 = @upd_projID_1,version_1 = @upd_version_1,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,CompletionDate = @upd_CompletionDate,Modes = @upd_Modes,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,EditNotes_1 = @upd_EditNotes_1,Processing_1 = @upd_Processing_1,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state

      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_projRteID, @upd_projDBS, @upd_projID, @upd_version, @upd_PhaseID, @upd_withEvents, @upd_Flag_area, @upd_Change_Type, @upd_Inode, @upd_Jnode, @upd_dateLastUpdated, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Processing, @upd_Enabled, @upd_intProjID, @upd_OnewayChange, @upd_Oneway, @upd_GDB_GEOMATTR_DATA, @upd_projRteID_1, @upd_projDBS_1, @upd_projID_1, @upd_version_1, @upd_InServiceDate, @upd_OutServiceDate, @upd_CompletionDate, @upd_Modes, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_EditNotes_1, @upd_Processing_1, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJBikeType, @upd_JIBikeType
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 40) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 40, @current_state
END
GO
