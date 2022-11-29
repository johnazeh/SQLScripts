Use [AdventureWorks2017]
Go

Begin Tran
update .[Person].[Person]
set Firstname = 'Peter'
where BusinessEntityID =2

rollback