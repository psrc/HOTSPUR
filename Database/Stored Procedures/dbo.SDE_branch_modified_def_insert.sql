SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_branch_modified_def_insert] 
@branchIdVal INTEGER, @regIdVal INTEGER, @editMomentVal DATETIME2 AS SET NOCOUNT ON
BEGIN
 SET XACT_ABORT OFF
 BEGIN TRY
 INSERT INTO dbo.SDE_branch_tables_modified (branch_id, registration_id, edit_moment)
 VALUES (@branchIdVal, @regIdVal, @editMomentVal)
 END TRY
 BEGIN CATCH
    IF ERROR_NUMBER() <> 2627 /* unique constraint violation */ 
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
END
GO
GRANT EXECUTE ON  [dbo].[SDE_branch_modified_def_insert] TO [public]
GO
