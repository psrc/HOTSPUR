CREATE TABLE [dbo].[TRANSITPOINTS]
(
[OBJECTID] [int] NOT NULL,
[LineID] [int] NULL,
[PointOrder] [smallint] NOT NULL,
[PSRCJunctID] [int] NOT NULL,
[timeFuncID] [smallint] NOT NULL,
[DwtStop] [smallint] NOT NULL,
[User1] [smallint] NOT NULL,
[User2] [smallint] NOT NULL,
[User3] [smallint] NOT NULL,
[UseGPOnly] [smallint] NOT NULL,
[isTimePoint] [smallint] NOT NULL,
[dateLastUpdated] [datetime2] NOT NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditNotes] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processing] [int] NULL,
[Enabled] [smallint] NULL,
[DWT] [numeric] (38, 8) NULL,
[txtDWT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_date] [datetime2] NULL,
[last_edited_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_edited_date] [datetime2] NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TRANSITPOINTS] ADD CONSTRAINT [g10_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[TRANSITPOINTS] ADD CONSTRAINT [R39_pk] PRIMARY KEY CLUSTERED ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [G111LineID] ON [dbo].[TRANSITPOINTS] ([LineID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [S10_idx] ON [dbo].[TRANSITPOINTS] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1174245.1764705882, 22822.5882352941, 1459714.7058823528, 467505.4705882353), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
