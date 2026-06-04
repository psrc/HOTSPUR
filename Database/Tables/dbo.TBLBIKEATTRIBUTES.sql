CREATE TABLE [dbo].[TBLBIKEATTRIBUTES]
(
[OBJECTID] [int] NOT NULL,
[PSRCEdgeID] [int] NULL,
[ijBikeFacil] [smallint] NOT NULL,
[jiBikeFacil] [smallint] NOT NULL,
[ijSignedBikeRoutes] [smallint] NULL,
[jiSignedBikeRoutes] [smallint] NULL,
[SurfaceType] [smallint] NULL,
[Width] [int] NULL,
[RegionalBikeNet] [smallint] NULL,
[RegBikeNetTier] [smallint] NULL,
[Slope] [int] NULL
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [R28_SDE_ROWID_UK] ON [dbo].[TBLBIKEATTRIBUTES] ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [G98PSRCEdgeID] ON [dbo].[TBLBIKEATTRIBUTES] ([PSRCEdgeID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
