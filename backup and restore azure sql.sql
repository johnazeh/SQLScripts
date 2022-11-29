BACKUP DATABASE [Demo0101]

TO URL = N'https://demoblgstg.blob.core.windows.net/demobackups/Demo0101.bak'

WITH NOFORMAT, NOINIT, NAME = N'[Demo-0101]-Full Database Backup', NOSKIP, NOREWIND, NOUNLOAD,STATS = 10
