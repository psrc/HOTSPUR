CREATE TABLE [dbo].[a28]
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
[Slope] [int] NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a28] ADD CONSTRAINT [a28_rowid_ix1] PRIMARY KEY NONCLUSTERED ([OBJECTID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [G98PSRCEdgeID_a] ON [dbo].[a28] ([PSRCEdgeID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a28_state_ix2] ON [dbo].[a28] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
