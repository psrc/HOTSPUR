CREATE TABLE [dbo].[TBLEDGEFACILITY]
(
[OBJECTID] [int] NOT NULL,
[FacilityID] [int] NOT NULL,
[FacilityName] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fprefix] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Ftype] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fsuffix] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AgencyOwner] [smallint] NULL,
[AgencyMaintainer] [smallint] NULL,
[Processing] [int] NOT NULL,
[dateLastUpdated] [datetime2] NULL,
[DateCreated] [datetime2] NULL,
[LastEditor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditNotes] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [G92FacilityID] ON [dbo].[TBLEDGEFACILITY] ([FacilityID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [R22_SDE_ROWID_UK] ON [dbo].[TBLEDGEFACILITY] ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
