SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[transitFrequency_evw] AS SELECT b.OBJECTID + 0 OBJECTID,b.rep_trip,b.hour_2,b.hour_3,b.hour_4,b.hour_5,b.hour_6,b.hour_7,b.hour_8,b.hour_9,b.hour_10,b.hour_11,b.hour_12,b.hour_13,b.hour_14,b.hour_15,b.hour_16,b.hour_17,b.hour_18,b.hour_19,b.hour_20,b.hour_21,b.hour_22,b.hour_23,b.LineID,b.hour_24,b.hour_25,b.hour_26,b.hour_27,b.hour_28,b.OBJECTID - b.OBJECTID SDE_STATE_ID FROM DBO.TRANSITFREQUENCY b LEFT JOIN  (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d24 WHERE SDE_STATE_ID = 0 AND DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON b.OBJECTID = d.SDE_DELETES_ROW_ID WHERE d.SDE_STATE_ID IS NULL UNION ALL SELECT a.OBJECTID + 0 OBJECTID,a.rep_trip,a.hour_2,a.hour_3,a.hour_4,a.hour_5,a.hour_6,a.hour_7,a.hour_8,a.hour_9,a.hour_10,a.hour_11,a.hour_12,a.hour_13,a.hour_14,a.hour_15,a.hour_16,a.hour_17,a.hour_18,a.hour_19,a.hour_20,a.hour_21,a.hour_22,a.hour_23,a.LineID,a.hour_24,a.hour_25,a.hour_26,a.hour_27,a.hour_28,a.SDE_STATE_ID FROM DBO.a24 a LEFT JOIN (SELECT SDE_DELETES_ROW_ID,SDE_STATE_ID FROM DBO.d24 WHERE DELETED_AT IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) ) d ON (a.OBJECTID = d.SDE_DELETES_ROW_ID) AND  (a.SDE_STATE_ID = d.SDE_STATE_ID) WHERE a.SDE_STATE_ID IN (SELECT l.lineage_id FROM dbo.SDE_states s INNER JOIN dbo.SDE_state_lineages l ON l.lineage_name = s.lineage_name WHERE s.state_id = dbo.SDE_get_view_state() AND l.lineage_id <= s.state_id ) AND d.SDE_STATE_ID IS NULL 
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v24_delete]  ON [dbo].[transitFrequency_evw] INSTEAD OF DELETE AS 
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
      INSERT INTO DBO.d24 VALUES (@old_state_id,@row_id,@current_state)
    ELSE
    BEGIN
      DELETE FROM DBO.a24 WHERE OBJECTID = @row_id AND SDE_STATE_ID = @current_state
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
           FROM DBO.d24 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.d24 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
         (@current_state, @row_id, @old_state_id)
      END
      ELSE
        DELETE FROM DBO.TRANSITFREQUENCY WHERE OBJECTID = @row_id
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
        INSERT INTO DBO.d24 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
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
          INSERT INTO DBO.d24 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES
           (@current_state, @row_id, @old_state_id)
        END
        ELSE
          DELETE FROM DBO.a24
            WHERE OBJECTID = @row_id AND SDE_STATE_ID = @old_state_id
      END

    END
  END
  FETCH NEXT FROM del_cursor INTO @row_id, @old_state_id
END
CLOSE del_cursor
DEALLOCATE del_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 24) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 24, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v24_insert] ON [dbo].[transitFrequency_evw] INSTEAD OF INSERT AS 
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
    EXECUTE DBO.i24_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i24_return_ids 2, @return_row_id, @num_return_ids
    END
  END

  -- If editing state 0, then the insert being performed
  -- must be written to the base table, not the adds table

  IF @current_state = 0
  BEGIN
  INSERT INTO DBO.TRANSITFREQUENCY
  (OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28)
  SELECT 
  @next_row_id,i.rep_trip,i.hour_2,i.hour_3,i.hour_4,i.hour_5,i.hour_6,i.hour_7,i.hour_8,i.hour_9,i.hour_10,i.hour_11,i.hour_12,i.hour_13,i.hour_14,i.hour_15,i.hour_16,i.hour_17,i.hour_18,i.hour_19,i.hour_20,i.hour_21,i.hour_22,i.hour_23,i.LineID,i.hour_24,i.hour_25,i.hour_26,i.hour_27,i.hour_28  FROM inserted i
  END
  ELSE
  BEGIN
  INSERT INTO DBO.a24
  (OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28,SDE_STATE_ID)
  SELECT 
  @next_row_id,i.rep_trip,i.hour_2,i.hour_3,i.hour_4,i.hour_5,i.hour_6,i.hour_7,i.hour_8,i.hour_9,i.hour_10,i.hour_11,i.hour_12,i.hour_13,i.hour_14,i.hour_15,i.hour_16,i.hour_17,i.hour_18,i.hour_19,i.hour_20,i.hour_21,i.hour_22,i.hour_23,i.LineID,i.hour_24,i.hour_25,i.hour_26,i.hour_27,i.hour_28,@current_state  FROM inserted i
  END
