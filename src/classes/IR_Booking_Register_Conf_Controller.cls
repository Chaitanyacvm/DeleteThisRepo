public class IR_Booking_Register_Conf_Controller {
    public IR_Customer__c customer {get; set;}
    
    public IR_Booking_Register_Conf_Controller() {
        customer = IR_Global_Class.getCustomer(ApexPages.currentPage().getParameters().get('cid'));
    }
        
    public String fullCustAddress {
        get {
            return customer.Address_1__c + (customer.Address_2__c == null ? '' : ', ' + customer.Address_2__c) + (customer.Address_3__c == null ? '' : ', ' + customer.Address_3__c) + (customer.Town_City__c == null ? '' : ', ' + customer.Town_City__c) + (customer.County__c == null ? '' : ', ' + customer.County__c) + ', ' + customer.Postcode__c;
        }
    }
    
    /********************************************************************/
    /*********************START OF HAPPY DAY SCENARIO********************/
    /********************************************************************/
    TestMethod static void testAll() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        ApexPages.currentPage().getParameters().put('cid', testCust.Id);
        Test.startTest();
        IR_Booking_Register_Conf_Controller cont = new IR_Booking_Register_Conf_Controller();
        System.debug(cont.fullCustAddress);
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF HAPPY DAY SCENARIO*********************/
    /********************************************************************/
}