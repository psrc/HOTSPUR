CREATE TABLE [dbo].[SDE_state_lineages]
(
[lineage_name] [bigint] NOT NULL,
[lineage_id] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_state_lineages] ADD CONSTRAINT [state_lineages_pk] PRIMARY KEY CLUSTERED ([lineage_name], [lineage_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [lineage_id_idx2] ON [dbo].[SDE_state_lineages] ([lineage_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_state_lineages] TO [public]
GO
