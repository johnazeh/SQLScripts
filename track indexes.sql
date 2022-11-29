use [AdventureWorks2017]

go 
select * into [AdventureWorks2017].[Person].[AddressB]
FROM [AdventureWorks2017].[Person].[Address]


------PROVIDES INFO ON SPACE USED PER DB

sp_spaceused
select * from [Person].[AddressB]