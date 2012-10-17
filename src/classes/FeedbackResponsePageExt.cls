public class FeedbackResponsePageExt {

    private ApexPages.StandardController controller;
                                             
    public FeedbackResponsePageExt (ApexPages.StandardController controller) {
        system.debug('Constructor Start');
        this.controller = controller;
        
        if (this.controller == null) {
            system.debug('No controller');
        }
        
        system.debug('Constructor End');
    }
    
    public Boolean RecordDeleted {
        get {
            system.debug('RecordDeleted Start');
            Boolean result = true;
            String idPassed = ApexPages.currentPage ().getParameters ().get ('Id');
            system.debug('ID passed - ' + idPassed);
            try {
                Feedback__c existingRecord = [select Name, Id from Feedback__c where Id = :idPassed];
                if (existingRecord != null) {
                    result = false;
                }
            }
            catch (QueryException ex) {
                result = true;
            }
            system.debug('RecordDeleted End');
            return result;
        }
    }
    
    public String Id {
        get {
            return ApexPages.currentPage ().getParameters ().get ('Id');            
        }
    }
    
    public PageReference save(){
        Feedback__c fb = (Feedback__c)controller.getRecord();
        fb.Status__c = 'Dept Resolved';
        String FBId = fb.Id;
        
        Feedback__c existingRecord = [select Id, resolution_comments__c from Feedback__c where Id=:FBId limit 1];
        
        if (existingRecord.resolution_comments__c != null) {
        
          Note n = new Note();
          n.parentid = FB.id;
          n.body = fb.resolution_comments__c;
          n.title= 'Further resolution comments';
          insert n;
            
          fb.resolution_comments__c = existingRecord.resolution_comments__c;
        }
        
        PageReference ref = controller.save();
        if (ref!=null){
           PageReference pr = Page.responseFeedbackThankYou;
           pr.setRedirect(true); 
           return pr;
        } 
        else return null;
    }

    static testmethod void testControllerSave(){
    
        Feedback__c fb = new Feedback__c(first_name__c='testController',
                                         last_name__c='test',
                                         subject__c='test subject',
                                         email__c='test@test.com',
                                         country_of_residence__c = 'Australia',
                                         customer_comments__c = 'test',
                                         resolution_comments__c = 'test resolution'
                                         );
        insert fb;
        //String FBId = 'a07R00000040mfk';
        //Feedback__c FB = [select Id, resolution_comments__c from Feedback__c where Id=:FBId limit 1];
        
        FB.resolution_comments__c = 'This has changed ....';
         
        ApexPages.StandardController cont = new ApexPages.StandardController(fb);
        FeedbackResponsePageExt ext = new FeedbackResponsePageExt(cont);
        test.startTest();
        PageReference pageref = ext.save();
        system.debug('directed to ' + pageref);
        
        System.Debug('ID ...' + ext.Id);
        System.Debug('Is Deleted ...' + ext.RecordDeleted);
        
        test.stopTest();
        System.assertEquals(Page.responseFeedbackThankYou.getUrl(),pageref.getUrl());
        
                               
    }

}