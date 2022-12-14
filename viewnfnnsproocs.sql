USE [UNIVDATABASE2]
GO
/****** Object:  UserDefinedFunction [dbo].[fntotal_Age_std]    Script Date: 10/10/2022 12:21:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fntotal_Age_std] (@StdAge1 int,@StdAge2 int,@StdAge3 int,@StdAge4 int,@StdAge5 int,@StdAge6 int)

RETURNS INT
AS 

BEGIN DECLARE @SUM INT 
SET @SUM = @StdAge1 + @StdAge2 + @StdAge3 + @StdAge4 + @StdAge5 + @StdAge6

RETURN (@SUM)

END

SELECT dbo.fntotal_Age_std 

where [StdName] = 'SAI'

create function fnstudentncourses (@Std_Name varchar(100))

returns table
as 
Return (
select * from [dbo].[tblCourses] as C

 join

[dbo].[tblStudents] as S

on  C.[CourseID] = S.[StdCourseID]

where [StdName] = @Std_Name


)

select * from fnstudentncourses ('AMI')