
------Demonstrating Dynamic Masking 


CREATE TABLE EmployeeData
(MemberID INT IDENTITY PRIMARY KEY,
FirstName varchar(100)	MASKED WITH (Function = 'default()'),
LastName varchar(100) MASKED WITH (Function = 'partial(1,"XXX",1)'),
Email varchar(100) MASKED WITH (function = 'email()'),
Age int MASKED WITH (Function = 'default()'),
JoinDate date MASKED WITH (Function = 'default()'),
LeaveDays int MASKED WITH (FUNCTION = 'random(1,5)')
)

------insert records from script 
INSERT INTO EmployeeData
(FirstName, LastName, Email,Age,JoinDate,LeaveDays)
VALUES
('Dinesh','Asanka','Dineshasanka@gmail.com',35,'2020-01-01',12),
('Saman','Perera','saman@somewhere.lk',45,'2020-01-01',1),
('Julian','Soman','j.soman@uniersity.edu.org',37,'2019-11-01',1),
('Telishia','Mathewsa','tm1@rose.lk',51,'2018-01-01',6)


-----Let us create a user to demonstrate data masking which has the SELECT permissions to the created data.

CREATE USER MaskUser WITHOUT Login;
GRANT SELECT ON EmployeeData TO MaskUser


----Let us query the data with the above user.

EXECUTE AS User= 'MaskUser';
SELECT * FROM EmployeeData
REVERT

-----When you need to provide the UNMASK permissions to the above user.

GRANT UNMASK TO MaskUser


-----ALTER EXISING TABLES ON A DATABASE TO HAVE Dynamic masking

alter table [Sales].[CreditCard] alter column CardNumber nvarchar(50) MASKED WITH (FUNCTION = 'DEFAULT()')

alter table [Sales].[CreditCard] alter column CardNumber nvarchar(50) MASKED WITH (FUNCTION = 'PARTIAL(1,"XXX-XXXX-XXXXX",1)')


alter table [Sales].[CreditCard] alter column [ExpMonth] tinyint MASKED WITH (FUNCTION = 'RANDOM(1,15)')

alter table [Sales].[CreditCard] alter column [ExpMonth] tinyint MASKED WITH (FUNCTION = 'EMAIL()')
