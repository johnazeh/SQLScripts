

Create database [SQL_SHACK]


USE AdventureWorks2014
GO
SELECT *
INTO [SQL_SHACK].[dbo].[MySalesOrderDetail] 
FROM [AdventureWorks2014].[Sales].[SalesOrderDetail]
GO


-----Then, I will demonstrate something interesting.

-----First, let us try to select * from our sample table with including actual execution plan and statistics IO.

SET STATISTICS IO ON
GO
SELECT *
FROM [SQL_SHACK].[dbo].[MySalesOrderDetail]

----------- logical reads 1499

---Now, let us try to run the same query using a specific range of values:--

SET STATISTICS IO ON
GO
SELECT *
FROM [SQL_SHACK].[dbo].[MySalesOrderDetail]
WHERE SalesOrderID = 60726 AND SalesOrderDetailID = 74616


------(1 row affected)
----------Table 'MySalesOrderDetail'. Scan count 1, logical reads 1499


------For the previously created table “MySalesOrderDetail”, we are going to create a clustered index primary key on [SalesOrderID] and [SalesOrderDetailID].

ALTER TABLE [SQL_SHACK].[dbo].[MySalesOrderDetail]
ADD CONSTRAINT [PK_MySalesOrderDetail_SalesOrderID_SalesOrderDetailID] 
PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC,
	[SalesOrderDetailID] ASC
)
GO
----Now, let us go ahead and do the same, select all, from the table
SET STATISTICS IO ON
GO
SELECT *
FROM [SQL_SHACK].[dbo].[MySalesOrderDetail]


----For the previously created table “MySalesOrderDetail”, we are going to create a clustered index primary key on [SalesOrderID] and [SalesOrderDetailID].

ALTER TABLE [SQL_SHACK].[dbo].[MySalesOrderDetail]
ADD CONSTRAINT [PK_MySalesOrderDetail_SalesOrderID_SalesOrderDetailID] 
PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC,
	[SalesOrderDetailID] ASC
)
GO
----Now, let us go ahead and do the same, select all, from the table
SET STATISTICS IO ON
GO
SELECT *
FROM [SQL_SHACK].[dbo].[MySalesOrderDetail]


------(121317 rows affected)
----Table 'MySalesOrderDetail'. Scan count 1, logical reads 1848


------Now, let me get to the specific case where we went about doing value collection. In this particular case same as what we selected before

SET STATISTICS IO ON
GO
SELECT *
FROM [SQL_SHACK].[dbo].[MySalesOrderDetail]
WHERE SalesOrderID = 60726 AND SalesOrderDetailID = 74616

---(1 row affected)
---Table 'MySalesOrderDetail'. Scan count 0, logical reads 3, physical reads 1,