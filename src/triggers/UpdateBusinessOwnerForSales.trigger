trigger UpdateBusinessOwnerForSales on Feedback__c (before update) {
 
    Contact c;
 
    try {
        c = [select ID from Contact where Name='Indoor Sales Team'];
    }
    catch(Exception e) {
        c = null;
    }
   
    for (Feedback__c fb : trigger.new) {
    

        if ((fb.Nature_of_Feedback__c == 'Enquiry') && (fb.Type__c == 'Sales') && (fb.New_Business__c == true)&&(fb.Status__c!='Completed'))
        {
             
            if (c != null) {
                fb.Business_Owner__c = c.Id;
                fb.status__c = 'Assigned to Dept' ;               
             }
            else {
                fb.AddError('Missing Sales Team Business Owner. See your admin');
            }
        
        }        
        
    }
}