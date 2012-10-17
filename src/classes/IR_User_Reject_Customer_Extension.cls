public class IR_User_Reject_Customer_Extension {
	public IR_Customer__c customer {get; set;}
	public String errorMSg {get; set;}
	public ApexPages.Severity errorSeverity {get; set;}
	public Boolean confirmed {get; set;}
		
		
	public IR_User_Reject_Customer_Extension(ApexPages.StandardController controller) {
		customer = IR_Global_Class.getCustomer(controller.getRecord().Id);		
		confirmed = false;
	}
	
	public void rejectCustomer() {
		try {
			confirmed = true;
						
			if (customer.Registration_Status__c != 'Rejected') {
				customer = IR_User_Utils.user_reject(customer);
				
				if (customer.Registration_Status__c == 'Rejected') {
					errorMsg = 'Customer has been Rejected and the sales team has been notified.';
					errorSeverity = ApexPages.Severity.CONFIRM;
				} else if(!ApexPages.hasMessages()){
					errorMsg = 'There has been an ERROR while rejecting the please do contact you Administrator.';
					errorSeverity = ApexPages.Severity.FATAL;
				}
			} else {
				errorMsg = 'Customer already has been Rejected.';
				errorSeverity = ApexPages.Severity.FATAL;
			}
			
			if (errorMsg != null) {
				ApexPages.addMessage(new ApexPages.Message(errorSeverity, errorMsg));
			}
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'The Rejection failed.' + ex));
		}
	}
	
	public PageReference back() {
    	PageReference pr = new ApexPages.StandardController(customer).view();
    	pr.setRedirect(true);
    	
    	return pr;
    }
     /********************************************************************/
    /*********************START OF HAPPY DAY SCENARIO********************/
    /********************************************************************/
    TestMethod static void testAll() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_User_Reject_Customer_Extension cont = new IR_User_Reject_Customer_Extension(new ApexPages.StandardController(testCust));
        cont.customer.Complete__c = true;
        cont.rejectCustomer();
        System.debug(cont.back());
        Test.stopTest();
    }
    
    //Testing the completeBooking Method - This is done separately as ApexPages cannot contain messages
    TestMethod static void testComplete() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        Test.startTest();
        IR_User_Reject_Customer_Extension cont = new IR_User_Reject_Customer_Extension(new ApexPages.StandardController(testCust));
        
        cont.customer.International_Account_Number__c = '0123456789';
        cont.customer.Domestic_Account_Number__c = '0123456789';
        cont.customer.Complete__c = false;
        cont.rejectCustomer();
        Test.stopTest();
    }
    
    //Testing the completeBooking Method - This is done separately as ApexPages cannot contain messages
    TestMethod static void testCompleteNoOrder() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        Test.startTest();
        IR_User_Reject_Customer_Extension cont = new IR_User_Reject_Customer_Extension(new ApexPages.StandardController(testCust));
        
        cont.customer.International_Account_Number__c = '0123456789';
        cont.customer.Domestic_Account_Number__c = '0123456789';
        cont.customer.Complete__c = false;
        cont.rejectCustomer();
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF HAPPY DAY SCENARIO*********************/
    /********************************************************************/ 
}