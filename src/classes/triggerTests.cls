@istest
private class triggerTests {
    
    static testMethod void testUpdateBusinessOwner ()
    {
    
         Feedback__c fb = new Feedback__c(first_name__c         = 'testController',
                                         last_name__c           = 'test',
                                         email__c               = 'test@test.com',
                                         customer_comments__c   = 'test',
                                         subject__c             = 'test subject',
                                         resolution_comments__c = 'comment',
                                         phone__c               = '3434343'
                                         );
        
        insert fb;

        RecordType rt = [select Id from RecordType where Name='General Feedback' limit 1];      
        fb.RecordTypeId = rt.Id;
        fb.Nature_of_Feedback__c = 'e-Crime';

        update fb;
        
    }

    static testMethod void testUpdateResolutionStatus ()
    {
         Feedback__c fb = new Feedback__c(first_name__c         = 'testController',
                                         last_name__c           = 'test',
                                         email__c               = 'test@test.com',
                                         customer_comments__c   = 'test',
                                         subject__c             = 'test subject',
                                         resolution_comments__c = 'comment',
                                         phone__c               = '3434343'
                                         );
        insert fb;
                         
        RecordType rt = [select Id from RecordType where Name='General Feedback' limit 1];
        fb.RecordTypeId = rt.Id;
        fb.Nature_of_Feedback__c = 'Compliment';
        fb.Action_new__c = 'Claim Accepted';
        fb.Cause__c = 'No Cause';
        fb.Status__c = 'Completed';
        fb.Feedback_Complete__c = true;
        fb.Department_Resolved__c = fb.CreatedDate;
        fb.Department_Resolved__c = Datetime.now();
        
        update fb;
        
    }

    static testMethod void testUpdateBOForSales ()
    {   
    
         Feedback__c fb = new Feedback__c(first_name__c         = 'testController',
                                         last_name__c           = 'test',
                                         email__c               = 'test@test.com',
                                         customer_comments__c   = 'test',
                                         subject__c             = 'test subject',
                                         resolution_comments__c = 'comment',
                                         phone__c               = '3434343',
                                         Business_Owner__c   = null
                                         );
        insert fb;
        
        
        // Needed to improve current code coverage 70%
        Contact c = new Contact(account = [select name from account where id != null limit 1]);
        c.FirstName = 'Indoor Sales';
        c.LastName = 'Team';
        insert c;
        
        RecordType rt = [select Id from RecordType where Name='General Feedback' limit 1];
        fb.RecordTypeId = rt.Id;
        fb.Type__c = 'Sales';
        fb.New_Business__c = true;
        fb.Nature_of_Feedback__c = 'Enquiry';
        fb.Action_new__c = 'Claim Accepted';
        fb.Cause__c = 'No Cause';
        fb.Business_Owner__c = c.Id;
        
        //update fb; 
    }
}