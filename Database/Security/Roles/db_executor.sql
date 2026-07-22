CREATE ROLE [db_executor]
AUTHORIZATION [dbo]
GO
ALTER ROLE [db_executor] ADD MEMBER [PSRC\HShepard]
GO
ALTER ROLE [db_executor] ADD MEMBER [PSRC\KThomas]
GO
GRANT EXECUTE TO [db_executor]
