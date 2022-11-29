

----Check TDE on SQL Server Instance

SELECT encryption_state, encryption_state_desc
FROM sys.dm_database_encryption_keys
GO
SELECT name, is_encrypted
FROM sys.databases
Go

USE master;
GO
ALTER DATABASE [tempdb] SET ENCRYPTION OFF;
GO

------REMOVE TDE ON TEMPDB USING GUI  GO TO DATABASE PROPERTY - OPTION -- SWITCH
----TRUE TO FALSE 

-- Drop Database Encryption key
USE [AdventureWorks2016];
GO
DROP DATABASE ENCRYPTION KEY;
GO

----CHANGE STATUS AGAIN
SELECT encryption_state, encryption_state_desc
FROM sys.dm_database_encryption_keys
GO
SELECT name, is_encrypted
FROM sys.databases
Go

-----It means Transparent Data Encryption has been removed from this user database completely but some of its associated files are still there in the master database that is master key and its certificate. If you are using the master key and same certificates to encrypt any other user database, then you should not remove them and leave them as it is. But if you want to completely remove TDE and its master key\certificates because you don’t have any database encrypted using TDE on your SQL Server instance then you must also remove them to clean your system.

------Drop TDE certificate from MASTER database
-- Drop Certificate
USE master
Go
DROP CERTIFICATE [TDE_Certificate];
Go

---The last step to complete the Transparent Data Encryption removal process is to drop its master key.
-- Drop master key
USE master
Go
DROP MASTER KEY;
GO

------TURN ECRYPTION OFF
USE MASTER
GO
ALTER DATABASE [AdventureWorks2016]
SET ENCRYPTION OFF
GO

------The above T-SQL will drop the database master key and with this step, you are done with the Transparent Data Encryption removal process.

----If you have not restarted the SQL Server service as I suggested in the section “Turn OFF TDE” then you can now restart the SQL Server service to create new files for the tempdb database without having TDE configuration.
