ALTER DATABASE AdventureWorks2017 SET PARTNER = N'TCP://JAZEH:5023'


select * from sys.database_mirroring_endpoints



----Make sure that endpoint has been created on principal, mirror and witness servers. Verify that the endpoints are started on each partner server instances. You can check endpoint status by running below T-SQL query on each instance.
SELECT state_desc FROM sys.database_mirroring_endpoints


---if either endpoint is not started, execute below ALTER ENDPOINT statement to start it.

#Change the name of your endpoints. Here endpoint name is Mirroring
ALTER ENDPOINT Mirroring
STATE = STARTED
AS TCP (LISTENER_PORT = <port_number>)
FOR database_mirroring (ROLE = ALL);
GO


------Service Accounts
--Do not use local system account to run SQL Server services. If you don’t have any choice and want to use local system then ensure to use certificates for authentications.

--Make sure that service accounts that you are using to run SQL Server services must have CONNECT permission to mirroring endpoints. Also, if you are configuring database mirroring between two domains then the login of one account must be created in master database on the other computer, and that login must be granted CONNECT permissions on the endpoint.

----It’s always advisable to use same service accounts to run SQL Server services on all three Instances on Principal, Mirror and Witness server.


----To Grant CONNECT on a previously created Mirroring Endpoint in SQL Server run following query:

USE master;
GO
CREATE LOGIN [domain_name\user_name] FROM WINDOWS;
GO
GRANT CONNECT on ENDPOINT::Mirroring TO [john.azeh];
GO




ALTER ENDPOINT Mirroring
STATE = Stopped

drop database [AdventureWorks2017]


-----to remove mirrioring 
ALTER DATABASE [AdventureWorks2017]SET PARTNER OFF