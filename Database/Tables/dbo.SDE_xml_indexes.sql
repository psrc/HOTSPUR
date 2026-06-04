CREATE TABLE [dbo].[SDE_xml_indexes]
(
[index_id] [int] NOT NULL IDENTITY(1, 1),
[index_name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[index_type] [int] NOT NULL,
[description] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_xml_indexes] ADD CONSTRAINT [xml_indexes_pk] PRIMARY KEY CLUSTERED ([index_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [xml_indexes_uk] ON [dbo].[SDE_xml_indexes] ([owner], [index_name]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_xml_indexes] TO [public]
GO
ALTER TABLE [dbo].[SDE_xml_indexes] SET ( LOCK_ESCALATION = DISABLE )
GO
