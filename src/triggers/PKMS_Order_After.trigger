trigger PKMS_Order_After on Order__c (after update) {
	Set<Id> orderIdSet = new Set<Id>();
	for(Order__c thisOrder : trigger.new){
		if(thisOrder.Transfer_Status__c == 'Pending-Transfer'){
	        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
	        approvalRequest.setComments('Submitted for approval. Please approve.');
	        approvalRequest.setObjectId(thisOrder.Id);
	        
	        Approval.ProcessResult result = Approval.process(approvalRequest);
	        List<Id> newWorkItemIds = result.getNewWorkitemIds();
	        for(Id workItemId : newWorkItemIds){
	            Approval.ProcessWorkitemRequest workItemRequest = new Approval.ProcessWorkitemRequest();
	            workItemRequest.setWorkitemId(workItemId);
	            workItemRequest.setComments('Approving request.');
	            workItemRequest.setAction('Approve');
	            Approval.ProcessResult result2 = Approval.process(workItemRequest);
	        }
	        orderIdSet.add(thisOrder.Id);
		}
    }
    
    for(Order_Item__c thisOrderItem : [SELECT Id FROM Order_Item__c WHERE Order__c IN: orderIdSet]){
    	Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        approvalRequest.setComments('Submitted for approval. Please approve.');
        approvalRequest.setObjectId(thisOrderItem.Id);
        
        Approval.ProcessResult result = Approval.process(approvalRequest);
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        for(Id workItemId : newWorkItemIds){
            Approval.ProcessWorkitemRequest workItemRequest = new Approval.ProcessWorkitemRequest();
            workItemRequest.setWorkitemId(workItemId);
            workItemRequest.setComments('Approving request.');
            workItemRequest.setAction('Approve');
            Approval.ProcessResult result2 = Approval.process(workItemRequest);
        }
    }
}