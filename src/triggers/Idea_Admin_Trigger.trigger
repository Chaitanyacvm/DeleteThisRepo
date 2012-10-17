trigger Idea_Admin_Trigger on Idea (after update) {
    
    List<Idea_Admin__c> i_admin = new List<Idea_Admin__c>();
    
    
    for(Idea_Admin__c i : [SELECT Id, Assign_National_Evaluator__c, Workflow_Status__c, Idea__r.National_Evaluator__c, Status__c, Evaluation__c, Idea__r.Move_Idea_To__c, Idea__r.Workflow_Status__c, Idea__r.Status__c FROM Idea_Admin__c WHERE Idea__c = :Trigger.newMap.keySet()]) {
        
        if(i.Workflow_Status__c != i.Idea__r.Workflow_Status__c){
            i.Workflow_Status__c = i.Idea__r.Workflow_Status__c;
            
            if(i.Idea__r.Workflow_Status__c == 'National Evaluator Queue'){
                i.Assign_National_Evaluator__c = i.Idea__r.National_Evaluator__c;
            }
            
            i_admin.add(i);
        }
        
        
        
    }
    
    if(i_admin.size() > 0){
        update i_admin;
    }
    
}