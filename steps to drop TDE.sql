-----step 1
USE MASTER
GO
ALTER DATABASE[AdventureWorks2017]
SET ENCRYPTION OFF
GO
----step 2
USE [AdventureWorks2017]
GO
DROP DATABASE ENCRYPTION KEY
GO

---step 3

USE master
DROP CERTIFICATE[TDE_Certificate]

-----step 4
USE master;  
DROP MASTER KEY;  
GO  