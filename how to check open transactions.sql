EXEC SP_WHO2

USE [AdventureWorks2017]
BEGIN TRAN 
UPDATE [Person].[Person]
SET [Title] = 'Test'


USE [AdventureWorks2017]
BEGIN TRAN 
UPDATE [Person].[Password]
SET  [PasswordSalt]= 'Test'


USE [AdventureWorks2017]
dbcc opentran

------Now we know the SPID ( server process ID) , we want to know which query is associated with this process id. We can use DBCC INPUTBUFFER(SPID) to get the query information as shown below

DBCC INPUTBUFFER(69)

---DBCC OPENTRAN AND DBCC INPUTBUFFER are very helpful but If we have more than one transactions open and we want to get all information in once, which query we can use to get all open transactions with database name,who executed these queries,sql query and program name etc.

This query can be used to get all above information

USE MASTER
GO
SELECT spid,
       PROGRAM_NAME,
       nt_userName,
       loginame,
       DB_NAME(s.dbid) AS DatabaseName,
       CR.TEXT AS Query
FROM   sysprocesses s
       CROSS apply sys.Dm_exec_sql_text(sql_handle) CR
WHERE  open_tran = 1