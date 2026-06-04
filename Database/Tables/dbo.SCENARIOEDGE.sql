CREATE TABLE [dbo].[SCENARIOEDGE]
(
[OBJECTID] [int] NOT NULL,
[Enabled] [smallint] NULL,
[PSRCEdgeID] [int] NOT NULL,
[FTRsegID] [int] NULL,
[FacilityType] [int] NOT NULL,
[NewFacilityType] [int] NULL,
[INode] [int] NOT NULL,
[JNode] [int] NOT NULL,
[InServiceDate] [smallint] NOT NULL,
[OutServiceDate] [smallint] NOT NULL,
[dateLastUpdated] [datetime2] NOT NULL,
[ActiveLink] [smallint] NOT NULL,
[LinkType] [smallint] NULL,
[FunctionalClass] [int] NOT NULL,
[Modes] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MTS] [int] NOT NULL,
[CMSlinkID] [int] NULL,
[CMScriticalLinkID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Oneway] [int] NOT NULL,
[Fullname] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditNotes] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tonnage] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GlobalEID] [int] NULL,
[Processing] [int] NULL,
[PSRC_E2ID] [int] NULL,
[ScenarioID] [int] NULL,
[Scen_Link] [int] NULL,
[TR_I] [int] NULL,
[TR_J] [int] NULL,
[HOV_I] [int] NULL,
[HOV_J] [int] NULL,
[TK_I] [int] NULL,
[TK_J] [int] NULL,
[UseEmmeN] [int] NULL,
[SplitHOV] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplitTR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplitTK] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Updated1] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prjRte] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shptype] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dissolve] [int] NULL,
[Direction] [int] NULL,
[CountID] [int] NULL,
[CountyID] [smallint] NULL,
[StateRoute] [int] NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCENARIOEDGE] ADD CONSTRAINT [g24_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[SCENARIOEDGE] ADD CONSTRAINT [R53_pk] PRIMARY KEY CLUSTERED ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [S24_idx] ON [dbo].[SCENARIOEDGE] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1129899.8235294118, -96661.2352941177, 1582954.0588235294, 482208.5294117647), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
