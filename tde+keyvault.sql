-- Enable advanced options.  
USE master;  
GO  

EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  

-- Enable EKM provider  
EXEC sp_configure 'EKM provider enabled', 1;  
GO  
RECONFIGURE;


---Register the SQL Server Connector as an EKM provider with SQL Server.

------Create a cryptographic provider by using the SQL Server Connector, which is an EKM provider for the Azure key vault. In this example, the provider name is AzureKeyVault_EKM.


CREATE CRYPTOGRAPHIC PROVIDER AzureKeyVault_EKM
FROM FILE = 'C:\Program Files\SQL Server Connector for Microsoft Azure Key Vault\Microsoft.AzureKeyVaultService.EKM.dll';  
GO  


------Set up a SQL Server credential for a SQL Server login to use the key vault.

------A credential must be added to each login that will perform encryption by using a key from the key vault. This might include:


USE master;  
CREATE CREDENTIAL sysadmin_ekm_creds
    WITH IDENTITY = 'sqlserverEKMKeyVault',                            -- for public Azure
    -- WITH IDENTITY = 'ContosoEKMKeyVault.vault.usgovcloudapi.net', -- for Azure Government
    -- WITH IDENTITY = 'ContosoEKMKeyVault.vault.azure.cn',          -- for Azure China 21Vianet
    -- WITH IDENTITY = 'ContosoEKMKeyVault.vault.microsoftazure.de', -- for Azure Germany
           --<----Application (Client) ID ---><--Azure AD app (Client) ID secret-->
    SECRET = '3f600728-fd43-4326-ab4c-92dd907dc8f3'
FOR CRYPTOGRAPHIC PROVIDER AzureKeyVault_EKM;  

-- Add the credential to the SQL Server administrator's domain login
ALTER LOGIN [jazeh\user]  
ADD CREDENTIAL sysadmin_ekm_creds;



----Open your Azure key vault key in your SQL Server instance.

----Whether you created a new key or imported an asymmetric key, as described in Step 2: Create a key vault, you will need to open the key. Open it by providing your key name in the following Transact-SQL script.

----Replace EKMSampleASYKey with the name you'd like the key to have in SQL Server.
----Replace ContosoRSAKey0 with the name of your key in your Azure key vault.
SQL

CREATE ASYMMETRIC KEY sqlserverkey01
FROM PROVIDER [AzureKeyVault_EKM]  
WITH PROVIDER_KEY_NAME = 'AzureKeyVault_EKM',  
CREATION_DISPOSITION = OPEN_EXISTING;


