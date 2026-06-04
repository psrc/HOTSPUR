CREATE TABLE [dbo].[a50]
(
[ObjectID] [int] NOT NULL,
[OriginClassID] [int] NOT NULL,
[OriginID] [int] NULL,
[DestClassID] [int] NULL,
[DestID] [int] NULL,
[TopoRuleType] [int] NOT NULL,
[TopoRuleID] [int] NOT NULL,
[IsException] [int] NOT NULL,
[Shape] [sys].[geometry] NULL,
[GDB_GEOMATTR_DATA] [varbinary] (max) NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a50] ADD CONSTRAINT [A_g21_ck] CHECK (([Shape].[STSrid]=(2285)))
GO
ALTER TABLE [dbo].[a50] ADD CONSTRAINT [a50_rowid_ix1] PRIMARY KEY CLUSTERED ([ObjectID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GDB_123_IsExcept_a] ON [dbo].[a50] ([IsException]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a50_state_ix2] ON [dbo].[a50] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [G123multi_a] ON [dbo].[a50] ([TopoRuleID], [TopoRuleType], [OriginClassID], [OriginID], [DestClassID], [DestID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE SPATIAL INDEX [SA21_idx] ON [dbo].[a50] ([Shape]) USING geometry_auto_grid  WITH (BOUNDING_BOX = (-117104300, -99539600, 120385100, 101712900), CELLS_PER_OBJECT = 8) ON [PRIMARY]
GO
