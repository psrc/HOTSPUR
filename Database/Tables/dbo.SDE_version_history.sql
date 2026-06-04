CREATE TABLE [dbo].[SDE_version_history]
(
[MAJOR] [int] NOT NULL,
[MINOR] [int] NOT NULL,
[BUGFIX] [int] NOT NULL,
[DESCRIPTION] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RELEASE] [int] NOT NULL,
[SDESVR_REL_LOW] [int] NOT NULL,
[LAST_UPGRADED] [datetime2] NULL CONSTRAINT [last_upgraded_def] DEFAULT (CONVERT([datetime2](3),getutcdate()))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_version_history] ADD CONSTRAINT [version_history_pk] PRIMARY KEY CLUSTERED ([DESCRIPTION], [RELEASE]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_version_history] TO [public]
GO
ALTER TABLE [dbo].[SDE_version_history] SET ( LOCK_ESCALATION = DISABLE )
GO
