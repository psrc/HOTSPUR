CREATE TABLE [dbo].[SDE_metadata]
(
[record_id] [int] NOT NULL,
[object_name] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[object_owner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[object_type] [int] NOT NULL,
[class_name] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[property] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prop_value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creation_date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SDE_metadata] ADD CONSTRAINT [sdemetadata_pk] PRIMARY KEY CLUSTERED ([record_id]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[SDE_metadata] TO [public]
GO
