BACKUP DATABASE [Demo0101]

TO URL = N'https://demoblgstg.blob.core.windows.net/demobackups/Demo0101.bak'

WITH NOFORMAT, NOINIT, NAME = N'[Demo-0101]-Full Database Backup', NOSKIP, NOREWIND, NOUNLOAD,STATS = 10

 



 RESTORE DATABASE [Demo0101]

FROM  URL = N'https://demoblgstg.blob.core.windows.net/demobackups/Demo0101.bak'
WITH  FILE = 1, 

MOVE N'Demo0101_Data' TO N'Z:\MSSQL\Demo0101_Data.mdf', 


MOVE N'Demo0101_Log' TO N'Y:\MSSQL\Demo0101_Log.ldf', 

NOUNLOAD,  STATS = 5

 

GO