CREATE TABLE [dbo].[SDE_table_registry]
(
[registration_id] [int] NOT NULL,
[table_name] [sys].[sysname] NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rowid_column] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[object_flags] [int] NOT NULL,
[object_flags2] [int] NULL,
[registration_date] [int] NOT NULL,
[config_keyword] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[minimum_id] [int] NULL,
[imv_view_name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_table_registry] ADD CONSTRAINT [registry_pk] PRIMARY KEY CLUSTERED ([registration_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_table_registry] ADD CONSTRAINT [registry_uk2] UNIQUE NONCLUSTERED ([table_name], [owner]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_table_registry] TO [public]
GO
