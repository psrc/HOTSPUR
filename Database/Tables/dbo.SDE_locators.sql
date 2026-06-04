CREATE TABLE [dbo].[SDE_locators]
(
[locator_id] [int] NOT NULL,
[name] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[category] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [int] NOT NULL,
[description] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_locators] ADD CONSTRAINT [sdelocators_pk] PRIMARY KEY CLUSTERED ([locator_id]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_locators] ADD CONSTRAINT [sdelocators_uk] UNIQUE NONCLUSTERED ([name], [owner]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_locators] TO [public]
GO
ALTER TABLE [dbo].[SDE_locators] SET ( LOCK_ESCALATION = DISABLE )
GO
