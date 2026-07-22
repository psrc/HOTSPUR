IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'PSRC\HShepard')
CREATE LOGIN [PSRC\HShepard] FROM WINDOWS
GO
CREATE USER [PSRC\HShepard] FOR LOGIN [PSRC\HShepard]
GO
