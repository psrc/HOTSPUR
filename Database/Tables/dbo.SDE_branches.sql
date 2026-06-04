CREATE TABLE [dbo].[SDE_branches]
(
[name] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[owner] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[description] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [int] NOT NULL,
[creation_time] [datetime2] (3) NOT NULL CONSTRAINT [creation_time_def] DEFAULT (CONVERT([datetime2](3),getutcdate())),
[branch_id] [int] NOT NULL IDENTITY(0, 1),
[branch_moment] [datetime2] (3) NOT NULL CONSTRAINT [branch_moment_def] DEFAULT (CONVERT([datetime2](3),getutcdate())),
[ancestor_moment] [datetime2] (3) NOT NULL CONSTRAINT [ancestor_moment_def] DEFAULT (CONVERT([datetime2](3),getutcdate())),
[previous_ancestor_moment] [datetime2] (3) NULL,
[last_reconcile_moment] [datetime2] (3) NULL,
[validation_moment] [datetime2] (3) NULL,
[service_name] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[branch_guid] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[sde_branches_delete_tg] ON [dbo].[SDE_branches] FOR DELETE AS 
BEGIN 
  SET NOCOUNT ON 
  DELETE dbo.SDE_branch_tables_modified FROM dbo.SDE_branch_tables_modified INNER JOIN deleted ON dbo.SDE_branch_tables_modified.branch_id = deleted.branch_id 
END
GO
ALTER TABLE [dbo].[SDE_branches] ADD CONSTRAINT [br_pk] PRIMARY KEY CLUSTERED ([branch_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [branch_bg_uk] ON [dbo].[SDE_branches] ([branch_guid]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_branches] ADD CONSTRAINT [br_uk] UNIQUE NONCLUSTERED ([owner], [name], [service_name]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [branch_sn_idx] ON [dbo].[SDE_branches] ([service_name]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_branches] TO [public]
GO
ALTER TABLE [dbo].[SDE_branches] SET ( LOCK_ESCALATION = DISABLE )
GO
