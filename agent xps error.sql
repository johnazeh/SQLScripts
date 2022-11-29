use master
go
select * from sys.configurations where name='Agent XPs'


---step 2
use master
go
exec sp_configure 'Show advanced options',1
Go
reconfigure with override
go
---step 3
use master
go
exec sp_configure 'Agent XPs',1
Go
reconfigure with override
go

---test
use master
go
select * from sys.configurations where name in ('Agent XPs','Show advanced options')