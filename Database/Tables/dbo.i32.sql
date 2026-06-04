CREATE TABLE [dbo].[i32]
(
[id_type] [int] NOT NULL,
[base_id] [bigint] NOT NULL,
[num_ids] [int] NOT NULL,
[last_id] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[i32] ADD CONSTRAINT [i32_pk] PRIMARY KEY CLUSTERED ([id_type], [num_ids], [base_id]) ON [PRIMARY]
GO
