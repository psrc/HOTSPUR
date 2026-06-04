CREATE TABLE [dbo].[SDE_layer_stats]
(
[oid] [int] NOT NULL IDENTITY(1, 1),
[layer_id] [int] NOT NULL,
[version_id] [int] NULL,
[minx] [float] NOT NULL,
[miny] [float] NOT NULL,
[maxx] [float] NOT NULL,
[maxy] [float] NOT NULL,
[minz] [float] NULL,
[minm] [float] NULL,
[maxz] [float] NULL,
[maxm] [float] NULL,
[total_features] [int] NOT NULL,
[total_points] [int] NOT NULL,
[last_analyzed] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layer_stats] ADD CONSTRAINT [sdelayer_stats_pk] PRIMARY KEY CLUSTERED ([oid]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layer_stats] ADD CONSTRAINT [sdelayer_stats_uk] UNIQUE NONCLUSTERED ([layer_id], [version_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layer_stats] ADD CONSTRAINT [sdelayer_stats_fk1] FOREIGN KEY ([layer_id]) REFERENCES [dbo].[SDE_layers] ([layer_id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SDE_layer_stats] ADD CONSTRAINT [sdelayer_stats_fk2] FOREIGN KEY ([version_id]) REFERENCES [dbo].[SDE_versions] ([version_id]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_layer_stats] TO [public]
GO
ALTER TABLE [dbo].[SDE_layer_stats] SET ( LOCK_ESCALATION = DISABLE )
GO
