

--------demo1nstatrating autogrowth and why it is not recommended to use default database setting .Model database setting is current set to  3 mb for mdf and autogrowth set to 1 mb and 1 mb for ldf  and autogrowth set to 10%

-----Any new database created will assume those characteristics.

----step create a database with default setting 
CREATE DATABASE [demo]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'demo', FILENAME = N'Z:\MSSQL\demo.mdf' , SIZE = 3072KB , ------<< initial file growth

FILEGROWTH = 1024KB ) -------<<<< growth by log


 LOG ON 
( NAME = N'demo_log', FILENAME = N'Y:\MSSQL\demo_log.ldf' , SIZE = 1024KB , ------<< initial file growth


FILEGROWTH = 10%)-------<<<< growth by log


DBCC LOGINFO




---STEP2  CREATE A NEW DATABASE WITH INCREASE MDF AND LDF FILE  SIZE AS WELL AS AUTOGROTH

CREATE DATABASE [demo1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'demo1', FILENAME = N'Z:\MSSQL\demo1.mdf' , SIZE = 1024000KB , ------<< increase in initial file growth

FILEGROWTH = 102400KB )-------<<<< increase in growth by log
 LOG ON 
( NAME = N'demo1_log', FILENAME = N'Y:\MSSQL\demo1_log.ldf' , SIZE = 102400KB ,  ------<< increase initial file growth

FILEGROWTH = 102400KB )-------<<<< increase growth by log


----Examine the database size 

exec sp_helpdb demo
exec Sp_helpdb demo1


---lets check the logspace used in both databases

dbcc sqlperf (logspace)


------We will insert some records to trigger autogrowth on both demo  and demo1


select * into demo1
from [AdventureWorks2017].[Sales].[SalesOrderDetail]