DBCC DROPCLEANBUFFERS
go

use [AdventureWorks2017]
 

  SELECT * 
  INTO [AdventureWorks2017].[Person].[AddressB]
  FROM  [AdventureWorks2017].[Person].[Address]
-----notice that 82% of the cost  is taken  by the sort command
  Select city,AddressLine1
  from [AdventureWorks2017].[Person].[AddressB]
  order by city ----we are using the order by command (sorting)

 ------ simplest way to avoid a sort operator is to create a clustered index

 Create clustered index [ClusteredIndex-20210119]
 on [Person].[AddressB] ([city]ASC)

 ----NOW LET REVIEW  THE EXECUTION PLAN.nOTICE THAT  THERE IS NOT  NEED TO SORT  THE DATA AND THE  SORT IS AVOIDED

SELECT  CITY ,AddressLine1
from [AdventureWorks2017].[Person].[AddressB]
order by ([city]) ----we are using the order by command sorting 



---eXAMPLE OF A NESTED LOOP JOIN 
----WHERE  THE SMALLER TABLE doesnt have an index based on the column  being used in an index,but the larger does have an index

select * from [Sales].[SalesOrderHeader] as OH
WHERE OH.OrderDate BETWEEN '2011-07-01' and '2011-07-14'------- smaller table (144 rows )(Outer table ) does not have  an indexon column  orderdate 


Select * from  [Sales].[SalesOrderHeader] AS OO -------LARGER TABLE (31465 ROWS )(INNER TABLE )


SELECT  
OH.OrderDate,OO.OrderQty
FROM [Sales].[SalesOrderHeader] as OH
INNER JOIN
Sales.SalesOrderDetail AS OO
ON OH SalesOrderID


------Demonstrating Hash join 
-----hash join happen when there are no indexes  or not properly sorted 

CREATE  TABLE  TABLE1
(ID INT IDENTITY,EVENTS VARCHAR(60))


--insert some data
declare @i int 
set @i=0
while (@i<100)
begin 
insert into Table1(Events)
select Event from [AdventureWorks2017].dbo.DatabaseLog
set @i=@i+1
end 

-----create a second table 
CREATE  TABLE  TABLE2
(ID INT IDENTITY,EVENTS VARCHAR(60))


--insert some data
declare @i int 
set @i=0
while (@i<100)
begin 
insert into Table2(Events)
select Event from [AdventureWorks2017].dbo.DatabaseLog
set @i=@i+1
end 



select * from table1------159600 rows 
select * from table2------159600 rows 


-----execute and view hash join as there is no index
Select Table1.id, Table1.Events,
Table2.id as Expr1,
Table2.Events as Expr2
from 
Table1
INNER JOIN
TABLE2
ON Table1.id=Table2.id


---what if we create  an index on both tables 


Use[AdventureWorks2017]
go 
Create nonClustered index [Test]
on [dbo].[Table2]([id])
include([Events])

Use[AdventureWorks2017]
go 
Create nonClustered index [Test]
on [dbo].[Table1]([id])
include([Events])

---execute and view  after creation of index .IT should ne nested join


Select Table1.id, Table1.Events,
Table2.id as Expr1,
Table2.Events as Expr2
from 
Table1
INNER JOIN
TABLE2
ON Table1.id=Table2.id
where table1.id = 159600


----Merge join is fast because  it has tables that are already sorted .

select H.[CustomerID],H.[SalesOrderID],D.ProductID, D.LineTotal
from [Sales].[SalesOrderHeader] H
INNER JOIN [Sales].[SalesOrderDetail] D ON H.SaleSOrderID = d.SalesOrderID
wHERE H.CustomerID > 100


eXAMPLE 2



CREATE TABLE Employee_Main
( Emp_ID INT IDENTITY (1,1) PRIMARY KEY,
  EMP_FirsrName VARCHAR (50),
  EMP_LastName VARCHAR (50),
  EMP_BirthDate DATETIME,
  EMP_PhoneNumber VARCHAR (50),
  EMP_Address VARCHAR (MAX)  
)
GO
CREATE TABLE EMP_Salaries
( EMP_ID INT IDENTITY (1,1),
  EMP_HireDate DATETIME,
  EMP_Salary INT,
  CONSTRAINT FK_EMP_Salaries_Employee_Main FOREIGN KEY (EMP_ID)     
  REFERENCES Employee_Main (EMP_ID),
)
GO

--insert some data
declare @i int 
set @i=0
while (@i<100)
begin 
insert into Employee_Main(Events)
select Event from [AdventureWorks2017].dbo.DatabaseLog
set @i=@i+1
end 

--insert some data
declare @i int 
set @i=0
while (@i<100)
begin 
insert into EMP_Salaries(Events)
select Event from [AdventureWorks2017].dbo.DatabaseLog
set @i=@i+1
end 


SELECT EMP_FirsrName, EMP_LastName, EMP_BirthDate, EMP_Address, EMP_HireDate, EMP_Salary
FROM [dbo].[Employee_Main] EM
JOIN  [dbo].[EMP_Salaries] ES
ON EM.[EMP_ID] =ES.[EMP_ID]
WHERE EM.[EMP_ID] > 2470 AND ES.EMP_Salary >450