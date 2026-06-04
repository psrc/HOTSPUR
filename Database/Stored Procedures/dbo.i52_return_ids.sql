SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[i52_return_ids]
@id_type integer,
@base_id bigint,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id bigint
  DECLARE @fetched_base_id bigint
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM DBO.i52 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE DBO.i52 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO DBO.i52 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
