-- =======================================================================================
-- Create User as DBO template for Azure SQL Database and Azure Synapse Analytics Database
-- =======================================================================================
-- For login <login_name, sysname, login_name>, create a user in the database
CREATE USER johnazeh1
	FOR LOGIN johnazeh1
	WITH DEFAULT_SCHEMA =  dbo
GO

-- Add user to the database owner role
EXEC sp_addrolemember N'db_datareader', N'johnazeh1'
GO
