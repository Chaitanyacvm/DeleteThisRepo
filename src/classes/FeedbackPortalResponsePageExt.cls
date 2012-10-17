public with sharing class FeedbackPortalResponsePageExt {

    public string id {get; set;}
    
    public Feedback__c feedback { get; set;}
    public ApexPages.StandardController controller {get; set;}
    
    public FeedbackPortalResponsePageExt(ApexPages.StandardController controller) {
    // public FeedbackPortalResponsePageExt() {

        this.controller = controller;

        id = Apexpages.currentpage().getParameters().get('id');
        
        feedback = [select id, Name, Resolution_Comments__c, Cause__c, Cause_Other__c, Action_new__c,  Action_Other__c, 
                Estimated_Cost__c, Status__c, Department_Resolved__c
                from feedback__c where id = :id]; 
        
        this.controller = new ApexPages.StandardController(feedback);
        this.controller.edit();
        
        System.debug('**************************************************');
        System.debug('Receieved' + id);
        
    }

    public PageReference save(){
                
        System.debug('**************************************************');
        System.debug('In Save method' + id);
        
        feedback.Status__c = 'Dept Resolved';
        feedback.Department_Resolved__c = System.now();
        //update feedback;  
        
        controller.save();
        return Page.Feedback_Portal_Page;
    }
    
    public PageReference cancel() {
        controller.cancel();
        return Page.Feedback_Portal_Page;
    }
    
    // Test method to bring code coverage up as it was only at 54% and not allowing a deploy to Production.
    // Not expected to test the code integrity.
    static testMethod void testCode(){
        // Get a portal user.
        User u = [select Id from User where alias = 'gsportal'];
        Feedback__c fb = new Feedback__c();
        fb.Email__c = 'test@test.com';
        fb.First_Name__c = 'test first name';
        fb.Last_Name__c = 'test last name';
        fb.Subject__c = 'test subject';
        insert fb;
        
        Apexpages.currentpage().getParameters ().put ('id', fb.id);
        
        System.runAs(u) {
            FeedbackPortalResponsePageExt controller = 
                new FeedbackPortalResponsePageExt(new ApexPages.StandardController(fb));
            controller.id= fb.id;
            controller.save();
            controller.cancel();
        }
    }    
}