CREATE TABLE [dbo].[i24]
(
[id_type] [int] NOT NULL,
[base_id] [bigint] NOT NULL,
[num_ids] [int] NOT NULL,
[last_id] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[i24] ADD CONSTRAINT [i24_pk] PRIMARY KEY CLUSTERED ([id_type], [num_ids], [base_id]) ON [PRIMARY]
GO
