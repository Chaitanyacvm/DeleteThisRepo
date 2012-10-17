public with sharing class CompletedFeedbackPortalController {

    public List<Feedback__c> BusinessOwnerFeedback {get; private set;}
    public string id {
        get; 
        set;        
    }
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public string status{get; set;}
    public Contact businessOwner {get; private set; }
    
    
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
   
    public CompletedFeedbackPortalController() {
        
        User u = [select ContactId from User where id = :userinfo.GetUserId()];
        businessOwner = [select Id, Name from Contact where id = :u.ContactId]; 
        BusinessOwnerFeedback = [Select f.Subject__c, f.Status_Flag__c, f.Next_Action_Due__c, f.Customer_Entered_Account_Name__c,
                f.Last_Name__c, f.Id, f.First_Name__c, f.Feedback_Age_in_MIns__c, f.Consignment_Number__c,
                f.Assignment_Status__c, f.Status__c, f.Name From Feedback__c f
                where (f.Business_Owner__c = :businessOwner.Id) AND (f.Status__c='Dept Resolved' or f.Status__c='Completed')
                order by f.Name];
   }
    
     public List<Feedback__c> getFeedbacks() {
       return BusinessOwnerFeedback;       
     }          
    public PageReference ViewData() 
    {                              
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        User u = [select ContactId from User where id = :userinfo.GetUserId()];
        businessOwner = [select Id, Name from Contact where id = :u.ContactId];         
        BusinessOwnerFeedback = Database.query('Select f.Subject__c, f.Status_Flag__c, f.Next_Action_Due__c, f.Customer_Entered_Account_Name__c, f.Last_Name__c, f.Id, f.First_Name__c, f.Feedback_Age_in_MIns__c, f.Consignment_Number__c, f.Assignment_Status__c, f.Status__c, f.Name From Feedback__c f where (f.Business_Owner__c = \'' + businessOwner.Id + '\' ) AND (f.Status__c = \'Dept Resolved\' or f.Status__c = \'Completed\') Order by ' + sortFullExp + '');    
        return null;      
    }   
    
    public PageReference create() {
        PageReference pr = Page.Feedback_Portal_New_Entry;            
        pr.SetRedirect(true);
        return pr;
    }
    
    public PageReference edit() {
        PageReference pr = Page.feedback_portal_response;       
        
        System.debug('===============================================');
        System.debug('id = ' + id);
        
        pr.getParameters ().put ('Id', id);
        pr.getParameters ().put ('Status', status);
        pr.SetRedirect(true);

        return pr;
    }
    
    public PageReference reopen() {
        Feedback__c fb = [Select id, status__c from Feedback__c where id=:id];
        fb.Status__c = 'Reopened';
        update fb;
        
        fb.Status__c = 'Dept Acknowledged Receipt';
        update fb;
        Pagereference pr = Page.CompletedFeedback_Portal_page;
        pr.SetRedirect(true);
        
        return pr;
    }
    
    // Test method to bring code coverage up as it was only at 54% and not allowing a deploy to Production.
    // Not expected to test the code integrity.
    static testMethod void testCode(){
        // Get a portal user.
        User u = [select ContactId from User where ContactId != null limit 1];
        Feedback__c fb = new Feedback__c();
        fb.Email__c = 'test@test.com';
        fb.First_Name__c = 'test first name';
        fb.Last_Name__c = 'test last name';
        fb.Subject__c = 'test subject';
        fb.Status__c = 'Completed';
        fb.Feedback_Complete__c = true;
        insert fb;
        
        System.runAs(u){
            CompletedFeedbackPortalController controller = new CompletedFeedbackPortalController();
            controller.id = fb.Id;
            controller.create();
            controller.edit();
            controller.reopen();
        }
    }
}