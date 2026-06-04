SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dbtune] as select * from dbo.SDE_dbtune
GO
GRANT SELECT ON  [dbo].[dbtune] TO [public]
GO
