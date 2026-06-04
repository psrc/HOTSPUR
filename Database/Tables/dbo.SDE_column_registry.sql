CREATE TABLE [dbo].[SDE_column_registry]
(
[table_name] [sys].[sysname] NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[column_name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sde_type] [int] NOT NULL,
[column_size] [int] NULL,
[decimal_digits] [int] NULL,
[description] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[object_flags] [int] NOT NULL,
[object_flags2] [int] NULL,
[object_id] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_column_registry] ADD CONSTRAINT [colregistry_pk] PRIMARY KEY CLUSTERED ([table_name], [owner], [column_name]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_column_registry] ADD CONSTRAINT [colregistry_fk] FOREIGN KEY ([table_name], [owner]) REFERENCES [dbo].[SDE_table_registry] ([table_name], [owner]) ON DELETE CASCADE ON UPDATE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_column_registry] TO [public]
GO
