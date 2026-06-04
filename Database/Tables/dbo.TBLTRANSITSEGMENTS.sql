CREATE TABLE [dbo].[TBLTRANSITSEGMENTS]
(
[OBJECTID] [int] NOT NULL,
[LineID] [int] NULL,
[Path] [smallint] NOT NULL,
[PSRCEdgeID] [int] NOT NULL,
[Inode] [int] NOT NULL,
[Jnode] [int] NOT NULL,
[timeFuncID] [smallint] NOT NULL,
[DwtStop] [smallint] NOT NULL,
[Layover] [smallint] NOT NULL,
[User1] [smallint] NOT NULL,
[User3] [smallint] NOT NULL,
[User2] [smallint] NOT NULL,
[SegOrder] [smallint] NOT NULL,
[UseGPOnly] [smallint] NOT NULL,
[isTimePoint] [smallint] NOT NULL,
[change] [int] NULL
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [R23_SDE_ROWID_UK] ON [dbo].[TBLTRANSITSEGMENTS] ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
