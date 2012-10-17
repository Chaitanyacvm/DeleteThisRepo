public class IR_Booking_Task_Confirmation_Extension {
	private IR_Customer__c customer {get;set;} 

	public IR_Booking_Task_Confirmation_Extension(ApexPages.StandardController controller){
		try {
            customer = [SELECT Id, eInvoicing_Account_Link_Task__c FROM IR_Customer__c WHERE Id = :controller.getRecord().Id AND eInvoicing_Account_Link_Task__c = false];
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Your receipt of task could not be verified'));
        }
	}
	
	public void Confirm_task(){
		 try {
            customer.eInvoicing_Account_Link_Task__c = true;            
                        
            update customer;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Success! Thank you for successfully confirming receipt of this task.'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Your receipt of task could not be verified'));
        }
	}
	
	   /**********************TEST METHODS*******************************/
    
    TestMethod static void test_Email_Verisfication(){
    	
    	IR_Customer__c testCust = new IR_Customer__c(eInvoicing_Account_Link_Task__c= false,Security_Check_Fail__c = true, Security_Check_Accepted__c = false, Potential_Private_Individual__c = true, Private_Individual_Check_OK__c= false, Domestic_Account_On_Stop__c=true, Confirmed_Off_Stop__c = false,International_Account_On_Stop__c = true, Booking_Complete__c=true,Account_Status_Int__c='New',Account_Status_Dom__c='New',International_Account_Number__c='123456789',Domestic_Account_Number__c='1234567890', Dom_Rates_Loaded__c = true, Dom_Contacts_Loaded__c = true, Int_Rates_Loaded__c =true,Int_Contacts_Loaded__c=true, Dom_EInvoicing_Already_Registered__c=true,Int_EInvoicing_Already_Registered__c=true, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='123456456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        
        IR_Booking_Task_Confirmation_Extension ext = new IR_Booking_Task_Confirmation_Extension(new ApexPages.StandardController(testCust));        
        ext.Confirm_task();                
    }
    
    TestMethod static void test_Email_Verisfication_Exception(){
    	
    	IR_Customer__c testCust = new IR_Customer__c(eInvoicing_Account_Link_Task__c= true,Security_Check_Fail__c = true, Security_Check_Accepted__c = false, Potential_Private_Individual__c = true, Private_Individual_Check_OK__c= false, Domestic_Account_On_Stop__c=true, Confirmed_Off_Stop__c = false,International_Account_On_Stop__c = true, Booking_Complete__c=true,Account_Status_Int__c='New',Account_Status_Dom__c='New',International_Account_Number__c='123456789',Domestic_Account_Number__c='1234567890', Dom_Rates_Loaded__c = true, Dom_Contacts_Loaded__c = true, Int_Rates_Loaded__c =true,Int_Contacts_Loaded__c=true, Dom_EInvoicing_Already_Registered__c=true,Int_EInvoicing_Already_Registered__c=true, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='123456456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        
        IR_Booking_Task_Confirmation_Extension ext = new IR_Booking_Task_Confirmation_Extension(new ApexPages.StandardController(testCust));        
        ext.Confirm_task();                
    }
}