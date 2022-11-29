--Find out the version of sql server
select @@version

--READ DATA FROM A TABLE USING SELECT STATEMENTS
Use SacretHeart
select * from [dbo].[Crse]

--WRITING FULLY QUALIFIED TSQL SCRIPTS(STATEMENTS)

Select* from AdventureWorks2017.Person.Address

--READ ONLY SELECTED COLUMNS ON TABLE 
Select Fname,Lname,InstructorID FROM [SacretHeart].[dbo].[Instructor]

Select Instructorid  FROM [SacretHeart].[dbo].[Instructor]


Select Firstname ,Lastname  from AdventureWorks2017.Person.Person
WHERE LASTNAME = 'Ackerman'

--SELECT ALL RECORDS
Select* from AdventureWorks2017.Person.Person

Where BusinessEntityID=10

--Sort values in desc or ascn order

Select* from AdventureWorks2017.Person.Person
order by BusinessEntityID asc


--NOT OPERATOR
SELECT* FROM 
AdventureWorks2017.Person.Person
where not FirstName ='David'


--and and or OPERATOR

--USING THE UNION  AND UNION ALL
/** SELECT COLUMN1,COLUMN, FROM TABLE 1
UNION
SELECT COLUMN1,COLUMN2 FROM TABLE2**/

SELECT FirstName,LastName, MiddleName, FROM PERSON.PERSON
UNION ALL
SELECT FIRSTNAME, LASTNAME, MIDDLENAME, FROM PERSON.PERSON
ORDER BY LASTNAME

--wild cat

select * from Person.Person
where LastName like '%E' AND FirstName  like '%E' or MiddleName = 'B'
Order by FirstName 


--USING THE _(UNDERSCORE)
SELECT * FROM Person.Person
WHERE FirstName like '__0%' and FirstName ='Jarrod'

--limit infoirmation by top values
Select  FirstName,LastName,BusinessEntityID
From Person.Person
Where BusinessEntityID <101
oRDER BY BusinessEntityID ASC


-- paging data 
--Offset =How many rows sql should skip
--FETCH=THE NUMBER OF ROW TO RETURN ATA FROM
USE AdventureWorks2017
SELECT PRODUCTID,PRODUCTNUMBER,Name
From production.Product
order by ProductID
offset 10 rows

--WRITING AN EXPRESSION 
USE AdventureWorks2017
Select 
FirstName+' ' + LastName as FULLNAME
FROM Person.Person



Select [AddressLine1]+' ' + [PostalCode] as Address
From  [Person].[Address]


---variable 
declare @vera int
set @vera =200



