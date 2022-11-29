use AdventureWorks2017
select * from [AdventureWorks2017].[Person].[Person]

SET STATISTICS IO ON
SET STATISTICS IO OFF

------ MIGRATE DATA FROM PERSON .PERSON THAT HAS CLUSTERED AND NON CLUSTERED INDEX INTO TABLE PERSON .PERSONA  THTA DOESNT HAVE CLUSTERED INDEX /NON CLUSTERED INDEX


SELECT *  INTO [AdventureWorks2017].[Person].[PersonA]
from [AdventureWorks2017].[Person].[Person]

select * from [AdventureWorks2017].[Person].[PersonA]where [FirstName] = 'ken'

-----logical reads 3809logical reads 3820,
---(19972 rows affected)(6 rows affected)



SELECT * FROM [Person].[PersonA] WHERE [FirstName] ='gloria'

-----(25 rows affected)
---- Scan count 1, logical reads 8


SELECT * FROM [Person].[PersonA][FirstName]
-----(19972 rows affected)

-----Scan count 1, logical reads 3799

SELECT *  INTO [AdventureWorks2017].[HumanResources].[EmployeeA]
from [AdventureWorks2017].[HumanResources].[Employee]

----Table 'Employee'. Scan count 9, logical reads 12, physical reads 8


SELECT *  FROM [AdventureWorks2017].[HumanResources].[EmployeeA]

-----(290 rows affected)
Table 'EmployeeA'. Scan count 1, logical reads 7,

USE [AdventureWorks2017]
GO

/****** Object:  Index [ClusteredIndex-ID]    Script Date: 4/21/2021 12:20:19 AM ******/
CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-ID] ON [HumanResources].[EmployeeA]
(
	[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SELECT * FROM [HumanResources].[EmployeeA] WHERE [JobTitle] =' Engineering Manager'

USE [AdventureWorks2017]

GO

SET ANSI_PADDING ON


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-JOBTITLE] ON [HumanResources].[EmployeeA]
(
	[JobTitle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)

GO

SELECT *  INTO [AdventureWorks2017].[Person].[AddressA]
from [AdventureWorks2017].[Person].[Address]


select * from [AdventureWorks2017].[Person].[AddressA]

SELECT [City],[AddressLine1] FROM [AdventureWorks2017].[Person].[AddressA] WHERE CITY  = 'oAKLAND'



SET STATISTICS IO ON