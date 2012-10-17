public class FeedbackReceiptAck {

    private ApexPages.StandardController controller;
    private Feedback__c feedback;
    public FeedbackReceiptAck(ApexPages.StandardController controller) {
        this.controller = controller;
        feedback = (Feedback__c) controller.getRecord ();
        feedback = [select Business_Owner__c, Id from Feedback__c where Id = :feedback.Id];
    }
    
    public Boolean Acknowledged {get; private set;}
    
    public void changeFBStatusToDeptAck()
    {
        String OwnerIdPassed = ApexPages.currentPage ().getParameters ().get ('OwnerId');
        if (feedback.Business_Owner__c == OwnerIdPassed)
        {
            feedback.status__c = 'Dept Acknowledged Receipt';
            Acknowledged = true;
            try { 
                update feedback;
            } catch (DMLException e){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An error occurred please contact your Salesforce.com administrator');
                ApexPages.addMessage(errorMsg);
            }
        }
        else
            Acknowledged = false;
        
    }
    
    public static testMethod void testchangeFBStatusToDeptAck() {    

        Feedback__c fb = new Feedback__c(first_name__c='testController',
            last_name__c='test',
            subject__c='test subject',
            email__c='test@test.com',
            country_of_residence__c = 'Australia',
            customer_comments__c = 'test',
            resolution_comments__c = 'test resolution'
        );
        insert fb;

        FB.resolution_comments__c = 'This has changed ....';

        ApexPages.StandardController cont = new ApexPages.StandardController(fb);
        FeedbackReceiptAck ext = new FeedbackReceiptAck(cont);
        test.startTest();
        ext.changeFBStatusToDeptAck();
        //system.debug('directed to ' + pageref);
        test.stopTest();
        //System.assertEquals(Page.responseFeedbackThankYou.getUrl(),pageref.getUrl());
    }
}