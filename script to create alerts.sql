----CREATING AN ALERT FOR TEMPDB
--create a small database 
CREATE DATABASE [ManagementDB]
 ON   
( NAME = N'ManagementDB', 
FILENAME = N'D:\MSSQL\UATDATA\ManagementDB.mdf' , 
SIZE = 8192KB , 
FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ManagementDB_log', 
FILENAME = N'E:\MSSQL\UATLOG\ManagementDB_log.ldf' , 
SIZE = 8192KB , 
FILEGROWTH = 65536KB )
GO



--create table in your management database
USE ManagementDB
GO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.TempdbGrowth
	(
	session_id smallint NOT NULL,
	request_id int NULL,
	task_alloc_GB numeric(18, 0) NULL,
	task_dealloc_GB numeric(18, 0) NULL,
	host nvarchar(50) NULL,
	login_name nvarchar(128) NULL,
	status nvarchar(30) NULL,
	last_request_start_time datetime NULL,
	last_request_end_time datetime NULL,
	row_count bigint NULL,
	transaction_isolation_level smallint NULL,
	query_text nvarchar(MAX) NULL,
	query_plan xml NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.TempdbGrowth SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

---3) Create SQL Agent Job to Insert Data into Table
Use the SSMS GUI to create a new SQL Agent job, and make sure to un-check the Enabled box:


------4) create job steps 

USE ManagementDB
GO
INSERT INTO TempdbGrowth
(session_id, request_id, task_alloc_GB, task_dealloc_GB, host, login_name, status,
 last_request_start_time, last_request_end_time, row_count, transaction_isolation_level,
 query_text, query_plan)
	(select
        t1.session_id
        , t1.request_id
        , task_alloc_GB = cast((t1.task_alloc_pages * 8./1024./1024.) as numeric(10,1))
        , task_dealloc_GB = cast((t1.task_dealloc_pages * 8./1024./1024.) as numeric(10,1))
        , host= case when t1.session_id <= 50 then 'SYS' else s1.host_name end
        , s1.login_name
        , s1.status
        , s1.last_request_start_time
        , s1.last_request_end_time
        , s1.row_count
        , s1.transaction_isolation_level
        , query_text=
            coalesce((SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,
              (CASE WHEN statement_end_offset = -1
                  THEN LEN(CONVERT(nvarchar(max),text)) * 2
                       ELSE statement_end_offset
                  END - t2.statement_start_offset)/2)
            FROM sys.dm_exec_sql_text(t2.sql_handle)) , 'Not currently executing')
        , query_plan=(SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle))
    from
        (Select session_id, request_id
        , task_alloc_pages=sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count)
        , task_dealloc_pages = sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count)
        from sys.dm_db_task_space_usage
        group by session_id, request_id) as t1
    left join sys.dm_exec_requests as t2 on
        t1.session_id = t2.session_id
        and t1.request_id = t2.request_id
    left join sys.dm_exec_sessions as s1 on
        t1.session_id=s1.session_id
    where
        t1.session_id > 50 -- ignore system unless you suspect there's a problem there
        and t1.session_id <> @@SPID -- ignore this request itself
    )
    GO

--from https://littlekendra.com/2009/08/27/whos-using-all-that-space-in-tempdb-and-whats-their-plan/


-----Leave the job disabled, and do not set a schedule.

Create SQL Agent Alert in SSMS

---Object = databases

----Counter= Data files kilobytes
----Instance =TempDB
---Alerts if counter =rises above
---Values= total size * 8 logical processor

----NEXT STILLON SSMS The Response page is where you will activate the Job you just created.   Mark the Execute Job checkbox and then select the name of the SQL Job you created in the previous step. Also mark the Notify Operators checkbox so that the appropriate person(s) will be notified as soon as the event happens

---If you prefer to use TSQL instead of the GUI to create the alert, execute the following script:
USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'TempdbGrowth', 
	@enabled=1, 
	@delay_between_responses=0, 
	@include_event_description_in=1, 
	@performance_condition=N'Databases|Data File(s) Size (KB)|tempdb|>|98304000', 
	@job_id=N'b02b2790-cde8-4c18-89fa-380b20d9a953'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'TempdbGrowth', @operator_name=N'YourOperatorName', @notification_method = 1
GO