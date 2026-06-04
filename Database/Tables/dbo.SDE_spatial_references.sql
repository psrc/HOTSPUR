CREATE TABLE [dbo].[SDE_spatial_references]
(
[srid] [int] NOT NULL,
[description] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auth_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auth_srid] [int] NULL,
[falsex] [float] NOT NULL,
[falsey] [float] NOT NULL,
[xyunits] [float] NOT NULL,
[falsez] [float] NOT NULL,
[zunits] [float] NOT NULL,
[falsem] [float] NOT NULL,
[munits] [float] NOT NULL,
[xycluster_tol] [float] NULL,
[zcluster_tol] [float] NULL,
[mcluster_tol] [float] NULL,
[object_flags] [int] NOT NULL,
[srtext] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_spatial_references] ADD CONSTRAINT [spatial_ref_xyunits] CHECK (([xyunits]>=(1)))
GO
ALTER TABLE [dbo].[SDE_spatial_references] ADD CONSTRAINT [spatial_ref_zunits] CHECK (([zunits]>=(1)))
GO
ALTER TABLE [dbo].[SDE_spatial_references] ADD CONSTRAINT [spatial_ref_pk] PRIMARY KEY CLUSTERED ([srid]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_spatial_references] TO [public]
GO
ALTER TABLE [dbo].[SDE_spatial_references] SET ( LOCK_ESCALATION = DISABLE )
GO
