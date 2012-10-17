@istest
private class FBReserNextActionDueTestClass
{    
    static testMethod void testReserNextActionDue ()
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
        
        fb.Days_To_Update__c = 5;
        update fb;
        
    }
}