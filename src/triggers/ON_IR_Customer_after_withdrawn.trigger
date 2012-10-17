trigger ON_IR_Customer_after_withdrawn on IR_Customer__c (before update) {
        
        LIST<Note> notesList = new LIST<Note>();
        
        for(IR_Customer__c customer: Trigger.New){
             if(customer.Registration_Status__c == 'Customer Withdrawn'){
                 if(customer.Comments__c != null && customer.Comments__c.length() > 0){
                    Note notes = new Note();
                    notes.Title = 'Customer Experience Comments';
                    notes.Body = customer.Comments__c;
                    notes.ParentId = customer.Id;       
                    customer.Comments__c = null;
                    notesList.add(notes);                  
                 }
             }
        }
        
        try{
            insert notesList;

        }catch(exception ex){
            system.debug(ex);
        }
}