CREATE MASTER KEY ENCRYPTION BY PASSWORD='Password1';  
 
CREATE DATABASE SCOPED CREDENTIAL BestRun WITH IDENTITY = 'BestUser',
    SECRET = 'Password1';  

 
CREATE DATABASE SCOPED CREDENTIAL MasterCred WITH IDENTITY = 'MasterUser',
    SECRET ='Password1';
  


 -----STEP 2
 EXEC jobs.sp_add_target_group 'DatabaseGroup1'
GO
 
EXEC jobs.sp_add_target_group_member
'DatabaseGroup1',
@target_type =  N'SqlDatabase',
--@refresh_credential_name='MasterCred',
@server_name='azeh5.database.windows.net',
@database_name =N'BEST4'
GO


----STEP3 CREATE LOGINS
------Run using Master
CREATE LOGIN MasterUser1
WITH PASSWORD = 'Password1'; 
 
CREATE LOGIN BestUser
WITH PASSWORD = 'Password1'; 
 
---Run on DB as well as MASTER 
CREATE USER MasterUser1
FROM LOGIN MasterUser1


create user BestUser
from login BestUser
 
 alter role db_owner
 Add member [Bestuser];
 GO

 ----create elastic jobs and job steps
 EXEC jobs.sp_add_job @job_name='Run_TSQL_Script', @description='This job will execute a simple TSQL script against a DB'
 
EXEC jobs.sp_add_jobstep @job_name='Run_TSQL_Script',
@command=N' print ''Print the entire script''',
@credential_name='BestRun',
@target_group_name='DatabaseGroup1'

---start the job
EXEC jobs.sp_start_job 'Run_TSQL_Script'

---run next 
select * from jobs.job_executions


---Updating and scheduling  the job to run every 1 min 
EXEC jobs.sp_update_job
@job_name='Run_TSQL_Script',
@enabled=1,
@schedule_interval_type='minutes',
@schedule_interval_count=1


---Last step
EXEC jobs.sp_add_jobstep @job_name='Run_TSQL_Script',
@step_name ='Execue procedure',
@command=N' EXEC TM',
@credential_name='BestRun',
@target_group_name='DatabaseGroup1'