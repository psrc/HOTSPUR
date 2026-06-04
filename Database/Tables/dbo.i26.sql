CREATE TABLE [dbo].[i26]
(
[id_type] [int] NOT NULL,
[base_id] [bigint] NOT NULL,
[num_ids] [int] NOT NULL,
[last_id] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[i26] ADD CONSTRAINT [i26_pk] PRIMARY KEY CLUSTERED ([id_type], [num_ids], [base_id]) ON [PRIMARY]
GO
