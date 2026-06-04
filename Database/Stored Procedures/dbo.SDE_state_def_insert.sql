SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_def_insert]
@stateIdVal BIGINT, @ownerVal NVARCHAR(128), @pStateIdVal BIGINT,
@pLineageNameVal BIGINT OUTPUT, @sdeIdVal INTEGER,@OpenOrCloseVal INTEGER,
@crTimeVal DATETIME OUTPUT AS SET NOCOUNT ON
BEGIN
  SET XACT_ABORT OFF
  DECLARE @new_lineage_name BIGINT
  DECLARE @clTimeVal DATETIME
  SET @new_lineage_name = @pLineageNameVal

  SET @crTimeVal = GETDATE()
  -- close state
  IF @OpenOrCloseVal = 2
  BEGIN
    SET @clTimeVal = @crTimeVal
  END
  ELSE
  BEGIN
    SET @clTimeVal = NULL
  END

  BEGIN TRAN state_insert
  BEGIN TRY
    INSERT INTO dbo.SDE_states (state_id,owner,
      creation_time, closing_time,parent_state_id,lineage_name) VALUES
      (@stateIdVal, @ownerVal, @crTimeVal, @clTimeVal, @pStateIdVal,
       @pLineageNameVal)
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 2627 /* unique constraint violation */ 
    BEGIN
      INSERT INTO dbo.SDE_states (state_id,owner,creation_time, closing_time,
                                  parent_state_id,lineage_name) VALUES 
                (@stateIdVal, @ownerVal, @crTimeVal, @clTimeVal, @pStateIdVal, 
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

  -- Place a mark on the new state so that it doesn't get cleaned up
  -- by compress.  Do it before the commit so it won't ever be both
  -- visible and unmarked at the same time.

  EXECUTE dbo.SDE_state_lock_def_insert @sdeIdVal, @stateIdVal, 'Y', 'M'

  COMMIT TRAN state_insert
END
GO
GRANT EXECUTE ON  [dbo].[SDE_state_def_insert] TO [public]
GO
