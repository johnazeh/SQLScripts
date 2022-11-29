
/* Re-sizing TempDB */
USE [master]; 
GO 
ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev', SIZE=2GB, FILEGROWTH = 100);
GO
/* Adding three additional files */
USE [master];
GO
ALTER DATABASE [tempdb] ADD FILE 
	(NAME = N'tempdev2', FILENAME = N'R:\TEMPDB_DATA\tempdev2.ndf' , SIZE = 2GB , FILEGROWTH = 100);
ALTER DATABASE [tempdb] ADD FILE 
	(NAME = N'tempdev3', FILENAME = N'R:\TEMPDB_DATA\tempdev3.ndf' , SIZE = 2GB , FILEGROWTH = 100);
ALTER DATABASE [tempdb] ADD FILE 
	(NAME = N'tempdev4', FILENAME = N'R:\TEMPDB_DATA\tempdev4.ndf' , SIZE = 2GB , FILEGROWTH = 100);
GO