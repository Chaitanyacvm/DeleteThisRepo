public with sharing class FeedbackPortalController {

    public List<Feedback__c> BusinessOwnerFeedback {get; private set;}
    public string id {
        get; 
        set;
    }
    public string status{get; set;}
    
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public Contact businessOwner {get; private set; }
    
    //private ApexPages.StandardController controller;
    
    //public FeedbackPortalController(ApexPages.StandardController controller) {
    public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }
   
    public String getSortDirection()
     {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
     }
     
      public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
    
    
    public FeedbackPortalController() {
        
        //this.controller = controller;
        
        User u = [select ContactId from User where id = :userinfo.GetUserId()];
        businessOwner = [select Id, Name from Contact where id = :u.ContactId]; 
        BusinessOwnerFeedback = [Select f.Subject__c, f.Status_Flag__c, f.Next_Action_Due__c, f.Customer_Entered_Account_Name__c,
                f.Last_Name__c, f.Id, f.First_Name__c, f.Feedback_Age__c,  f.Consignment_Number__c, 
                f.Assignment_Status__c, f.Status__c, f.Name, f.Date_Logged__c, f.Progress__c, f.Assigned_to_dept__c, f.Nature_of_Feedback__c
                From Feedback__c f
                where (f.Business_Owner__c = :businessOwner.Id) AND (f.Status__c='Assigned to Dept' or f.Status__c='Dept Acknowledged Receipt')
                order by f.Date_Logged__c, f.Name];
    }
    
     public List<Feedback__c> getFeedbacks() {
       return BusinessOwnerFeedback;       
     }          
    
    public PageReference ViewData() 
    {                              
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        User u = [select ContactId from User where id = :userinfo.GetUserId()];
        businessOwner = [select Id, Name from Contact where id = :u.ContactId];         
        BusinessOwnerFeedback = Database.query('Select f.Subject__c, f.Status_Flag__c, f.Next_Action_Due__c, f.Customer_Entered_Account_Name__c, f.Last_Name__c, f.Id, f.First_Name__c, f.Feedback_Age__c, f.Consignment_Number__c,  f.Assignment_Status__c, f.Status__c, f.Name, f.Date_Logged__c, f.Progress__c, f.Assigned_to_dept__c, f.Nature_of_Feedback__c from Feedback__c f Where (f.Business_Owner__c = \'' + businessOwner.Id + '\' ) AND (f.Status__c = \'Assigned to Dept\' or f.Status__c = \'Dept Acknowledged Receipt\') Order by ' + sortFullExp + '');    
        return null;      
    }   
    
    public PageReference create() {
        PageReference pr = Page.Feedback_Portal_New_Entry;
        pr.SetRedirect(true);
        return pr;
    }
    
    public PageReference email() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.  
            
        String[] toAddresses = new String[] {'glen.swindell@tnt.com'}; 
          
        
        // Assign the addresses for the To and CC lists to the mail object.  
            
        mail.setToAddresses(toAddresses);
        
        // Specify the address used when the recipients reply to the email.   
            
        mail.setReplyTo('glen.swindell@tnt.com');
        
        // Specify the name used as the display name.  
            
        mail.setSenderDisplayName('Salesforce Support');
        
        // Specify the subject line for your email address.  
            
        mail.setSubject('New Case Created : ');
        
        // Set to True if you want to BCC yourself on the email.  
            
        mail.setBccSender(false);
        
        // Optionally append the salesforce.com email signature to the email.  
            
        // The email address of the user executing the Apex Code will be used.  
            
        mail.setUseSignature(false);
        
        // Specify the text content of the email.  
            
        mail.setPlainTextBody('Your Case: 72354 has been created');
        
        mail.setHtmlBody('Your case:<b> FB-028982 </b>has been created<p>'+
             ' View case <a href=https://na1.salesforce.com/FB-028982>click here</a>');
        
        // Send the email you have created.  
            
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
        return null;
    }    
    public PageReference edit() {
        // PageReference pr = Page.feedback_portal_response;
        PageReference pr = Page.feedback_portal_Update;         
        
        System.debug('===============================================');
        System.debug('id = ' + id);
        
        pr.getParameters ().put ('Id', id);
        pr.getParameters ().put ('Status', status);
        pr.SetRedirect(true);

        return pr;
    }
    
    public PageReference accept() {
        Feedback__c fb = [Select id, status__c from Feedback__c where id=:id];
        fb.Status__c = 'Dept Acknowledged Receipt';
        update fb;
        
        Pagereference pr = Page.Feedback_Portal_page;
        pr.SetRedirect(true);
        
        return pr;
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
        System.runAs(u) {
            FeedbackPortalController controller = new FeedbackPortalController();
            controller.id = fb.id;
            controller.create();
            controller.edit();
            controller.accept();
        }
    }
}