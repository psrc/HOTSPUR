CREATE TABLE [dbo].[SCENARIOJUNCT]
(
[OBJECTID] [int] NOT NULL,
[ANCILLARYROLE] [smallint] NULL,
[ENABLED] [smallint] NULL,
[PSRCjunctID] [int] NOT NULL,
[JunctionType] [int] NOT NULL,
[TRANSITSTOPID] [int] NULL,
[P_RStalls] [int] NULL,
[Modes] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FTRdescription] [nvarchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inServiceDate] [smallint] NOT NULL,
[outServiceDate] [smallint] NOT NULL,
[dateLastUpdated] [datetime2] NOT NULL,
[EMME2nodeID] [int] NULL,
[EMME2nodeLabel] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditNotes] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processing] [int] NULL,
[EMME2Dir] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMME2HOV] [int] NULL,
[PSRC_E2ID] [int] NULL,
[ScenarioID] [int] NULL,
[Scen_Node] [int] NULL,
[SHAPE] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCENARIOJUNCT] ADD CONSTRAINT [g2_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[SCENARIOJUNCT] ADD CONSTRAINT [R31_pk] PRIMARY KEY CLUSTERED ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [S2_idx] ON [dbo].[SCENARIOJUNCT] ([SHAPE]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1129899.8235294118, -94773.8235294118, 1582954.0588235294, 482208.5294117647), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
