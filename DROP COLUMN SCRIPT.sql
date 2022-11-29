/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Student]
      ,[Age]
      ,[Subject]
      ,[StudentID]
  FROM [Demo].[dbo].[school]

  ALTER TABLE [dbo].[school] DROP COLUMN Subject