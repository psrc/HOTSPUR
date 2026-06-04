SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[i14_return_ids]
@id_type integer,
@base_id bigint,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id bigint
  DECLARE @fetched_base_id bigint
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM DBO.i14 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  /* Raise error if the high number being returned is less than the current value for base_id */
  IF ((@base_id + @num_ids) > @fetched_base_id)
    BEGIN
      ROLLBACK TRAN
      RAISERROR(N'Error - invalid fragment being returned', 16, -1)
      RETURN
    END
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE DBO.i14 SET base_id = @base_id, last_id = (@base_id - 1)
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO DBO.i14 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
GRANT EXECUTE ON  [dbo].[i14_return_ids] TO [public] WITH GRANT OPTION
GO