END
ELSE
BEGIN
  --Multi-row insert, need to cursor through the changes.
  DECLARE ins_cursor CURSOR FOR
  SELECT OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28,SDE_STATE_ID
  FROM inserted
  DECLARE @col1 int
  DECLARE @col2 nvarchar(max) 
  DECLARE @col3 numeric(38,8) 
  DECLARE @col4 numeric(38,8) 
  DECLARE @col5 numeric(38,8) 
  DECLARE @col6 numeric(38,8) 
  DECLARE @col7 numeric(38,8) 
  DECLARE @col8 numeric(38,8) 
  DECLARE @col9 numeric(38,8) 
  DECLARE @col10 numeric(38,8) 
  DECLARE @col11 numeric(38,8) 
  DECLARE @col12 numeric(38,8) 
  DECLARE @col13 numeric(38,8) 
  DECLARE @col14 numeric(38,8) 
  DECLARE @col15 numeric(38,8) 
  DECLARE @col16 numeric(38,8) 
  DECLARE @col17 numeric(38,8) 
  DECLARE @col18 numeric(38,8) 
  DECLARE @col19 numeric(38,8) 
  DECLARE @col20 numeric(38,8) 
  DECLARE @col21 numeric(38,8) 
  DECLARE @col22 numeric(38,8) 
  DECLARE @col23 numeric(38,8) 
  DECLARE @col24 numeric(38,8) 
  DECLARE @col25 int
  DECLARE @col26 numeric(38,8) 
  DECLARE @col27 numeric(38,8) 
  DECLARE @col28 numeric(38,8) 
  DECLARE @col29 numeric(38,8) 
  DECLARE @col30 numeric(38,8) 
  DECLARE @col31 bigint
  OPEN ins_cursor
  FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXECUTE DBO.i24_get_ids 2, 1, @next_row_id OUTPUT, @num_ids OUTPUT
    IF @num_ids > 1
    BEGIN
      SET @return_row_id = @next_row_id + 1
      SET @num_return_ids = @num_ids - 1
      EXECUTE DBO.i24_return_ids 2, @return_row_id, @num_return_ids
    END
    IF @current_state = 0
    BEGIN
      -- If editing state 0, then the insert being performed
      -- must be written to the base table, not the adds table

      INSERT INTO DBO.TRANSITFREQUENCY
      (OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30 )
    END
    ELSE
    BEGIN
      INSERT INTO DBO.a24
      (OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28,SDE_STATE_ID)
      VALUES (@next_row_id,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@current_state )
    END

    FETCH NEXT FROM ins_cursor INTO @col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31
  END
  CLOSE ins_cursor
  DEALLOCATE ins_cursor
END
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 24) = 0
 AND @current_state > 0
EXECUTE dbo.SDE_mvmodified_table_insert 24, @current_state
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[v24_update]  ON [dbo].[transitFrequency_evw] INSTEAD OF UPDATE AS 
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
 i.rep_trip,
 i.hour_2,
 i.hour_3,
 i.hour_4,
 i.hour_5,
 i.hour_6,
 i.hour_7,
 i.hour_8,
 i.hour_9,
 i.hour_10,
 i.hour_11,
 i.hour_12,
 i.hour_13,
 i.hour_14,
 i.hour_15,
 i.hour_16,
 i.hour_17,
 i.hour_18,
 i.hour_19,
 i.hour_20,
 i.hour_21,
 i.hour_22,
 i.hour_23,
 i.LineID,
 i.hour_24,
 i.hour_25,
 i.hour_26,
 i.hour_27,
 i.hour_28
  FROM inserted i INNER JOIN deleted d
  ON i.OBJECTID = d.OBJECTID
