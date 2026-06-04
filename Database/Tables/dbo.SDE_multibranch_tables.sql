CREATE TABLE [dbo].[SDE_multibranch_tables]
(
[registration_id] [int] NOT NULL,
[start_moment] [datetime2] (3) NOT NULL CONSTRAINT [start_moment_def] DEFAULT (CONVERT([datetime2](3),getutcdate())),
[behavior_map] [binary] (16) NOT NULL CONSTRAINT [behavior_map_def] DEFAULT (0x00),
[properties] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_multibranch_tables] ADD CONSTRAINT [registration_id_pk] PRIMARY KEY CLUSTERED ([registration_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_multibranch_tables] ADD CONSTRAINT [mb_ref_fk] FOREIGN KEY ([registration_id]) REFERENCES [dbo].[SDE_table_registry] ([registration_id]) ON DELETE CASCADE
GO
GRANT SELECT ON  [dbo].[SDE_multibranch_tables] TO [public]
GO
ALTER TABLE [dbo].[SDE_multibranch_tables] SET ( LOCK_ESCALATION = DISABLE )
GO
