CREATE TABLE [dbo].[a48]
(
[OBJECTID] [int] NOT NULL,
[ANCILLARYROLE] [smallint] NULL,
[ENABLED] [smallint] NULL,
[PSRCjunctID] [int] NULL,
[JunctionType] [int] NULL,
[TRANSITSTOPID] [int] NULL,
[P_RStalls] [int] NULL,
[Modes] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTRdescription] [nvarchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inServiceDate] [smallint] NULL,
[outServiceDate] [smallint] NULL,
[dateLastUpdated] [datetime2] NULL,
[EMME2nodeID] [int] NULL,
[EMME2nodeLabel] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditNotes] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processing] [int] NULL,
[EMME2Dir] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMME2HOV] [int] NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a48] ADD CONSTRAINT [A_g19_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[a48] ADD CONSTRAINT [a48_rowid_ix1] PRIMARY KEY CLUSTERED ([OBJECTID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a48_state_ix2] ON [dbo].[a48] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [SA19_idx] ON [dbo].[a48] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1063211.4705882352, -173715.8823529412, 1846505.294117647, 557871.1176470588), CELLS_PER_OBJECT = 8) ON [PRIMARY]
GO
