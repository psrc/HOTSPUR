SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_mvmodified_table_del_base_save]       @high_state_idVal BIGINT, @lineage_nameVal BIGINT, @id1 INTEGER,      @id2 INTEGER, @id3 INTEGER, @id4 INTEGER, @id5 INTEGER,      @id6 INTEGER, @id7 INTEGER, @id8 INTEGER AS      SET NOCOUNT ON      BEGIN      DELETE FROM dbo.SDE_mvtables_modified WHERE registration_id IN         (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)        AND state_id IN (SELECT state_id FROM dbo.SDE_states WHERE state_id > 0 AND        state_id <= @high_state_idVal AND lineage_name = @lineage_nameVal)      END
GO
GRANT EXECUTE ON  [dbo].[SDE_mvmodified_table_del_base_save] TO [public]
GO
