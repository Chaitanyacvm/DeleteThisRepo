@istest
private class FBStatusToDeptAckTestClass
{    
    static testMethod void testChangeFBStatusToDeptAck ()
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
        
        ApexPages.StandardController cont = new ApexPages.StandardController(fb);
        FeedbackReceiptAck ext = new FeedbackReceiptAck(cont);
        ext.changeFBStatusToDeptAck();               
    }
}