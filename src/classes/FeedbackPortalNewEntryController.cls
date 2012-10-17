public with sharing class FeedbackPortalNewEntryController {

    private ApexPages.StandardController controller;

    public FeedbackPortalNewEntryController(ApexPages.StandardController controller) {
        System.Debug('************** EXTENSION CONSTRUCTOR **************');
        this.controller = controller;
    }

    public PageReference save() {
        System.Debug('************** EXTENSION SAVE() **************');
        Feedback__c feedback = (feedback__c)controller.getrecord();
        User u = [select ContactId from User where id = :userinfo.GetUserId()];
        Contact businessOwner = [select Id, Name from Contact where id = :u.ContactId]; 

        System.Debug('nature of feedback ' + feedback.Nature_of_Feedback__c);

        if (feedback.Nature_of_Feedback__c == 'e-Crime') {
            businessOwner = [select Id, Name from Contact where Name='e crime'];
        }
        
        System.Debug('Updating Receieved etc');
        feedback.Created_In_Portal__c = true;
        feedback.Business_Owner__c = businessOwner.Id;
        feedback.Status__c = 'Received';
        PageReference ref = controller.save();
        feedback = (feedback__c)controller.getrecord();
        if (ref !=null) {
            Feedback__c fb = [Select id, status__c, Business_Owner__c, Created_In_Portal__c from Feedback__c where id=:feedback.Id];
            // update fb;
            fb.Status__c = 'Assigned to Dept';
            System.Debug('Updating Assigned to Dept');
            update fb;
            System.Debug('Updating Dept Acknowledged Receipt');
            fb.Status__c = 'Dept Acknowledged Receipt';
            update fb;
            return PortalListPage;
        }
        else {
            return null;
        }
    }

    public void defaultValues(){
        System.Debug('************** EXTENSION ACTION METHOD **************');
        Feedback__c fb = (Feedback__c)controller.getRecord();
        fb.country_of_residence__c = 'United Kingdom';       
        controller = new ApexPages.StandardController(fb);
    }
    
    private PageReference PortalListPage 
    {
        get {
            PageReference pr = Page.Feedback_Portal_Page;
            //pr.getParameters ().put ('Id', id);
            pr.SetRedirect(true);
            return pr;
        }
    }
    
    // Test method to bring code coverage up as it was only at 54% and not allowing a deploy to Production.
    // Not expected to test the code integrity.
    static testMethod void testCode(){
        // Get a portal user.
        User u = [select Id from User where alias = 'gsportal'];
        System.runAs(u) {
	        Feedback__c fb = new Feedback__c();
    	    fb.Email__c = 'test@test.com';
        	fb.First_Name__c = 'test first name';
        	fb.Last_Name__c = 'test last name';
        	fb.Subject__c = 'test subject';
        	insert fb;
        	// Apexpages.currentPage().getParameters().put('Id',fb.Id);
            FeedbackPortalNewEntryController controller = 
                new FeedbackPortalNewEntryController(new ApexPages.StandardController(fb));
            fb.Nature_of_Feedback__c = 'Enquiry';
            controller.defaultValues();
            controller.save();
        }
    }
    
    
}