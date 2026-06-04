CREATE TABLE [dbo].[SDE_archives]
(
[archiving_regid] [int] NOT NULL,
[history_regid] [int] NOT NULL,
[from_date] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[to_date] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[archive_date] [bigint] NOT NULL,
[archive_flags] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_archives] ADD CONSTRAINT [archives_pk] PRIMARY KEY CLUSTERED ([archiving_regid]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_archives] ADD CONSTRAINT [archives_uk] UNIQUE NONCLUSTERED ([history_regid]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_archives] ADD CONSTRAINT [archives_fk1] FOREIGN KEY ([archiving_regid]) REFERENCES [dbo].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [dbo].[SDE_archives] ADD CONSTRAINT [archives_fk2] FOREIGN KEY ([history_regid]) REFERENCES [dbo].[SDE_table_registry] ([registration_id])
GO
GRANT SELECT ON  [dbo].[SDE_archives] TO [public]
GO
ALTER TABLE [dbo].[SDE_archives] SET ( LOCK_ESCALATION = DISABLE )
GO
