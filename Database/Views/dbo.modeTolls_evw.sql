SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[modeTolls_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.PSRCEdgeID,b.IJtollSOVAM,b.IJtollSOVMD,b.IJtollSOVPM,b.IJtollSOVEV,b.IJtollSOVNI,b.JItollSOVAM,b.JItollSOVMD,b.JItollSOVPM,b.JItollSOVEV,b.JItollSOVNI,b.IJtollHOV2AM,b.IJtollHOV2MD,b.IJtollHOV2PM,b.IJtollHOV2EV,b.IJtollHOV2NI,b.JItollHOV2AM,b.JItollHOV2MD,b.JItollHOV2PM,b.JItollHOV2EV,b.JItollHOV2NI,b.IJtollHOV3AM,b.IJtollHOV3MD,b.IJtollHOV3PM,b.IJtollHOV3EV,b.IJtollHOV3NI,b.JItollHOV3AM,b.JItollHOV3MD,b.JItollHOV3PM,b.JItollHOV3EV,b.JItollHOV3NI,b.IJtollTrkLtAM,b.IJtollTrkLtMD,b.IJtollTrkLtPM,b.IJtollTrkLtEV,b.IJtollTrkLtNI,b.JItollTrkLtAM,b.JItollTrkLtMD,b.JItollTrkLtPM,b.JItollTrkLtEV,b.JItollTrkLtNI,b.IJtollTrkMedAM,b.IJtollTrkMedMD,b.IJtollTrkMedPM,b.IJtollTrkMedEV,b.IJtollTrkMedNI,b.JItollTrkMedAM,b.JItollTrkMedMD,b.JItollTrkMedPM,b.JItollTrkMedEV,b.JItollTrkMedNI,b.IJtollTrkHvyAM,b.IJtollTrkHvyMD,b.IJtollTrkHvyPM,b.IJtollTrkHvyEV,b.IJtollTrkHvyNI,b.JItollTrkHvyAM,b.JItollTrkHvyMD,b.JItollTrkHvyPM,b.JItollTrkHvyEV,b.JItollTrkHvyNI,b.IJcostAddlAM,b.IJcostAddlMD,b.IJcostAddlPM,b.IJcostAddlEV,b.IJcostAddlNI,b.JIcostAddlAM,b.JIcostAddlMD,b.JIcostAddlPM,b.JIcostAddlEV,b.JIcostAddlNI,b.DateCreated,b.DateLastUpdated,b.LastEditor,b.Processing,b.InServiceDate,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.MODETOLLS b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d15 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.PSRCEdgeID,a.IJtollSOVAM,a.IJtollSOVMD,a.IJtollSOVPM,a.IJtollSOVEV,a.IJtollSOVNI,a.JItollSOVAM,a.JItollSOVMD,a.JItollSOVPM,a.JItollSOVEV,a.JItollSOVNI,a.IJtollHOV2AM,a.IJtollHOV2MD,a.IJtollHOV2PM,a.IJtollHOV2EV,a.IJtollHOV2NI,a.JItollHOV2AM,a.JItollHOV2MD,a.JItollHOV2PM,a.JItollHOV2EV,a.JItollHOV2NI,a.IJtollHOV3AM,a.IJtollHOV3MD,a.IJtollHOV3PM,a.IJtollHOV3EV,a.IJtollHOV3NI,a.JItollHOV3AM,a.JItollHOV3MD,a.JItollHOV3PM,a.JItollHOV3EV,a.JItollHOV3NI,a.IJtollTrkLtAM,a.IJtollTrkLtMD,a.IJtollTrkLtPM,a.IJtollTrkLtEV,a.IJtollTrkLtNI,a.JItollTrkLtAM,a.JItollTrkLtMD,a.JItollTrkLtPM,a.JItollTrkLtEV,a.JItollTrkLtNI,a.IJtollTrkMedAM,a.IJtollTrkMedMD,a.IJtollTrkMedPM,a.IJtollTrkMedEV,a.IJtollTrkMedNI,a.JItollTrkMedAM,a.JItollTrkMedMD,a.JItollTrkMedPM,a.JItollTrkMedEV,a.JItollTrkMedNI,a.IJtollTrkHvyAM,a.IJtollTrkHvyMD,a.IJtollTrkHvyPM,a.IJtollTrkHvyEV,a.IJtollTrkHvyNI,a.JItollTrkHvyAM,a.JItollTrkHvyMD,a.JItollTrkHvyPM,a.JItollTrkHvyEV,a.JItollTrkHvyNI,a.IJcostAddlAM,a.IJcostAddlMD,a.IJcostAddlPM,a.IJcostAddlEV,a.IJcostAddlNI,a.JIcostAddlAM,a.JIcostAddlMD,a.JIcostAddlPM,a.JIcostAddlEV,a.JIcostAddlNI,a.DateCreated,a.DateLastUpdated,a.LastEditor,a.Processing,a.InServiceDate,a.SDE_STATE_ID FROM DBO.a15 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d15 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v15_delete]  ON [dbo].[modeTolls_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d15 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a15 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d15 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d15 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.MODETOLLS WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d15 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d15 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a15
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 15) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 15, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v15_insert] ON [dbo].[modeTolls_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i15_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i15_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.MODETOLLS
  (OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate)
  SELECT 
  @next_row_id,i.PSRCEdgeID,i.IJtollSOVAM,i.IJtollSOVMD,i.IJtollSOVPM,i.IJtollSOVEV,i.IJtollSOVNI,i.JItollSOVAM,i.JItollSOVMD,i.JItollSOVPM,i.JItollSOVEV,i.JItollSOVNI,i.IJtollHOV2AM,i.IJtollHOV2MD,i.IJtollHOV2PM,i.IJtollHOV2EV,i.IJtollHOV2NI,i.JItollHOV2AM,i.JItollHOV2MD,i.JItollHOV2PM,i.JItollHOV2EV,i.JItollHOV2NI,i.IJtollHOV3AM,i.IJtollHOV3MD,i.IJtollHOV3PM,i.IJtollHOV3EV,i.IJtollHOV3NI,i.JItollHOV3AM,i.JItollHOV3MD,i.JItollHOV3PM,i.JItollHOV3EV,i.JItollHOV3NI,i.IJtollTrkLtAM,i.IJtollTrkLtMD,i.IJtollTrkLtPM,i.IJtollTrkLtEV,i.IJtollTrkLtNI,i.JItollTrkLtAM,i.JItollTrkLtMD,i.JItollTrkLtPM,i.JItollTrkLtEV,i.JItollTrkLtNI,i.IJtollTrkMedAM,i.IJtollTrkMedMD,i.IJtollTrkMedPM,i.IJtollTrkMedEV,i.IJtollTrkMedNI,i.JItollTrkMedAM,i.JItollTrkMedMD,i.JItollTrkMedPM,i.JItollTrkMedEV,i.JItollTrkMedNI,i.IJtollTrkHvyAM,i.IJtollTrkHvyMD,i.IJtollTrkHvyPM,i.IJtollTrkHvyEV,i.IJtollTrkHvyNI,i.JItollTrkHvyAM,i.JItollTrkHvyMD,i.JItollTrkHvyPM,i.JItollTrkHvyEV,i.JItollTrkHvyNI,i.IJcostAddlAM,i.IJcostAddlMD,i.IJcostAddlPM,i.IJcostAddlEV,i.IJcostAddlNI,i.JIcostAddlAM,i.JIcostAddlMD,i.JIcostAddlPM,i.JIcostAddlEV,i.JIcostAddlNI,i.DateCreated,i.DateLastUpdated,i.LastEditor,i.Processing,i.InServiceDate  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a15
  (OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.PSRCEdgeID,i.IJtollSOVAM,i.IJtollSOVMD,i.IJtollSOVPM,i.IJtollSOVEV,i.IJtollSOVNI,i.JItollSOVAM,i.JItollSOVMD,i.JItollSOVPM,i.JItollSOVEV,i.JItollSOVNI,i.IJtollHOV2AM,i.IJtollHOV2MD,i.IJtollHOV2PM,i.IJtollHOV2EV,i.IJtollHOV2NI,i.JItollHOV2AM,i.JItollHOV2MD,i.JItollHOV2PM,i.JItollHOV2EV,i.JItollHOV2NI,i.IJtollHOV3AM,i.IJtollHOV3MD,i.IJtollHOV3PM,i.IJtollHOV3EV,i.IJtollHOV3NI,i.JItollHOV3AM,i.JItollHOV3MD,i.JItollHOV3PM,i.JItollHOV3EV,i.JItollHOV3NI,i.IJtollTrkLtAM,i.IJtollTrkLtMD,i.IJtollTrkLtPM,i.IJtollTrkLtEV,i.IJtollTrkLtNI,i.JItollTrkLtAM,i.JItollTrkLtMD,i.JItollTrkLtPM,i.JItollTrkLtEV,i.JItollTrkLtNI,i.IJtollTrkMedAM,i.IJtollTrkMedMD,i.IJtollTrkMedPM,i.IJtollTrkMedEV,i.IJtollTrkMedNI,i.JItollTrkMedAM,i.JItollTrkMedMD,i.JItollTrkMedPM,i.JItollTrkMedEV,i.JItollTrkMedNI,i.IJtollTrkHvyAM,i.IJtollTrkHvyMD,i.IJtollTrkHvyPM,i.IJtollTrkHvyEV,i.IJtollTrkHvyNI,i.JItollTrkHvyAM,i.JItollTrkHvyMD,i.JItollTrkHvyPM,i.JItollTrkHvyEV,i.JItollTrkHvyNI,i.IJcostAddlAM,i.IJcostAddlMD,i.IJcostAddlPM,i.IJcostAddlEV,i.IJcostAddlNI,i.JIcostAddlAM,i.JIcostAddlMD,i.JIcostAddlPM,i.JIcostAddlEV,i.JIcostAddlNI,i.DateCreated,i.DateLastUpdated,i.LastEditor,i.Processing,i.InServiceDate,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate,SDE_STATE_ID
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 int
  DECLARE @col3 int
  DECLARE @col4 int
  DECLARE @col5 int
  DECLARE @col6 int
  DECLARE @col7 int
  DECLARE @col8 int
  DECLARE @col9 int
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
  DECLARE @col20 int
  DECLARE @col21 int
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
  DECLARE @col70 int
  DECLARE @col71 int
  DECLARE @col72 int
  DECLARE @col73 datetime2
  DECLARE @col74 datetime2
  DECLARE @col75 nvarchar(50) 
  DECLARE @col76 int
  DECLARE @col77 int
  DECLARE @col78 bigint
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i15_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i15_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.MODETOLLS
      (OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77 )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a15
      (OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate,SDE_STATE_ID)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@current_state )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62,@col63,@col64,@col65,@col66,@col67,@col68,@col69,@col70,@col71,@col72,@col73,@col74,@col75,@col76,@col77,@col78
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 15) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 15, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v15_update]  ON [dbo].[modeTolls_evw] INSTEAD OF UPDATE AS 
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
 i.PSRCEdgeID,
 i.IJtollSOVAM,
 i.IJtollSOVMD,
 i.IJtollSOVPM,
 i.IJtollSOVEV,
 i.IJtollSOVNI,
 i.JItollSOVAM,
 i.JItollSOVMD,
 i.JItollSOVPM,
 i.JItollSOVEV,
 i.JItollSOVNI,
 i.IJtollHOV2AM,
 i.IJtollHOV2MD,
 i.IJtollHOV2PM,
 i.IJtollHOV2EV,
 i.IJtollHOV2NI,
 i.JItollHOV2AM,
 i.JItollHOV2MD,
 i.JItollHOV2PM,
 i.JItollHOV2EV,
 i.JItollHOV2NI,
 i.IJtollHOV3AM,
 i.IJtollHOV3MD,
 i.IJtollHOV3PM,
 i.IJtollHOV3EV,
 i.IJtollHOV3NI,
 i.JItollHOV3AM,
 i.JItollHOV3MD,
 i.JItollHOV3PM,
 i.JItollHOV3EV,
 i.JItollHOV3NI,
 i.IJtollTrkLtAM,
 i.IJtollTrkLtMD,
 i.IJtollTrkLtPM,
 i.IJtollTrkLtEV,
 i.IJtollTrkLtNI,
 i.JItollTrkLtAM,
 i.JItollTrkLtMD,
 i.JItollTrkLtPM,
 i.JItollTrkLtEV,
 i.JItollTrkLtNI,
 i.IJtollTrkMedAM,
 i.IJtollTrkMedMD,
 i.IJtollTrkMedPM,
 i.IJtollTrkMedEV,
 i.IJtollTrkMedNI,
 i.JItollTrkMedAM,
 i.JItollTrkMedMD,
 i.JItollTrkMedPM,
 i.JItollTrkMedEV,
 i.JItollTrkMedNI,
 i.IJtollTrkHvyAM,
 i.IJtollTrkHvyMD,
 i.IJtollTrkHvyPM,
 i.IJtollTrkHvyEV,
 i.IJtollTrkHvyNI,
 i.JItollTrkHvyAM,
 i.JItollTrkHvyMD,
 i.JItollTrkHvyPM,
 i.JItollTrkHvyEV,
 i.JItollTrkHvyNI,
 i.IJcostAddlAM,
 i.IJcostAddlMD,
 i.IJcostAddlPM,
 i.IJcostAddlEV,
 i.IJcostAddlNI,
 i.JIcostAddlAM,
 i.JIcostAddlMD,
 i.JIcostAddlPM,
 i.JIcostAddlEV,
 i.JIcostAddlNI,
 i.DateCreated,
 i.DateLastUpdated,
 i.LastEditor,
 i.Processing,
 i.InServiceDate
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_PSRCEdgeID int
DECLARE @upd_IJtollSOVAM int
DECLARE @upd_IJtollSOVMD int
DECLARE @upd_IJtollSOVPM int
DECLARE @upd_IJtollSOVEV int
DECLARE @upd_IJtollSOVNI int
DECLARE @upd_JItollSOVAM int
DECLARE @upd_JItollSOVMD int
DECLARE @upd_JItollSOVPM int
DECLARE @upd_JItollSOVEV int
DECLARE @upd_JItollSOVNI int
DECLARE @upd_IJtollHOV2AM int
DECLARE @upd_IJtollHOV2MD int
DECLARE @upd_IJtollHOV2PM int
DECLARE @upd_IJtollHOV2EV int
DECLARE @upd_IJtollHOV2NI int
DECLARE @upd_JItollHOV2AM int
DECLARE @upd_JItollHOV2MD int
DECLARE @upd_JItollHOV2PM int
DECLARE @upd_JItollHOV2EV int
DECLARE @upd_JItollHOV2NI int
DECLARE @upd_IJtollHOV3AM int
DECLARE @upd_IJtollHOV3MD int
DECLARE @upd_IJtollHOV3PM int
DECLARE @upd_IJtollHOV3EV int
DECLARE @upd_IJtollHOV3NI int
DECLARE @upd_JItollHOV3AM int
DECLARE @upd_JItollHOV3MD int
DECLARE @upd_JItollHOV3PM int
DECLARE @upd_JItollHOV3EV int
DECLARE @upd_JItollHOV3NI int
DECLARE @upd_IJtollTrkLtAM int
DECLARE @upd_IJtollTrkLtMD int
DECLARE @upd_IJtollTrkLtPM int
DECLARE @upd_IJtollTrkLtEV int
DECLARE @upd_IJtollTrkLtNI int
DECLARE @upd_JItollTrkLtAM int
DECLARE @upd_JItollTrkLtMD int
DECLARE @upd_JItollTrkLtPM int
DECLARE @upd_JItollTrkLtEV int
DECLARE @upd_JItollTrkLtNI int
DECLARE @upd_IJtollTrkMedAM int
DECLARE @upd_IJtollTrkMedMD int
DECLARE @upd_IJtollTrkMedPM int
DECLARE @upd_IJtollTrkMedEV int
DECLARE @upd_IJtollTrkMedNI int
DECLARE @upd_JItollTrkMedAM int
DECLARE @upd_JItollTrkMedMD int
DECLARE @upd_JItollTrkMedPM int
DECLARE @upd_JItollTrkMedEV int
DECLARE @upd_JItollTrkMedNI int
DECLARE @upd_IJtollTrkHvyAM int
DECLARE @upd_IJtollTrkHvyMD int
DECLARE @upd_IJtollTrkHvyPM int
DECLARE @upd_IJtollTrkHvyEV int
DECLARE @upd_IJtollTrkHvyNI int
DECLARE @upd_JItollTrkHvyAM int
DECLARE @upd_JItollTrkHvyMD int
DECLARE @upd_JItollTrkHvyPM int
DECLARE @upd_JItollTrkHvyEV int
DECLARE @upd_JItollTrkHvyNI int
DECLARE @upd_IJcostAddlAM int
DECLARE @upd_IJcostAddlMD int
DECLARE @upd_IJcostAddlPM int
DECLARE @upd_IJcostAddlEV int
DECLARE @upd_IJcostAddlNI int
DECLARE @upd_JIcostAddlAM int
DECLARE @upd_JIcostAddlMD int
DECLARE @upd_JIcostAddlPM int
DECLARE @upd_JIcostAddlEV int
DECLARE @upd_JIcostAddlNI int
DECLARE @upd_DateCreated datetime2
DECLARE @upd_DateLastUpdated datetime2
DECLARE @upd_LastEditor nvarchar(50) 
DECLARE @upd_Processing int
DECLARE @upd_InServiceDate int
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_PSRCEdgeID, @upd_IJtollSOVAM, @upd_IJtollSOVMD, @upd_IJtollSOVPM, @upd_IJtollSOVEV, @upd_IJtollSOVNI, @upd_JItollSOVAM, @upd_JItollSOVMD, @upd_JItollSOVPM, @upd_JItollSOVEV, @upd_JItollSOVNI, @upd_IJtollHOV2AM, @upd_IJtollHOV2MD, @upd_IJtollHOV2PM, @upd_IJtollHOV2EV, @upd_IJtollHOV2NI, @upd_JItollHOV2AM, @upd_JItollHOV2MD, @upd_JItollHOV2PM, @upd_JItollHOV2EV, @upd_JItollHOV2NI, @upd_IJtollHOV3AM, @upd_IJtollHOV3MD, @upd_IJtollHOV3PM, @upd_IJtollHOV3EV, @upd_IJtollHOV3NI, @upd_JItollHOV3AM, @upd_JItollHOV3MD, @upd_JItollHOV3PM, @upd_JItollHOV3EV, @upd_JItollHOV3NI, @upd_IJtollTrkLtAM, @upd_IJtollTrkLtMD, @upd_IJtollTrkLtPM, @upd_IJtollTrkLtEV, @upd_IJtollTrkLtNI, @upd_JItollTrkLtAM, @upd_JItollTrkLtMD, @upd_JItollTrkLtPM, @upd_JItollTrkLtEV, @upd_JItollTrkLtNI, @upd_IJtollTrkMedAM, @upd_IJtollTrkMedMD, @upd_IJtollTrkMedPM, @upd_IJtollTrkMedEV, @upd_IJtollTrkMedNI, @upd_JItollTrkMedAM, @upd_JItollTrkMedMD, @upd_JItollTrkMedPM, @upd_JItollTrkMedEV, @upd_JItollTrkMedNI, @upd_IJtollTrkHvyAM, @upd_IJtollTrkHvyMD, @upd_IJtollTrkHvyPM, @upd_IJtollTrkHvyEV, @upd_IJtollTrkHvyNI, @upd_JItollTrkHvyAM, @upd_JItollTrkHvyMD, @upd_JItollTrkHvyPM, @upd_JItollTrkHvyEV, @upd_JItollTrkHvyNI, @upd_IJcostAddlAM, @upd_IJcostAddlMD, @upd_IJcostAddlPM, @upd_IJcostAddlEV, @upd_IJcostAddlNI, @upd_JIcostAddlAM, @upd_JIcostAddlMD, @upd_JIcostAddlPM, @upd_JIcostAddlEV, @upd_JIcostAddlNI, @upd_DateCreated, @upd_DateLastUpdated, @upd_LastEditor, @upd_Processing, @upd_InServiceDate
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     INSERT INTO DBO.a15 (
OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_PSRCEdgeID, @upd_IJtollSOVAM, @upd_IJtollSOVMD, @upd_IJtollSOVPM, @upd_IJtollSOVEV, @upd_IJtollSOVNI, @upd_JItollSOVAM, @upd_JItollSOVMD, @upd_JItollSOVPM, @upd_JItollSOVEV, @upd_JItollSOVNI, @upd_IJtollHOV2AM, @upd_IJtollHOV2MD, @upd_IJtollHOV2PM, @upd_IJtollHOV2EV, @upd_IJtollHOV2NI, @upd_JItollHOV2AM, @upd_JItollHOV2MD, @upd_JItollHOV2PM, @upd_JItollHOV2EV, @upd_JItollHOV2NI, @upd_IJtollHOV3AM, @upd_IJtollHOV3MD, @upd_IJtollHOV3PM, @upd_IJtollHOV3EV, @upd_IJtollHOV3NI, @upd_JItollHOV3AM, @upd_JItollHOV3MD, @upd_JItollHOV3PM, @upd_JItollHOV3EV, @upd_JItollHOV3NI, @upd_IJtollTrkLtAM, @upd_IJtollTrkLtMD, @upd_IJtollTrkLtPM, @upd_IJtollTrkLtEV, @upd_IJtollTrkLtNI, @upd_JItollTrkLtAM, @upd_JItollTrkLtMD, @upd_JItollTrkLtPM, @upd_JItollTrkLtEV, @upd_JItollTrkLtNI, @upd_IJtollTrkMedAM, @upd_IJtollTrkMedMD, @upd_IJtollTrkMedPM, @upd_IJtollTrkMedEV, @upd_IJtollTrkMedNI, @upd_JItollTrkMedAM, @upd_JItollTrkMedMD, @upd_JItollTrkMedPM, @upd_JItollTrkMedEV, @upd_JItollTrkMedNI, @upd_IJtollTrkHvyAM, @upd_IJtollTrkHvyMD, @upd_IJtollTrkHvyPM, @upd_IJtollTrkHvyEV, @upd_IJtollTrkHvyNI, @upd_JItollTrkHvyAM, @upd_JItollTrkHvyMD, @upd_JItollTrkHvyPM, @upd_JItollTrkHvyEV, @upd_JItollTrkHvyNI, @upd_IJcostAddlAM, @upd_IJcostAddlMD, @upd_IJcostAddlPM, @upd_IJcostAddlEV, @upd_IJcostAddlNI, @upd_JIcostAddlAM, @upd_JIcostAddlMD, @upd_JIcostAddlPM, @upd_JIcostAddlEV, @upd_JIcostAddlNI, @upd_DateCreated, @upd_DateLastUpdated, @upd_LastEditor, @upd_Processing, @upd_InServiceDate, @current_state)

     INSERT INTO DBO.d15 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     UPDATE DBO.a15 SET PSRCEdgeID = @upd_PSRCEdgeID,IJtollSOVAM = @upd_IJtollSOVAM,IJtollSOVMD = @upd_IJtollSOVMD,IJtollSOVPM = @upd_IJtollSOVPM,IJtollSOVEV = @upd_IJtollSOVEV,IJtollSOVNI = @upd_IJtollSOVNI,JItollSOVAM = @upd_JItollSOVAM,JItollSOVMD = @upd_JItollSOVMD,JItollSOVPM = @upd_JItollSOVPM,JItollSOVEV = @upd_JItollSOVEV,JItollSOVNI = @upd_JItollSOVNI,IJtollHOV2AM = @upd_IJtollHOV2AM,IJtollHOV2MD = @upd_IJtollHOV2MD,IJtollHOV2PM = @upd_IJtollHOV2PM,IJtollHOV2EV = @upd_IJtollHOV2EV,IJtollHOV2NI = @upd_IJtollHOV2NI,JItollHOV2AM = @upd_JItollHOV2AM,JItollHOV2MD = @upd_JItollHOV2MD,JItollHOV2PM = @upd_JItollHOV2PM,JItollHOV2EV = @upd_JItollHOV2EV,JItollHOV2NI = @upd_JItollHOV2NI,IJtollHOV3AM = @upd_IJtollHOV3AM,IJtollHOV3MD = @upd_IJtollHOV3MD,IJtollHOV3PM = @upd_IJtollHOV3PM,IJtollHOV3EV = @upd_IJtollHOV3EV,IJtollHOV3NI = @upd_IJtollHOV3NI,JItollHOV3AM = @upd_JItollHOV3AM,JItollHOV3MD = @upd_JItollHOV3MD,JItollHOV3PM = @upd_JItollHOV3PM,JItollHOV3EV = @upd_JItollHOV3EV,JItollHOV3NI = @upd_JItollHOV3NI,IJtollTrkLtAM = @upd_IJtollTrkLtAM,IJtollTrkLtMD = @upd_IJtollTrkLtMD,IJtollTrkLtPM = @upd_IJtollTrkLtPM,IJtollTrkLtEV = @upd_IJtollTrkLtEV,IJtollTrkLtNI = @upd_IJtollTrkLtNI,JItollTrkLtAM = @upd_JItollTrkLtAM,JItollTrkLtMD = @upd_JItollTrkLtMD,JItollTrkLtPM = @upd_JItollTrkLtPM,JItollTrkLtEV = @upd_JItollTrkLtEV,JItollTrkLtNI = @upd_JItollTrkLtNI,IJtollTrkMedAM = @upd_IJtollTrkMedAM,IJtollTrkMedMD = @upd_IJtollTrkMedMD,IJtollTrkMedPM = @upd_IJtollTrkMedPM,IJtollTrkMedEV = @upd_IJtollTrkMedEV,IJtollTrkMedNI = @upd_IJtollTrkMedNI,JItollTrkMedAM = @upd_JItollTrkMedAM,JItollTrkMedMD = @upd_JItollTrkMedMD,JItollTrkMedPM = @upd_JItollTrkMedPM,JItollTrkMedEV = @upd_JItollTrkMedEV,JItollTrkMedNI = @upd_JItollTrkMedNI,IJtollTrkHvyAM = @upd_IJtollTrkHvyAM,IJtollTrkHvyMD = @upd_IJtollTrkHvyMD,IJtollTrkHvyPM = @upd_IJtollTrkHvyPM,IJtollTrkHvyEV = @upd_IJtollTrkHvyEV,IJtollTrkHvyNI = @upd_IJtollTrkHvyNI,JItollTrkHvyAM = @upd_JItollTrkHvyAM,JItollTrkHvyMD = @upd_JItollTrkHvyMD,JItollTrkHvyPM = @upd_JItollTrkHvyPM,JItollTrkHvyEV = @upd_JItollTrkHvyEV,JItollTrkHvyNI = @upd_JItollTrkHvyNI,IJcostAddlAM = @upd_IJcostAddlAM,IJcostAddlMD = @upd_IJcostAddlMD,IJcostAddlPM = @upd_IJcostAddlPM,IJcostAddlEV = @upd_IJcostAddlEV,IJcostAddlNI = @upd_IJcostAddlNI,JIcostAddlAM = @upd_JIcostAddlAM,JIcostAddlMD = @upd_JIcostAddlMD,JIcostAddlPM = @upd_JIcostAddlPM,JIcostAddlEV = @upd_JIcostAddlEV,JIcostAddlNI = @upd_JIcostAddlNI,DateCreated = @upd_DateCreated,DateLastUpdated = @upd_DateLastUpdated,LastEditor = @upd_LastEditor,Processing = @upd_Processing,InServiceDate = @upd_InServiceDate 
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
           FROM DBO.d15 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.a15 (
OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_PSRCEdgeID, @upd_IJtollSOVAM, @upd_IJtollSOVMD, @upd_IJtollSOVPM, @upd_IJtollSOVEV, @upd_IJtollSOVNI, @upd_JItollSOVAM, @upd_JItollSOVMD, @upd_JItollSOVPM, @upd_JItollSOVEV, @upd_JItollSOVNI, @upd_IJtollHOV2AM, @upd_IJtollHOV2MD, @upd_IJtollHOV2PM, @upd_IJtollHOV2EV, @upd_IJtollHOV2NI, @upd_JItollHOV2AM, @upd_JItollHOV2MD, @upd_JItollHOV2PM, @upd_JItollHOV2EV, @upd_JItollHOV2NI, @upd_IJtollHOV3AM, @upd_IJtollHOV3MD, @upd_IJtollHOV3PM, @upd_IJtollHOV3EV, @upd_IJtollHOV3NI, @upd_JItollHOV3AM, @upd_JItollHOV3MD, @upd_JItollHOV3PM, @upd_JItollHOV3EV, @upd_JItollHOV3NI, @upd_IJtollTrkLtAM, @upd_IJtollTrkLtMD, @upd_IJtollTrkLtPM, @upd_IJtollTrkLtEV, @upd_IJtollTrkLtNI, @upd_JItollTrkLtAM, @upd_JItollTrkLtMD, @upd_JItollTrkLtPM, @upd_JItollTrkLtEV, @upd_JItollTrkLtNI, @upd_IJtollTrkMedAM, @upd_IJtollTrkMedMD, @upd_IJtollTrkMedPM, @upd_IJtollTrkMedEV, @upd_IJtollTrkMedNI, @upd_JItollTrkMedAM, @upd_JItollTrkMedMD, @upd_JItollTrkMedPM, @upd_JItollTrkMedEV, @upd_JItollTrkMedNI, @upd_IJtollTrkHvyAM, @upd_IJtollTrkHvyMD, @upd_IJtollTrkHvyPM, @upd_IJtollTrkHvyEV, @upd_IJtollTrkHvyNI, @upd_JItollTrkHvyAM, @upd_JItollTrkHvyMD, @upd_JItollTrkHvyPM, @upd_JItollTrkHvyEV, @upd_JItollTrkHvyNI, @upd_IJcostAddlAM, @upd_IJcostAddlMD, @upd_IJcostAddlPM, @upd_IJcostAddlEV, @upd_IJcostAddlNI, @upd_JIcostAddlAM, @upd_JIcostAddlMD, @upd_JIcostAddlPM, @upd_JIcostAddlEV, @upd_JIcostAddlNI, @upd_DateCreated, @upd_DateLastUpdated, @upd_LastEditor, @upd_Processing, @upd_InServiceDate, @current_state)

        INSERT INTO DBO.d15 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.MODETOLLS SET PSRCEdgeID = @upd_PSRCEdgeID,IJtollSOVAM = @upd_IJtollSOVAM,IJtollSOVMD = @upd_IJtollSOVMD,IJtollSOVPM = @upd_IJtollSOVPM,IJtollSOVEV = @upd_IJtollSOVEV,IJtollSOVNI = @upd_IJtollSOVNI,JItollSOVAM = @upd_JItollSOVAM,JItollSOVMD = @upd_JItollSOVMD,JItollSOVPM = @upd_JItollSOVPM,JItollSOVEV = @upd_JItollSOVEV,JItollSOVNI = @upd_JItollSOVNI,IJtollHOV2AM = @upd_IJtollHOV2AM,IJtollHOV2MD = @upd_IJtollHOV2MD,IJtollHOV2PM = @upd_IJtollHOV2PM,IJtollHOV2EV = @upd_IJtollHOV2EV,IJtollHOV2NI = @upd_IJtollHOV2NI,JItollHOV2AM = @upd_JItollHOV2AM,JItollHOV2MD = @upd_JItollHOV2MD,JItollHOV2PM = @upd_JItollHOV2PM,JItollHOV2EV = @upd_JItollHOV2EV,JItollHOV2NI = @upd_JItollHOV2NI,IJtollHOV3AM = @upd_IJtollHOV3AM,IJtollHOV3MD = @upd_IJtollHOV3MD,IJtollHOV3PM = @upd_IJtollHOV3PM,IJtollHOV3EV = @upd_IJtollHOV3EV,IJtollHOV3NI = @upd_IJtollHOV3NI,JItollHOV3AM = @upd_JItollHOV3AM,JItollHOV3MD = @upd_JItollHOV3MD,JItollHOV3PM = @upd_JItollHOV3PM,JItollHOV3EV = @upd_JItollHOV3EV,JItollHOV3NI = @upd_JItollHOV3NI,IJtollTrkLtAM = @upd_IJtollTrkLtAM,IJtollTrkLtMD = @upd_IJtollTrkLtMD,IJtollTrkLtPM = @upd_IJtollTrkLtPM,IJtollTrkLtEV = @upd_IJtollTrkLtEV,IJtollTrkLtNI = @upd_IJtollTrkLtNI,JItollTrkLtAM = @upd_JItollTrkLtAM,JItollTrkLtMD = @upd_JItollTrkLtMD,JItollTrkLtPM = @upd_JItollTrkLtPM,JItollTrkLtEV = @upd_JItollTrkLtEV,JItollTrkLtNI = @upd_JItollTrkLtNI,IJtollTrkMedAM = @upd_IJtollTrkMedAM,IJtollTrkMedMD = @upd_IJtollTrkMedMD,IJtollTrkMedPM = @upd_IJtollTrkMedPM,IJtollTrkMedEV = @upd_IJtollTrkMedEV,IJtollTrkMedNI = @upd_IJtollTrkMedNI,JItollTrkMedAM = @upd_JItollTrkMedAM,JItollTrkMedMD = @upd_JItollTrkMedMD,JItollTrkMedPM = @upd_JItollTrkMedPM,JItollTrkMedEV = @upd_JItollTrkMedEV,JItollTrkMedNI = @upd_JItollTrkMedNI,IJtollTrkHvyAM = @upd_IJtollTrkHvyAM,IJtollTrkHvyMD = @upd_IJtollTrkHvyMD,IJtollTrkHvyPM = @upd_IJtollTrkHvyPM,IJtollTrkHvyEV = @upd_IJtollTrkHvyEV,IJtollTrkHvyNI = @upd_IJtollTrkHvyNI,JItollTrkHvyAM = @upd_JItollTrkHvyAM,JItollTrkHvyMD = @upd_JItollTrkHvyMD,JItollTrkHvyPM = @upd_JItollTrkHvyPM,JItollTrkHvyEV = @upd_JItollTrkHvyEV,JItollTrkHvyNI = @upd_JItollTrkHvyNI,IJcostAddlAM = @upd_IJcostAddlAM,IJcostAddlMD = @upd_IJcostAddlMD,IJcostAddlPM = @upd_IJcostAddlPM,IJcostAddlEV = @upd_IJcostAddlEV,IJcostAddlNI = @upd_IJcostAddlNI,JIcostAddlAM = @upd_JIcostAddlAM,JIcostAddlMD = @upd_JIcostAddlMD,JIcostAddlPM = @upd_JIcostAddlPM,JIcostAddlEV = @upd_JIcostAddlEV,JIcostAddlNI = @upd_JIcostAddlNI,DateCreated = @upd_DateCreated,DateLastUpdated = @upd_DateLastUpdated,LastEditor = @upd_LastEditor,Processing = @upd_Processing,InServiceDate = @upd_InServiceDate 
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
        INSERT INTO DBO.a15 (
OBJECTID,PSRCEdgeID,IJtollSOVAM,IJtollSOVMD,IJtollSOVPM,IJtollSOVEV,IJtollSOVNI,JItollSOVAM,JItollSOVMD,JItollSOVPM,JItollSOVEV,JItollSOVNI,IJtollHOV2AM,IJtollHOV2MD,IJtollHOV2PM,IJtollHOV2EV,IJtollHOV2NI,JItollHOV2AM,JItollHOV2MD,JItollHOV2PM,JItollHOV2EV,JItollHOV2NI,IJtollHOV3AM,IJtollHOV3MD,IJtollHOV3PM,IJtollHOV3EV,IJtollHOV3NI,JItollHOV3AM,JItollHOV3MD,JItollHOV3PM,JItollHOV3EV,JItollHOV3NI,IJtollTrkLtAM,IJtollTrkLtMD,IJtollTrkLtPM,IJtollTrkLtEV,IJtollTrkLtNI,JItollTrkLtAM,JItollTrkLtMD,JItollTrkLtPM,JItollTrkLtEV,JItollTrkLtNI,IJtollTrkMedAM,IJtollTrkMedMD,IJtollTrkMedPM,IJtollTrkMedEV,IJtollTrkMedNI,JItollTrkMedAM,JItollTrkMedMD,JItollTrkMedPM,JItollTrkMedEV,JItollTrkMedNI,IJtollTrkHvyAM,IJtollTrkHvyMD,IJtollTrkHvyPM,IJtollTrkHvyEV,IJtollTrkHvyNI,JItollTrkHvyAM,JItollTrkHvyMD,JItollTrkHvyPM,JItollTrkHvyEV,JItollTrkHvyNI,IJcostAddlAM,IJcostAddlMD,IJcostAddlPM,IJcostAddlEV,IJcostAddlNI,JIcostAddlAM,JIcostAddlMD,JIcostAddlPM,JIcostAddlEV,JIcostAddlNI,DateCreated,DateLastUpdated,LastEditor,Processing,InServiceDate,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_PSRCEdgeID, @upd_IJtollSOVAM, @upd_IJtollSOVMD, @upd_IJtollSOVPM, @upd_IJtollSOVEV, @upd_IJtollSOVNI, @upd_JItollSOVAM, @upd_JItollSOVMD, @upd_JItollSOVPM, @upd_JItollSOVEV, @upd_JItollSOVNI, @upd_IJtollHOV2AM, @upd_IJtollHOV2MD, @upd_IJtollHOV2PM, @upd_IJtollHOV2EV, @upd_IJtollHOV2NI, @upd_JItollHOV2AM, @upd_JItollHOV2MD, @upd_JItollHOV2PM, @upd_JItollHOV2EV, @upd_JItollHOV2NI, @upd_IJtollHOV3AM, @upd_IJtollHOV3MD, @upd_IJtollHOV3PM, @upd_IJtollHOV3EV, @upd_IJtollHOV3NI, @upd_JItollHOV3AM, @upd_JItollHOV3MD, @upd_JItollHOV3PM, @upd_JItollHOV3EV, @upd_JItollHOV3NI, @upd_IJtollTrkLtAM, @upd_IJtollTrkLtMD, @upd_IJtollTrkLtPM, @upd_IJtollTrkLtEV, @upd_IJtollTrkLtNI, @upd_JItollTrkLtAM, @upd_JItollTrkLtMD, @upd_JItollTrkLtPM, @upd_JItollTrkLtEV, @upd_JItollTrkLtNI, @upd_IJtollTrkMedAM, @upd_IJtollTrkMedMD, @upd_IJtollTrkMedPM, @upd_IJtollTrkMedEV, @upd_IJtollTrkMedNI, @upd_JItollTrkMedAM, @upd_JItollTrkMedMD, @upd_JItollTrkMedPM, @upd_JItollTrkMedEV, @upd_JItollTrkMedNI, @upd_IJtollTrkHvyAM, @upd_IJtollTrkHvyMD, @upd_IJtollTrkHvyPM, @upd_IJtollTrkHvyEV, @upd_IJtollTrkHvyNI, @upd_JItollTrkHvyAM, @upd_JItollTrkHvyMD, @upd_JItollTrkHvyPM, @upd_JItollTrkHvyEV, @upd_JItollTrkHvyNI, @upd_IJcostAddlAM, @upd_IJcostAddlMD, @upd_IJcostAddlPM, @upd_IJcostAddlEV, @upd_IJcostAddlNI, @upd_JIcostAddlAM, @upd_JIcostAddlMD, @upd_JIcostAddlPM, @upd_JIcostAddlEV, @upd_JIcostAddlNI, @upd_DateCreated, @upd_DateLastUpdated, @upd_LastEditor, @upd_Processing, @upd_InServiceDate, @current_state)

        INSERT INTO DBO.d15 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.a15 SET PSRCEdgeID = @upd_PSRCEdgeID,IJtollSOVAM = @upd_IJtollSOVAM,IJtollSOVMD = @upd_IJtollSOVMD,IJtollSOVPM = @upd_IJtollSOVPM,IJtollSOVEV = @upd_IJtollSOVEV,IJtollSOVNI = @upd_IJtollSOVNI,JItollSOVAM = @upd_JItollSOVAM,JItollSOVMD = @upd_JItollSOVMD,JItollSOVPM = @upd_JItollSOVPM,JItollSOVEV = @upd_JItollSOVEV,JItollSOVNI = @upd_JItollSOVNI,IJtollHOV2AM = @upd_IJtollHOV2AM,IJtollHOV2MD = @upd_IJtollHOV2MD,IJtollHOV2PM = @upd_IJtollHOV2PM,IJtollHOV2EV = @upd_IJtollHOV2EV,IJtollHOV2NI = @upd_IJtollHOV2NI,JItollHOV2AM = @upd_JItollHOV2AM,JItollHOV2MD = @upd_JItollHOV2MD,JItollHOV2PM = @upd_JItollHOV2PM,JItollHOV2EV = @upd_JItollHOV2EV,JItollHOV2NI = @upd_JItollHOV2NI,IJtollHOV3AM = @upd_IJtollHOV3AM,IJtollHOV3MD = @upd_IJtollHOV3MD,IJtollHOV3PM = @upd_IJtollHOV3PM,IJtollHOV3EV = @upd_IJtollHOV3EV,IJtollHOV3NI = @upd_IJtollHOV3NI,JItollHOV3AM = @upd_JItollHOV3AM,JItollHOV3MD = @upd_JItollHOV3MD,JItollHOV3PM = @upd_JItollHOV3PM,JItollHOV3EV = @upd_JItollHOV3EV,JItollHOV3NI = @upd_JItollHOV3NI,IJtollTrkLtAM = @upd_IJtollTrkLtAM,IJtollTrkLtMD = @upd_IJtollTrkLtMD,IJtollTrkLtPM = @upd_IJtollTrkLtPM,IJtollTrkLtEV = @upd_IJtollTrkLtEV,IJtollTrkLtNI = @upd_IJtollTrkLtNI,JItollTrkLtAM = @upd_JItollTrkLtAM,JItollTrkLtMD = @upd_JItollTrkLtMD,JItollTrkLtPM = @upd_JItollTrkLtPM,JItollTrkLtEV = @upd_JItollTrkLtEV,JItollTrkLtNI = @upd_JItollTrkLtNI,IJtollTrkMedAM = @upd_IJtollTrkMedAM,IJtollTrkMedMD = @upd_IJtollTrkMedMD,IJtollTrkMedPM = @upd_IJtollTrkMedPM,IJtollTrkMedEV = @upd_IJtollTrkMedEV,IJtollTrkMedNI = @upd_IJtollTrkMedNI,JItollTrkMedAM = @upd_JItollTrkMedAM,JItollTrkMedMD = @upd_JItollTrkMedMD,JItollTrkMedPM = @upd_JItollTrkMedPM,JItollTrkMedEV = @upd_JItollTrkMedEV,JItollTrkMedNI = @upd_JItollTrkMedNI,IJtollTrkHvyAM = @upd_IJtollTrkHvyAM,IJtollTrkHvyMD = @upd_IJtollTrkHvyMD,IJtollTrkHvyPM = @upd_IJtollTrkHvyPM,IJtollTrkHvyEV = @upd_IJtollTrkHvyEV,IJtollTrkHvyNI = @upd_IJtollTrkHvyNI,JItollTrkHvyAM = @upd_JItollTrkHvyAM,JItollTrkHvyMD = @upd_JItollTrkHvyMD,JItollTrkHvyPM = @upd_JItollTrkHvyPM,JItollTrkHvyEV = @upd_JItollTrkHvyEV,JItollTrkHvyNI = @upd_JItollTrkHvyNI,IJcostAddlAM = @upd_IJcostAddlAM,IJcostAddlMD = @upd_IJcostAddlMD,IJcostAddlPM = @upd_IJcostAddlPM,IJcostAddlEV = @upd_IJcostAddlEV,IJcostAddlNI = @upd_IJcostAddlNI,JIcostAddlAM = @upd_JIcostAddlAM,JIcostAddlMD = @upd_JIcostAddlMD,JIcostAddlPM = @upd_JIcostAddlPM,JIcostAddlEV = @upd_JIcostAddlEV,JIcostAddlNI = @upd_JIcostAddlNI,DateCreated = @upd_DateCreated,DateLastUpdated = @upd_DateLastUpdated,LastEditor = @upd_LastEditor,Processing = @upd_Processing,InServiceDate = @upd_InServiceDate 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_PSRCEdgeID, @upd_IJtollSOVAM, @upd_IJtollSOVMD, @upd_IJtollSOVPM, @upd_IJtollSOVEV, @upd_IJtollSOVNI, @upd_JItollSOVAM, @upd_JItollSOVMD, @upd_JItollSOVPM, @upd_JItollSOVEV, @upd_JItollSOVNI, @upd_IJtollHOV2AM, @upd_IJtollHOV2MD, @upd_IJtollHOV2PM, @upd_IJtollHOV2EV, @upd_IJtollHOV2NI, @upd_JItollHOV2AM, @upd_JItollHOV2MD, @upd_JItollHOV2PM, @upd_JItollHOV2EV, @upd_JItollHOV2NI, @upd_IJtollHOV3AM, @upd_IJtollHOV3MD, @upd_IJtollHOV3PM, @upd_IJtollHOV3EV, @upd_IJtollHOV3NI, @upd_JItollHOV3AM, @upd_JItollHOV3MD, @upd_JItollHOV3PM, @upd_JItollHOV3EV, @upd_JItollHOV3NI, @upd_IJtollTrkLtAM, @upd_IJtollTrkLtMD, @upd_IJtollTrkLtPM, @upd_IJtollTrkLtEV, @upd_IJtollTrkLtNI, @upd_JItollTrkLtAM, @upd_JItollTrkLtMD, @upd_JItollTrkLtPM, @upd_JItollTrkLtEV, @upd_JItollTrkLtNI, @upd_IJtollTrkMedAM, @upd_IJtollTrkMedMD, @upd_IJtollTrkMedPM, @upd_IJtollTrkMedEV, @upd_IJtollTrkMedNI, @upd_JItollTrkMedAM, @upd_JItollTrkMedMD, @upd_JItollTrkMedPM, @upd_JItollTrkMedEV, @upd_JItollTrkMedNI, @upd_IJtollTrkHvyAM, @upd_IJtollTrkHvyMD, @upd_IJtollTrkHvyPM, @upd_IJtollTrkHvyEV, @upd_IJtollTrkHvyNI, @upd_JItollTrkHvyAM, @upd_JItollTrkHvyMD, @upd_JItollTrkHvyPM, @upd_JItollTrkHvyEV, @upd_JItollTrkHvyNI, @upd_IJcostAddlAM, @upd_IJcostAddlMD, @upd_IJcostAddlPM, @upd_IJcostAddlEV, @upd_IJcostAddlNI, @upd_JIcostAddlAM, @upd_JIcostAddlMD, @upd_JIcostAddlPM, @upd_JIcostAddlEV, @upd_JIcostAddlNI, @upd_DateCreated, @upd_DateLastUpdated, @upd_LastEditor, @upd_Processing, @upd_InServiceDate
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 15) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 15, @current_state
END
GO
