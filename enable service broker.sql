
--Enabling service broker
USE master 
ALTER DATABASE 
SET ENABLE_BROKER;


------If other connections are blocking the SET NEW_BROKER statement in a user database, and the command hangs, you can put the database in single user mode first or use this command:

ALTER DATABASE [AdventureWorks2016] SET NEW_BROKER WITH ROLLBACK IMMEDIATE;


ALTER DATABASE [AdventureWorks2016]
SET MULTI_USER;
GO



	  --Create Message Types for Request and Reply messages
USE demotestDb
-- For Request
CREATE MESSAGE TYPE
[//SBTest/SBSample/RequestMessage]
VALIDATION=WELL_FORMED_XML;
-- For Reply
CREATE MESSAGE TYPE
[//SBTest/SBSample/ReplyMessage]
VALIDATION=WELL_FORMED_XML; 


--Create Contract for the Conversation 
USE demotestDb
CREATE CONTRACT [//SBTest/SBSample/SBContract]
(
[//SBTest/SBSample/RequestMessage]
SENT BY INITIATOR 
,[//SBTest/SBSample/ReplyMessage]
SENT BY TARGET 
);

USE  demotestDb
--Create Queue for the Initiator
CREATE QUEUE SBInitiatorQueue; 
--Create Queue for the Target
CREATE QUEUE SBTargetQueue; 


--Create Service for the Target and the Initiator.
USE  demotestDb
--Create Service for the Initiator.
CREATE SERVICE [//SBTest/SBSample/SBInitiatorService]
ON QUEUE SBInitiatorQueue; 
--Create Service for the Target.
CREATE SERVICE [//SBTest/SBSample/SBTargetService] 
ON QUEUE SBTargetQueue
([//SBTest/SBSample/SBContract]); 