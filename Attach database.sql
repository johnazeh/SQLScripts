USE [master]
GO
CREATE DATABASE [JOB] ON 
( FILENAME = N'D:\MSSQL\PRODDATA\JOB.mdf' ),
( FILENAME = N'E:\MSSQL\PRODLOG\JOB_log.ldf' )
 FOR ATTACH
GO
USE [master]
GO
CREATE DATABASE [JOINS] ON 
( FILENAME = N'D:\MSSQL\PRODDATA\JOINS.mdf' ),
( FILENAME = N'E:\MSSQL\PRODLOG\JOINS_log.ldf' )
 FOR ATTACH
GO
USE [master]
GO
CREATE DATABASE [Kiawitech2020] ON 
( FILENAME = N'D:\MSSQL\PRODDATA\Kiawitech2020.mdf' ),
( FILENAME = N'E:\MSSQL\PRODLOG\Kiawitech2020_log.ldf' )
 FOR ATTACH
GO
USE [master]
GO
CREATE DATABASE [ORG] ON 
( FILENAME = N'D:\MSSQL\PRODDATA\ORG.mdf' ),
( FILENAME = N'E:\MSSQL\PRODLOG\ORG_log.ldf' )
 FOR ATTACH
GO
USE [master]
GO
CREATE DATABASE [Kiawitech2020B9] ON 
( FILENAME = N'D:\MSSQL\PRODDATA\Kiawitech2020B9.mdf' ),
( FILENAME = N'E:\MSSQL\PRODLOG\Kiawitech2020B9_log.ldf' ),
( FILENAME = N'D:\MSSQL\PRODDATA\Default.ndf' ),
( FILENAME = N'D:\MSSQL\PRODDATA\Kiawitech2020_Q2.ndf' ),
( FILENAME = N'D:\MSSQL\PRODDATA\Kiawitech2020_Q3.ndf' ),
( FILENAME = N'D:\MSSQL\PRODDATA\Quarter1.ndf' ),
( FILENAME = N'D:\MSSQL\PRODDATA\Quarter2.ndf' )
 FOR ATTACH
GO
