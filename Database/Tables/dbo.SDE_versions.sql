CREATE TABLE [dbo].[SDE_versions]
(
[name] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[version_id] [int] NOT NULL,
[status] [int] NOT NULL,
[state_id] [bigint] NOT NULL,
[description] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_name] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_version_id] [int] NULL,
[creation_time] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_versions] ADD CONSTRAINT [versions_pk] PRIMARY KEY CLUSTERED ([version_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_versions] ADD CONSTRAINT [versions_uk] UNIQUE NONCLUSTERED ([name], [owner]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ver_state_ix] ON [dbo].[SDE_versions] ([state_id]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_versions] TO [public]
GO
