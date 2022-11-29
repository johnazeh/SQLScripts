
USE AdventureWorks2016
Drop table Person.PersonB


select * into AdventureWorks2016.Person.PersonB
from AdventureWorks2016.Person.Person

select * from Person.PersonB

SET STATISTICS IO ON 
 SET STATISTICS TIME ON 

 -----(19972 rows affected)
--- logical reads 3810, physical reads 0, page server reads 0, read-ahead reads 3815

----   CPU time = 188 ms,  elapsed time = 1626 ms

----Table scan 



 
CREATE CLUSTERED INDEX IX__BusinessEntityID
ON  Person.PersonB(BusinessEntityID ASC)

----(19972 rows affected)
------logical reads 3820, physical reads 3, page server reads 0, read-ahead reads 3858, 
----Clustered index scan 
Begin tran
select * from Person.PersonB
 where FirstName  = 'Ken'

 -----(6 rows affected)
---- logical reads 3820, physical reads 1, page server reads 0, read-ahead reads 1029
----Clustered index scan 


CREATE NONCLUSTERED INDEX CIX_FirstName
ON Person.PersonB(FirstName ASC);


---- logical reads 20, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-----Index seek $ key lookup 87% cost 

-----create a cover index

CREATE NONCLUSTERED INDEX [CIX_FirstName] ON [Person].[PersonB]
(
	[FirstName] ASC
)
INCLUDE([BusinessEntityID],[PersonType],[NameStyle],[Title],[MiddleName],[LastName],[Suffix],[EmailPromotion],[AdditionalContactInfo],[Demographics],[rowguid],[ModifiedDate])



---
------logical reads 4, physical reads 0, page server reads 0, read-ahead reads 0, page server read

---SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 121 ms.

