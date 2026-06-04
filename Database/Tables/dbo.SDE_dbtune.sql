CREATE TABLE [dbo].[SDE_dbtune]
(
[keyword] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[parameter_name] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[config_string] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_dbtune] ADD CONSTRAINT [dbtune_pk] PRIMARY KEY CLUSTERED ([keyword], [parameter_name]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_dbtune] TO [public]
GO
ALTER TABLE [dbo].[SDE_dbtune] SET ( LOCK_ESCALATION = DISABLE )
GO
