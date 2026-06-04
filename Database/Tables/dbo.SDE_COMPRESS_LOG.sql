CREATE TABLE [dbo].[SDE_COMPRESS_LOG]
(
[compress_id] [int] NOT NULL,
[sde_id] [int] NOT NULL,
[server_id] [int] NOT NULL,
[direct_connect] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[compress_start] [datetime2] NOT NULL,
[start_state_count] [int] NOT NULL,
[compress_end] [datetime2] NULL,
[end_state_count] [int] NULL,
[compress_status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [R30_SDE_ROWID_UK] ON [dbo].[SDE_COMPRESS_LOG] ([compress_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
