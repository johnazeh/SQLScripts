/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [StudentID]
      ,[FirstName]
      ,[LastName]
      ,[DateOfBirth]
      ,[Gender]
      ,[PhoneNumber]
      ,[Email]
      ,[SSN]
  FROM [Kiawitech2020].[dbo].[Student]