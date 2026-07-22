IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'PSRC\NJohnson')
CREATE LOGIN [PSRC\NJohnson] FROM WINDOWS
GO
CREATE USER [PSRC\NJohnson] FOR LOGIN [PSRC\NJohnson]
GO
