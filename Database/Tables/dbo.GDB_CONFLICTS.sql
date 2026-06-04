CREATE TABLE [dbo].[GDB_CONFLICTS]
(
[branch_id] [int] NOT NULL,
[registration_id] [int] NOT NULL,
[objectid] [int] NOT NULL,
[conflict_type] [int] NOT NULL,
[branch_moment] [datetime2] NOT NULL,
[default_moment] [datetime2] NOT NULL,
[inspected] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[objectid_64] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TG_GDB_CONFLICTS] ON [dbo].[GDB_CONFLICTS] INSTEAD OF INSERT AS BEGIN 
  SET NOCOUNT ON 
  DECLARE @objectid        INTEGER
  DECLARE @objectid_64     BIGINT
  SELECT @objectid = objectid, @objectid_64 = objectid_64 FROM inserted 
  IF @objectid_64 IS NULL
    SET @objectid_64 = @objectid 
  INSERT INTO dbo.GDB_CONFLICTS (branch_id, registration_id, objectid, objectid_64, conflict_type,
                  branch_moment, default_moment, inspected, description) 
  SELECT i.branch_id,i.registration_id,@objectid,@objectid_64, i.conflict_type, i.branch_moment,
         i.default_moment,i.inspected, i.description FROM inserted i 
END 
GO
CREATE NONCLUSTERED INDEX [GDB_Conflicts_idx] ON [dbo].[GDB_CONFLICTS] ([branch_id], [objectid]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GDB_Conflicts_idx_64] ON [dbo].[GDB_CONFLICTS] ([branch_id], [objectid_64]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[GDB_CONFLICTS] TO [public] WITH GRANT OPTION
GO
GRANT INSERT ON  [dbo].[GDB_CONFLICTS] TO [public] WITH GRANT OPTION
GO
GRANT SELECT ON  [dbo].[GDB_CONFLICTS] TO [public] WITH GRANT OPTION
GO
GRANT UPDATE ON  [dbo].[GDB_CONFLICTS] TO [public] WITH GRANT OPTION
GO
ALTER TABLE [dbo].[GDB_CONFLICTS] SET ( LOCK_ESCALATION = DISABLE )
GO
