CREATE TABLE [dbo].[a36]
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
ALTER TABLE [dbo].[a36] ADD CONSTRAINT [A_g7_ck] CHECK (([SHAPE].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[a36] ADD CONSTRAINT [a36_rowid_ix1] PRIMARY KEY CLUSTERED ([OID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a36_state_ix2] ON [dbo].[a36] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [SA7_idx] ON [dbo].[a36] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (1174210.6470588236, -82858.8235294117, 1452648.6470588236, 460142.8823529412), CELLS_PER_OBJECT = 16) ON [PRIMARY]
GO
