CREATE TABLE [dbo].[a35]
(
[OID] [int] NOT NULL,
[OriginObjectClassName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginObjectID] [int] NULL,
[DestinationObjectClassName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestinationObjectID] [int] NULL,
[RuleType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RuleDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[isException] [int] NOT NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a35] ADD CONSTRAINT [A_g6_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[a35] ADD CONSTRAINT [a35_rowid_ix1] PRIMARY KEY CLUSTERED ([OID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a35_state_ix2] ON [dbo].[a35] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [SA6_idx] ON [dbo].[a35] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (-117104300, -99539600, 120385100, 101712900), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
