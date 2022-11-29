Use Pages  
go 
Create table Cars(
CarName char(1000))

insert into Cars
Values('BMW')


----- uSE dbcc ind command to see what is going on 
DBCC TRACEON(3604)
 
DBCC IND ('Pages',cars,-1)


----Get more details in the page 
DBCC TRACEON(3604)


DBCC PAGE ('Pages',1,320,1)
DBCC PAGE ('Pages',1,320,3)


insert into Cars
Values('Benz')


insert into Cars
Values ('Ford'),('chevy'),('Toyota'),('audi'),('Honda'),('Prius')
----last record will split the page because the isnt any room .it is above 8060 .we have already used 8056 so only 4 kb left
insert into Cars
Values('Renault')

DBCC TRACEON(3604)


DBCC PAGE ('Pages',1,321,1)
DBCC PAGE ('Pages',1,321,3)