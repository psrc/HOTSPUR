CREATE TABLE [dbo].[SDE_process_information]
(
[sde_id] [int] NOT NULL,
[spid] [int] NOT NULL,
[server_id] [int] NOT NULL,
[start_time] [datetime] NOT NULL,
[rcount] [int] NOT NULL,
[wcount] [int] NOT NULL,
[opcount] [int] NOT NULL,
[numlocks] [int] NOT NULL,
[fb_partial] [int] NOT NULL,
[fb_count] [int] NOT NULL,
[fb_fcount] [int] NOT NULL,
[fb_kbytes] [int] NOT NULL,
[owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[direct_connect] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sysname] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[nodename] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[xdr_needed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[table_name] [nvarchar] (95) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_process_information] ADD CONSTRAINT [process_pk] PRIMARY KEY CLUSTERED ([sde_id]) WITH (FILLFACTOR=100, ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [pinfo_uk] ON [dbo].[SDE_process_information] ([spid]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_process_information] TO [public]
GO
ALTER TABLE [dbo].[SDE_process_information] SET ( LOCK_ESCALATION = DISABLE )
GO
