CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'password010101@';
CREATE DATABASE SCOPED CREDENTIAL [elasticquerry_112]  WITH IDENTITY = 'pam.awaw',  
SECRET = 'Password010101';


------setup the datasource

---<External_Data_Source> ::=
    CREATE EXTERNAL DATA SOURCE mydatasources WITH
        (TYPE = RDBMS,
                   LOCATION = 'trudev03.database.windows.net',
        DATABASE_NAME = 'Promodb2',
        CREDENTIAL = elasticquerry_112,
      
               ) 

----STEP3----------------------------

CREATE EXTERNAL TABLE [Person].[Person](
	[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [bit] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[rowguid] [uniqueidentifier] NOT NULL,
	[ModifiedDate] [smalldatetime] NOT NULL,
	[city] [varchar](50) NULL
)  WITH ( 
DATA_SOURCE = mydatasource,
SCHEMA_NAME = N'Person',
   OBJECT_NAME = N'Person')
GO




select * from [Person].[Person]
insert INTO [Person].[Person]
select * from [Person].[EXT.Person]
