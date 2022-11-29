SELECT *  from Customer 
FULL OUTER JOIN Order1 ON [dbo].[Customer].OrderId= Order1.Orderid;

SELECT *  from Customer 
FULL OUTER JOIN Product ON [dbo].[Customer].Customerid= Product.Customerid;



select* from Customer
select * from Product