CREATE TABLE Persons 
(ID int ,
LastName varchar(255) , 
FirstName varchar(255), 
Age int);

ALTER TABLE  Person ALTER COLUMN Age int NOT NULL ;

Alter Table Persons1
ADD UNIQUE (ID);

ALTER TABLE Persons1
ADD CHECK (Age>=18);

