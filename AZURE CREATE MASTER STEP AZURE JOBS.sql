CREATE MASTER KEY ENCRYPTION BY PASSWORD='Password1';  
 
CREATE DATABASE SCOPED CREDENTIAL JobRun WITH IDENTITY = 'JobUser',
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
@database_name =N'bestB'
GO


----STEP3 CREATE LOGINS
------Run using Master
CREATE LOGIN MasterUser
WITH PASSWORD = 'Password1'; 
 
CREATE LOGIN JobUser
WITH PASSWORD = 'Password1'; 
 
---Run on DB bestB 
CREATE USER MasterUser
FROM LOGIN MasterUser

---Create user logins
create user JobUser
from login JobUser
 
 alter role db_owner
 Add member [Jobuser];
 GO

 ----create elastic jobs and job steps
 EXEC jobs.sp_add_job @job_name='Run_TSQL_Script', @description='This job will execute a simple TSQL script against a DB'
 
EXEC jobs.sp_add_jobstep @job_name='Run_TSQL_Script',
@command=N' print ''Print the entire script''',
@credential_name='JobRun',
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
@credential_name='Jobrun',
@target_group_name='DatabaseGroup1'