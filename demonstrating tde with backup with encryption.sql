-- create a new database for this example
CREATE DATABASE Demoshack;
GO
USE Demoshack;
GO
-- insert some data
CREATE TABLE DemoshackTable (
    ID int IDENTITY(1,1000) PRIMARY KEY NOT NULL,
    value int
);
GO
CREATE PROCEDURE InsertDemoshackTable
AS
DECLARE @i int = 1
WHILE @i <100
    BEGIN
        INSERT DemoshackTable (value) VALUES (@i)
        Set @i +=1
    END
GO
EXECUTE InsertDemoshackTable;
GO
SELECT * FROM DemoshackTable;
GO


-------Drop master key

Drop master key


USE MASTER;
GO
-- create master key and certificate
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '!@Api1401@2015!!';
GO


----create certificate
CREATE CERTIFICATE DemoshackDBCert
    WITH SUBJECT = 'DemoshackDB Backup Certificate';
GO
 

 -- export the backup certificate to a file
BACKUP CERTIFICATE DemoshackDBCert TO FILE = 'X:\Certificate\Demoshack\DemoshackDBCert.cert'
WITH PRIVATE KEY (
FILE = 'X:\Certificate\Demoshack\DemoshackDBCert.key',
ENCRYPTION BY PASSWORD = 'Api1401@2015!!')


-- backup the database with encryption

BACKUP DATABASE [Demoshack] TO  DISK = N'X:\MSSQL\Demoshack.bak' 

WITH ENCRYPTION (ALGORITHM = AES_256, SERVER CERTIFICATE = DemoshackDBCert) 

-- insert additional records
USE Demoshack;
GO
EXECUTE InsertDemoshackTable;

-----Insert sample data
-----Simulate database corruption by detaching the database
-----Delete the file from the drive
------Bring the database back online
----Refresh the database
----Initiate the Tail Log backup with database encryption


-- take SQLShack offline
 
ALTER DATABASE Demoshack SET OFFLINE WITH  ROLLBACK IMMEDIATE
 
-- delete .mdf data file from the hard drive



-- attempt to take TailLogDB online
 
USE master;
GO
BACKUP LOG Demoshack
TO DISK = 'Y:\MSSQL\DemoshackTailLogDB.log'
WITH CONTINUE_AFTER_ERROR,ENCRYPTION (ALGORITHM = AES_256, SERVER CERTIFICATE = DemoshackDBCert)
 



 ---------Check the backup meta-data
-----If you use encryption during the backup you wouldn’t be able to append the backup to an existing media set. The restoration just works like normal restoration steps, except ensuring the corresponding certificates are created and configured on the destination server.

 --Check for the backup
 
SELECT 
 b.database_name,
    key_algorithm,
    encryptor_thumbprint,
    encryptor_type,
	b.media_set_id,
    is_encrypted, 
	type,
    is_compressed,
	bf.physical_device_name
	 FROM msdb.dbo.backupset b
INNER JOIN msdb.dbo.backupmediaset m ON b.media_set_id = m.media_set_id
INNER JOIN msdb.dbo.backupmediafamily bf on bf.media_set_id=b.media_set_id
WHERE database_name = 'Demoshack'
ORDER BY b.backup_start_date  DESC


---We have four new files that have just been created. We have the backup certificate, the encryption key file, as well as the full backup and the tail log backup of our database. Let’s go back into SQL Server Management Studio and see how we can restore this backup.

 
-- clean up the instance
 
DROP DATABASE Demoshack;
GO
DROP CERTIFICATE DemoshackDBCert;
GO
DROP MASTER KEY;
GO

------Without configuring the certificate, any attempt to restore would result in the following error:

 
--Use RESTORE FILELISTONLY to get the logical names of the data files in the backup. This is especially useful when you’re working with an unfamiliar backup file.
 
RESTORE FILELISTONLY FROM DISK='X:\MSSQL\Demoshack.bak'

--Msg 33111, Level 16, State 3, Line 125
---Cannot find server certificate with thumbprint '0x46383B86CF852B2C4A6F6ADDDA8CF7A25D78B7A9'.
---Msg 3013, Level 16, State 1, Line 125
---RESTORE FILELIST is terminating abnormally.



----Recreate the master key and the certificates
---In order to restore this encrypted database, we first need to restore the certificate. But this time, instead of creating it based off of the master key for the database, we’re going to restore it from the file. I’ll specify FROM FILE and the path to that file that we exported. We’ll also specify the private key file. Finally, we’ll enter DECRYPTION BY PASSWORD and we’ll re-specify the password that we established earlier when we created that key. After execution, if I go back into System Databases -> master, -> Security, and back to Certificates, we should see the DemoshackDBCert certificate back there.

-- recreate master key and certificate
 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '!@Api1401@2015!!';
GO
-- restore the certificate
CREATE CERTIFICATE DemoshackDBCert
FROM FILE = 'X:\Certificate\Demoshack\DemoshackDBCert.cert'
WITH PRIVATE KEY (FILE = 'X:\Certificate\Demoshack\DemoshackDBCert.key',
DECRYPTION BY PASSWORD = 'Api1401@2015!!');
GO


-------Database Restoration
----Now, go ahead and try the restore again, the RESTORE DATABASE SQLShack from the disk file. Execute the command, and voila, it processed successfully this time! We see that the database, SQLShack, came online

 
--Use RESTORE WITH MOVE to move and/or rename database files to a new path.
 
 USE [master]
RESTORE DATABASE [Demoshack] FROM  DISK = N'X:\MSSQL\Demoshack.bak' WITH  NORECOVERY, MOVE 'Demoshack' TO 'Z:\MSSQL\Demoshack_Data.mdf',
MOVE 'Demoshack_log' TO 'Y:\MSSQL\Demoshack_Log.ldf',

REPLACE,  STATS = 5

-- attempt the restore log again
RESTORE LOG Demoshack
FROM DISK = 'Y:\MSSQL\DemoshackTailLogDB.log';
GO