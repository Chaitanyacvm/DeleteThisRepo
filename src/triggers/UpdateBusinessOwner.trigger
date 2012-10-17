trigger UpdateBusinessOwner on Feedback__c (before update) {
 
    Contact c;
 
    try {
        c = [select ID from Contact where Name='e crime'];
    }
    catch(Exception e) {
        c = null;
    }
    
    RecordType rt;
    try {
        rt = [select Id from RecordType where Name='General Feedback' limit 1];
    }
    catch (Exception e) {
        rt = null;
    }
    
    for (Feedback__c fb : trigger.new) {
    
        if ((fb.Nature_of_Feedback__c == 'e-Crime') && (fb.RecordTypeId != rt.Id))
        {
           
           if (rt != null) {
               fb.RecordTypeId = rt.Id;
             
               if (c != null) {
                    fb.Business_Owner__c = c.Id;
                    fb.Status__c = 'Completed';
                    fb.Feedback_Complete__c = true;
                    NextActionDueController ctrl = new NextActionDueController();
                    fb.Assigned_to_dept__c = ctrl.EffectiveTime(DateTime.Now());
                    fb.Assigned_within_1_hour__c = ctrl.IsWithin1Hour(fb);
                   
                    System.Debug('********The department has been assigned********');
                }
                else {
                    fb.AddError('Missing e-crime contact - please contact your admin');
                }
            }
            else {
                fb.AddError('Missing feedback record type - please contact your admin');
            }
        
        }        
        
    }
}