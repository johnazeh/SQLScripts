use TempDB
exec sp_helpfile

USE MASTER
GO
ALTER DATABASE TempDB MODIFY FILE
(NAME = tempdev, FILENAME = 'K:\MSSQL\UATDATA\tempdb.mdf')

ALTER DATABASE TempDB MODIFY FILE
(NAME = templog, FILENAME = 'K:\MSSQL\UATLOG\templog.ldf')


    ALTER DATABASE tempdb MODIFY FILE ( NAME = temp2 , FILENAME = 'K:\MSSQL\UATDATA\temp2.ndf' )
    ALTER DATABASE tempdb MODIFY FILE ( NAME = temp3 , FILENAME = 'K:\MSSQL\UATDATA\temp3.ndf' )
    ALTER DATABASE tempdb MODIFY FILE ( NAME = temp4 , FILENAME = 'K:\MSSQL\UATDATA\temp4.ndf' )
	ALTER DATABASE tempdb MODIFY FILE ( NAME = temp5 , FILENAME = 'K:\MSSQL\UATDATA\temp5.ndf' )
    ALTER DATABASE tempdb MODIFY FILE ( NAME = temp6 , FILENAME = 'K:\MSSQL\UATDATA\temp6.ndf' )
    ALTER DATABASE tempdb MODIFY FILE ( NAME = temp7 , FILENAME = 'K:\MSSQL\UATDATA\temp7.ndf' )
	ALTER DATABASE tempdb MODIFY FILE ( NAME = temp8 , FILENAME = 'K:\MSSQL\UATDATA\temp8.ndf' )


SELECT 
name, file_id, type_desc, size * 8 / 1024 [TempdbSizeInMB]
FROM sys.master_files
WHERE DB_NAME(database_id) = 'tempdb'
ORDER BY type_desc DESC, file_id 
GO