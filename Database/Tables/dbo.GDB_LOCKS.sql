CREATE TABLE [dbo].[GDB_LOCKS]
(
[objectid] [int] NOT NULL,
[branch_id] [int] NULL,
[registration_id] [int] NULL,
[type] [int] NOT NULL,
[user_identity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[session_id] [uniqueidentifier] NOT NULL,
[lock_time] [datetime2] NULL,
[lock_duration] [int] NULL,
[base_id] [int] NULL,
[num_ids] [int] NULL,
[service_name] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[can_post] [smallint] NULL,
[base_id_64] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TG_GDB_LOCKS] ON [dbo].[GDB_LOCKS] FOR INSERT AS BEGIN 
  SET NOCOUNT ON 
  DECLARE @base_id    INTEGER
  DECLARE @base_id_64 BIGINT
  DECLARE @objectid   INTEGER
  DECLARE @max_id     INTEGER
  SET @max_id = 2147483647
  SELECT @objectid = objectid, @base_id = base_id, @base_id_64 = base_id_64 
  FROM inserted
  IF (@base_id IS NULL AND @base_id_64 IS NOT NULL AND @base_id_64 <= @max_id)
    UPDATE dbo.GDB_LOCKS SET base_id = @base_id_64 WHERE objectid = @objectid
  ELSE IF (@base_id_64 IS NULL AND @base_id IS NOT NULL)
    UPDATE dbo.GDB_LOCKS SET base_id_64 = @base_id WHERE objectid = @objectid
END 
GO
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET CONCAT_NULL_YIELDS_NULL ON
GO
SET ARITHABORT ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [GDB_Locks_cond_idx] ON [dbo].[GDB_LOCKS] ([branch_id]) WHERE ([type]=(2)) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [gdb_locks_ix1] ON [dbo].[GDB_LOCKS] ([branch_id], [session_id], [registration_id]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [R11_SDE_ROWID_UK] ON [dbo].[GDB_LOCKS] ([objectid]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[GDB_LOCKS] TO [public] WITH GRANT OPTION
GO
GRANT INSERT ON  [dbo].[GDB_LOCKS] TO [public] WITH GRANT OPTION
GO
GRANT SELECT ON  [dbo].[GDB_LOCKS] TO [public] WITH GRANT OPTION
GO
GRANT UPDATE ON  [dbo].[GDB_LOCKS] TO [public] WITH GRANT OPTION
GO
ALTER TABLE [dbo].[GDB_LOCKS] SET ( LOCK_ESCALATION = DISABLE )
GO
