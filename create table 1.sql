CREATE TABLE Persons1
(ID int NOT NULL,
LastName varchar(255) NOT NULL,
FirstName varchar(255) NOT NULL,
Age int);


ALTER TABLE Persons1 ALTER COLUMN LastName varchar(255) NOT NULL;
ALTER TABLE Persons1 ALTER COLUMN FirstName varchar(255) NOT NULL;

CREATE TABLE Persons2 
(
ID int NOT NULL UNIQUE,
LastName varchar(255) NOT NULL,  
FirstName varchar(255),
Age int);

