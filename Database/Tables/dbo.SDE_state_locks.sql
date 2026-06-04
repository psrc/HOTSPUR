CREATE TABLE [dbo].[SDE_state_locks]
(
[sde_id] [int] NOT NULL,
[state_id] [bigint] NOT NULL,
[autolock] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lock_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lock_time] [datetime] NOT NULL CONSTRAINT [DF__SDE_state__lock___236943A5] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_state_locks] ADD CONSTRAINT [state_locks_pk] PRIMARY KEY CLUSTERED ([sde_id], [state_id], [autolock], [lock_type]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_state_locks] ADD CONSTRAINT [state_locks_fk] FOREIGN KEY ([sde_id]) REFERENCES [dbo].[SDE_process_information] ([sde_id]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_state_locks] TO [public]
GO
ALTER TABLE [dbo].[SDE_state_locks] SET ( LOCK_ESCALATION = DISABLE )
GO
