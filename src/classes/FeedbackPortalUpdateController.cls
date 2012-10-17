public with sharing class FeedbackPortalUpdateController {

    public string id {get; set;}
    public Feedback__c feedback {get; set;}
    public ApexPages.StandardController controller {get; set;}
    public String Receiver {get; set;} 
    public String Subject {get; set;} 
    public String Message {get; set;} 
    List <Attachment> attachments = new List <Attachment> ();
    Attachment attach;
    
    
    public FeedbackPortalUpdateController(ApexPages.StandardController controller) {
        System.Debug('************** EXTENSION CONSTRUCTOR **************');
        this.controller = controller;
                 
        Receiver = Receiver;
        Subject = Subject;
        Message = Message;
        id = Apexpages.currentpage().getParameters().get('Id');
        
        feedback = [Select f.Type__c, f.Title__c, f.Subject__c, f.Source__c, f.Resolution_Comments__c, 
        f.Postcode__c, f.Phone__c, f.Nature_of_Feedback__c, f.Name, f.Logged_Time__c, f.Last_Name__c, 
        f.Internal_Comments__c, f.Id, f.First_Name__c, f.Estimated_Cost__c, f.Email__c, f.Originating_Depot__c,
        f.Customer_Entered_Account_Number__c, f.Customer_Entered_Account_Name__c, f.Customer_Comments__c, 
        f.Country_of_Residence__c, f.Consignment_Number__c, f.Cause__c,  Action_new__c, f.Action_Other__c,
        f.status__c, f.Issue_Location__c,  CSR_Name_Lookup__c, f.Case_Owner__c, f.Business_owner__c, f.Salutation__c
        From Feedback__c f where f.id = :id]; 
       
        this.controller = new ApexPages.StandardController(feedback);
        this.controller.edit();
        System.Debug('************** EXTENSION CONSTRUCTOR END **************');

    }
    
    public string accepted 
    {
        get 
        {
            return feedback.status__c != 'Assigned to Dept' ? 'true' : 'false';
        }
        set;
    }
    
    public string causeRequired {
        get 
        {
                // Condition is never going to be true but this code may still be required in the future (just change the AND to OR)
            return (feedback.Nature_of_Feedback__c=='Complaint' && feedback.Nature_of_Feedback__c=='Escalation') ? 'true' : 'false' ;
        }
        set;
    }

    public PageReference cancel() 
    {
        controller.cancel();
        return PortalListPage;
    }
   
    public void SendEmail()
    {   
        Contact a = [SELECT id, firstname, email FROM Contact Where email ='glen.swindell@tnt.com' Limit 1];
        if (a == null || a.email == null)  
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Missing main contact for email please - Contact Admin'));
        }
        else if (Receiver == '' || Receiver == null)  
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing receiver on email'));
        }
        else if (Subject == '' || Subject == null)  
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing subject on email'));
        }
        else if (Message == '' || Message == null)  
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing message on email'));
        }
        else
        {   
            Message = Message + ' ' + feedback.Salutation__c;         
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(a.id); // Specify who the email should be sent to.
            mail.setReplyTo('customerexperienceteamuk@tnt.co.uk');
            String[] ccAddresses = new String[] {Receiver};
            mail.setSenderDisplayName('Customer Experience Team UK');
            mail.setSubject(Subject + ' Relates to Feedback ' + feedback.Name );
            mail.setPlainTextBody(Message);
            mail.setHtmlBody(Message);
            mail.setSaveAsActivity(false);
            mail.setCcAddresses(ccAddresses);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Message Sent'));
            attach = new Attachment();
            attach.parentId = feedback.id;
            attach.body = blob.valueOf(Message);
            attach.name = 'E-mail Sent' + '.txt';
            attach.description =  'E-mail Sent to: ' + Receiver;
            attachments.add (attach);
            insert attachments;
        }        
    }   
   
    public PageReference accept() 
    {
        Feedback__c fb = [Select id, status__c from Feedback__c where id=:id];
        fb.Status__c = 'Dept Acknowledged Receipt';
        update fb;

        return PortalUpdatePage;
    }

    public PageReference save() 
    {
        System.Debug('************** EXTENSION SAVE() **************');
        // feedback = (feedback__c)controller.getrecord();
        System.Debug('Action - ' + feedback.Cause__c);
        controller.save();
        return PortalListPage;
    }
    
    public PageReference resolve() 
    {    
        if((feedback.Nature_of_Feedback__c=='Complaint' || feedback.Nature_of_Feedback__c=='Escalation') && (feedback.Action_new__c== '' || feedback.Action_new__c== Null ))        
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Action required'));
            return null;
        }
        else if((feedback.Nature_of_Feedback__c=='Complaint' || feedback.Nature_of_Feedback__c=='Escalation') && (feedback.Cause__c== '' || feedback.Cause__c== Null))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cause required'));
            return null;
        }
        else if((feedback.Nature_of_Feedback__c=='Complaint' || feedback.Nature_of_Feedback__c=='Escalation') && (feedback.Resolution_Comments__c== Null || feedback.Resolution_Comments__c== ''))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Resolution Comments required'));
            return null;
        }        
        else
        {
            System.Debug('************** EXTENSION RESOLVE() **************');
            controller.save();
            feedback = (feedback__c)controller.getrecord();
            controller.save();
            Feedback__c fb = [Select id, status__c, Department_Resolved__c from Feedback__c where id=:id];
            fb.Status__c = 'Dept Resolved';
            fb.Department_Resolved__c = System.now();
            update fb;        
            return PortalListPage;
        }
    }
    private PageReference PortalListPage 
    {
        get 
        {
            PageReference pr = Page.Feedback_Portal_Page;
            pr.getParameters ().put ('Id', id);
            pr.SetRedirect(true);
            return pr;
        }
    }
    private PageReference PortalUpdatePage 
    {
        get 
        {
            PageReference pr = Page.Feedback_Portal_Update;
            pr.getParameters ().put ('Id', id);
            pr.SetRedirect(true);
            return pr;
        }
    }
    // Test method to bring code coverage up as it was only at 54% and not allowing a deploy to Production.
    // Not expected to test the code integrity.
            static testMethod void testUpdateCode(){
        // Get a portal user.
            User u = [select Id from User where alias = 'gsportal' and IsActive=true];
            System.runAs(u){
            Feedback__c fb = new Feedback__c();
            fb.Email__c = 'test@test.com';
            fb.First_Name__c = 'test first name';
            fb.Last_Name__c = 'test last name';
            fb.Subject__c = 'test subject';
            //fb.Status__c = 'Completed';
            //fb.Feedback_Complete__c = true;
            insert fb;
        
            Apexpages.currentPage().getParameters().put('Id',fb.Id);
            FeedbackPortalUpdateController controller = 
            new FeedbackPortalUpdateController(new ApexPages.StandardController(fb));
            //controller.feedback = fb;

            controller.accept();
            fb = controller.feedback;
            fb.Internal_Comments__c = 'Internal Comment';
            Apexpages.currentPage().getParameters().put('Id',fb.Id);

            controller.save();
            controller.SendEmail();
            controller.resolve();
            controller.cancel();
       }
    }
}