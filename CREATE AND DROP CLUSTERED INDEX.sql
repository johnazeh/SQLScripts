SELECT [Name]
FROM [AdventureWorks2017].[HumanResources].[Department]
WHERE [Name] = 'Finance'

DROP INDEX[HumanResources].[Department] .[AK_Department_Name]; 


CREATE NONCLUSTERED INDEX CIX_Name
ON [HumanResources].[Department]([Name] ASC);
