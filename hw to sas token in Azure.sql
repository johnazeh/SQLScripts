CREATE CREDENTIAL [https://ngangstorage.blob.core.windows.net/back1] WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'SharedAccessSignature=sv=2020-04-08&ss=btqf&srt=sco&st=2021-04-18T18%3A01%3A50Z&se=2021-04-19T18%3A01%3A50Z&sp=rl&sig=U0PFR3MB2huT8WXa8ehELZCV6VNo%2B%2F7Bi9WRnmoxZP0%3D;BlobEndpoint=https://ngangstorage.blob.core.windows.net/;FileEndpoint=https://ngangstorage.file.core.windows.net/;QueueEndpoint=https://ngangstorage.queue.core.windows.net/;TableEndpoint=https://ngangstorage.table.core.windows.net/';


RESTORE DATABASE [IndexDB] FROM  URL = N'https://ngangstorage.blob.core.windows.net/back1/[IndexDB].bak'WITH  FILE = 1,  NOUNLOAD,  STATS = 5 


