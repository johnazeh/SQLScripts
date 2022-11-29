


select pbe.[BusinessEntityID],
pbe.[rowguid],
pbe.[ModifiedDate],

pbea.[AddressID],
pbea.[AddressTypeID],

pbec.[PersonID],
pbec.[ContactTypeID],
pbec.[ModifiedDate]

from [Person].[BusinessEntity]pbe

inner join [Person].[BusinessEntityAddress]pbea
on pbe.[BusinessEntityID] = pbea.[BusinessEntityID]

inner join [Person].[BusinessEntityContact]pbec
on pbe.[BusinessEntityID] = pbec.[BusinessEntityID]

where
pbea.[AddressID] = '249' and pbe.[ModifiedDate] = '2017-12-13 '

order by pbec.[ContactTypeID]



----rewrite the query 

select count(*) from [Person].[BusinessEntity]
select count(*) from [Person].[BusinessEntityContact]
select count(*) from [Person].[BusinessEntityAddress]

select pbe.[BusinessEntityID],
pbe.[rowguid]

from [Person].[BusinessEntity]pbe
where pbe.[ModifiedDate] = '2017-12-17'

and exists (select * from 

[Person].[BusinessEntityAddress]pbea
 inner join [Person].[BusinessEntityAddress]
on pbe.[BusinessEntityID] = pbea.[BusinessEntityID]

where 
pbe.[BusinessEntityID] = pbea.[BusinessEntityID])