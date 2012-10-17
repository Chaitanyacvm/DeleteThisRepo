trigger Idea_Admin_Object_Trigger on Idea_Admin__c (after update, before update) {   
    
    
if(trigger.isBefore){
	/*
    //aaron additions
    if(trigger.isUpdate){
    List<Idea> i_admin = new List<Idea>();    
    
    for(Idea i : [SELECT Id, Inappropriate_Flag_By_SC__c,Idea_Admin__c,Idea_Admin__r.Inappropriate_Flag__c, Iadmin_flag__c FROM Idea WHERE Idea_Admin__c = :Trigger.newMap.keySet()]) {
        
        if(i.Inappropriate_Flag_By_SC__c != i.Idea_Admin__r.Inappropriate_Flag__c){
            i.Inappropriate_Flag_By_SC__c = i.Iadmin_flag__c;

            i_admin.add(i);
        }       
    }
    
    if(i_admin.size() > 0){
        update i_admin;
    }
       
	}
	//aaron end additions
	*/
}

if(trigger.isAfter){
    
    List<Idea> i_dea = new List<Idea>();
    
    Set<Id> i_ids = new Set<Id>();
    
    for(Idea_Admin__c iA : [SELECT Id, Idea__r.Id FROM Idea_Admin__c WHERE Id IN :Trigger.newMap.keySet()]) {
        i_ids.add(iA.Idea__r.Id);
    }
    
    for(Idea i : [SELECT Inappropriate_Flag_By_SC__c, Idea_Location__r.RCIM_Queue__r.Id, Idea_Location__r.Delivering_More_Queue__r.Id, Idea_Location__r.Evaluator_Queue__r.Id, Idea_Location__r.CCIM_Queue__r.Id, Assigned_Admin__c, Idea_Rewarded__c, Additional_Information_Question__c, Additional_Information_Question_SC__c, Request_Additional_Information__c, Request_Additional_Information_SC__c, Id, Status, Decision__c, National_Evaluator__c, Delivery_More_Approved__c, Workflow_Status__c, Status__c, Move_Idea_To__c  FROM Idea WHERE Id IN :i_ids]) {
    for(Idea_Admin__c iA : [SELECT Id, Inappropriate_Flag__c, Idea_In_Action__c,  Assign_National_Evaluator__r.Delivering_More_Issuer__r.Id, Assign_National_Evaluator__c, Workflow_Status__c, Status__c, Evaluation__c, Idea__r.Id FROM Idea_Admin__c WHERE Id IN :Trigger.newMap.keySet()]) {    
        
        if(i.Id == iA.Idea__r.Id){
        	//aaron added 1 line below
            i.Inappropriate_Flag_By_SC__c = iA.Inappropriate_Flag__c;
            i_dea.add(i);

        if(i.Workflow_Status__c != iA.Workflow_Status__c){
            i.Workflow_Status__c = iA.Workflow_Status__c;
            

            if(iA.Workflow_Status__c == 'RCIM Queue'){
                
                i.Request_Additional_Information__c = null;
                i.Request_Additional_Information_SC__c = null;
                i.Additional_Information_Question_SC__c = null;
                i.Additional_Information_Question__c = null;
                i.Move_Idea_To__c = 'Local';
                i.Decision__c = null;
                i.Delivery_More_Approved__c = null;
                i.National_Evaluator__c = null;
                i.Status__c = 'New';
                i.Status = 'New';
                
                i.Assigned_Admin__c = i.Idea_Location__r.RCIM_Queue__r.Id;
                
            }else if(iA.Workflow_Status__c == 'Sensibility Check Queue'){
            
                i.Request_Additional_Information__c = null;
                i.Request_Additional_Information_SC__c = null;
                i.Additional_Information_Question_SC__c = null;
                i.Additional_Information_Question__c = null;
                i.Move_Idea_To__c = 'National';
                i.Decision__c = null;
                i.Delivery_More_Approved__c = null;
                i.National_Evaluator__c = null;
                i.Status__c = 'Acknowledged';
                i.Status = 'Acknowledged';
                
                i.Assigned_Admin__c = i.Idea_Location__r.CCIM_Queue__r.Id;
                
            }else if( iA.Workflow_Status__c == 'Local Evaluator Queue'){
                
                i.Request_Additional_Information__c = null;
                i.Request_Additional_Information_SC__c = null;
                i.Additional_Information_Question_SC__c = null;
                i.Additional_Information_Question__c = null;
                i.Move_Idea_To__c = 'Local';
                i.Decision__c = null;
                i.Delivery_More_Approved__c = null;
                i.National_Evaluator__c = null;
                i.Status__c = 'Acknowledged';
                i.Status = 'Acknowledged';
                
                i.Assigned_Admin__c = i.Idea_Location__r.Evaluator_Queue__r.Id;
                
            }else if(iA.Workflow_Status__c == 'National Evaluator Queue' ){
                
                i.Request_Additional_Information__c = null;
                i.Request_Additional_Information_SC__c = (i.Request_Additional_Information_SC__c == null)?'No':i.Request_Additional_Information_SC__c;
                i.Move_Idea_To__c = 'National';
                i.Decision__c = null;
                i.Delivery_More_Approved__c = null;
                i.Status__c = 'In Progress';
                i.Status = 'In Progress'; 
                
                i.Assigned_Admin__c = iA.Assign_National_Evaluator__c;
                
            }else if(iA.Workflow_Status__c == 'Local Delivering More Queue' ){
                
                i.Request_Additional_Information__c = (i.Request_Additional_Information__c == null)?'No':i.Request_Additional_Information__c;
                i.Move_Idea_To__c = 'Local';
                i.Decision__c = (i.Decision__c == null)?'One for the Future':i.Decision__c;
                i.Delivery_More_Approved__c = null;
                i.Status__c = 'In Progress';
                i.Status = 'In Progress';
                i.Idea_Rewarded__c = 'Yes';
                
                i.Assigned_Admin__c = i.Idea_Location__r.Delivering_More_Queue__r.Id;
                
            }else if(iA.Workflow_Status__c == 'National Delivering More Queue' ){
                
                i.Request_Additional_Information__c =  (i.Request_Additional_Information__c == null)?'No':i.Request_Additional_Information__c;
                i.Request_Additional_Information_SC__c =  (i.Request_Additional_Information_SC__c == null)?'No':i.Request_Additional_Information_SC__c;
                i.Move_Idea_To__c = 'National';
                i.Decision__c = (i.Decision__c == null)?'One for the Future':i.Decision__c;
                i.Delivery_More_Approved__c = null;
                i.Status__c = 'In Progress';
                i.Status = 'In Progress';
                i.Idea_Rewarded__c = 'Yes';
                
                i.Assigned_Admin__c = iA.Assign_National_Evaluator__r.Delivering_More_Issuer__r.Id;
                
            }
            
            if(iA.Idea_In_Action__c){
                i.Status__c = 'In Action';
                i.Status = 'In Action';
            }
            
            // aaron commented: i_dea.add(i);
        }
        }
    }
    
    }
    
    if(i_dea.size() > 0){
        update i_dea;
    }
}    
}