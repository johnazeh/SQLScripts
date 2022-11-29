CREATE TABLE Customers(Country int,
Fname varchar(25),
LName varchar(25),
Age varchar(10));



insert into Customers values(1001,'john','awa',25)
insert into Customers values(1002,'john1','awa1',28)
insert into Customers values(1003,'john2','awa2',27)
insert into Customers values(1004,'john3','awa3',26)

----enable cdc at db level
 exec sys.sp_cdc_enable_db  --will create a system table as well as cdc schema 


 create user DBA_Team from external provider

 exec sp_addrolemember [db_securityadmin],DBA_Team
 exec sp_addrolemember [db_ddladmin],DBA_Team
 exec sp_addrolemember [db_owner],DBA_Team

 select * from cdc.captured_columns

 select * from cdc.change_tables

select * from cdc.ddl_history

select * from cdc.index_columns

select * from cdc.lsn_time_mapping

select * from [dbo].[systranschemas]

select * from Customers


------2. Enable CDC at the table level: 
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',   

@source_name   = N'Customers',   

@role_name     = NULL /* Control access to change data.*/ 

--@filegroup_name = N'MyDB_CT',   

@supports_net_changes = 1  

select * from [cdc].[dbo_Customers_CT]

select * from[cdc].[cdc_jobs]

select * from[dbo].[systranschemas]



insert into Customers values(1008,'john6','awa8',29,'USA')
insert into Customers values(1009,'john7','awa9',30,'France')

insert into Customers values(10010,'john8','awa10',31,'Belgium')
insert into Customers values(10011,'john9','awa11',23,'Cameroon')



DELETE FROM Customers WHERE Fname='john9';





------check for change data in CT table  (scheduler) and also try manual scan */

select * from [cdc].[dbo_Customers_CT]


------manual scan 
exec sys.sp_cdc_scan 


-----change the retention (Min) for cleanup 

execute sys.sp_cdc_change_job
@job_type = N'cleanup',
@retention = 4320;

select * from[cdc].[cdc_jobs] 

-----Disable cdc on table 
 select * from sys.tables/*is_tracked_by_cdc*/


 EXEC sys.sp_cdc_disable_table
@source_schema = N'dbo',   

@source_name   = N'Customers',
@capture_instance = N'dbo_Customers',
@role_name = NULL





@role_name = NULL   /* Control access to change data.*/ 

@supports_net_changes = 1 

--@filegroup_name = N'MyDB_CT',  



----------disable cdc at db level
 exec sys.sp_cdc_disable_db  --will create a system table as wall as cdc schema 


----testing cdc breakage 


Alter table [Customers]
alter column Age int 


Alter table [Customers]


select count(*) from [dbo].[Customers]

insert into Customers values('','','','','Cameroon')
insert into Customers values('','','','','Benin')
insert into Customers values('','','','','France')
insert into Customers values('','','','','Britian')
insert into Customers values('','','','','Germany')
insert into Customers values('','','','','Usa')

delete  from Customers where country = 'Cameroon'
delete  from Customers where country = 'italy'
delete  from Customers where country = 'Japan'
delete  from Customers where country = 'Germany'
delete  from Customers where country = 'USA'
delete  from Customers where country = 'france'



Update [dbo].[Customers] set Country = 'Cameroon' where  CustomerId = '1001'
Update [dbo].[Customers] set Country = 'France' where  CustomerId = '1002'
Update [dbo].[Customers] set Country = 'britian' where  CustomerId = '1003'
Update [dbo].[Customers] set Country = 'germany' where  CustomerId = '1004'
Update [dbo].[Customers] set Country = 'usa' where  CustomerId = '1006'
Update [dbo].[Customers] set Country = 'Canada' where  CustomerId = '1007'



--------stop cdc job

exec sys.sp_cdc_stop_job
@job_type = N'cleanup';
@retention = 4320;


select * from sys.dm_cdc_log_scan_sessions


---backup 
SELECT * INTO [dbo].[Backup_dbo_Customers_CT] FROM [cdc].[dbo_Customers_CT];

---restore 

insert INTO[cdc].[dbo_Customers_CT] select * from  [dbo].[Backup_dbo_Customers_CT]  


--drop backup 