DECLARE @upd_OBJECTID int
DECLARE @upd_rep_trip nvarchar(max) 
DECLARE @upd_hour_2 numeric(38,8) 
DECLARE @upd_hour_3 numeric(38,8) 
DECLARE @upd_hour_4 numeric(38,8) 
DECLARE @upd_hour_5 numeric(38,8) 
DECLARE @upd_hour_6 numeric(38,8) 
DECLARE @upd_hour_7 numeric(38,8) 
DECLARE @upd_hour_8 numeric(38,8) 
DECLARE @upd_hour_9 numeric(38,8) 
DECLARE @upd_hour_10 numeric(38,8) 
DECLARE @upd_hour_11 numeric(38,8) 
DECLARE @upd_hour_12 numeric(38,8) 
DECLARE @upd_hour_13 numeric(38,8) 
DECLARE @upd_hour_14 numeric(38,8) 
DECLARE @upd_hour_15 numeric(38,8) 
DECLARE @upd_hour_16 numeric(38,8) 
DECLARE @upd_hour_17 numeric(38,8) 
DECLARE @upd_hour_18 numeric(38,8) 
DECLARE @upd_hour_19 numeric(38,8) 
DECLARE @upd_hour_20 numeric(38,8) 
DECLARE @upd_hour_21 numeric(38,8) 
DECLARE @upd_hour_22 numeric(38,8) 
DECLARE @upd_hour_23 numeric(38,8) 
DECLARE @upd_LineID int
DECLARE @upd_hour_24 numeric(38,8) 
DECLARE @upd_hour_25 numeric(38,8) 
DECLARE @upd_hour_26 numeric(38,8) 
DECLARE @upd_hour_27 numeric(38,8) 
DECLARE @upd_hour_28 numeric(38,8) 
OPEN updt_cursor
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_rep_trip, @upd_hour_2, @upd_hour_3, @upd_hour_4, @upd_hour_5, @upd_hour_6, @upd_hour_7, @upd_hour_8, @upd_hour_9, @upd_hour_10, @upd_hour_11, @upd_hour_12, @upd_hour_13, @upd_hour_14, @upd_hour_15, @upd_hour_16, @upd_hour_17, @upd_hour_18, @upd_hour_19, @upd_hour_20, @upd_hour_21, @upd_hour_22, @upd_hour_23, @upd_LineID, @upd_hour_24, @upd_hour_25, @upd_hour_26, @upd_hour_27, @upd_hour_28
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @g_is_default = '0'
  BEGIN
    IF (@old_state_id != @current_state)
    BEGIN
     INSERT INTO DBO.a24 (
OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_rep_trip, @upd_hour_2, @upd_hour_3, @upd_hour_4, @upd_hour_5, @upd_hour_6, @upd_hour_7, @upd_hour_8, @upd_hour_9, @upd_hour_10, @upd_hour_11, @upd_hour_12, @upd_hour_13, @upd_hour_14, @upd_hour_15, @upd_hour_16, @upd_hour_17, @upd_hour_18, @upd_hour_19, @upd_hour_20, @upd_hour_21, @upd_hour_22, @upd_hour_23, @upd_LineID, @upd_hour_24, @upd_hour_25, @upd_hour_26, @upd_hour_27, @upd_hour_28, @current_state)

     INSERT INTO DBO.d24 VALUES (@old_state_id, @old_row_id, @current_state)
    END
    ELSE
    BEGIN
     UPDATE DBO.a24 SET rep_trip = @upd_rep_trip,hour_2 = @upd_hour_2,hour_3 = @upd_hour_3,hour_4 = @upd_hour_4,hour_5 = @upd_hour_5,hour_6 = @upd_hour_6,hour_7 = @upd_hour_7,hour_8 = @upd_hour_8,hour_9 = @upd_hour_9,hour_10 = @upd_hour_10,hour_11 = @upd_hour_11,hour_12 = @upd_hour_12,hour_13 = @upd_hour_13,hour_14 = @upd_hour_14,hour_15 = @upd_hour_15,hour_16 = @upd_hour_16,hour_17 = @upd_hour_17,hour_18 = @upd_hour_18,hour_19 = @upd_hour_19,hour_20 = @upd_hour_20,hour_21 = @upd_hour_21,hour_22 = @upd_hour_22,hour_23 = @upd_hour_23,LineID = @upd_LineID,hour_24 = @upd_hour_24,hour_25 = @upd_hour_25,hour_26 = @upd_hour_26,hour_27 = @upd_hour_27,hour_28 = @upd_hour_28 
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
           FROM DBO.d24 WITH (TABLOCKX,HOLDLOCK)
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
        INSERT INTO DBO.a24 (
OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_rep_trip, @upd_hour_2, @upd_hour_3, @upd_hour_4, @upd_hour_5, @upd_hour_6, @upd_hour_7, @upd_hour_8, @upd_hour_9, @upd_hour_10, @upd_hour_11, @upd_hour_12, @upd_hour_13, @upd_hour_14, @upd_hour_15, @upd_hour_16, @upd_hour_17, @upd_hour_18, @upd_hour_19, @upd_hour_20, @upd_hour_21, @upd_hour_22, @upd_hour_23, @upd_LineID, @upd_hour_24, @upd_hour_25, @upd_hour_26, @upd_hour_27, @upd_hour_28, @current_state)

        INSERT INTO DBO.d24 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.TRANSITFREQUENCY SET rep_trip = @upd_rep_trip,hour_2 = @upd_hour_2,hour_3 = @upd_hour_3,hour_4 = @upd_hour_4,hour_5 = @upd_hour_5,hour_6 = @upd_hour_6,hour_7 = @upd_hour_7,hour_8 = @upd_hour_8,hour_9 = @upd_hour_9,hour_10 = @upd_hour_10,hour_11 = @upd_hour_11,hour_12 = @upd_hour_12,hour_13 = @upd_hour_13,hour_14 = @upd_hour_14,hour_15 = @upd_hour_15,hour_16 = @upd_hour_16,hour_17 = @upd_hour_17,hour_18 = @upd_hour_18,hour_19 = @upd_hour_19,hour_20 = @upd_hour_20,hour_21 = @upd_hour_21,hour_22 = @upd_hour_22,hour_23 = @upd_hour_23,LineID = @upd_LineID,hour_24 = @upd_hour_24,hour_25 = @upd_hour_25,hour_26 = @upd_hour_26,hour_27 = @upd_hour_27,hour_28 = @upd_hour_28 
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
        INSERT INTO DBO.a24 (
OBJECTID,rep_trip,hour_2,hour_3,hour_4,hour_5,hour_6,hour_7,hour_8,hour_9,hour_10,hour_11,hour_12,hour_13,hour_14,hour_15,hour_16,hour_17,hour_18,hour_19,hour_20,hour_21,hour_22,hour_23,LineID,hour_24,hour_25,hour_26,hour_27,hour_28,SDE_STATE_ID)
        VALUES(  @upd_OBJECTID, @upd_rep_trip, @upd_hour_2, @upd_hour_3, @upd_hour_4, @upd_hour_5, @upd_hour_6, @upd_hour_7, @upd_hour_8, @upd_hour_9, @upd_hour_10, @upd_hour_11, @upd_hour_12, @upd_hour_13, @upd_hour_14, @upd_hour_15, @upd_hour_16, @upd_hour_17, @upd_hour_18, @upd_hour_19, @upd_hour_20, @upd_hour_21, @upd_hour_22, @upd_hour_23, @upd_LineID, @upd_hour_24, @upd_hour_25, @upd_hour_26, @upd_hour_27, @upd_hour_28, @current_state)

        INSERT INTO DBO.d24 (DELETED_AT,SDE_DELETES_ROW_ID,SDE_STATE_ID) VALUES (@current_state, @old_row_id, @old_state_id)
      END
      ELSE
      BEGIN
        UPDATE DBO.a24 SET rep_trip = @upd_rep_trip,hour_2 = @upd_hour_2,hour_3 = @upd_hour_3,hour_4 = @upd_hour_4,hour_5 = @upd_hour_5,hour_6 = @upd_hour_6,hour_7 = @upd_hour_7,hour_8 = @upd_hour_8,hour_9 = @upd_hour_9,hour_10 = @upd_hour_10,hour_11 = @upd_hour_11,hour_12 = @upd_hour_12,hour_13 = @upd_hour_13,hour_14 = @upd_hour_14,hour_15 = @upd_hour_15,hour_16 = @upd_hour_16,hour_17 = @upd_hour_17,hour_18 = @upd_hour_18,hour_19 = @upd_hour_19,hour_20 = @upd_hour_20,hour_21 = @upd_hour_21,hour_22 = @upd_hour_22,hour_23 = @upd_hour_23,LineID = @upd_LineID,hour_24 = @upd_hour_24,hour_25 = @upd_hour_25,hour_26 = @upd_hour_26,hour_27 = @upd_hour_27,hour_28 = @upd_hour_28 
WHERE OBJECTID = @old_row_id  AND SDE_STATE_ID = @current_state
      END
    END

  END
FETCH NEXT FROM updt_cursor INTO @old_row_id, @old_state_id, @upd_OBJECTID, @upd_rep_trip, @upd_hour_2, @upd_hour_3, @upd_hour_4, @upd_hour_5, @upd_hour_6, @upd_hour_7, @upd_hour_8, @upd_hour_9, @upd_hour_10, @upd_hour_11, @upd_hour_12, @upd_hour_13, @upd_hour_14, @upd_hour_15, @upd_hour_16, @upd_hour_17, @upd_hour_18, @upd_hour_19, @upd_hour_20, @upd_hour_21, @upd_hour_22, @upd_hour_23, @upd_LineID, @upd_hour_24, @upd_hour_25, @upd_hour_26, @upd_hour_27, @upd_hour_28
END
CLOSE updt_cursor
DEALLOCATE updt_cursor
IF (SELECT COUNT (*) FROM dbo.SDE_mvtables_modified WHERE state_id = @current_state AND registration_id = 24) = 0
 AND @current_state > 0
  EXECUTE dbo.SDE_mvmodified_table_insert 24, @current_state
END
GO
