---create login
CREATE LOGIN DBA WITH PASSWORD = 'Password1'

-- Create the database role
CREATE ROLE [TruRW] AUTHORIZATION [dbo]
GO


-- Add an existing user to the role

EXEC sp_addrolemember N'TruRW', N'DBA'
GO




