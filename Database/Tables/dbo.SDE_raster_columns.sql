CREATE TABLE [dbo].[SDE_raster_columns]
(
[rastercolumn_id] [int] NOT NULL,
[description] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[table_name] [sys].[sysname] NOT NULL,
[raster_column] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cdate] [int] NOT NULL,
[config_keyword] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[minimum_id] [int] NULL,
[base_rastercolumn_id] [int] NOT NULL,
[rastercolumn_mask] [int] NOT NULL,
[srid] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_raster_columns] ADD CONSTRAINT [rascol_pk] PRIMARY KEY CLUSTERED ([owner], [table_name], [raster_column]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_raster_columns] ADD CONSTRAINT [rascol_uk] UNIQUE NONCLUSTERED ([rastercolumn_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_raster_columns] ADD CONSTRAINT [rascol_fk] FOREIGN KEY ([srid]) REFERENCES [dbo].[SDE_spatial_references] ([srid])
GO
GRANT SELECT ON  [dbo].[SDE_raster_columns] TO [public]
GO
