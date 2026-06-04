SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_new_edit]
@stateIdVal BIGINT, @ownerVal NVARCHAR(128),
@pStateIdVal BIGINT, @pLineageNameVal BIGINT OUTPUT,
@sdeIdVal INTEGER,
@crTimeVal DATETIME OUTPUT AS SET NOCOUNT ON
BEGIN
  DECLARE @new_lineage_name BIGINT
  DECLARE @ClosingTime DATETIME

  BEGIN TRAN state_new_edit
  --  Close parent state if it is open
  SELECT @ClosingTime = closing_time FROM dbo.SDE_states
     WHERE state_id = @pStateIdVal

  SET @crTimeVal = GETDATE()
  IF @ClosingTime  IS NULL
  BEGIN
     UPDATE dbo.SDE_states SET closing_time =  @crTimeVal 
          WHERE state_id = @pStateIdVal
  END

  SET @new_lineage_name = @pLineageNameVal
  BEGIN TRY
    INSERT INTO dbo.SDE_states (state_id,owner,
      creation_time, closing_time,parent_state_id,lineage_name) VALUES
      (@stateIdVal, @ownerVal, @crTimeVal, NULL, @pStateIdVal,
       @pLineageNameVal)
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 2627 /* unique constraint violation */ 
    BEGIN
      INSERT INTO dbo.SDE_states (state_id,owner,creation_time, closing_time,
                                  parent_state_id,lineage_name) VALUES 
                (@stateIdVal, @ownerVal, @crTimeVal, NULL, @pStateIdVal, 
                 @stateIdVal)
      SET @new_lineage_name = @stateIdVal
    END
    ELSE
    BEGIN
      -- rethrow unexpected error
      DECLARE @ErrorMessage    NVARCHAR(4000),
        @ErrorNumber     INT,
        @ErrorSeverity   INT,
        @ErrorState      INT,
        @ErrorLine       INT,
        @ErrorProcedure  NVARCHAR(200);
      SELECT @ErrorNumber = ERROR_NUMBER(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorLine = ERROR_LINE(),
        @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');
      SELECT @ErrorMessage = 
        N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' +
        'Message: '+ ERROR_MESSAGE();
      RAISERROR (@ErrorMessage, @ErrorSeverity, 1,
        @ErrorNumber, @ErrorSeverity, @ErrorState,
        @ErrorProcedure, @ErrorLine);
    END
  END CATCH
  -- If we created a new lineage, insert it into the STATE_LINEAGE table
  --  in normalized form. 
  IF @new_lineage_name <> @pLineageNameVal
  BEGIN
    INSERT INTO dbo.SDE_state_lineages (lineage_name, lineage_id)
         SELECT @new_lineage_name,l.lineage_id
         FROM dbo.SDE_state_lineages l 
         WHERE l.lineage_name = @pLineageNameVal AND
               l.lineage_id <= @pStateIdVal
    SET @pLineageNameVal = @new_lineage_name
  END

  -- We also insert a row for this state, as if it were in its own
  -- state lineage. 

  INSERT INTO dbo.SDE_state_lineages  (lineage_name, lineage_id)
      VALUES (@new_lineage_name,@stateIdVal)

  -- Place a lock entry in the SDE_state_locks table.  Doing this directly
  -- is both safe and necessary.  Safe, as this is a newly created state
  -- so there can not be a conflict; necessary as this function needs to
  -- be efficient and secure, this is the only way to avoid rechecking
  -- the current user's access rights.

  INSERT INTO dbo.SDE_state_locks(sde_id,state_id,autolock,lock_type)
     VALUES (@sdeIdVal, @stateIdVal, 'N', 'E')
  COMMIT TRAN state_new_edit

END
GO
GRANT EXECUTE ON  [dbo].[SDE_state_new_edit] TO [public]
GO
