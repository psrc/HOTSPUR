CREATE TABLE [dbo].[SDE_server_config]
(
[prop_name] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[char_prop_value] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[num_prop_value] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_server_config] ADD CONSTRAINT [server_config_pk] PRIMARY KEY CLUSTERED ([prop_name]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_server_config] TO [public]
GO
ALTER TABLE [dbo].[SDE_server_config] SET ( LOCK_ESCALATION = DISABLE )
GO
