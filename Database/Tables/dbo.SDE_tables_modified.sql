CREATE TABLE [dbo].[SDE_tables_modified]
(
[table_name] [sys].[sysname] NOT NULL,
[time_last_modified] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_tables_modified] ADD CONSTRAINT [tables_modified_pk] PRIMARY KEY CLUSTERED ([table_name]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_tables_modified] TO [public]
GO
ALTER TABLE [dbo].[SDE_tables_modified] SET ( LOCK_ESCALATION = DISABLE )
GO
