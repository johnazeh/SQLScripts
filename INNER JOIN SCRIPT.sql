

Alter table [Production].[WorkOrderRouting]  
add [BusinessEntityID] int 


Insert into [Production].[WorkOrderRouting] (BusinessEntityID)  select (BusinessEntityID) from [Purchasing].[Vendor]




------WODR
----W 

select WODR.[ProductID],

WODR.[OperationSequence],
WODR.[ScheduledStartDate],
WODR.[ActualStartDate],
WODR.[ActualResourceHrs],

W.[WorkOrderID],
W.[OrderQty],
W.[ScrappedQty],
W.[ModifiedDate]

from [Production].[WorkOrder]W
INNER JOIN [Production].[WorkOrderRouting]WODR ON

WODR.[ProductID] = W.[ProductID]

WHERE W.[OrderQty] <10