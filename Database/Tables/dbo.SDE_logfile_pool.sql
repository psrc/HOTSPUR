CREATE TABLE [dbo].[SDE_logfile_pool]
(
[table_id] [int] NOT NULL,
[sde_id] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_logfile_pool] ADD CONSTRAINT [logfile_pool_pk] PRIMARY KEY CLUSTERED ([table_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_logfile_pool] ADD CONSTRAINT [logfile_pool_fk] FOREIGN KEY ([sde_id]) REFERENCES [dbo].[SDE_process_information] ([sde_id]) ON DELETE SET NULL
GO
GRANT SELECT ON  [dbo].[SDE_logfile_pool] TO [public]
GO
ALTER TABLE [dbo].[SDE_logfile_pool] SET ( LOCK_ESCALATION = DISABLE )
GO
