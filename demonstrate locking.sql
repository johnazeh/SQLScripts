USE AdventureWorks2017
create table TableD( FN varchar(50))

insert into TableD Values ('BoB')

SELECT * FROM TableD

set statistics time on 
-----User1 execute an update statement causing an EXclusive lock (X) but not committing the transaction 


 Begin Tran 
 update TableD 
 set FN = 'John'
  where FN = 'Philan'
  Commit tran
  ---not using the commit tran we are using the begin tran therefore is an open transaction 

  Select * from TableD


  ---now user 2 call MARY tries to update thesame statement using commit trans 
 
  ----execute script on new query to demonstrate another session 

  --you will notice execution is not stopping keeps going over and over cause the first user is still holding an executive lock on statement or resource
 ------use this for user 2 
Begin Tran 
 update TableA 
 set FN = 'Hurry'
  where FN = 'peter'
  Commit tran ------user 1 decides to commit it`s transaction  see what happens to user 2 who is Mary

  ----- Need to check for open Transaction 
  DBCC OPENTran
  ----or

  SELECT
	[tst].[session_id] AS SessionID
	,[des].[login_name] AS LoginName
	,DB_NAME (tdt.database_id) AS DatabaseName
	,[tdt].[database_transaction_begin_time] AS TransactionBeginTime
	,[tdt].[database_transaction_log_bytes_used] AS LogBytesUsed    
	,[mrsh].text AS QueryText
	,[ph].[query_plan] AS QueryPlan
FROM sys.dm_tran_database_transactions [tdt]
JOIN sys.dm_tran_session_transactions [tst]
	ON [tst].[transaction_id] = [tdt].[transaction_id]
JOIN sys.[dm_exec_sessions] [des]
	ON [des].[session_id] = [tst].[session_id]
JOIN sys.dm_exec_connections [dec]
	ON [dec].[session_id] = [tst].[session_id]
LEFT OUTER JOIN sys.dm_exec_requests [der]
	ON [der].[session_id] = [tst].[session_id]
CROSS APPLY sys.dm_exec_sql_text ([dec].[most_recent_sql_handle]) AS [mrsh]
OUTER APPLY sys.dm_exec_query_plan ([der].[plan_handle]) AS [ph]
ORDER BY [TransactionBeginTime] ASC
GO
-----or

	
SELECT * FROM sys.sysprocesses WHERE open_tran >= 1

kill 72


select * from TableA

sp_who2