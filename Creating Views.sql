CREATE VIEW [Customer Product] AS
SELECT Productid,ProductNum,ProductDes,CustomerId
FROM Product
WHERE ProductDes ='DG';

select* from [dbo].[Customer Product]

----Multiple view script

CREATE VIEW [SaleReport] AS(

  SELECT Fname,Lname,ProductDes,Ordernumber
  FROM
    Customer
  FULL JOIN 
    Order1 
  ON
    Customer.OrderId= Order1.orderId
  Full JOIN
    Product
  ON 
    Customer.CustomerId= Product.CustomerId
  WHERE 
   Customer.Orderid= Order1.Orderid
  AND
    Customer.CustomerId= Product.CustomerId )



CREATE VIEW V AS
SELECT POP.country, POP.year, POP.pop, FOOD.food, INCOME.income
FROM POP
INNER JOIN FOOD ON (POP.country=FOOD.country) AND (POP.year=FOOD.year)
INNER JOIN INCOME ON (POP.country=INCOME.country) AND (POP.year=INCOME.year)

SELECT * FROM [dbo].[SaleReport]

DROP VIEW [dbo].[SaleReport]