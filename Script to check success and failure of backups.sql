
------check last backup for all databases
SELECT  
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name,  
   MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date 
FROM 
   msdb.dbo.backupmediafamily  
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
WHERE msdb..backupset.type = 'D' 
GROUP BY 
   msdb.dbo.backupset.database_name  
ORDER BY  
   msdb.dbo.backupset.database_name



   -----check backup success
DECLARE @path nvarchar(260);

SELECT 
   @path = REVERSE(SUBSTRING(REVERSE([path]), 
   CHARINDEX(CHAR(92), REVERSE([path])), 260)) + N'log.trc'
FROM    sys.traces
WHERE   is_default = 1;

SELECT dt.DatabaseName, dt.StartTime, bs.backup_start_date, bs.backup_finish_date, 
  [Status] = CASE WHEN bs.backup_start_date IS NULL 
    THEN 'Probably failed'
    ELSE 'Seems like success'
  END
FROM sys.fn_trace_gettable(@path, DEFAULT) AS dt
LEFT OUTER JOIN msdb.dbo.backupset AS bs
ON dt.DatabaseName = bs.database_name
AND ABS(DATEDIFF(SECOND, dt.StartTime, bs.backup_start_date)) < 5
WHERE dt.EventClass = 115 -- backup/restore events
AND UPPER(CONVERT(nvarchar(max),dt.TextData)) LIKE N'BACKUP%DATABASE%'
--AND dt.DatabaseName = N'db_name' -- to filter to a single database
--AND bs.database_name = N'db_name'
ORDER BY dt.StartTime;


EXEC sp_readerrorlog 0, 1, 'BACKUP failed'; -- current
EXEC sp_readerrorlog 1, 1, 'BACKUP failed'; -- .1 (previous)
EXEC sp_readerrorlog 2, 1, 'BACKUP failed'; -- .2 (the one before that)