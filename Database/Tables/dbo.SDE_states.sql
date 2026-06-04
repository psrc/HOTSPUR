CREATE TABLE [dbo].[SDE_states]
(
[state_id] [bigint] NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[creation_time] [datetime] NOT NULL,
[closing_time] [datetime] NULL,
[parent_state_id] [bigint] NOT NULL,
[lineage_name] [bigint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[sde_lineage_delete] ON [dbo].[SDE_states] FOR DELETE AS      DELETE FROM dbo.SDE_state_lineages WHERE lineage_id IN (SELECT state_id FROM deleted)
GO
ALTER TABLE [dbo].[SDE_states] ADD CONSTRAINT [states_pk] PRIMARY KEY CLUSTERED ([state_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_states] ADD CONSTRAINT [states_cuk] UNIQUE NONCLUSTERED ([parent_state_id], [lineage_name]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_states] TO [public]
GO
