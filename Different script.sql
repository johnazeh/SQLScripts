INSERT INTO ngang.Birthday (BirthdayID, Fname, Lname, Age, Sex) VALUES ('003', 'Jessy', 'Ngang', '8', 'M');
INSERT INTO ngang.Birthday (BirthdayID, Fname, Lname, Age, Sex) VALUES ('004', 'Elnathan', 'Ngang', '7', 'M');
INSERT INTO ngang.Birthday (BirthdayID, Fname, Lname, Age, Sex) VALUES ('005', 'Mary', 'Ngang', '1', 'F');


UPDATE ngang.Birthday SET Sex = 'M' WHERE BirthdayID = 100 ;
UPDATE ngang.Birthday SET Sex = 'M'  WHERE BirthdayID = 300 ;
UPDATE ngang.Birthday SET Sex = 'F'  WHERE BirthdayID = 200 ;
UPDATE ngang.Birthday SET Sex = 'M'  WHERE BirthdayID = 400 ;
UPDATE ngang.Birthday SET Sex = 'F'  WHERE BirthdayID = 500 ;

ALTER  TABLE ngang.Birthday ADD Sex VARCHAR (20);


ALTER TABLE ngang.Birthday
ADD UNIQUE (BirthdayID);