CREATE TABLE [dbo].[SDE_lineages_modified]
(
[lineage_name] [bigint] NOT NULL,
[time_last_modified] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_lineages_modified] ADD CONSTRAINT [lineages_mod_pk] PRIMARY KEY CLUSTERED ([lineage_name]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_lineages_modified] TO [public]
GO
