CREATE TABLE [dbo].[SDE_object_locks]
(
[sde_id] [int] NOT NULL,
[object_id] [int] NOT NULL,
[object_type] [int] NOT NULL,
[application_id] [int] NOT NULL,
[autolock] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lock_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lock_time] [datetime] NOT NULL CONSTRAINT [DF__SDE_objec__lock___2B0A656D] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_object_locks] ADD CONSTRAINT [object_locks_pk] PRIMARY KEY CLUSTERED ([sde_id], [object_id], [object_type], [application_id], [autolock], [lock_type]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_object_locks] ADD CONSTRAINT [object_locks_fk] FOREIGN KEY ([sde_id]) REFERENCES [dbo].[SDE_process_information] ([sde_id]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_object_locks] TO [public]
GO
ALTER TABLE [dbo].[SDE_object_locks] SET ( LOCK_ESCALATION = DISABLE )
GO
