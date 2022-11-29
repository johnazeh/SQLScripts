/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [BusinessEntityID]
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,[EmailPromotion]
      ,[AdditionalContactInfo]
      ,[Demographics]
      ,[rowguid]
      ,[ModifiedDate]
      ,[namepeopl]
      ,[col1]
  FROM [Person].[Person]


  DELETE FROM [Person].[Person];


  create table demo (
  Fn varchar(20),
  ln varchar(10))

  insert into demo values( 'john','azeh')
    insert into demo values( 'john1','azeh2')
	  insert into demo values( 'john2','azeh3')

	  select * from demo


	  delete from [dbo].[demo]