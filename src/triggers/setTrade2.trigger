trigger setTrade2 on FM_Job_Instance__c (before update, before insert) {
    for (FM_Job_Instance__c a: trigger.new) 
    {
        if (a.Job_Type__c != null) 
        {
            // get the job type object
            string id = a.Job_Type__c;
           
           
           
            // get the trade from the object 
            FM_Job_Type__c  job = [select Trade__c from FM_Job_Type__c where id=:id];            
            
            
            a.Trade__c = job.Trade__c;
        }
    }
    }