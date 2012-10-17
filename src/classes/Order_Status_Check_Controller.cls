public with sharing class Order_Status_Check_Controller {
    private final Order__c order;
    public Boolean hasPermission {get; set;}
    
    public Order_Status_Check_Controller(ApexPages.StandardController stdController) {
        this.order = (Order__c)stdController.getRecord();
        String userProfileName = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
        String transferStatus = [SELECT Id, Transfer_Status__c FROM Order__c WHERE Id = :order.Id].Transfer_Status__c;
        
        if (userProfileName.Contains('TNT Portal Customer Manager') && transferStatus != null && transferStatus != '') {
            hasPermission = false;
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You do not have permission to view this order'));
        } else {
            hasPermission = true;
        }
    } 

    // Tests    
    public static testMethod void testThis()
    {
        //User usr = [SELECT Id, Name, ProfileId FROM User WHERE Profile.Name = 'PKMS Portal Customer Manager' AND IsActive = TRUE limit 1];
        //Profile prof = [SELECT Id, Name FROM Profile WHERE Id =: usr.ProfileId];
        
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        order.Transfer_Status__c = 'Pending-Transfer';
        insert order;
        
        try{
	        // Branch 1
	        //System.RunAs(usr)
	        {
	            // initialise page & controller
	            PageReference pageRef = Page.Order_Done;
	            Test.setCurrentPage(pageRef);  
	            ApexPages.StandardController stdController = new ApexPages.StandardController(order);
	            Order_Status_Check_Controller controller = new Order_Status_Check_Controller(stdController);
	        }
	        
	        // create objects
	        CustomerCompany = new Account(Name = 'cc', 
	                                      Default_Packaging_Type__c = 'Blank');
	        upsert CustomerCompany;
	        order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
	                                        Name = '123',
	                                        Start_Ship_Date__c = System.today());
	        order.Transfer_Status__c = '';
	        upsert order;
	        
	        // Branch 2
	        //System.RunAs(usr)
	        {
	            // initialise page & controller
	            PageReference pageRef = Page.Order_Done;
	            Test.setCurrentPage(pageRef);  
	            ApexPages.StandardController stdController = new ApexPages.StandardController(order);
	            Order_Status_Check_Controller controller = new Order_Status_Check_Controller(stdController);
	        }
	    } catch (exception e){}
	}
}