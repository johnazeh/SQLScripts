Begin Tran
Update tableB
set fn ='LUCY'
WHERE FN ='ROSE'


select * from TableB

-----UPDATE TABLEA1
Begin Tran
Update tableA1
set fn ='TOM'
WHERE FN ='BOB'




SELECT * FROM SYS.SYSPROCESSES WHERE OPEN_TRAN >= 1