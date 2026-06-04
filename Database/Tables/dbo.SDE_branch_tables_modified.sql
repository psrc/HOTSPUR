CREATE TABLE [dbo].[SDE_branch_tables_modified]
(
[branch_id] [int] NOT NULL,
[edit_moment] [datetime2] (3) NOT NULL,
[registration_id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_branch_tables_modified] ADD CONSTRAINT [btm_pk] PRIMARY KEY CLUSTERED ([branch_id], [edit_moment], [registration_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_branch_tables_modified] TO [public]
GO
ALTER TABLE [dbo].[SDE_branch_tables_modified] SET ( LOCK_ESCALATION = DISABLE )
GO
