CREATE TABLE [dbo].[SDE_table_locks]
(
[sde_id] [int] NOT NULL,
[registration_id] [int] NOT NULL,
[lock_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lock_time] [datetime] NOT NULL CONSTRAINT [DF__SDE_table__lock___2739D489] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_table_locks] ADD CONSTRAINT [table_locks_pk] PRIMARY KEY CLUSTERED ([sde_id], [registration_id], [lock_type]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_table_locks] ADD CONSTRAINT [table_locks_fk] FOREIGN KEY ([sde_id]) REFERENCES [dbo].[SDE_process_information] ([sde_id]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_table_locks] TO [public]
GO
ALTER TABLE [dbo].[SDE_table_locks] SET ( LOCK_ESCALATION = DISABLE )
GO
