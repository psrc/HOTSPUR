CREATE TABLE [dbo].[SDE_layer_locks]
(
[sde_id] [int] NOT NULL,
[layer_id] [int] NOT NULL,
[autolock] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lock_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lock_time] [datetime] NOT NULL CONSTRAINT [DF__SDE_layer__lock___1F98B2C1] DEFAULT (getdate()),
[minx] [bigint] NULL,
[miny] [bigint] NULL,
[maxx] [bigint] NULL,
[maxy] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layer_locks] ADD CONSTRAINT [layer_locks_pk] PRIMARY KEY CLUSTERED ([sde_id], [layer_id], [autolock], [lock_type]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layer_locks] ADD CONSTRAINT [layer_locks_fk] FOREIGN KEY ([sde_id]) REFERENCES [dbo].[SDE_process_information] ([sde_id]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_layer_locks] TO [public]
GO
ALTER TABLE [dbo].[SDE_layer_locks] SET ( LOCK_ESCALATION = DISABLE )
GO
