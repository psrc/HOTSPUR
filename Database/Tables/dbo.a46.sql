CREATE TABLE [dbo].[a46]
(
[OBJECTID] [int] NOT NULL,
[PSRCEdgeID] [int] NOT NULL,
[INode] [int] NOT NULL,
[JNode] [int] NOT NULL,
[dateLastUpdated] [datetime2] NOT NULL,
[Oneway] [int] NOT NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditNotes] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GlobalEID] [int] NULL,
[Processing] [int] NULL,
[SOURCE] [numeric] (38, 8) NULL,
[AADT] [numeric] (38, 8) NULL,
[ORIG_FID] [int] NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a46] ADD CONSTRAINT [A_g17_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[a46] ADD CONSTRAINT [a46_rowid_ix1] PRIMARY KEY CLUSTERED ([OBJECTID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a46_state_ix2] ON [dbo].[a46] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [SA17_idx] ON [dbo].[a46] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1180185.4705882352, 22481.4705882353, 1425499.588235294, 387419.4705882353), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
