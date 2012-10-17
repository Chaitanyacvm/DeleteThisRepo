public class IR_User_Customer_PDF_Controller {
	public IR_Customer__c customer {get; set;}
	
	public IR_User_Customer_PDF_Controller() {
		customer = new IR_Customer__c();
	}
	
	public Id custId {
		get;
		
		set {
			try {
				customer = IR_Global_Class.getCustomer(value);
			} catch (Exception e) {
				customer = new IR_Customer__c();
			}
		}
		
	}
	
	//*******************Test Method*****************//
	TestMethod static void test_Pdf_controller(){
		IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        
        Test.startTest();
        IR_User_Customer_PDF_Controller cont = new IR_User_Customer_PDF_Controller();
        cont.custId = testCust.Id;        
        System.debug(cont.custId);
        cont.custId = null;
        System.debug(cont.custId);
        Test.stopTest();
	}
}