------ first create a master key:

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD='Password1';


------In the next step, we will create a database credential to access to the Azure Storage. The credential name is azurecred:

CREATE DATABASE SCOPED CREDENTIAL johnazehcred  
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 
'8EkuOW5xMoVbNO83JFtjsvXtBqNwisvFHAfLXT+Wfkf8MT2sDHun99tM01V6EeK3NNU2mPiIfw44QAr6RxR3TA==';

-----The next step is to create an external data source. The external data source can be used to access to Hadoop or in this case to an Azure Account. The name of this data source is customer. The type is blob storage. We will use the credential just created before:


CREATE EXTERNAL DATA SOURCE abcdefg0122356
WITH 
(
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://stortrudev.blob.core.windows.net/backupcc03',
    CREDENTIAL = johnazehcred 
);


---We will create a table named listcustomerAzure to store the data:



CREATE TABLE [dbo].[StateCampaignInstance1](
	[CampaignInstanceId] [int] NOT NULL,
	[StateId] [int] NOT NULL)






CREATE TABLE [dbo].[CampaignInstance1](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Description] [varchar](max)NOT NULL,
	[CampaignId] [int] NOT NULL,
	[IsTrial] [bit] NOT NULL,
	[Type] [bit]NOT NULL,
	[LiveDate] [date] NOT NULL,
	[ExpireDate] [date] NOT NULL,
	[EnrollmentFeeWaived] [bit] NOT NULL,
	[Discount] [float] NOT NULL,
	[RequiresExam] [bit] NOT NULL,
	[RequiresAdoption] [bit] NOT NULL,
	[DeferredEnrollment] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[OrganizationId] [uniqueidentifier] NULL,
	[BrandId] [uniqueidentifier]  NULL,
	[OrganizationTypeId] [uniqueidentifier] NULL,
	[UniqueId] [uniqueidentifier] NULL,
	[ProvidePreExistingCoverage] [bit] NULL,
	[WaiveTPCommission] [bit] NOT NULL,
	[DisableWebUsage] [bit] NOT NULL,
	[WaiveWaitingPeriods] [bit]  NULL,
	[EmployeeBenefitsCode] [bit] NULL,
	[BillToCorporateAccount] [bit] NULL,
	[CreatedBy] [uniqueidentifier]  NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[StateChangedBy] [uniqueidentifier]  NULL,
	[StateChangedOn] [datetime] NULL)





	CREATE TABLE [dbo].[CampaignInstanceNew](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](450) NULL,
	[Description] [nvarchar](max) NULL,
	[CampaignId] [nvarchar](max) NOT NULL,
	[IsTrial] [nvarchar](max) NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[LiveDate] [timestamp] NOT NULL,
	[ExpireDate] [nvarchar](max) NOT NULL,
	[EnrollmentFeeWaived] [nvarchar](max) NOT NULL,
	[Discount] [nvarchar](max) NOT NULL,
	[RequiresExam] [nvarchar](max) NOT NULL,
	[RequiresAdoption] [nvarchar](max) NOT NULL,
	[DeferredEnrollment] [nvarchar](max) NOT NULL,
	[Active] [nvarchar](max) NOT NULL,
	[OrganizationId] [nvarchar](max) NULL,
	[BrandId] [nvarchar](max) NOT NULL,
	[OrganizationTypeId] [nvarchar](max) NULL,
	[UniqueId] [nvarchar](max) NOT NULL,
	[ProvidePreExistingCoverage] [nvarchar](max) NOT NULL,
	[WaiveTPCommission] [nvarchar](max) NOT NULL,
	[DisableWebUsage] [nvarchar](max) NOT NULL,
	[WaiveWaitingPeriods] [nvarchar](max) NOT NULL,
	[EmployeeBenefitsCode] [nvarchar](max) NOT NULL,
	[BillToCorporateAccount] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NOT NULL,
	[CreatedOn] [nvarchar](max) NOT NULL,
	[ModifiedBy] [nvarchar](max) NOT NULL,
	[ModifiedOn] [nvarchar](max) NOT NULL,
	[StateChangedBy] [nvarchar](max) NOT NULL,
	[StateChangedOn] [nvarchar](max) NOT NULL)







------We will use now the BULK INSERT to insert data into the listcustomerAzure table from the file custmers.csv stored in Azure. We will invoke the external data source just created:

BULK INSERT [dbo].[Associate2]FROM 'AssociateUploadSandbox (1).csv'
WITH (
    CHECK_CONSTRAINTS,
    DATA_SOURCE = 'abcdefg0122356',
    DATAFILETYPE='char',
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
 FIRSTROW=2,
    KEEPIDENTITY,
    TABLOCK
);

delete from [dbo].[Associate2]






BULK INSERT [dbo].[CampaignInstance]
FROM 'CampaignInstanceUploadSandbox.csv'
WITH (DATA_SOURCE = 'customers2',
      FORMAT = 'CSV');



	  create user [john.azeh] from login [john.azeh]


	  Create user [john.azeh] from external provider
	  exec sp_addrolemember [db_owner],[john.azeh]
      exec sp_addrolemember [db_accessadmin],[john.azeh]

	  delete from[dbo].[StateCampaignInstance]