CREATE TABLE [dbo].[i20]
(
[id_type] [int] NOT NULL,
[base_id] [bigint] NOT NULL,
[num_ids] [int] NOT NULL,
[last_id] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[i20] ADD CONSTRAINT [i20_pk] PRIMARY KEY CLUSTERED ([id_type], [num_ids], [base_id]) ON [PRIMARY]
GO
