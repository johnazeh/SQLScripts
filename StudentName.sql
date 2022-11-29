
INSERT INTO Student(StudentID, Fname, Lname, Gender, Telephone) VALUES ('103 ','Blaise', 'Ng', 'M', '1000');

ALTER TABLE Student 



INSERT INTO Student(SID, Fname) VALUES ('104 ','Vanessa');
INSERT INTO Student(SID, Fname) VALUES ('105 ','Helen');
INSERT INTO Student(SID, Fname) VALUES ('106 ','Richard');
INSERT INTO Student(SID, Fname) VALUES ('107 ','Tracy');
INSERT INTO Student(SID, Fname) VALUES ('108 ','Anthony');
INSERT INTO Student(SID, Fname) VALUES ('109 ','Collins');
INSERT INTO Student(SID, Fname) VALUES ('110 ','Emmanuel');
INSERT INTO Student(SID, Fname) VALUES ('111 ','Phillipe');
INSERT INTO Student(SID, Fname) VALUES ('112 ','Clarise');
INSERT INTO Student(SID, Fname) VALUES ('113 ','Beryl');
INSERT INTO Student(SID, Fname) VALUES ('114 ','Elvis');
INSERT INTO Student(SID, Fname) VALUES ('115 ','Izaiah');
INSERT INTO Student(SID, Fname) VALUES ('116 ','Tim');
INSERT INTO Student(SID, Fname) VALUES ('117 ','uzoma');
INSERT INTO Student(SID, Fname) VALUES ('118 ','Roland');
INSERT INTO Student(SID, Fname) VALUES ('119 ','Doris');
INSERT INTO Student(SID, Fname) VALUES ('120 ','Bernard');




ALTER DATABASE [PartitioningDB]
    ADD FILE 
    (
    NAME = [PartDec],
    FILENAME = 'D:\MSSQL\DATA\PRODDATA\PartitioningDB11.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [December]


*******ADDING FILEGROUP

ALTER DATABASE PartitioningDB
ADD FILEGROUP January

ALTER DATABASE PartitioningDB
ADD FILEGROUP February

ALTER DATABASE PartitioningDB
ADD FILEGROUP March

ALTER DATABASE PartitioningDB
ADD FILEGROUP April

ALTER DATABASE PartitioningDB
ADD FILEGROUP May

ALTER DATABASE PartitioningDB
ADD FILEGROUP June

ALTER DATABASE PartitioningDB
ADD FILEGROUP July

ALTER DATABASE PartitioningDB
ADD FILEGROUP August

ALTER DATABASE PartitioningDB
ADD FILEGROUP September

ALTER DATABASE PartitioningDB
ADD FILEGROUP October

ALTER DATABASE PartitioningDB
ADD FILEGROUP November

ALTER DATABASE PartitioningDB
ADD FILEGROUP December