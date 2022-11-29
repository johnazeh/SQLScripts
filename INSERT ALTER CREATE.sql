CREATE TABLE MyFirstTable (
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Address VARCHAR(50) DEFAULT '7190 CARDINAL WAY SW',
DriverLicenseID INT NOT NULL,
PhoneNumber INT,
SocialSecID INT,
PRIMARY KEY (SocialSecID),
DOB DATETIME );



INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('John', 'Azeh', 'Monte Jouvence', '123456', '78045968', '336699', '01/02/1980'); 

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('Frank', 'Azeh1', 'Monte Britin', '1234561', '780459682', '3366991', '03/04/1984'); 


INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('Pam', 'Awa', 'Dallas', '1234562', '780459683', '3366997', '01/06/1987');   

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('kohn', 'bzeh', ' ', '1234568', '780459684', '3366993', '02/08/1975');   

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('Ben', 'Grat', 'Limbe', '123456', '78045568', '335699', '03/10/1960');   

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('Sam', 'khan', 'Buea', '124562', '78045168', '332699', '03/05/1950');   

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('jacob', 'nzeh', ' ', '123476', '78040968', '330699', '06/08/1965');   

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('Francis', 'man', 'Bamenda', '123016', '78045448', '336039', '03/05/2001');   

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('Grace', 'Plant', 'Chappelle', '120006', '78045788', '331119', '02/01/2020');   

INSERT INTO  MyFirstTable(FirstName ,LastName , Address, DriverLicenseID, PhoneNumber, SocialSecID, DOB) VALUES('Prat', 'zland', 'Zaich', '100156', '78045688', '332299', '03/07/2011');   

DROP  TABLE MyFirstTable ;



CREATE TABLE Gender (
GenderID INT,
Gender_Description VARCHAR(20));



INSERT INTO  Gender(GenderID,Gender_Description) VALUES('115', 'Male');
INSERT INTO  Gender(GenderID,Gender_Description) VALUES('116', 'Female');



CREATE TABLE TraineeInfo (
StudentID INT PRIMARY KEY,
Student_age INT,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Address varchar(50) DEFAULT('7190 CARDINAL WAY SW'),
SSN INT ,
GenderID INT );



INSERT INTO  TraineeInfo(StudentID,Student_age,FirstName,LastName,Address,SSN,GenderID) VALUES('1001','22', 'John', 'Azeh', ' ','0101', '115');
INSERT INTO  TraineeInfo(StudentID,Student_age,FirstName,LastName,Address,SSN,GenderID) VALUES('1002','24', 'John1', 'Azeh2', ' ','0102', '116');

ALTER TABLE TraineeInfo ADD FOREIGN KEY (GenderID) REFERENCES Gender(GenderID);

ALTER TABLE TraineeInfo ADD UNIQUE (StudentID,SSN);

);

DROP TABLE TraineeInfo;