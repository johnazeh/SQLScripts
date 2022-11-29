use [IndexDB]
select[LastName],[FirstName]
from[dbo].[Names]

----drop database
use master
go
drop database IndexDB
GO
 ---cREATE A DB
 USE MASTER
 GO

 select * from [Person].[Person]

USE [AmazonDB]
CREATE NONCLUSTERED INDEX CIX_Persons1_LastName
ON Persons1(LastName ASC);

DROP INDEX [Person].[Person].[PK_Person_BusinessEntityID]; 

Alter  tABLE [Person].[Person] drop PRIMARYID (BusinessEntityID)

use [AdventureWorks2017]
 
CREATE CLUSTERED INDEX IdX_Fname
ON [dbo].[Names](FirstName)


set statistics Time ON 
---SET STATISTICs time off

set statistics IO ON 
---SET STATISTICS IO off

USE  [IndexDB]
GO 
SELECT  FirstName,LastName
From [dbo].[Names]
where FirstName ='Rob'

create table Orders(
OrderID INT PRIMARY KEY ,
Orders varchar(20),
Cost Varchar(20))

use IndexDB

Insert  into Orders 
values(5,'book','5.00'),(2,'watch','24.00'),(4,'glasses','10.00'),(1,'laptop','100.00'),(3,'monitor','55.00')



select * from Orders


insert into Orders
VALUES (6,'PEN','2.00')


DROP TABLE ORDERS