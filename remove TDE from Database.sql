SELECT DB_Name(database_id) As [DB Name, encryption_state, encryption_state_desc]
FROM sys.dm_database_encryption_keys
GO
SELECT name, is_encrypted
FROM sys.databases
Go


-----You can also see the associated certificate TDE_Certificate in the left side pane of the above image. Now, we must remove TDE from the user database AdventureWorks2017 on this SQL Server instance. Let’s follow the same sequence I have mentioned above.

----The first step to remove the TDE from any SQL Server database is to turn it off by executing the below ALTER statement.

-- Replace “AdventureWorks2017” with your target user database name
USE master;
GO
ALTER DATABASE AdventureWorks2017 SET ENCRYPTION OFF;
GO

------We can also turn off TDE using GUI by accessing the database properties window. You just need to launch the database properties window in SQL Server management studio and then click on the “Options” tab from the left side pane. You can see the “Encryption Enabled” option set as True in the state section in the right-side pane. Just choose False from the drop-down for this setting and click on the OK button to apply this change. You have disabled TDE using GUI for a SQL Server database


--------if you don’t want to remove the database master key and associated certificate, then you can go ahead and restart the SQL Server service to remove encryption from the tempdb database as well. I have restarted the SQL Server instance and then checked the Transparent Data Encryption status again.


----Once you have turned off TDE from the user database, run the below T-SQL statement to drop the database encryption key.

-- Drop Database Encryption key
USE AdventureWorks2017;
GO
DROP DATABASE ENCRYPTION KEY;
GO

------The database encryption key is dropped now. Let’s check the TDE status for the user database again to ensure whether it is still there in the above DMV output or not. I have executed the same T-SQL statements to check the Transparent Data Encryption state for this database post removing the database encryption key.

SELECT DB_Name(database_id) As [DB Name, encryption_state, encryption_state_desc]
FROM sys.dm_database_encryption_keys
GO
SELECT name, is_encrypted
FROM sys.databases
Go



------We can see there is no entry in this DMV now. It means Transparent Data Encryption has been removed from this user database completely but some of its associated files are still there in the master database that is master key and its certificate. If you are using the master key and same certificates to encrypt any other user database, then you should not remove them and leave them as it is. But if you want to completely remove TDE and its master key\certificates because you don’t have any database encrypted using TDE on your SQL Server instance then you must also remove them to clean your system. Next, I will show you how to remove its master key and certificate to clean Transparent Data Encryption components from SQL Server instance.


---Drop TDE certificate from MASTER database
---Run the below T-SQL statement to drop the TDE certificate that was created to encrypt the database TDE_DB.

-- Drop Certificate
USE master
Go
DROP CERTIFICATE TDE_Certificate;
Go

------I have refreshed the master database and then expanded the security folder to see the associated certificate and we cannot see our target certificate TDE_DB_Cert in the above image. The last step to complete the Transparent Data Encryption removal process is to drop its master key.


--Drop MASTER KEY
--The master key in TDE is used to protect the certificates associated with TDE encryption. As we have already decided to disable TDE from SQL Server and removed associated certificates in the above steps so there is no use in keeping the database master key on the SQL Server instance.

--Let’s remove the master key by running the below T-SQL statement from the master database.

-- Drop master key
USE master
Go
DROP MASTER KEY;
GO

----The above T-SQL will drop the database master key and with this step, you are done with the Transparent Data Encryption removal process.

---If you have not restarted the SQL Server service as I suggested in the section “Turn OFF TDE” then you can now restart the SQL Server service to create new files for the tempdb database without having TDE configuration.

---You must immediately run a full backup of your unencrypted databases to ensure you have a healthy backup without any key or certificate. Now, you can go ahead and perform activities for which you have decided to remove TDE from your SQL Server user database.