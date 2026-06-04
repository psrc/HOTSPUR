SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TransitLines_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.LineID,b.TimePeriod,b.TransLineNo,b.Mode,b.VehicleType,b.Headway,b.Speed,b.Operator,b.InServiceDate,b.OutServiceDate,b.Seats,b.CapacityVehicles,b.ProjID,b.ProjDBS,b.Path,b.dateLastUpdated,b.DateCreated,b.LastEditor,b.EditNotes,b.Processing,b.Enabled,b.UL2,b.Headway_AM,b.Headway_MD,b.Headway_PM,b.Headway_EV,b.Headway_NI,b.light_rail,b.TransitType,b.RouteID,b.RepTripID,b.Description,b.created_user,b.created_date,b.last_edited_user,b.last_edited_date,b.Version,b.frequent,b.Shape,b.GDB_GEOMATTR_DATA,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.TRANSITLINES b LEFT HASH JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d42 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.LineID,a.TimePeriod,a.TransLineNo,a.Mode,a.VehicleType,a.Headway,a.Speed,a.Operator,a.InServiceDate,a.OutServiceDate,a.Seats,a.CapacityVehicles,a.ProjID,a.ProjDBS,a.Path,a.dateLastUpdated,a.DateCreated,a.LastEditor,a.EditNotes,a.Processing,a.Enabled,a.UL2,a.Headway_AM,a.Headway_MD,a.Headway_PM,a.Headway_EV,a.Headway_NI,a.light_rail,a.TransitType,a.RouteID,a.RepTripID,a.Description,a.created_user,a.created_date,a.last_edited_user,a.last_edited_date,a.Version,a.frequent,a.Shape,a.GDB_GEOMATTR_DATA,a.SDE_STATE_ID FROM DBO.a42 a LEFT HASH JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d42 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER LOOP JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v42_delete]  ON [dbo].[TransitLines_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d42 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a42 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d42 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d42 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TRANSITLINES WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d42 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d42 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a42
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 42) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 42, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v42_insert] ON [dbo].[TransitLines_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i42_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i42_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TRANSITLINES
  (OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA)
  SELECT 
  @next_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,NULL  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a42
  (OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,NULL,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
CREATE TABLE #temp42(
OBJECTID int
,LineID int
,TimePeriod smallint
,TransLineNo nvarchar(25) 
,Mode nvarchar(25) 
,VehicleType smallint
,Headway numeric(6,2) 
,Speed numeric(5,2) 
,Operator smallint
,InServiceDate smallint
,OutServiceDate smallint
,Seats smallint
,CapacityVehicles smallint
,ProjID nvarchar(25) 
,ProjDBS nvarchar(10) 
,Path smallint
,dateLastUpdated datetime2
,DateCreated datetime2
,LastEditor nvarchar(25) 
,EditNotes nvarchar(256) 
,Processing int
,Enabled smallint
,UL2 smallint
,Headway_AM numeric(38,8) 
,Headway_MD numeric(38,8) 
,Headway_PM numeric(38,8) 
,Headway_EV numeric(38,8) 
,Headway_NI numeric(38,8) 
,light_rail smallint
,TransitType smallint
,RouteID nvarchar(50) 
,RepTripID nvarchar(50) 
,Description nvarchar(50) 
,created_user nvarchar(255) 
,created_date datetime2
,last_edited_user nvarchar(255) 
,last_edited_date datetime2
,Version int
,frequent smallint
,Shape geometry
,GDB_GEOMATTR_DATA varbinary(max) 
)
INSERT INTO #temp42(
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA) SELECT 
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA FROM inserted
DECLARE ins_cursor CURSOR FOR SELECT OBJECTID FROM #temp42 FOR UPDATE OF OBJECTID
OPEN ins_cursor
DECLARE @rowid INTEGER
FETCH NEXT FROM ins_cursor INTO @rowid
WHILE @@FETCH_STATUS = 0
BEGIN
    EXECUTE DBO.i42_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i42_return_ids 2, @return_row_id, @num_return_ids
    END
  UPDATE #temp42 SET OBJECTID = @next_row_id WHERE CURRENT OF ins_cursor
  FETCH NEXT FROM ins_cursor INTO @rowid
