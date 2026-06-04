SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TransRefEdges_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.Enabled,b.PSRCEdgeID,b.FTRsegID,b.FacilityType,b.NewFacilityType,b.INode,b.JNode,b.InServiceDate,b.OutServiceDate,b.dateLastUpdated,b.ActiveLink,b.LinkType,b.FunctionalClass,b.Modes,b.MTS,b.CMSlinkID,b.CMScriticalLinkID,b.Oneway,b.Fullname,b.DateCreated,b.LastEditor,b.EditNotes,b.Tonnage,b.GlobalEID,b.Processing,b.CountID,b.CountyID,b.StateRoute,b.OldPSRCEdgeID,b.OSMID,b.OSMNetID,b.highway,b.OSM_Oneway,b.CorridorID,b.RegShared,b.FGTS,b.Source,b.Shape,b.GDB_GEOMATTR_DATA,b.OBJECTID - b.OBJECTID SDE_STATE_ID,b.GlobalID,b.PSRCEdgeID_1,b.IJLanesGPAM,b.IJLanesGPMD,b.IJLanesGPPM,b.IJLanesGPEV,b.IJLanesGPNI,b.JILanesGPAM,b.JILanesGPMD,b.JILanesGPPM,b.JILanesGPEV,b.JILanesGPNI,b.IJlanesGPadjust,b.JIlanesGPadjust,b.IJLanesHOVAM,b.IJLanesHOVMD,b.IJLanesHOVPM,b.IJLanesHOVEV,b.IJLanesHOVNI,b.JILanesHOVAM,b.JILanesHOVMD,b.JILanesHOVPM,b.JILanesHOVEV,b.JILanesHOVNI,b.IJSpeedLimit,b.JISpeedLimit,b.IJVDFunc,b.JIVDFunc,b.IJLaneCapGP,b.IJLaneCapHOV,b.JILaneCapGP,b.JILaneCapHOV,b.IJSideWalks,b.JISideWalks,b.IJBikeLanes,b.JIBikeLanes,b.IJLanesTR,b.JILanesTR,b.IJLanesTK,b.JILanesTK,b.PSRCE2_ID,b.dateLastUpdated_1,b.DateCreated_1,b.LastEditor_1,b.DataSource,b.Processing_1,b.BikeSigns,b.SidewalkSource,b.BikeEditorNotes,b.IJBikeFacility,b.JIBikeFacility,b.IJPedFacilities,b.JIPedFacilities,b.IJBikeType,b.JIBikeType,b.IJBikeFacilities,b.JIBikeFacilities,b.IJCorridorID,b.JICorridorID,b.Channelization,b.BikeSource_hold,b.BikeSource,b.PedBikeNotes,b.created_user,b.created_date,b.last_edited_user,b.last_edited_date FROM DBO.TRANSREFEDGES b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d44 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.Enabled,a.PSRCEdgeID,a.FTRsegID,a.FacilityType,a.NewFacilityType,a.INode,a.JNode,a.InServiceDate,a.OutServiceDate,a.dateLastUpdated,a.ActiveLink,a.LinkType,a.FunctionalClass,a.Modes,a.MTS,a.CMSlinkID,a.CMScriticalLinkID,a.Oneway,a.Fullname,a.DateCreated,a.LastEditor,a.EditNotes,a.Tonnage,a.GlobalEID,a.Processing,a.CountID,a.CountyID,a.StateRoute,a.OldPSRCEdgeID,a.OSMID,a.OSMNetID,a.highway,a.OSM_Oneway,a.CorridorID,a.RegShared,a.FGTS,a.Source,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID,a.GlobalID,a.PSRCEdgeID_1,a.IJLanesGPAM,a.IJLanesGPMD,a.IJLanesGPPM,a.IJLanesGPEV,a.IJLanesGPNI,a.JILanesGPAM,a.JILanesGPMD,a.JILanesGPPM,a.JILanesGPEV,a.JILanesGPNI,a.IJlanesGPadjust,a.JIlanesGPadjust,a.IJLanesHOVAM,a.IJLanesHOVMD,a.IJLanesHOVPM,a.IJLanesHOVEV,a.IJLanesHOVNI,a.JILanesHOVAM,a.JILanesHOVMD,a.JILanesHOVPM,a.JILanesHOVEV,a.JILanesHOVNI,a.IJSpeedLimit,a.JISpeedLimit,a.IJVDFunc,a.JIVDFunc,a.IJLaneCapGP,a.IJLaneCapHOV,a.JILaneCapGP,a.JILaneCapHOV,a.IJSideWalks,a.JISideWalks,a.IJBikeLanes,a.JIBikeLanes,a.IJLanesTR,a.JILanesTR,a.IJLanesTK,a.JILanesTK,a.PSRCE2_ID,a.dateLastUpdated_1,a.DateCreated_1,a.LastEditor_1,a.DataSource,a.Processing_1,a.BikeSigns,a.SidewalkSource,a.BikeEditorNotes,a.IJBikeFacility,a.JIBikeFacility,a.IJPedFacilities,a.JIPedFacilities,a.IJBikeType,a.JIBikeType,a.IJBikeFacilities,a.JIBikeFacilities,a.IJCorridorID,a.JICorridorID,a.Channelization,a.BikeSource_hold,a.BikeSource,a.PedBikeNotes,a.created_user,a.created_date,a.last_edited_user,a.last_edited_date FROM DBO.a44 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d44 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v44_delete]  ON [dbo].[TransRefEdges_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d44 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a44 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d44 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d44 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TRANSREFEDGES WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d44 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d44 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a44
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 44) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 44, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v44_insert] ON [dbo].[TransRefEdges_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i44_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i44_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TRANSREFEDGES
  (OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
  SELECT 
  @next_row_id,i.Enabled,i.PSRCEdgeID,i.FTRsegID,i.FacilityType,i.NewFacilityType,i.INode,i.JNode,i.InServiceDate,i.OutServiceDate,i.dateLastUpdated,i.ActiveLink,i.LinkType,i.FunctionalClass,i.Modes,i.MTS,i.CMSlinkID,i.CMScriticalLinkID,i.Oneway,i.Fullname,i.DateCreated,i.LastEditor,i.EditNotes,i.Tonnage,i.GlobalEID,i.Processing,i.CountID,i.CountyID,i.StateRoute,i.OldPSRCEdgeID,i.OSMID,i.OSMNetID,i.highway,i.OSM_Oneway,i.CorridorID,i.RegShared,i.FGTS,i.Source,i.Shape,NULL,i.GlobalID,i.PSRCEdgeID_1,i.IJLanesGPAM,i.IJLanesGPMD,i.IJLanesGPPM,i.IJLanesGPEV,i.IJLanesGPNI,i.JILanesGPAM,i.JILanesGPMD,i.JILanesGPPM,i.JILanesGPEV,i.JILanesGPNI,i.IJlanesGPadjust,i.JIlanesGPadjust,i.IJLanesHOVAM,i.IJLanesHOVMD,i.IJLanesHOVPM,i.IJLanesHOVEV,i.IJLanesHOVNI,i.JILanesHOVAM,i.JILanesHOVMD,i.JILanesHOVPM,i.JILanesHOVEV,i.JILanesHOVNI,i.IJSpeedLimit,i.JISpeedLimit,i.IJVDFunc,i.JIVDFunc,i.IJLaneCapGP,i.IJLaneCapHOV,i.JILaneCapGP,i.JILaneCapHOV,i.IJSideWalks,i.JISideWalks,i.IJBikeLanes,i.JIBikeLanes,i.IJLanesTR,i.JILanesTR,i.IJLanesTK,i.JILanesTK,i.PSRCE2_ID,i.dateLastUpdated_1,i.DateCreated_1,i.LastEditor_1,i.DataSource,i.Processing_1,i.BikeSigns,i.SidewalkSource,i.BikeEditorNotes,i.IJBikeFacility,i.JIBikeFacility,i.IJPedFacilities,i.JIPedFacilities,i.IJBikeType,i.JIBikeType,i.IJBikeFacilities,i.JIBikeFacilities,i.IJCorridorID,i.JICorridorID,i.Channelization,i.BikeSource_hold,i.BikeSource,i.PedBikeNotes,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a44
  (OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
  SELECT 
  @next_row_id,i.Enabled,i.PSRCEdgeID,i.FTRsegID,i.FacilityType,i.NewFacilityType,i.INode,i.JNode,i.InServiceDate,i.OutServiceDate,i.dateLastUpdated,i.ActiveLink,i.LinkType,i.FunctionalClass,i.Modes,i.MTS,i.CMSlinkID,i.CMScriticalLinkID,i.Oneway,i.Fullname,i.DateCreated,i.LastEditor,i.EditNotes,i.Tonnage,i.GlobalEID,i.Processing,i.CountID,i.CountyID,i.StateRoute,i.OldPSRCEdgeID,i.OSMID,i.OSMNetID,i.highway,i.OSM_Oneway,i.CorridorID,i.RegShared,i.FGTS,i.Source,i.Shape,NULL,@current_state,i.GlobalID,i.PSRCEdgeID_1,i.IJLanesGPAM,i.IJLanesGPMD,i.IJLanesGPPM,i.IJLanesGPEV,i.IJLanesGPNI,i.JILanesGPAM,i.JILanesGPMD,i.JILanesGPPM,i.JILanesGPEV,i.JILanesGPNI,i.IJlanesGPadjust,i.JIlanesGPadjust,i.IJLanesHOVAM,i.IJLanesHOVMD,i.IJLanesHOVPM,i.IJLanesHOVEV,i.IJLanesHOVNI,i.JILanesHOVAM,i.JILanesHOVMD,i.JILanesHOVPM,i.JILanesHOVEV,i.JILanesHOVNI,i.IJSpeedLimit,i.JISpeedLimit,i.IJVDFunc,i.JIVDFunc,i.IJLaneCapGP,i.IJLaneCapHOV,i.JILaneCapGP,i.JILaneCapHOV,i.IJSideWalks,i.JISideWalks,i.IJBikeLanes,i.JIBikeLanes,i.IJLanesTR,i.JILanesTR,i.IJLanesTK,i.JILanesTK,i.PSRCE2_ID,i.dateLastUpdated_1,i.DateCreated_1,i.LastEditor_1,i.DataSource,i.Processing_1,i.BikeSigns,i.SidewalkSource,i.BikeEditorNotes,i.IJBikeFacility,i.JIBikeFacility,i.IJPedFacilities,i.JIPedFacilities,i.IJBikeType,i.JIBikeType,i.IJBikeFacilities,i.JIBikeFacilities,i.IJCorridorID,i.JICorridorID,i.Channelization,i.BikeSource_hold,i.BikeSource,i.PedBikeNotes,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 smallint
  DECLARE @col3 int
  DECLARE @col4 int
  DECLARE @col5 int
  DECLARE @col6 int
  DECLARE @col7 int
  DECLARE @col8 int
  DECLARE @col9 smallint
  DECLARE @col10 smallint
  DECLARE @col11 datetime2
  DECLARE @col12 smallint
  DECLARE @col13 smallint
  DECLARE @col14 int
  DECLARE @col15 nvarchar(50) 
  DECLARE @col16 int
  DECLARE @col17 int
  DECLARE @col18 nvarchar(5) 
  DECLARE @col19 int
  DECLARE @col20 nvarchar(80) 
  DECLARE @col21 datetime2
  DECLARE @col22 nvarchar(50) 
  DECLARE @col23 nvarchar(256) 
  DECLARE @col24 nvarchar(25) 
  DECLARE @col25 int
  DECLARE @col26 int
  DECLARE @col27 int
  DECLARE @col28 smallint
  DECLARE @col29 int
  DECLARE @col30 int
  DECLARE @col31 nvarchar(20) 
  DECLARE @col32 int
  DECLARE @col33 nvarchar(30) 
  DECLARE @col34 nvarchar(50) 
  DECLARE @col35 int
  DECLARE @col36 smallint
  DECLARE @col37 smallint
  DECLARE @col38 nvarchar(50) 
  DECLARE @col39 geometry
  DECLARE @col40 varbinary(max) 
  DECLARE @col41 bigint
  DECLARE @col42 uniqueidentifier
  DECLARE @col43 int
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
  DECLARE @col54 numeric(6,2) 
  DECLARE @col55 numeric(6,2) 
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
  DECLARE @col70 int
  DECLARE @col71 int
  DECLARE @col72 int
  DECLARE @col73 int
  DECLARE @col74 int
  DECLARE @col75 int
  DECLARE @col76 int
  DECLARE @col77 int
  DECLARE @col78 int
  DECLARE @col79 int
  DECLARE @col80 int
  DECLARE @col81 int
  DECLARE @col82 int
  DECLARE @col83 datetime2
  DECLARE @col84 datetime2
  DECLARE @col85 nvarchar(50) 
  DECLARE @col86 smallint
  DECLARE @col87 int
  DECLARE @col88 int
  DECLARE @col89 smallint
  DECLARE @col90 nvarchar(50) 
  DECLARE @col91 int
  DECLARE @col92 int
  DECLARE @col93 int
  DECLARE @col94 int
  DECLARE @col95 int
  DECLARE @col96 int
  DECLARE @col97 int
  DECLARE @col98 int
  DECLARE @col99 int
  DECLARE @col100 int
  DECLARE @col101 numeric(38,8) 
  DECLARE @col102 nvarchar(50) 
  DECLARE @col103 smallint
  DECLARE @col104 nvarchar(50) 
  DECLARE @col105 nvarchar(255) 
  DECLARE @col106 datetime2
  DECLARE @col107 nvarchar(255) 
  DECLARE @col108 datetime2
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78,@col79,@col80,@col81,@col82,@col83,@col84,@col85,@col86,@col87,@col88,@col89,@col90,@col91,@col92,@col93,@col94,@col95,@col96,@col97,@col98,@col99,@col100,@col101,@col102,@col103,@col104,@col105,@col106,@col107,@col108
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i44_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i44_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.TRANSREFEDGES
      (OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,NULL,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78,@col79,@col80,@col81,@col82,@col83,@col84,@col85,@col86,@col87,@col88,@col89,@col90,@col91,@col92,@col93,@col94,@col95,@col96,@col97,@col98,@col99,@col100,@col101,@col102,@col103,@col104,@col105,@col106,@col107,@col108 )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a44
      (OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,NULL,@current_state,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78,@col79,@col80,@col81,@col82,@col83,@col84,@col85,@col86,@col87,@col88,@col89,@col90,@col91,@col92,@col93,@col94,@col95,@col96,@col97,@col98,@col99,@col100,@col101,@col102,@col103,@col104,@col105,@col106,@col107,@col108 )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78,@col79,@col80,@col81,@col82,@col83,@col84,@col85,@col86,@col87,@col88,@col89,@col90,@col91,@col92,@col93,@col94,@col95,@col96,@col97,@col98,@col99,@col100,@col101,@col102,@col103,@col104,@col105,@col106,@col107,@col108
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 44) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 44, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v44_update]  ON [dbo].[TransRefEdges_evw] INSTEAD OF UPDATE AS 
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
 i.Enabled,
 i.PSRCEdgeID,
 i.FTRsegID,
 i.FacilityType,
 i.NewFacilityType,
 i.INode,
 i.JNode,
 i.InServiceDate,
 i.OutServiceDate,
 i.dateLastUpdated,
 i.ActiveLink,
 i.LinkType,
 i.FunctionalClass,
 i.Modes,
 i.MTS,
 i.CMSlinkID,
 i.CMScriticalLinkID,
 i.Oneway,
 i.Fullname,
 i.DateCreated,
 i.LastEditor,
 i.EditNotes,
 i.Tonnage,
 i.GlobalEID,
 i.Processing,
 i.CountID,
 i.CountyID,
 i.StateRoute,
 i.OldPSRCEdgeID,
 i.OSMID,
 i.OSMNetID,
 i.highway,
 i.OSM_Oneway,
 i.CorridorID,
 i.RegShared,
 i.FGTS,
 i.Source,
 i.GDB_GEOMATTR_DATA,
 i.GlobalID,
 i.PSRCEdgeID_1,
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
 i.PSRCE2_ID,
 i.dateLastUpdated_1,
 i.DateCreated_1,
 i.LastEditor_1,
 i.DataSource,
 i.Processing_1,
 i.BikeSigns,
 i.SidewalkSource,
 i.BikeEditorNotes,
 i.IJBikeFacility,
 i.JIBikeFacility,
 i.IJPedFacilities,
 i.JIPedFacilities,
 i.IJBikeType,
 i.JIBikeType,
 i.IJBikeFacilities,
 i.JIBikeFacilities,
 i.IJCorridorID,
 i.JICorridorID,
 i.Channelization,
 i.BikeSource_hold,
 i.BikeSource,
 i.PedBikeNotes,
 i.created_user,
 i.created_date,
 i.last_edited_user,
 i.last_edited_date
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_Enabled smallint
DECLARE @upd_PSRCEdgeID int
DECLARE @upd_FTRsegID int
DECLARE @upd_FacilityType int
DECLARE @upd_NewFacilityType int
DECLARE @upd_INode int
DECLARE @upd_JNode int
DECLARE @upd_InServiceDate smallint
DECLARE @upd_OutServiceDate smallint
DECLARE @upd_dateLastUpdated datetime2
DECLARE @upd_ActiveLink smallint
DECLARE @upd_LinkType smallint
DECLARE @upd_FunctionalClass int
DECLARE @upd_Modes nvarchar(50) 
DECLARE @upd_MTS int
DECLARE @upd_CMSlinkID int
DECLARE @upd_CMScriticalLinkID nvarchar(5) 
DECLARE @upd_Oneway int
DECLARE @upd_Fullname nvarchar(80) 
DECLARE @upd_DateCreated datetime2
DECLARE @upd_LastEditor nvarchar(50) 
DECLARE @upd_EditNotes nvarchar(256) 
DECLARE @upd_Tonnage nvarchar(25) 
DECLARE @upd_GlobalEID int
DECLARE @upd_Processing int
DECLARE @upd_CountID int
DECLARE @upd_CountyID smallint
DECLARE @upd_StateRoute int
DECLARE @upd_OldPSRCEdgeID int
DECLARE @upd_OSMID nvarchar(20) 
DECLARE @upd_OSMNetID int
DECLARE @upd_highway nvarchar(30) 
DECLARE @upd_OSM_Oneway nvarchar(50) 
DECLARE @upd_CorridorID int
DECLARE @upd_RegShared smallint
DECLARE @upd_FGTS smallint
DECLARE @upd_Source nvarchar(50) 
DECLARE @upd_GDB_GEOMATTR_DATA varbinary(max) 
DECLARE @upd_GlobalID uniqueidentifier
DECLARE @upd_PSRCEdgeID_1 int
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
DECLARE @upd_PSRCE2_ID int
DECLARE @upd_dateLastUpdated_1 datetime2
DECLARE @upd_DateCreated_1 datetime2
DECLARE @upd_LastEditor_1 nvarchar(50) 
DECLARE @upd_DataSource smallint
DECLARE @upd_Processing_1 int
DECLARE @upd_BikeSigns int
DECLARE @upd_SidewalkSource smallint
DECLARE @upd_BikeEditorNotes nvarchar(50) 
DECLARE @upd_IJBikeFacility int
DECLARE @upd_JIBikeFacility int
DECLARE @upd_IJPedFacilities int
DECLARE @upd_JIPedFacilities int
DECLARE @upd_IJBikeType int
DECLARE @upd_JIBikeType int
DECLARE @upd_IJBikeFacilities int
DECLARE @upd_JIBikeFacilities int
DECLARE @upd_IJCorridorID int
DECLARE @upd_JICorridorID int
DECLARE @upd_Channelization numeric(38,8) 
DECLARE @upd_BikeSource_hold nvarchar(50) 
DECLARE @upd_BikeSource smallint
DECLARE @upd_PedBikeNotes nvarchar(50) 
DECLARE @upd_created_user nvarchar(255) 
DECLARE @upd_created_date datetime2
DECLARE @upd_last_edited_user nvarchar(255) 
DECLARE @upd_last_edited_date datetime2
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @upd_GDB_GEOMATTR_DATA, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     IF @old_spatial_column IS NOT NULL AND NOT UPDATE(SHAPE)
INSERT INTO DBO.a44 (
OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
         VALUES(  @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date)

     ELSE
INSERT INTO DBO.a44 (
OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
          VALUES(  @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @new_spatial_column, NULL, @current_state, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date)

     INSERT INTO DBO.d44 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a44 SET Enabled = @upd_Enabled,PSRCEdgeID = @upd_PSRCEdgeID,FTRsegID = @upd_FTRsegID,FacilityType = @upd_FacilityType,NewFacilityType = @upd_NewFacilityType,INode = @upd_INode,JNode = @upd_JNode,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,dateLastUpdated = @upd_dateLastUpdated,ActiveLink = @upd_ActiveLink,LinkType = @upd_LinkType,FunctionalClass = @upd_FunctionalClass,Modes = @upd_Modes,MTS = @upd_MTS,CMSlinkID = @upd_CMSlinkID,CMScriticalLinkID = @upd_CMScriticalLinkID,Oneway = @upd_Oneway,Fullname = @upd_Fullname,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Tonnage = @upd_Tonnage,GlobalEID = @upd_GlobalEID,Processing = @upd_Processing,CountID = @upd_CountID,CountyID = @upd_CountyID,StateRoute = @upd_StateRoute,OldPSRCEdgeID = @upd_OldPSRCEdgeID,OSMID = @upd_OSMID,OSMNetID = @upd_OSMNetID,highway = @upd_highway,OSM_Oneway = @upd_OSM_Oneway,CorridorID = @upd_CorridorID,RegShared = @upd_RegShared,FGTS = @upd_FGTS,Source = @upd_Source,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL ,GlobalID = @upd_GlobalID,PSRCEdgeID_1 = @upd_PSRCEdgeID_1,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,PSRCE2_ID = @upd_PSRCE2_ID,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,DataSource = @upd_DataSource,Processing_1 = @upd_Processing_1,BikeSigns = @upd_BikeSigns,SidewalkSource = @upd_SidewalkSource,BikeEditorNotes = @upd_BikeEditorNotes,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJPedFacilities = @upd_IJPedFacilities,JIPedFacilities = @upd_JIPedFacilities,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType,IJBikeFacilities = @upd_IJBikeFacilities,JIBikeFacilities = @upd_JIBikeFacilities,IJCorridorID = @upd_IJCorridorID,JICorridorID = @upd_JICorridorID,Channelization = @upd_Channelization,BikeSource_hold = @upd_BikeSource_hold,BikeSource = @upd_BikeSource,PedBikeNotes = @upd_PedBikeNotes,created_user = @upd_created_user,created_date = @upd_created_date,last_edited_user = @upd_last_edited_user,last_edited_date = @upd_last_edited_date 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a44 SET Enabled = @upd_Enabled,PSRCEdgeID = @upd_PSRCEdgeID,FTRsegID = @upd_FTRsegID,FacilityType = @upd_FacilityType,NewFacilityType = @upd_NewFacilityType,INode = @upd_INode,JNode = @upd_JNode,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,dateLastUpdated = @upd_dateLastUpdated,ActiveLink = @upd_ActiveLink,LinkType = @upd_LinkType,FunctionalClass = @upd_FunctionalClass,Modes = @upd_Modes,MTS = @upd_MTS,CMSlinkID = @upd_CMSlinkID,CMScriticalLinkID = @upd_CMScriticalLinkID,Oneway = @upd_Oneway,Fullname = @upd_Fullname,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Tonnage = @upd_Tonnage,GlobalEID = @upd_GlobalEID,Processing = @upd_Processing,CountID = @upd_CountID,CountyID = @upd_CountyID,StateRoute = @upd_StateRoute,OldPSRCEdgeID = @upd_OldPSRCEdgeID,OSMID = @upd_OSMID,OSMNetID = @upd_OSMNetID,highway = @upd_highway,OSM_Oneway = @upd_OSM_Oneway,CorridorID = @upd_CorridorID,RegShared = @upd_RegShared,FGTS = @upd_FGTS,Source = @upd_Source,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA,GlobalID = @upd_GlobalID,PSRCEdgeID_1 = @upd_PSRCEdgeID_1,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,PSRCE2_ID = @upd_PSRCE2_ID,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,DataSource = @upd_DataSource,Processing_1 = @upd_Processing_1,BikeSigns = @upd_BikeSigns,SidewalkSource = @upd_SidewalkSource,BikeEditorNotes = @upd_BikeEditorNotes,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJPedFacilities = @upd_IJPedFacilities,JIPedFacilities = @upd_JIPedFacilities,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType,IJBikeFacilities = @upd_IJBikeFacilities,JIBikeFacilities = @upd_JIBikeFacilities,IJCorridorID = @upd_IJCorridorID,JICorridorID = @upd_JICorridorID,Channelization = @upd_Channelization,BikeSource_hold = @upd_BikeSource_hold,BikeSource = @upd_BikeSource,PedBikeNotes = @upd_PedBikeNotes,created_user = @upd_created_user,created_date = @upd_created_date,last_edited_user = @upd_last_edited_user,last_edited_date = @upd_last_edited_date 
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
           FROM DBO.d44 WITH (TABLOCKX,HOLDLOCK)
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
INSERT INTO DBO.a44 (
OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
         VALUES(  @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date)

     ELSE
INSERT INTO DBO.a44 (
OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
          VALUES(  @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @new_spatial_column, NULL, @current_state, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date)

        INSERT INTO DBO.d44 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.TRANSREFEDGES SET Enabled = @upd_Enabled,PSRCEdgeID = @upd_PSRCEdgeID,FTRsegID = @upd_FTRsegID,FacilityType = @upd_FacilityType,NewFacilityType = @upd_NewFacilityType,INode = @upd_INode,JNode = @upd_JNode,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,dateLastUpdated = @upd_dateLastUpdated,ActiveLink = @upd_ActiveLink,LinkType = @upd_LinkType,FunctionalClass = @upd_FunctionalClass,Modes = @upd_Modes,MTS = @upd_MTS,CMSlinkID = @upd_CMSlinkID,CMScriticalLinkID = @upd_CMScriticalLinkID,Oneway = @upd_Oneway,Fullname = @upd_Fullname,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Tonnage = @upd_Tonnage,GlobalEID = @upd_GlobalEID,Processing = @upd_Processing,CountID = @upd_CountID,CountyID = @upd_CountyID,StateRoute = @upd_StateRoute,OldPSRCEdgeID = @upd_OldPSRCEdgeID,OSMID = @upd_OSMID,OSMNetID = @upd_OSMNetID,highway = @upd_highway,OSM_Oneway = @upd_OSM_Oneway,CorridorID = @upd_CorridorID,RegShared = @upd_RegShared,FGTS = @upd_FGTS,Source = @upd_Source,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL ,GlobalID = @upd_GlobalID,PSRCEdgeID_1 = @upd_PSRCEdgeID_1,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,PSRCE2_ID = @upd_PSRCE2_ID,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,DataSource = @upd_DataSource,Processing_1 = @upd_Processing_1,BikeSigns = @upd_BikeSigns,SidewalkSource = @upd_SidewalkSource,BikeEditorNotes = @upd_BikeEditorNotes,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJPedFacilities = @upd_IJPedFacilities,JIPedFacilities = @upd_JIPedFacilities,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType,IJBikeFacilities = @upd_IJBikeFacilities,JIBikeFacilities = @upd_JIBikeFacilities,IJCorridorID = @upd_IJCorridorID,JICorridorID = @upd_JICorridorID,Channelization = @upd_Channelization,BikeSource_hold = @upd_BikeSource_hold,BikeSource = @upd_BikeSource,PedBikeNotes = @upd_PedBikeNotes,created_user = @upd_created_user,created_date = @upd_created_date,last_edited_user = @upd_last_edited_user,last_edited_date = @upd_last_edited_date 
WHERE OBJECTID = @old_row_id 
     ELSE
     UPDATE DBO.TRANSREFEDGES SET Enabled = @upd_Enabled,PSRCEdgeID = @upd_PSRCEdgeID,FTRsegID = @upd_FTRsegID,FacilityType = @upd_FacilityType,NewFacilityType = @upd_NewFacilityType,INode = @upd_INode,JNode = @upd_JNode,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,dateLastUpdated = @upd_dateLastUpdated,ActiveLink = @upd_ActiveLink,LinkType = @upd_LinkType,FunctionalClass = @upd_FunctionalClass,Modes = @upd_Modes,MTS = @upd_MTS,CMSlinkID = @upd_CMSlinkID,CMScriticalLinkID = @upd_CMScriticalLinkID,Oneway = @upd_Oneway,Fullname = @upd_Fullname,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Tonnage = @upd_Tonnage,GlobalEID = @upd_GlobalEID,Processing = @upd_Processing,CountID = @upd_CountID,CountyID = @upd_CountyID,StateRoute = @upd_StateRoute,OldPSRCEdgeID = @upd_OldPSRCEdgeID,OSMID = @upd_OSMID,OSMNetID = @upd_OSMNetID,highway = @upd_highway,OSM_Oneway = @upd_OSM_Oneway,CorridorID = @upd_CorridorID,RegShared = @upd_RegShared,FGTS = @upd_FGTS,Source = @upd_Source,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA,GlobalID = @upd_GlobalID,PSRCEdgeID_1 = @upd_PSRCEdgeID_1,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,PSRCE2_ID = @upd_PSRCE2_ID,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,DataSource = @upd_DataSource,Processing_1 = @upd_Processing_1,BikeSigns = @upd_BikeSigns,SidewalkSource = @upd_SidewalkSource,BikeEditorNotes = @upd_BikeEditorNotes,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJPedFacilities = @upd_IJPedFacilities,JIPedFacilities = @upd_JIPedFacilities,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType,IJBikeFacilities = @upd_IJBikeFacilities,JIBikeFacilities = @upd_JIBikeFacilities,IJCorridorID = @upd_IJCorridorID,JICorridorID = @upd_JICorridorID,Channelization = @upd_Channelization,BikeSource_hold = @upd_BikeSource_hold,BikeSource = @upd_BikeSource,PedBikeNotes = @upd_PedBikeNotes,created_user = @upd_created_user,created_date = @upd_created_date,last_edited_user = @upd_last_edited_user,last_edited_date = @upd_last_edited_date 
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
INSERT INTO DBO.a44 (
OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
         VALUES(  @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @new_spatial_column, @upd_GDB_GEOMATTR_DATA, @current_state, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date)

     ELSE
INSERT INTO DBO.a44 (
OBJECTID,Enabled,PSRCEdgeID,FTRsegID,FacilityType,NewFacilityType,INode,JNode,InServiceDate,OutServiceDate,dateLastUpdated,ActiveLink,LinkType,FunctionalClass,Modes,MTS,CMSlinkID,CMScriticalLinkID,Oneway,Fullname,DateCreated,LastEditor,EditNotes,Tonnage,GlobalEID,Processing,CountID,CountyID,StateRoute,OldPSRCEdgeID,OSMID,OSMNetID,highway,OSM_Oneway,CorridorID,RegShared,FGTS,Source,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,GlobalID,PSRCEdgeID_1,IJLanesGPAM,IJLanesGPMD,IJLanesGPPM,IJLanesGPEV,IJLanesGPNI,JILanesGPAM,JILanesGPMD,JILanesGPPM,JILanesGPEV,JILanesGPNI,IJlanesGPadjust,JIlanesGPadjust,IJLanesHOVAM,IJLanesHOVMD,IJLanesHOVPM,IJLanesHOVEV,IJLanesHOVNI,JILanesHOVAM,JILanesHOVMD,JILanesHOVPM,JILanesHOVEV,JILanesHOVNI,IJSpeedLimit,JISpeedLimit,IJVDFunc,JIVDFunc,IJLaneCapGP,IJLaneCapHOV,JILaneCapGP,JILaneCapHOV,IJSideWalks,JISideWalks,IJBikeLanes,JIBikeLanes,IJLanesTR,JILanesTR,IJLanesTK,JILanesTK,PSRCE2_ID,dateLastUpdated_1,DateCreated_1,LastEditor_1,DataSource,Processing_1,BikeSigns,SidewalkSource,BikeEditorNotes,IJBikeFacility,JIBikeFacility,IJPedFacilities,JIPedFacilities,IJBikeType,JIBikeType,IJBikeFacilities,JIBikeFacilities,IJCorridorID,JICorridorID,Channelization,BikeSource_hold,BikeSource,PedBikeNotes,created_user,created_date,last_edited_user,last_edited_date)
          VALUES(  @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @new_spatial_column, NULL, @current_state, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date)

        INSERT INTO DBO.d44 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.a44 SET Enabled = @upd_Enabled,PSRCEdgeID = @upd_PSRCEdgeID,FTRsegID = @upd_FTRsegID,FacilityType = @upd_FacilityType,NewFacilityType = @upd_NewFacilityType,INode = @upd_INode,JNode = @upd_JNode,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,dateLastUpdated = @upd_dateLastUpdated,ActiveLink = @upd_ActiveLink,LinkType = @upd_LinkType,FunctionalClass = @upd_FunctionalClass,Modes = @upd_Modes,MTS = @upd_MTS,CMSlinkID = @upd_CMSlinkID,CMScriticalLinkID = @upd_CMScriticalLinkID,Oneway = @upd_Oneway,Fullname = @upd_Fullname,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Tonnage = @upd_Tonnage,GlobalEID = @upd_GlobalEID,Processing = @upd_Processing,CountID = @upd_CountID,CountyID = @upd_CountyID,StateRoute = @upd_StateRoute,OldPSRCEdgeID = @upd_OldPSRCEdgeID,OSMID = @upd_OSMID,OSMNetID = @upd_OSMNetID,highway = @upd_highway,OSM_Oneway = @upd_OSM_Oneway,CorridorID = @upd_CorridorID,RegShared = @upd_RegShared,FGTS = @upd_FGTS,Source = @upd_Source,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = NULL ,GlobalID = @upd_GlobalID,PSRCEdgeID_1 = @upd_PSRCEdgeID_1,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,PSRCE2_ID = @upd_PSRCE2_ID,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,DataSource = @upd_DataSource,Processing_1 = @upd_Processing_1,BikeSigns = @upd_BikeSigns,SidewalkSource = @upd_SidewalkSource,BikeEditorNotes = @upd_BikeEditorNotes,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJPedFacilities = @upd_IJPedFacilities,JIPedFacilities = @upd_JIPedFacilities,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType,IJBikeFacilities = @upd_IJBikeFacilities,JIBikeFacilities = @upd_JIBikeFacilities,IJCorridorID = @upd_IJCorridorID,JICorridorID = @upd_JICorridorID,Channelization = @upd_Channelization,BikeSource_hold = @upd_BikeSource_hold,BikeSource = @upd_BikeSource,PedBikeNotes = @upd_PedBikeNotes,created_user = @upd_created_user,created_date = @upd_created_date,last_edited_user = @upd_last_edited_user,last_edited_date = @upd_last_edited_date 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.a44 SET Enabled = @upd_Enabled,PSRCEdgeID = @upd_PSRCEdgeID,FTRsegID = @upd_FTRsegID,FacilityType = @upd_FacilityType,NewFacilityType = @upd_NewFacilityType,INode = @upd_INode,JNode = @upd_JNode,InServiceDate = @upd_InServiceDate,OutServiceDate = @upd_OutServiceDate,dateLastUpdated = @upd_dateLastUpdated,ActiveLink = @upd_ActiveLink,LinkType = @upd_LinkType,FunctionalClass = @upd_FunctionalClass,Modes = @upd_Modes,MTS = @upd_MTS,CMSlinkID = @upd_CMSlinkID,CMScriticalLinkID = @upd_CMScriticalLinkID,Oneway = @upd_Oneway,Fullname = @upd_Fullname,DateCreated = @upd_DateCreated,LastEditor = @upd_LastEditor,EditNotes = @upd_EditNotes,Tonnage = @upd_Tonnage,GlobalEID = @upd_GlobalEID,Processing = @upd_Processing,CountID = @upd_CountID,CountyID = @upd_CountyID,StateRoute = @upd_StateRoute,OldPSRCEdgeID = @upd_OldPSRCEdgeID,OSMID = @upd_OSMID,OSMNetID = @upd_OSMNetID,highway = @upd_highway,OSM_Oneway = @upd_OSM_Oneway,CorridorID = @upd_CorridorID,RegShared = @upd_RegShared,FGTS = @upd_FGTS,Source = @upd_Source,Shape = @new_spatial_column,GDB_GEOMATTR_DATA = @upd_GDB_GEOMATTR_DATA,GlobalID = @upd_GlobalID,PSRCEdgeID_1 = @upd_PSRCEdgeID_1,IJLanesGPAM = @upd_IJLanesGPAM,IJLanesGPMD = @upd_IJLanesGPMD,IJLanesGPPM = @upd_IJLanesGPPM,IJLanesGPEV = @upd_IJLanesGPEV,IJLanesGPNI = @upd_IJLanesGPNI,JILanesGPAM = @upd_JILanesGPAM,JILanesGPMD = @upd_JILanesGPMD,JILanesGPPM = @upd_JILanesGPPM,JILanesGPEV = @upd_JILanesGPEV,JILanesGPNI = @upd_JILanesGPNI,IJlanesGPadjust = @upd_IJlanesGPadjust,JIlanesGPadjust = @upd_JIlanesGPadjust,IJLanesHOVAM = @upd_IJLanesHOVAM,IJLanesHOVMD = @upd_IJLanesHOVMD,IJLanesHOVPM = @upd_IJLanesHOVPM,IJLanesHOVEV = @upd_IJLanesHOVEV,IJLanesHOVNI = @upd_IJLanesHOVNI,JILanesHOVAM = @upd_JILanesHOVAM,JILanesHOVMD = @upd_JILanesHOVMD,JILanesHOVPM = @upd_JILanesHOVPM,JILanesHOVEV = @upd_JILanesHOVEV,JILanesHOVNI = @upd_JILanesHOVNI,IJSpeedLimit = @upd_IJSpeedLimit,JISpeedLimit = @upd_JISpeedLimit,IJVDFunc = @upd_IJVDFunc,JIVDFunc = @upd_JIVDFunc,IJLaneCapGP = @upd_IJLaneCapGP,IJLaneCapHOV = @upd_IJLaneCapHOV,JILaneCapGP = @upd_JILaneCapGP,JILaneCapHOV = @upd_JILaneCapHOV,IJSideWalks = @upd_IJSideWalks,JISideWalks = @upd_JISideWalks,IJBikeLanes = @upd_IJBikeLanes,JIBikeLanes = @upd_JIBikeLanes,IJLanesTR = @upd_IJLanesTR,JILanesTR = @upd_JILanesTR,IJLanesTK = @upd_IJLanesTK,JILanesTK = @upd_JILanesTK,PSRCE2_ID = @upd_PSRCE2_ID,dateLastUpdated_1 = @upd_dateLastUpdated_1,DateCreated_1 = @upd_DateCreated_1,LastEditor_1 = @upd_LastEditor_1,DataSource = @upd_DataSource,Processing_1 = @upd_Processing_1,BikeSigns = @upd_BikeSigns,SidewalkSource = @upd_SidewalkSource,BikeEditorNotes = @upd_BikeEditorNotes,IJBikeFacility = @upd_IJBikeFacility,JIBikeFacility = @upd_JIBikeFacility,IJPedFacilities = @upd_IJPedFacilities,JIPedFacilities = @upd_JIPedFacilities,IJBikeType = @upd_IJBikeType,JIBikeType = @upd_JIBikeType,IJBikeFacilities = @upd_IJBikeFacilities,JIBikeFacilities = @upd_JIBikeFacilities,IJCorridorID = @upd_IJCorridorID,JICorridorID = @upd_JICorridorID,Channelization = @upd_Channelization,BikeSource_hold = @upd_BikeSource_hold,BikeSource = @upd_BikeSource,PedBikeNotes = @upd_PedBikeNotes,created_user = @upd_created_user,created_date = @upd_created_date,last_edited_user = @upd_last_edited_user,last_edited_date = @upd_last_edited_date 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state

      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column, @upd_OBJECTID, @upd_Enabled, @upd_PSRCEdgeID, @upd_FTRsegID, @upd_FacilityType, @upd_NewFacilityType, @upd_INode, @upd_JNode, @upd_InServiceDate, @upd_OutServiceDate, @upd_dateLastUpdated, @upd_ActiveLink, @upd_LinkType, @upd_FunctionalClass, @upd_Modes, @upd_MTS, @upd_CMSlinkID, @upd_CMScriticalLinkID, @upd_Oneway, @upd_Fullname, @upd_DateCreated, @upd_LastEditor, @upd_EditNotes, @upd_Tonnage, @upd_GlobalEID, @upd_Processing, @upd_CountID, @upd_CountyID, @upd_StateRoute, @upd_OldPSRCEdgeID, @upd_OSMID, @upd_OSMNetID, @upd_highway, @upd_OSM_Oneway, @upd_CorridorID, @upd_RegShared, @upd_FGTS, @upd_Source, @upd_GDB_GEOMATTR_DATA, @upd_GlobalID, @upd_PSRCEdgeID_1, @upd_IJLanesGPAM, @upd_IJLanesGPMD, @upd_IJLanesGPPM, @upd_IJLanesGPEV, @upd_IJLanesGPNI, @upd_JILanesGPAM, @upd_JILanesGPMD, @upd_JILanesGPPM, @upd_JILanesGPEV, @upd_JILanesGPNI, @upd_IJlanesGPadjust, @upd_JIlanesGPadjust, @upd_IJLanesHOVAM, @upd_IJLanesHOVMD, @upd_IJLanesHOVPM, @upd_IJLanesHOVEV, @upd_IJLanesHOVNI, @upd_JILanesHOVAM, @upd_JILanesHOVMD, @upd_JILanesHOVPM, @upd_JILanesHOVEV, @upd_JILanesHOVNI, @upd_IJSpeedLimit, @upd_JISpeedLimit, @upd_IJVDFunc, @upd_JIVDFunc, @upd_IJLaneCapGP, @upd_IJLaneCapHOV, @upd_JILaneCapGP, @upd_JILaneCapHOV, @upd_IJSideWalks, @upd_JISideWalks, @upd_IJBikeLanes, @upd_JIBikeLanes, @upd_IJLanesTR, @upd_JILanesTR, @upd_IJLanesTK, @upd_JILanesTK, @upd_PSRCE2_ID, @upd_dateLastUpdated_1, @upd_DateCreated_1, @upd_LastEditor_1, @upd_DataSource, @upd_Processing_1, @upd_BikeSigns, @upd_SidewalkSource, @upd_BikeEditorNotes, @upd_IJBikeFacility, @upd_JIBikeFacility, @upd_IJPedFacilities, @upd_JIPedFacilities, @upd_IJBikeType, @upd_JIBikeType, @upd_IJBikeFacilities, @upd_JIBikeFacilities, @upd_IJCorridorID, @upd_JICorridorID, @upd_Channelization, @upd_BikeSource_hold, @upd_BikeSource, @upd_PedBikeNotes, @upd_created_user, @upd_created_date, @upd_last_edited_user, @upd_last_edited_date
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 44) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 44, @current_state
END
GO
