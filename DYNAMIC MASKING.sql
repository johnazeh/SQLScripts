CREATE  DATABASE MASK


USE [AdventureWorks2017]
 
DROP TABLE IF EXISTS DefaultMask;
        
CREATE TABLE DefaultMask
(
ID		       INT              IDENTITY (1,1) PRIMARY KEY NOT NULL
,Name VARCHAR(255)	MASKED WITH (FUNCTION = 'default()') NULL
,BirthDate     DATE		MASKED WITH (FUNCTION = 'default()') NOT NULL
,Social_Security  BIGINT		MASKED WITH (FUNCTION = 'default()') NOT NULL
);
GO


INSERT INTO DefaultMask
(
Name, BirthDate, Social_Security
)
VALUES 
('James Jones',  '1998-06-01', 784562145987),
( 'Pat Rice',  '1982-08-12', 478925416938),
('George Eliot',  '1990-05-07', 794613976431);

SET STATISTICS IO ON 
SELECT * FROM [dbo].[DefaultMask]



DROP USER IF EXISTS DefaultMaskTestUser;
CREATE USER DefaultMaskTestUser WITHOUT LOGIN;
 
GRANT SELECT ON DefaultMask TO DefaultMaskTestUser;
 
EXECUTE AS USER = 'DefaultMaskTestUser';
SELECT * FROM DefaultMask;
 
REVERT;

USE MASK
 
DROP TABLE IF EXISTS PartialMask;
        
CREATE TABLE PartialMask
(
ID		       INT              IDENTITY (1,1) PRIMARY KEY NOT NULL
,Name VARCHAR(255)	MASKED WITH (FUNCTION = 'partial(2, "XXXX",2)') NULL
,Comment   NVARCHAR(255)		MASKED WITH (FUNCTION = 'partial(5, "XXXX", 5)') NOT NULL
);
GO

SELECT * FROM [dbo].[PartialMask]

INSERT INTO PartialMask
(
  Name,  Comment
)
VALUES 
('James Jones',  'The tea was fantastic'),
( 'Pat Rice',  'I like these mangoes' ),
('George Eliot',  'I do not really like this');




DROP USER IF EXISTS PartialMaskTestUser;
CREATE USER  PartialMaskTestUser WITHOUT LOGIN;
        
GRANT SELECT ON PartialMask TO PartialMaskTestUser;  
        
EXECUTE AS USER = 'PartialMaskTestUser';  
SELECT * FROM PartialMask

