-------Enabling Change Data Capture on Azure SQL Databases 

---1.------ Enable CDC at the database level: 

EXEC sys.sp_cdc_enable_db 

System tables (e.g. cdc.captured_columns, cdc.change_tables) and the cdc schema will be created, stored in the same database.  

 

------2. Enable CDC at the table level: 

EXEC sys.sp_cdc_enable_table   

@source_schema = N'dbo',   

@source_name   = N'demo',   

@role_name     = N'null',   

@filegroup_name = N'PRIMARY',   

@supports_net_changes = 1   

 

-----The associated change table (cdc.dbo_MyTable_CT) will be created, along with the capture and cleanup jobs (cdc.cdc_jobs). Be aware that in Azure SQL Databases, capture and cleanup are run by the scheduler, while in SQL Server and Azure SQL Managed Instance they are run by the SQL Server Agent. 

 

------3. Run DML changes on source tables and observe changes being recorded in the associated CT tables.  

 

4. Table-valued functions can be used to collect changes from the CT tables.  

 

5. Disable CDC at the table level: 

EXEC sys.sp_cdc_disable_table   

@source_schema = N'dbo',   

@source_name   = N'demo',  

@capture_instance = N'dbo_demo'   

 

6. Disable CDC at the database level: 

EXEC sys.sp_cdc_disable_db 

create user [john.azeh@johnazehoutlook.onmicrosoft.com] from external provider 

exec sp_addrolemember [db_owner],[john.azeh@johnazehoutlook.onmicrosoft.com]

-----check cdc
 exec  sys.sp_cdc_help_change_data_capture 


 
create table demo (
Id int not null,
Fn varchar(30),
Ln Varchar(30)

)

insert into demo Values (1001,'John','aza')
insert into demo Values (1002,'Joh','azda')
insert into demo Values (1003,'Jon','azqa')
insert into demo Values (1004,'kohn','azwa')
insert into demo Values (1005,'kohnss','a12zwa')
insert into demo Values (1006,'kohn77s','a12z66wa')
insert into demo Values (1007,'kohn778s','a12z66wra')
insert into demo Values (1008,'kohn79998s','a12z6336wra')


delete from [dbo].[demo]
delete from demo where id =1010

update demo set id = 1009 where id =1008

alter table demo 
add city varchar(20)

alter table demo 
drop column city 

select * from demo

select * from [cdc].[dbo_demo_CT]

select * from [cdc].[ddl_history]

select * from [cdc].[captured_columns]