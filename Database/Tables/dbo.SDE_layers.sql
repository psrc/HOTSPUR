CREATE TABLE [dbo].[SDE_layers]
(
[layer_id] [int] NOT NULL,
[description] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[table_name] [sys].[sysname] NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[spatial_column] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eflags] [int] NOT NULL,
[layer_mask] [int] NOT NULL,
[gsize1] [float] NOT NULL,
[gsize2] [float] NOT NULL,
[gsize3] [float] NOT NULL,
[minx] [float] NOT NULL,
[miny] [float] NOT NULL,
[maxx] [float] NOT NULL,
[maxy] [float] NOT NULL,
[minz] [float] NULL,
[maxz] [float] NULL,
[minm] [float] NULL,
[maxm] [float] NULL,
[cdate] [int] NOT NULL,
[layer_config] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[optimal_array_size] [int] NULL,
[stats_date] [int] NULL,
[minimum_id] [int] NULL,
[srid] [int] NOT NULL,
[base_layer_id] [int] NOT NULL,
[secondary_srid] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layers] ADD CONSTRAINT [layers_pk] PRIMARY KEY CLUSTERED ([table_name], [owner], [spatial_column]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layers] ADD CONSTRAINT [layers_uk] UNIQUE NONCLUSTERED ([layer_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_layers] ADD CONSTRAINT [layers_fk] FOREIGN KEY ([srid]) REFERENCES [dbo].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [dbo].[SDE_layers] ADD CONSTRAINT [layers_sfk] FOREIGN KEY ([secondary_srid]) REFERENCES [dbo].[SDE_spatial_references] ([srid])
GO
GRANT SELECT ON  [dbo].[SDE_layers] TO [public]
GO
