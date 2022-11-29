----check all database sizes
	
SET STATISTICS TIME off
exec sp_MSforeachdb 'use [?]; EXEC sp_helpfile'



-- Find all data files with Percent or 1MB growth
SELECT d.name as database_name,
	mf.name as file_name,
	mf.physical_name as file_path,
	mf.type_desc as file_type,
	CONVERT(DECIMAL(20,2), (CONVERT(DECIMAL,mf.size)/128)) as filesizeMB,
	mf.growth as growth,
	'Percent' as growth_increment
FROM sys.master_files mf 
JOIN sys.databases d  ON mf.database_id=d.database_id
WHERE is_percent_growth=1
UNION
SELECT d.name as database_name,
    mf.name as file_name,
	mf.physical_name as file_path,
    mf.type_desc as file_type,
	CONVERT(DECIMAL(20,2), (CONVERT(DECIMAL,mf.size)/128)) as filesizeMB,
    (CASE WHEN mf.growth = 128 THEN 1 END) AS growth,
	'MB' as growth_increment
FROM sys.master_files mf 
JOIN sys.databases d ON mf.database_id=d.database_id
WHERE is_percent_growth=0
AND mf.growth = 128
ORDER BY d.name, mf.name

-------change data and log file to 1024 mb


DECLARE @dbname VARCHAR(200) 
DECLARE @filename VARCHAR(200) 
DECLARE @SqlCmd VARCHAR(2000) 

DECLARE dbfiles CURSOR FOR
SELECT sd.name AS DBName, mf.name AS LogicalName
FROM sys.master_files mf
JOIN sys.databases sd ON sd.database_id = mf.database_id
WHERE DB_NAME(mf.database_id) NOT IN ('master','model','msdb','tempdb')
AND CONVERT(DECIMAL(20,2), (CONVERT(DECIMAL,size)/128)) BETWEEN 0 AND 1000  --(MB) Change to correct size range
AND sd.name NOT IN (SELECT d.name
			FROM sys.databases d
			INNER JOIN sys.availability_databases_cluster adc ON d.group_database_id = adc.group_database_id
			INNER JOIN sys.availability_groups ag ON adc.group_id = ag.group_id
			INNER JOIN sys.dm_hadr_availability_replica_states rs ON ag.group_id = rs.group_id AND d.replica_id = rs.replica_id
			WHERE rs.role_desc = 'SECONDARY') -- exclude dbs in AG secondary
AND sd.is_read_only = 0 AND sd.state = 0 -- exclude dbs that are read only or offline 
OPEN dbfiles
FETCH NEXT FROM dbfiles INTO @dbname, @filename

WHILE @@FETCH_STATUS = 0
BEGIN
	 SET @SqlCmd = 'ALTER DATABASE [' + @dbname + '] MODIFY FILE (NAME = N'''+@filename+''', FILEGROWTH =10)' --Change to correct MB preference
	 --EXEC (@SqlCmd)
	 PRINT @SqlCmd
	 FETCH NEXT FROM dbfiles INTO @dbname, @filename
END

CLOSE dbfiles
DEALLOCATE dbfiles



