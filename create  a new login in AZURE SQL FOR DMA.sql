create user [DBA_TEAM] from external provider


exec sp_addrolemember[db_owner],[DBA_TEAM]

CREATE LOGIN johnazeh  WITH PASSWORD = 'Tumenta01'  
GO

CREATE USER johnazeh  FOR LOGIN johnazeh  
GO
EXEC sp_addrolemember N'db_owner', N'johnazeh'  
GO