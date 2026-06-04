CREATE TABLE [dbo].[TURNMOVEMENTS]
(
[OBJECTID] [int] NOT NULL,
[TurnID] [int] NOT NULL,
[PSRCJunctID] [int] NOT NULL,
[FrEdgeID] [int] NOT NULL,
[ToEdgeID] [int] NOT NULL,
[InServiceDate] [smallint] NOT NULL,
[OutServiceDate] [smallint] NOT NULL,
[FunctionAM] [smallint] NOT NULL,
[FunctionMD] [smallint] NOT NULL,
[FunctionPM] [smallint] NOT NULL,
[FunctionEV] [smallint] NOT NULL,
[FunctionNI] [smallint] NOT NULL,
[user1AM] [int] NOT NULL,
[user1MD] [int] NOT NULL,
[user1PM] [int] NOT NULL,
[user1EV] [int] NOT NULL,
[user1NI] [int] NOT NULL,
[user2AM] [numeric] (7, 2) NOT NULL,
[user2MD] [numeric] (7, 2) NOT NULL,
[user2PM] [numeric] (7, 2) NOT NULL,
[user2EV] [numeric] (7, 2) NOT NULL,
[user2NI] [numeric] (7, 2) NOT NULL,
[user3AM] [int] NOT NULL,
[user3MD] [int] NOT NULL,
[user3PM] [int] NOT NULL,
[user3EV] [int] NOT NULL,
[user3NI] [int] NOT NULL,
[ModesProhibited] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjID] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjDBS] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateLastUpdated] [datetime2] NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditNotes] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processing] [int] NOT NULL,
[Enabled] [smallint] NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TURNMOVEMENTS] ADD CONSTRAINT [g8_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[TURNMOVEMENTS] ADD CONSTRAINT [R37_pk] PRIMARY KEY CLUSTERED ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [S8_idx] ON [dbo].[TURNMOVEMENTS] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1177717.8235294118, -14741.8823529412, 1412110.8235294118, 455211.5294117647), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
