

------ first create a master key:

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD='Password1';


------In the next step, we will create a database credential to access to the Azure Storage. The credential name is azurecred:

CREATE DATABASE SCOPED CREDENTIAL azurecred2  
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 
'JTzbsWrGzcDf6ovVBpcv+7pUkQae3n4QMGFdViV7WxVYhFb+KtODvwXeu5EkmRXA3eCf+T3c8HXz+alIGEz3yA==';

-----The next step is to create an external data source. The external data source can be used to access to Hadoop or in this case to an Azure Account. The name of this data source is customer. The type is blob storage. We will use the credential just created before:


CREATE EXTERNAL DATA SOURCE customers2
WITH 
(
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://stortrudev.blob.core.windows.net/stor1',
    CREDENTIAL = azurecred2
);


---We will create a table named listcustomerAzure to store the data:

create table CustomerInfo2
(id int, 
ItemNum int,
)

------We will use now the BULK INSERT to insert data into the listcustomerAzure table from the file custmers.csv stored in Azure. We will invoke the external data source just created:

BULK INSERT [dbo].[CustomerInfo2]
FROM 'data.csv'
WITH (DATA_SOURCE = 'customers2',
      FORMAT = 'CSV');



----- If everything is OK now, you will be able to access to the data:

select * from CustomerInfo2


--------How to import data from a local file to SQL Server on-premises

create table home 
(id int, 
homeNUM int
)


BULK
INSERT home
FROM 'c:\storage'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO