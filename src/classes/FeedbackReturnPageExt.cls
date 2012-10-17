public class FeedbackReturnPageExt {

    private ApexPages.StandardController controller;
                                             
    public feedbackReturnPageExt(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    
    public String emailToCheck{ 
        get {
            if (emailToCheck == null) {
                emailToCheck = '';
            }
            return emailToCheck;
        } 
        set; 
    }
    
    //public Boolean stationary{ 
    //  get {
    //      if  (stationary == null) {
    //          stationary = false;
    //      }   
    //      return stationary;
    //  } 
    //  set; 
    //}
    
    public PageReference onStationaryClick() {
        return new PageReference('http://www.tnt.co.uk/stationery');
    }
    
    public PageReference save(){
        Feedback__c fb = (Feedback__c)controller.getRecord();
        
        //fb.Stationary_Request__c = stationary;
        
        if (fb.email__c == null ||  fb.email__c == emailToCheck)
        {
          String CustomerEnteredAccountNumber = fb.Customer_Entered_Account_Number__c ;

          if(CustomerEnteredAccountNumber !=null && CustomerEnteredAccountNumber !='') 
          {
                Account[] a = [select id from Account where TNT_Account_Number__c=:CustomerEnteredAccountNumber];
                if (!a.isEmpty())
                {
                    fb.Account__c = a[0].id;
                    fb.Account_Match__c = true;
                    controller = new ApexPages.StandardController(fb);
                }
          }
          
          fb.Source__c = 'Web';
          
          if ((fb.Subject__c.toUpperCase().contains('IR-')) || (fb.Customer_Comments__c.toUpperCase().contains('IR-'))) {
              fb.Source__c = 'Internet Registration';
          }
          
          RecordType rt = [select id from RecordType where Name='Received'];
          fb.RecordTypeId = rt.id;
          PageReference ref = controller.save();
          if (ref!=null)
          {
                   system.debug('webfeedbackthankyou page ' + Page.webFeedbackThankyou.getURL());
                   system.debug('id ' + controller.getId());

                   PageReference pageRef;

                   //if (fb.Stationary_Request__c) {
                   //    pageRef = new  PageReference(Page.webFeedbackThankyouWithStationary.getURL() );
                   //}
                   //else {
                   //    pageRef = new  PageReference(Page.webFeedbackThankyou.getURL() );
                   //}
                   
                   pageRef = new  PageReference(Page.webFeedbackThankyou.getURL() );
                   pageRef.getParameters().put('id',controller.getid());
                   pageRef.setRedirect(true);
                   return pageRef;
            } 
            else 
                return null;
         } 
         else 
         { 
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'the email addresses do not match');
             ApexPages.addMessage(myMsg);
             return null;
         }
    }

    public void defaultValues(){
        Feedback__c fb = (Feedback__c)controller.getRecord();
        fb.country_of_residence__c = 'United Kingdom';       
        // stationary = false; 
        controller = new ApexPages.StandardController(fb);
    }
    
    static testmethod void testControllerSave(){
    
        Account a = new Account(name='test', TNT_Account_Number__c = 'externalID');
        insert a;
        Feedback__c fb = new Feedback__c(first_name__c='testController',
                                         last_name__c='test',
                                         email__c='test@test.com',
                                         subject__c = 'test subject',
                                         customer_comments__c = 'test',
                                         Customer_Entered_Account_Number__c = a.TNT_Account_Number__c,
                                         resolution_comments__c = 'comment'
                                         );
        insert fb;
        
        ApexPages.StandardController cont = new ApexPages.StandardController(fb);
        FeedbackReturnPageExt ext = new FeedbackReturnPageExt (cont);
        ext.defaultValues();
        
        
        test.startTest();
        
        // save without email verification
        ext.save();
        // fix it
        ext.emailToCheck = fb.email__c;
        
        System.Debug(ext.emailtocheck);
        
        PageReference pageref = ext.save();
        test.stopTest();
        fb = [select account__c from Feedback__c where email__c=:'test@test.com' and first_name__c='testController'];
        System.assertEquals(fb.account__c,a.id);
        System.assertNotEquals(null,pageref.getUrl());
        
        
                           
    }

}