END
  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

IF @current_state = 0
BEGIN
INSERT INTO DBO.TRANSITLINES(
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA) SELECT 
t.OBJECTID,t.LineID,t.TimePeriod,t.TransLineNo,t.Mode,t.VehicleType,t.Headway,t.Speed,t.Operator,t.InServiceDate,t.OutServiceDate,t.Seats,t.CapacityVehicles,t.ProjID,t.ProjDBS,t.Path,t.dateLastUpdated,t.DateCreated,t.LastEditor,t.EditNotes,t.Processing,t.Enabled,t.UL2,t.Headway_AM,t.Headway_MD,t.Headway_PM,t.Headway_EV,t.Headway_NI,t.light_rail,t.TransitType,t.RouteID,t.RepTripID,t.Description,t.created_user,t.created_date,t.last_edited_user,t.last_edited_date,t.Version,t.frequent,t.Shape,t.GDB_GEOMATTR_DATA FROM #temp42 t 
END
ELSE
BEGIN
INSERT INTO DBO.a42(
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID) SELECT 
t.OBJECTID,t.LineID,t.TimePeriod,t.TransLineNo,t.Mode,t.VehicleType,t.Headway,t.Speed,t.Operator,t.InServiceDate,t.OutServiceDate,t.Seats,t.CapacityVehicles,t.ProjID,t.ProjDBS,t.Path,t.dateLastUpdated,t.DateCreated,t.LastEditor,t.EditNotes,t.Processing,t.Enabled,t.UL2,t.Headway_AM,t.Headway_MD,t.Headway_PM,t.Headway_EV,t.Headway_NI,t.light_rail,t.TransitType,t.RouteID,t.RepTripID,t.Description,t.created_user,t.created_date,t.last_edited_user,t.last_edited_date,t.Version,t.frequent,t.Shape,t.GDB_GEOMATTR_DATA,@current_state FROM #temp42 t 
END
CLOSE ins_cursor
DEALLOCATE ins_cursor
DROP TABLE #temp42
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 42) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 42, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v42_update]  ON [dbo].[TransitLines_evw] INSTEAD OF UPDATE AS 
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
INSERT INTO DBO.a42 (
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

     ELSE
INSERT INTO DBO.a42 (
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

    INSERT INTO DBO.d42 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.A42 SET LineID = i.LineID,TimePeriod = i.TimePeriod,TransLineNo = i.TransLineNo,Mode = i.Mode,VehicleType = i.VehicleType,Headway = i.Headway,Speed = i.Speed,Operator = i.Operator,InServiceDate = i.InServiceDate,OutServiceDate = i.OutServiceDate,Seats = i.Seats,CapacityVehicles = i.CapacityVehicles,ProjID = i.ProjID,ProjDBS = i.ProjDBS,Path = i.Path,dateLastUpdated = i.dateLastUpdated,DateCreated = i.DateCreated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,UL2 = i.UL2,Headway_AM = i.Headway_AM,Headway_MD = i.Headway_MD,Headway_PM = i.Headway_PM,Headway_EV = i.Headway_EV,Headway_NI = i.Headway_NI,light_rail = i.light_rail,TransitType = i.TransitType,RouteID = i.RouteID,RepTripID = i.RepTripID,Description = i.Description,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Version = i.Version,frequent = i.frequent,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.A42  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OBJECTID = @old_row_id AND a.SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.A42 SET LineID = i.LineID,TimePeriod = i.TimePeriod,TransLineNo = i.TransLineNo,Mode = i.Mode,VehicleType = i.VehicleType,Headway = i.Headway,Speed = i.Speed,Operator = i.Operator,InServiceDate = i.InServiceDate,OutServiceDate = i.OutServiceDate,Seats = i.Seats,CapacityVehicles = i.CapacityVehicles,ProjID = i.ProjID,ProjDBS = i.ProjDBS,Path = i.Path,dateLastUpdated = i.dateLastUpdated,DateCreated = i.DateCreated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,UL2 = i.UL2,Headway_AM = i.Headway_AM,Headway_MD = i.Headway_MD,Headway_PM = i.Headway_PM,Headway_EV = i.Headway_EV,Headway_NI = i.Headway_NI,light_rail = i.light_rail,TransitType = i.TransitType,RouteID = i.RouteID,RepTripID = i.RepTripID,Description = i.Description,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Version = i.Version,frequent = i.frequent,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.A42  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
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
           FROM DBO.d42 WITH (TABLOCKX,HOLDLOCK)
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
INSERT INTO DBO.a42 (
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

     ELSE
INSERT INTO DBO.a42 (
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

        INSERT INTO DBO.d42 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.TRANSITLINES SET LineID = i.LineID,TimePeriod = i.TimePeriod,TransLineNo = i.TransLineNo,Mode = i.Mode,VehicleType = i.VehicleType,Headway = i.Headway,Speed = i.Speed,Operator = i.Operator,InServiceDate = i.InServiceDate,OutServiceDate = i.OutServiceDate,Seats = i.Seats,CapacityVehicles = i.CapacityVehicles,ProjID = i.ProjID,ProjDBS = i.ProjDBS,Path = i.Path,dateLastUpdated = i.dateLastUpdated,DateCreated = i.DateCreated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,UL2 = i.UL2,Headway_AM = i.Headway_AM,Headway_MD = i.Headway_MD,Headway_PM = i.Headway_PM,Headway_EV = i.Headway_EV,Headway_NI = i.Headway_NI,light_rail = i.light_rail,TransitType = i.TransitType,RouteID = i.RouteID,RepTripID = i.RepTripID,Description = i.Description,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Version = i.Version,frequent = i.frequent,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.TRANSITLINES  b INNER JOIN inserted i  ON (b.OBJECTID = i.OBJECTID) 
     WHERE b.OBJECTID = @old_row_id 
     ELSE
     UPDATE DBO.TRANSITLINES SET LineID = i.LineID,TimePeriod = i.TimePeriod,TransLineNo = i.TransLineNo,Mode = i.Mode,VehicleType = i.VehicleType,Headway = i.Headway,Speed = i.Speed,Operator = i.Operator,InServiceDate = i.InServiceDate,OutServiceDate = i.OutServiceDate,Seats = i.Seats,CapacityVehicles = i.CapacityVehicles,ProjID = i.ProjID,ProjDBS = i.ProjDBS,Path = i.Path,dateLastUpdated = i.dateLastUpdated,DateCreated = i.DateCreated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,UL2 = i.UL2,Headway_AM = i.Headway_AM,Headway_MD = i.Headway_MD,Headway_PM = i.Headway_PM,Headway_EV = i.Headway_EV,Headway_NI = i.Headway_NI,light_rail = i.light_rail,TransitType = i.TransitType,RouteID = i.RouteID,RepTripID = i.RepTripID,Description = i.Description,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Version = i.Version,frequent = i.frequent,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.TRANSITLINES  b INNER JOIN inserted i  ON (b.OBJECTID = i.OBJECTID) 
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
INSERT INTO DBO.a42 (
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,i.GDB_GEOMATTR_DATA,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

     ELSE
INSERT INTO DBO.a42 (
OBJECTID,LineID,TimePeriod,TransLineNo,Mode,VehicleType,Headway,Speed,Operator,InServiceDate,OutServiceDate,Seats,CapacityVehicles,ProjID,ProjDBS,Path,dateLastUpdated,DateCreated,LastEditor,EditNotes,Processing,Enabled,UL2,Headway_AM,Headway_MD,Headway_PM,Headway_EV,Headway_NI,light_rail,TransitType,RouteID,RepTripID,Description,created_user,created_date,last_edited_user,last_edited_date,Version,frequent,Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID)
        SELECT @old_row_id,i.LineID,i.TimePeriod,i.TransLineNo,i.Mode,i.VehicleType,i.Headway,i.Speed,i.Operator,i.InServiceDate,i.OutServiceDate,i.Seats,i.CapacityVehicles,i.ProjID,i.ProjDBS,i.Path,i.dateLastUpdated,i.DateCreated,i.LastEditor,i.EditNotes,i.Processing,i.Enabled,i.UL2,i.Headway_AM,i.Headway_MD,i.Headway_PM,i.Headway_EV,i.Headway_NI,i.light_rail,i.TransitType,i.RouteID,i.RepTripID,i.Description,i.created_user,i.created_date,i.last_edited_user,i.last_edited_date,i.Version,i.frequent,i.Shape,NULL,@current_state  FROM inserted i WHERE i.OBJECTID = @new_row_id

        INSERT INTO DBO.d42 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        IF @old_spatial_column IS NOT NULL AND UPDATE(SHAPE)
UPDATE DBO.A42 SET LineID = i.LineID,TimePeriod = i.TimePeriod,TransLineNo = i.TransLineNo,Mode = i.Mode,VehicleType = i.VehicleType,Headway = i.Headway,Speed = i.Speed,Operator = i.Operator,InServiceDate = i.InServiceDate,OutServiceDate = i.OutServiceDate,Seats = i.Seats,CapacityVehicles = i.CapacityVehicles,ProjID = i.ProjID,ProjDBS = i.ProjDBS,Path = i.Path,dateLastUpdated = i.dateLastUpdated,DateCreated = i.DateCreated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,UL2 = i.UL2,Headway_AM = i.Headway_AM,Headway_MD = i.Headway_MD,Headway_PM = i.Headway_PM,Headway_EV = i.Headway_EV,Headway_NI = i.Headway_NI,light_rail = i.light_rail,TransitType = i.TransitType,RouteID = i.RouteID,RepTripID = i.RepTripID,Description = i.Description,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Version = i.Version,frequent = i.frequent,Shape = i.Shape,GDB_GEOMATTR_DATA = NULL FROM DBO.A42  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OBJECTID = @old_row_id AND a.SDE_STATE_ID = @current_state
     ELSE
     UPDATE DBO.A42 SET LineID = i.LineID,TimePeriod = i.TimePeriod,TransLineNo = i.TransLineNo,Mode = i.Mode,VehicleType = i.VehicleType,Headway = i.Headway,Speed = i.Speed,Operator = i.Operator,InServiceDate = i.InServiceDate,OutServiceDate = i.OutServiceDate,Seats = i.Seats,CapacityVehicles = i.CapacityVehicles,ProjID = i.ProjID,ProjDBS = i.ProjDBS,Path = i.Path,dateLastUpdated = i.dateLastUpdated,DateCreated = i.DateCreated,LastEditor = i.LastEditor,EditNotes = i.EditNotes,Processing = i.Processing,Enabled = i.Enabled,UL2 = i.UL2,Headway_AM = i.Headway_AM,Headway_MD = i.Headway_MD,Headway_PM = i.Headway_PM,Headway_EV = i.Headway_EV,Headway_NI = i.Headway_NI,light_rail = i.light_rail,TransitType = i.TransitType,RouteID = i.RouteID,RepTripID = i.RepTripID,Description = i.Description,created_user = i.created_user,created_date = i.created_date,last_edited_user = i.last_edited_user,last_edited_date = i.last_edited_date,Version = i.Version,frequent = i.frequent,Shape = i.Shape,GDB_GEOMATTR_DATA = i.GDB_GEOMATTR_DATA FROM DBO.A42  a INNER JOIN inserted i  ON (a.OBJECTID = i.OBJECTID)  AND (a.SDE_STATE_ID = i.SDE_STATE_ID) 
     WHERE a.OBJECTID = @old_row_id AND a.SDE_STATE_ID = @current_state

      END
    END

  END
  FETCH NEXT FROM updt_cursor INTO @new_row_id, @old_row_id, @old_state_id, @new_spatial_column, @old_spatial_column
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 42) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 42, @current_state
END
GO
