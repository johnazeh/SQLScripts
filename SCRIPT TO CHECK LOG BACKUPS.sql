SELECT
  backupset.database_name,
  CAST(8.0 * master_files.size/1024.0 AS DECIMAL(18, 0)) AS database_file_size_in_MB,
  CAST(backupset.backup_size/1024.0/1024.0 AS DECIMAL(18, 2)) AS BackupSizeMB,
  CAST(backupset.compressed_backup_size/1024.0/1024.0 AS DECIMAL(18, 2)) AS CompressedSizeMB,
  backupset.backup_start_date AS BackupStartDate,
  backupset.backup_finish_date AS BackupEndDate,
  CAST(backupset.backup_finish_date - backupset.backup_start_date AS TIME) AS AmtTimeToBkup,
  backupmediafamily.physical_device_name AS BackupDeviceName
FROM msdb.dbo.backupset
INNER JOIN msdb.dbo.backupmediafamily
ON backupset.media_set_id = backupmediafamily.media_set_id
INNER JOIN sys.databases
ON databases.name = backupset.database_name
INNER JOIN sys.master_files
ON master_files.database_id = databases.database_id
AND master_files.type_desc = 'ROWS'
WHERE backupset.type = 'L';