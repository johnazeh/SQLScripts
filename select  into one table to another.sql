Use AdventureWorks2016
select * 
into [AdventureWorks2016].[Person].[PersonB]
from [AdventureWorks2016].[Person].[Person]

select * from [AdventureWorks2016].[Person].[PersonB]



------.01 ms table scan
---if we enable force parameterization 