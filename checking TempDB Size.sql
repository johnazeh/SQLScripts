SELECT 
name, file_id, type_desc, size * 8 / 1024 [TempdbSizeInMB]
FROM sys.master_files
WHERE DB_NAME(database_id) = 'tempdb'
ORDER BY type_desc DESC, file_id 
GO
