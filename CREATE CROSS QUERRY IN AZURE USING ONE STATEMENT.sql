CREATE TABLE [dbo].[SQLSatEvent](
[SQLSatEventKey] [int] IDENTITY(1,1) NOT NULL,
[SQLSatNumber] [int] NULL,
[SQLSatName] [varchar](500) NULL,
[LocationKey] [varchar] NULL,
[Completed] [bit] NULL,
[Cancelled] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SQLSatEvent] ADD  DEFAULT ((0)) FOR [Completed]
GO
ALTER TABLE [dbo].[SQLSatEvent] ADD  DEFAULT ((0)) FOR [Cancelled]
GO

---step 2:In the Master database on the target server, run this (with a stronger password:
USE MASTER
CREATE LOGIN DBA WITH PASSWORD = 'Password1'


------We need a user now to match with this login, so let's connect a user with this login.
CREATE USER DBA FOR LOGIN DBA

-------We also need to grant rights for the user to our table, so let's do that here.

GRANT SELECT, INSERT ON dbo.SQLSatEvent TO DBA


-----Secondary database
--------Next, we need a master key for security in the SECONDARY database(SOURCE). Let's go there and just create a master key with a password. Please use a strong password here.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pasword1';

-----Now the last part of the security is the Database Scoped Credential. This will use the values for the user we created above. The credential is the way we allow a user to proxy with the login/user from the target database.

CREATE DATABASE SCOPED CREDENTIAL QueryCredential2 
  WITH IDENTITY = 'DBA', SECRET = 'Password1'

  ----Getting the Tables SetOnce we have set up the security, let's now set our tables. We already have the target table in the SQLSat database, so let's get things setup to link to this from the Speakers database. The first step in this is to create an EXTERNAL DATA SOURCE.

-----In this CREATE command, you give a type as a relational database. There are other types, but here we are accessing SQL Server. The location is your server. This does not need to be the same server. This is just the location of the database. You specify the database and then the Database Scoped Credential from above.

CREATE EXTERNAL DATA SOURCE primaryDB
 WITH 
 ( TYPE = RDBMS,
   LOCATION='tru-dev01.database.windows.net',
   DATABASE_NAME = 'primary1',
   CREDENTIAL = QueryCredential2
 );


 -----Now we create our table. Note that this table needs to match the schema of the target table. I'll just take the code from above for the SQL Sat table and then add a WITH clause. The WITH clause includes the data source, which we created above.

-----The other changes made are including the EXTERNAL keyword in the above. We also need to change the key to remove the IDENTITY keyword. This isn't needed with the external table as this is just a pointer to the actual table, which has the identity set. The same thing for the PK and defaults. We don't add those clauses to this external table.

CREATE EXTERNAL TABLE [dbo].[SQLSatEvent](
[SQLSatEventKey] [int] NOT NULL,
[SQLSatNumber] [int] NULL,
[SQLSatName] [varchar](500) NULL,
[LocationKey] [varchar] NULL,
[Completed] [bit] NULL,
[Cancelled] [bit] NULL
) WITH (DATA_SOURCE = primaryDB)
GO

-------Test configuration 

select * from [dbo].[SQLSatEvent]


----insert into primary

insert into [dbo].[SQLSatEvent] values(1001,2,'john','C',null,null)
insert into [dbo].[SQLSatEvent] values(1002,3,'jan','B',null,null)
insert into [dbo].[SQLSatEvent] values(1003,4,'jon','D',null,null)