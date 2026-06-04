CREATE TABLE [dbo].[a42]
(
[OBJECTID] [int] NOT NULL,
[LineID] [int] NOT NULL,
[TimePeriod] [smallint] NOT NULL,
[TransLineNo] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VehicleType] [smallint] NOT NULL,
[Headway] [numeric] (6, 2) NULL,
[Speed] [numeric] (5, 2) NULL,
[Operator] [smallint] NOT NULL,
[InServiceDate] [smallint] NOT NULL,
[OutServiceDate] [smallint] NOT NULL,
[Seats] [smallint] NULL,
[CapacityVehicles] [smallint] NULL,
[ProjID] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjDBS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Path] [smallint] NULL,
[dateLastUpdated] [datetime2] NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditNotes] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processing] [int] NOT NULL,
[Enabled] [smallint] NULL,
[UL2] [smallint] NULL,
[Headway_AM] [numeric] (38, 8) NULL,
[Headway_MD] [numeric] (38, 8) NULL,
[Headway_PM] [numeric] (38, 8) NULL,
[Headway_EV] [numeric] (38, 8) NULL,
[Headway_NI] [numeric] (38, 8) NULL,
[light_rail] [smallint] NULL,
[TransitType] [smallint] NULL,
[RouteID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepTripID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_date] [datetime2] NULL,
[last_edited_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_edited_date] [datetime2] NULL,
[Version] [int] NULL,
[frequent] [smallint] NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a42] ADD CONSTRAINT [A_g13_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[a42] ADD CONSTRAINT [a42_rowid_ix1] PRIMARY KEY CLUSTERED ([OBJECTID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [G114LineID_a] ON [dbo].[a42] ([LineID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a42_state_ix2] ON [dbo].[a42] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [SA13_idx] ON [dbo].[a42] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1174245.1764705882, 22822.4705882353, 1459714.7058823528, 467867.9411764706), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
