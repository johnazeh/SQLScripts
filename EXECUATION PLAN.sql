SELECT TOP (1000)[DepartmentID],[Name],[GroupName],[ModifiedDate]
from[AdventureWorks2017].[HumanResources].[Department]


---more complex plan 
Select [Person].[Person].[FirstName],[Person].[Person].[LastName],[Person].[Person].[Suffix],[Person].[Person].[Demographics],[Person].[PersonPhone].[PhoneNumber],

Sales.PersonCreditCard.[BusinessEntityID]
from [Person].[Person] INNER JOIN 
[Sales].[PersonCreditCard] ON[Person].[Person].[BusinessEntityID]=[Sales].[PersonCreditCard].[BusinessEntityID] INNER JOIN
[Person].[PersonPhone] ON [Person].[Person].[BusinessEntityID]=[Person].[PersonPhone].[BusinessEntityID] where [FirstName] ='John'


SET statistics IO ON


DBCC IND('Project1','dbo.school',-1)

dbcc traceon (3604)
Dbcc page('Project1',1,328,1)

Create nonclustered index CIX_GroupName on [HumanResources].[Department]([GroupName])


SELECT * FROM [HumanResources].[Department][DepartmentID]


Select  [PhoneNumber] from[Person].[PersonPhone][PhoneNumber]
where [PhoneNumber] = '697-555-0142'

---scan count =1
----Logical read =150

drop non clustered IX_PersonPhone_PhoneNumber

Select * from[Person].[Person][BusinessEntityID]
where [FirstName] = 'ken'


Select FirstName,[MiddleName] from [Person].[Person][BusinessEntityID]
where [FirstName] = 'ken'



Table 'Person'. Scan count 1, logical reads 3821,


-----(6 rows affected)
Table 'Person'. Scan count 1, logical reads 20,
(6 rows affected)
Table 'Person'. Scan count 1, logical reads 84,