USE Test
GO
--It shows the Zeroing process events in output window
DBCC TRACEON(3004,3605,-1)

DBCC TRACEON(3004)
GO
--Create a Empty Table Structue
SELECT * INTO Test.dbo.Sales FROM [AdventureWorks2014].[Sales].[SalesPerson] WHERE 1=2;

--Switch on Table Statistics
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Insert Data
INSERT INTO Test.dbo.Sales(
[BusinessEntityID],
[TerritoryID],
[SalesQuota],
[Bonus],
[CommissionPct],
[SalesYTD],
[SalesLastYear],
[rowguid],
[ModifiedDate]
)
SELECT[BusinessEntityID],
[TerritoryID],


[SalesQuota],
[Bonus],
[CommissionPct],
[SalesYTD],
[SalesLastYear],
[rowguid],
[ModifiedDate]
 FROM
[AdventureWorks2014].[Sales].[SalesPerson]; 


---Turning off trace flag
DBCC TRACEOFF(3605,3604)




select * from [dbo].[Sales]

update [dbo].[Sales] set 