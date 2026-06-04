CREATE TABLE [dbo].[a20]
(
[OBJECTID] [int] NOT NULL,
[projRteID] [int] NULL,
[projDBS] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[projID] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[version] [smallint] NOT NULL,
[PSRCJunctID] [int] NOT NULL,
[InServiceDate] [smallint] NOT NULL,
[OutServiceDate] [smallint] NULL,
[CompletedDate] [datetime2] NULL,
[M] [numeric] (9, 2) NOT NULL,
[P_RStalls] [int] NULL,
[Modes] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewOwner] [smallint] NULL,
[NewMaintainer] [smallint] NULL,
[dateLastUpdated] [datetime2] NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditNotes] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processing] [int] NULL,
[SDE_STATE_ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[a20] ADD CONSTRAINT [a20_rowid_ix1] PRIMARY KEY NONCLUSTERED ([OBJECTID], [SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [G90projRteID_a] ON [dbo].[a20] ([projRteID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [a20_state_ix2] ON [dbo].[a20] ([SDE_STATE_ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
