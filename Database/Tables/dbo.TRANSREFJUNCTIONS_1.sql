CREATE TABLE [dbo].[TRANSREFJUNCTIONS_1]
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
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TRANSREFJUNCTIONS_1] ADD CONSTRAINT [g4_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[TRANSREFJUNCTIONS_1] ADD CONSTRAINT [R33_pk] PRIMARY KEY CLUSTERED ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [S4_idx] ON [dbo].[TRANSREFJUNCTIONS_1] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1102285.7647058824, -96507, 1582954.0588235294, 482208.5294117647), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
