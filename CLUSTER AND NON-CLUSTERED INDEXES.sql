USE DB3
CREATE NONCLUSTERED INDEX CIX_Person_LastName
ON Person(LastName ASC);



CREATE NONCLUSTERED INDEX CIX_Person_FirstName
ON Person(FirstName ASC);

 
CREATE CLUSTERED INDEX IX_dboMankon_Lname_DOB
ON  dbo.Mankon(Lname ASC, DOB DESC)

-----inserting 1000 rows

INSERT INTO Person( [ID],[FirstName],[LastName],[Address],[State],[Zip])
VALUES('','Brady','Upton','123 Main Street','TN',55555)
GO 1000

-------CHANGE VALUES ON A COLUMN 

DECLARE @ID int
SET @ID = 0
UPDATE Person
SET @ID = ID = @ID + 1


 ALTER TABLE Person
ADD ID int NOT NULL IDENTITY (1,1)

ALTER TABLE Person
ADD UNIQUE (ID);

ALTER TABLE Person
DROP [UQ__Person__3214EC2608E13BD9] ;


DELETE FROM Person
WHERE ID = 0;

Drop Unique 


DBCC SHOWCONFIG ('DBO.Person')

sp_blitzindex