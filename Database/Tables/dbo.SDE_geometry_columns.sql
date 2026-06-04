CREATE TABLE [dbo].[SDE_geometry_columns]
(
[f_table_schema] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[f_table_name] [sys].[sysname] NOT NULL,
[f_geometry_column] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[g_table_schema] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[g_table_name] [sys].[sysname] NOT NULL,
[storage_type] [int] NULL,
[geometry_type] [int] NULL,
[coord_dimension] [int] NULL,
[max_ppr] [int] NULL,
[srid] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_geometry_columns] ADD CONSTRAINT [geocol_pk] PRIMARY KEY CLUSTERED ([f_table_schema], [f_table_name], [f_geometry_column]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [geocol_g_table_idx] ON [dbo].[SDE_geometry_columns] ([g_table_name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_geometry_columns] ADD CONSTRAINT [geocol_fk] FOREIGN KEY ([srid]) REFERENCES [dbo].[SDE_spatial_references] ([srid])
GO
GRANT SELECT ON  [dbo].[SDE_geometry_columns] TO [public]
GO
