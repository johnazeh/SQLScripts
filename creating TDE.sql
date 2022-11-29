Step 1: Create Database Master Key
USE master;

CREATE MASTER KEY ENCRYPTION
       BY PASSWORD='Password1';
GO
Step 2: Create a Certificate to support TDE
USE master;

CREATE CERTIFICATE TDE_Certificate1
       WITH SUBJECT='TDEcert';
GO
Step 3: Create Database Encryption Key

use AdventureWorks2016;

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Certificate1;  


Step 4: Enable TDE on Database

Use AdventureWorks2016
ALTER DATABASE AdventureWorks2016 SET ENCRYPTION ON;

Step 5: Backup the Certificate
This step is not required to encrypt a database using TDE.  But to make sure you can recover your encrypted data from a database backup, should your instance database become corrupted, or you want to move an encrypted database to another server, you should backup the certificate.  To accomplish that backup run the following code:

USE master;

BACKUP CERTIFICATE TDE_Certificate
TO FILE = 'X:\BACKUPDEV\TDE\AdventureWorks2016\TDE_Certificate1_AdventureWorks2016.cert'
WITH PRIVATE KEY (file='X:\BACKUPDEV\TDE\AdventureWorks2016\TDE_Certificate1Key.pvk',
ENCRYPTION BY PASSWORD='Password1');


------Steps to Restore TDE encrypted database
Use AdventureWorks2016
ALTER DATABASE  AdventureWorks2016
  SET ENCRYPTION OFF;

  -----Take a fullbackup  of database copy and paste it in the destination folder 

  -----Run this on destination server to create the database master key 
CREATE MASTER KEY
  ENCRYPTION BY PASSWORD = 'Password1';

  USE master
Go
DROP MASTER KEY;
GO

USE master
Go
DROP CERTIFICATE [TDE_Certificate];
Go

------Create a certificate
USE master;

CREATE CERTIFICATE TDE_Certificate1
       WITH SUBJECT='TDEcert';



------Copy and paste master key and certificate key to destination folder


-- Restoring the certificate and the private key on destination server
CREATE CERTIFICATE TDE_Certificate1
FROM FILE = 'X:\BACKUPDEV\TDE\AdventureWorks2016\TDE_Certificate1_AdventureWorks2016.cert'
WITH PRIVATE KEY (file='X:\BACKUPDEV\TDE\AdventureWorks2016\TDE_Certificate1Key.pvk',
DECRYPTION BY PASSWORD='Password1');


------ Finally Restore database


