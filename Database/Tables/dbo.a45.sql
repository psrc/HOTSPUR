CREATE TABLE [dbo].[a45]
(
[OBJECTID] [int] NOT NULL,
[PRassetID] [int] NOT NULL,
[PSRCJunctID] [int] NULL,
[LotName] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[stallsBaseYr] [int] NULL,
[utlizationBaseYr] [smallint] NULL,
[agencyOwner] [smallint] NULL,
[agencyMaintainer] [smallint] NULL,
[address1] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address2] [nvarchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressCity] [nvarchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressZip] [int] NULL,
[service] [smallint] NULL,
[fee] [smallint] NULL,
[Boeing] [smallint] NULL,
[inServiceDate] [smallint] NOT NULL,
[outServiceDate] [smallint] NOT NULL,
[dateLastUpdated] [datetime2] NOT NULL,
[Processing] [int] NOT NULL,
[Enabled] [smallint] NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a45] ADD CONSTRAINT [A_g16_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[a45] ADD CONSTRAINT [a45_rowid_ix1] PRIMARY KEY CLUSTERED ([OBJECTID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a45_state_ix2] ON [dbo].[a45] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [SA16_idx] ON [dbo].[a45] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1142591.8823529412, 34324.5294117647, 1427120.5294117648, 465696.1176470588), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
