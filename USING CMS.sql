
uSE DB3
select * from [dbo].[school]

-----Using insert statement
Insert into dbo.school values (106,'Philian','Josh')

----Check index created

EXEC sys.sp_helpindex @objname = N'dbo.school' -- nvarchar(77)

-----Execute an Update on CMS
Update dbo.school set FirstName = 'Peter' where  StudentID = 101

----Create a Clustered Index

uSE DB3

CREATE INDEX IX_StudentID ON dbo.school (StudentID desc )

----Delete a row using cms
Delete from dbo.school where  StudentID =  106

-------Update statistics using CMS
use [DB3]
GO
UPDATE STATISTICS [dbo].[school] [IX_StudentID]
GO

----creating logins across multiple server using CMS

use [DB3]
GO


USE [master]
GO

CREATE LOGIN [Mary] WITH PASSWORD=N'CyMP72uq/9Z/Qw30JebQCnAB6ufiQoqzOsu4mDo3sO4=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
