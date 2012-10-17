public class IR_User_CE_Complete_Extension {
    public IR_Customer__c thisCustomer {get; set;}
    
    public IR_User_CE_Complete_Extension(ApexPages.StandardController controller) {
        thisCustomer = IR_Global_Class.getCustomer(controller.getRecord().Id);
    }
    
    public PageReference Complete() {
    	thisCustomer = IR_User_Utils.CE_Complete(thisCustomer);
    	
    	update thisCustomer;
    	
    	if (!ApexPages.hasMessages()) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The Customer has been saved'));
    	}
    	
    	return null;
    }
    
    public PageReference back() {
        PageReference pr = new ApexPages.StandardController(thisCustomer).view();
        pr.setRedirect(true);
        
        return pr;
    }
    
    //**************************Test Methods***********************************//
    
    TestMethod static void test_CE_Complete(){
    	IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
    	
    	   
        ApexPages.currentPage().getParameters().put('id', testCust.Id);
        Test.startTest();
        IR_User_CE_Complete_Extension cont = new IR_User_CE_Complete_Extension(new ApexPages.StandardController(testCust));        
        System.debug(cont.Complete());
        System.debug(cont.back());
        Test.stopTest();
    	
    } 
}