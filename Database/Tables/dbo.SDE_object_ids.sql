CREATE TABLE [dbo].[SDE_object_ids]
(
[id_type] [int] NOT NULL,
[base_id] [bigint] NOT NULL,
[object_type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_object_ids] ADD CONSTRAINT [object_ids_pk] PRIMARY KEY CLUSTERED ([id_type]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_object_ids] SET ( LOCK_ESCALATION = DISABLE )
GO
