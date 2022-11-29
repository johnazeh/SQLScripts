tep 1

Create an azure storage account


Step 2

Create a container

Step 3
USE master
GO
CREATE CREDENTIAL SQLBackup3 --give this a meaningful name
--storage account name:
WITH IDENTITY='ngangstorage',
--storage account key from portal:
SECRET = 'BYrz95r+Yb5gYd4OXxoU1c9YjYJb/U1gjf4Em+KVXq0QWf4tLAz0GdGux4s9XMOyW4M4rf5SbfTaqxWH69jwnw=='
GO

step 4
--back it up to Azure
--get URL from portal, add database name-date to the end of the URL
 
BACKUP DATABASE [GROUP] 
TO URL = N'https://ngangstorage.blob.core.windows.net/back1/[GROUP].bak'
WITH credential ='SQLBackup3';


BACKUP DATABASE Test
TO URL = N'https://sqlbackups12345.blob.core.windows.net/kbh-precision-2016/Test_20180114_1038am.bak'
WITH credential = 'SQLBackups';
GO
 





 
-- go see the file in the portal


-- Restore the DB to a new DB:
--use the same URL as above
-- WITH Moves to new file names
 
RESTORE DATABASE Demo --new database name
FROM URL = 'https://azehit.blob.core.windows.net/backup/Demo_10:35am.bak'
WITH CREDENTIAL = 'SQLBackup',
Move 'Demo' to 'D:\MSSQL\UATDATA\Demo_data.mdf',
Move 'Demo_log' to 'E:\MSSQL\UATLOG\Demo_log.ldf'
;
GO
;
GO