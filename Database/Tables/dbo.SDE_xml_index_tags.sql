CREATE TABLE [dbo].[SDE_xml_index_tags]
(
[index_id] [int] NOT NULL,
[tag_id] [int] NOT NULL IDENTITY(1, 1),
[tag_name] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[data_type] [int] NOT NULL,
[tag_alias] [int] NULL,
[description] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_excluded] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_xml_index_tags] ADD CONSTRAINT [xml_indextags_pk] PRIMARY KEY CLUSTERED ([index_id], [tag_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [xml_indextags_ix2] ON [dbo].[SDE_xml_index_tags] ([tag_alias]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [xml_indextags_ix1] ON [dbo].[SDE_xml_index_tags] ([tag_name]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_xml_index_tags] ADD CONSTRAINT [xml_indextags_fk1] FOREIGN KEY ([index_id]) REFERENCES [dbo].[SDE_xml_indexes] ([index_id]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_xml_index_tags] TO [public]
GO
ALTER TABLE [dbo].[SDE_xml_index_tags] SET ( LOCK_ESCALATION = DISABLE )
GO
