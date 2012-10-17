trigger CS_Claim_after on CS_Claims__c (after update) {
    LIST<Id> claimIds = new LIST<Id>();
    for(CS_Claims__c claim : Trigger.New){
            claimIds.add(claim.Id);    
    }

Map<Id,CS_Claims__c> claims = new Map<Id,CS_Claims__c>([SELECT Id, Claims_Stage__c FROM CS_Claims__c WHERE Id in :claimIds]);

     for(CS_Claims__c thisClaim : trigger.new){
         if(claims.get(thisClaim.Id).Claims_Stage__c == 'Returned'){
         Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
         approvalRequest.setComments('Submitted for approval. Please approve.');
         approvalRequest.setObjectId(thisClaim.Id);
         
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
}