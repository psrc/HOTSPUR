CREATE TABLE [dbo].[SDE_mvtables_modified]
(
[state_id] [bigint] NOT NULL,
[registration_id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_mvtables_modified] ADD CONSTRAINT [mvtables_modified_pk] PRIMARY KEY CLUSTERED ([state_id], [registration_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_mvtables_modified] ADD CONSTRAINT [mvtables_modified_fk1] FOREIGN KEY ([state_id]) REFERENCES [dbo].[SDE_states] ([state_id])
GO
ALTER TABLE [dbo].[SDE_mvtables_modified] ADD CONSTRAINT [mvtables_modified_fk2] FOREIGN KEY ([registration_id]) REFERENCES [dbo].[SDE_table_registry] ([registration_id])
GO
GRANT SELECT ON  [dbo].[SDE_mvtables_modified] TO [public]
GO
