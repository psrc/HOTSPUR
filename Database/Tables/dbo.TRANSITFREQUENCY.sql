CREATE TABLE [dbo].[TRANSITFREQUENCY]
(
[OBJECTID] [int] NOT NULL,
[rep_trip] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hour_2] [numeric] (38, 8) NULL,
[hour_3] [numeric] (38, 8) NULL,
[hour_4] [numeric] (38, 8) NULL,
[hour_5] [numeric] (38, 8) NULL,
[hour_6] [numeric] (38, 8) NULL,
[hour_7] [numeric] (38, 8) NULL,
[hour_8] [numeric] (38, 8) NULL,
[hour_9] [numeric] (38, 8) NULL,
[hour_10] [numeric] (38, 8) NULL,
[hour_11] [numeric] (38, 8) NULL,
[hour_12] [numeric] (38, 8) NULL,
[hour_13] [numeric] (38, 8) NULL,
[hour_14] [numeric] (38, 8) NULL,
[hour_15] [numeric] (38, 8) NULL,
[hour_16] [numeric] (38, 8) NULL,
[hour_17] [numeric] (38, 8) NULL,
[hour_18] [numeric] (38, 8) NULL,
[hour_19] [numeric] (38, 8) NULL,
[hour_20] [numeric] (38, 8) NULL,
[hour_21] [numeric] (38, 8) NULL,
[hour_22] [numeric] (38, 8) NULL,
[hour_23] [numeric] (38, 8) NULL,
[LineID] [int] NULL,
[hour_24] [numeric] (38, 8) NULL,
[hour_25] [numeric] (38, 8) NULL,
[hour_26] [numeric] (38, 8) NULL,
[hour_27] [numeric] (38, 8) NULL,
[hour_28] [numeric] (38, 8) NULL
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [R24_SDE_ROWID_UK] ON [dbo].[TRANSITFREQUENCY] ([OBJECTID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
