CREATE TABLE [dbo].[SDE_xml_columns]
(
[column_id] [int] NOT NULL IDENTITY(1, 1),
[registration_id] [int] NOT NULL,
[column_name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[index_id] [int] NULL,
[minimum_id] [int] NULL,
[config_keyword] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[xflags] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_xml_columns] ADD CONSTRAINT [xml_columns_pk] PRIMARY KEY NONCLUSTERED ([column_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [xml_columns_uk] ON [dbo].[SDE_xml_columns] ([registration_id], [column_name]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_xml_columns] ADD CONSTRAINT [xml_columns_fk1] FOREIGN KEY ([registration_id]) REFERENCES [dbo].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [dbo].[SDE_xml_columns] ADD CONSTRAINT [xml_columns_fk2] FOREIGN KEY ([index_id]) REFERENCES [dbo].[SDE_xml_indexes] ([index_id])
GO
GRANT SELECT ON  [dbo].[SDE_xml_columns] TO [public]
GO
ALTER TABLE [dbo].[SDE_xml_columns] SET ( LOCK_ESCALATION = DISABLE )
GO
