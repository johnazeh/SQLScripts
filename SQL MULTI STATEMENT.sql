 Select upper (FIRST_NAME)   FROM  DBO.WORKER;

 ---- Converting all characters to uppercases
  Select upper ([BONUS_AMOUNT])   FROM  DBO.Bonus;
  
  
  -- Converting all chracters to lower cases
   Select lower ([WORKER_TITLE])  FROM  DBO.Title;

   -- Getting Unique information on a column 
   Select Distinct DEPARtMENT,WORKER_ID,FIRST_NAME FROM Worker

   -- Selecting the first 3 character of a name.
   sELECT SUBSTRING(FIRST_NAME,1,4) from Worker

   Select INSTR (FIRST_NAME, BINARY'a') from Worker where FIRST_NAME = 'Amitabh';

   Select RTRIM(FIRST_NAME) from Worker;

   Select LTRIM(DEPARTMENT) from Worker;

    Select Distinct lenght(DEPARTMENT) FROM Worker
	--Replacing or modifying a letter in a name 
	Select REPLACE(FIRST_NAME,'a','A') from Worker;
	Select REPLACE(FIRST_NAME,'A','a') from Worker;

	-- adding two string together

	Select CONCAT(FIRST_NAME, ' ', LAST_NAME,' ', DEPARTMENT) AS 'COMPLETE_NAME' from Worker;

	SELECT * from Worker order by FIRST_NAME ASC


	SELECT CONCAT(FIRST_NAME,',',LAST_NAME) AS 'COMPLETE_NAME' FROM Worker
	---- ASC AND DESC
	sELECT * FROM Worker ORDER BY FIRST_NAME ASC, DEPARTMENT DESC