SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_state_def_update]
@stateIdVal BIGINT, @OpenOrCloseVal INTEGER,
@clTimeVal DATETIME OUTPUT AS SET NOCOUNT ON 
BEGIN
DECLARE @closeTimeVal DATETIME
SET @clTimeVal = GETDATE()
IF @OpenOrCloseVal = 2
BEGIN
  SET @closeTimeVal = @clTimeVal
END
ELSE
BEGIN
  SET @closeTimeVal = NULL
END
BEGIN TRAN state_def_update
UPDATE dbo.SDE_states SET closing_time = @closeTimeVal
  WHERE state_id = @stateIdVal
COMMIT TRAN state_def_update
END
GO
GRANT EXECUTE ON  [dbo].[SDE_state_def_update] TO [public]
GO
