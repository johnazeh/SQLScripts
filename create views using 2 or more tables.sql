CREATE VIEW [Business information] AS(

  SELECT [PersonID],[ContactTypeID],[AddressTypeID],[AddressID]
  FROM
    [Person].[BusinessEntity]
  FULL JOIN 
    [Person].[BusinessEntityAddress]
  ON
    [Person].[BusinessEntity].[BusinessEntityID]= [Person].[BusinessEntityAddress].[BusinessEntityID]
  Full JOIN
    [Person].[BusinessEntityContact]
  ON 
   [Person].[BusinessEntity].[BusinessEntityID] = [Person].[BusinessEntityContact].[BusinessEntityID]
  WHERE 
  [Person].[BusinessEntity].[BusinessEntityID] = [Person].[BusinessEntityAddress].[BusinessEntityID]
  AND
    [Person].[BusinessEntity].[BusinessEntityID]= [Person].[BusinessEntityContact].[BusinessEntityID] )


	select* from[dbo].[Business information]