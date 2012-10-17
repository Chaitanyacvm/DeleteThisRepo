public class IR_User_RC_Queue_Extension {
    public LIST<IR_Global_Class.QueueCustomer> RateandContactsCustomers {get; set;}
    public Id selectedCustomerId {get; set;}
    private Id RatesandContactsQueueId {get; set;}
    
    public IR_User_RC_Queue_Extension(ApexPages.StandardController controller) {
        RatesandContactsQueueId = IR_Global_Class.getRatesandContactsQueueId();
        
        RateandContactsCustomers = new LIST<IR_Global_Class.QueueCustomer>();
        for (IR_Customer__c customer : [SELECT Id, Name, Time_Order_Placed__c, Time_Accepted_By_CE__c, Time_Accepted_By_RC__c, Time_Accepted_By_SA__c, Time_Booking_Completed__c, Time_Entered_CE_Queue__c, Time_Entered_RC_Queue__c, Time_Entered_SA_Queue__c, Time_Exited_CE_Stage__c, Time_Quoted__c, Time_Verification_Email_Sent__c, SLA_CE_Status__c, SLA_CE_Status_Text__c, SLA_RC_Status__c, SLA_RC_Status_Text__c, SLA_SA_Status__c, SLA_SA_Status_Text__c, Company__c, Register_Only__c, Dom_Rates_Loaded__c, Dom_Contacts_Loaded__c, Int_Rates_Loaded__c, Int_Contacts_Loaded__c, Town_City__c, Telephone__c, Surname__c, Sender_Reference__c, Postcode__c, First_Name__c, Email__c, County__c, Address_3__c, Address_2__c, Address_1__c, International_Account_Number__c, Domestic_Account_Number__c, CreatedDate FROM IR_Customer__c WHERE Registration_Status__c = 'In Rates and Contacts Queue' ORDER BY CreatedDate ASC]) {
            RateandContactsCustomers.add(new IR_Global_Class.QueueCustomer(customer));
        }
    }
    
    public PageReference refreshScreen() {
        RateandContactsCustomers = new LIST<IR_Global_Class.QueueCustomer>();
        for (IR_Customer__c customer : [SELECT Id, Name, Time_Order_Placed__c, Time_Accepted_By_CE__c, Time_Accepted_By_RC__c, Time_Accepted_By_SA__c, Time_Booking_Completed__c, Time_Entered_CE_Queue__c, Time_Entered_RC_Queue__c, Time_Entered_SA_Queue__c, Time_Exited_CE_Stage__c, Time_Quoted__c, Time_Verification_Email_Sent__c, SLA_CE_Status__c, SLA_CE_Status_Text__c, SLA_RC_Status__c, SLA_RC_Status_Text__c, SLA_SA_Status__c, SLA_SA_Status_Text__c, Company__c, Register_Only__c, Dom_Rates_Loaded__c, Dom_Contacts_Loaded__c, Int_Rates_Loaded__c, Int_Contacts_Loaded__c, Town_City__c, Telephone__c, Surname__c, Sender_Reference__c, Postcode__c, First_Name__c, Email__c, County__c, Address_3__c, Address_2__c, Address_1__c, International_Account_Number__c, Domestic_Account_Number__c, CreatedDate FROM IR_Customer__c WHERE Registration_Status__c = 'In Rates and Contacts Queue' ORDER BY CreatedDate ASC]) {
            RateandContactsCustomers.add(new IR_Global_Class.QueueCustomer(customer));
        }
        
        return null;
    }
    
    public PageReference acceptCustomer() {
        try {
            if (selectedCustomerId == null) {
                selectedCustomerId = ApexPages.currentPage().getParameters().get('userSelection');
            }
            
            IR_Customer__c acceptedCustomer = [SELECT Id, OwnerId FROM IR_Customer__c WHERE Id = :selectedCustomerId AND Registration_Status__c = 'In Rates and Contacts Queue' LIMIT 1];
            acceptedCustomer.ownerId = UserInfo.getUserId();
            acceptedCustomer.Registration_Status__c = 'Accepted by Rates and Contacts';
            update acceptedCustomer;
            
            PageReference pr = new ApexPages.StandardController(acceptedCustomer).view();
            pr.setRedirect(true);
            
            return pr;
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'That Customer has been accepted by another user'));
            }
            
            refreshScreen();
            
            return null;
        }
    }
    
    /********************************************************************/
    /*********************START OF HAPPY DAY SCENARIO********************/
    /********************************************************************/
    TestMethod static void testAll() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getRatesandContactsQueueId());
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_User_RC_Queue_Extension cont = new IR_User_RC_Queue_Extension(new ApexPages.StandardController(testCust));
        cont.acceptCustomer();
        System.debug(cont.refreshScreen());
        Test.stopTest();
    }
    
    //Testing the acceptCustomer Method - This is done separately as ApexPages cannot contain messages
    TestMethod static void testCompleteNoOrder() {
        IR_Customer__c testCust = new IR_Customer__c(Registration_Status__c = 'In Rates and Contacts Queue',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getRatesandContactsQueueId());
        insert testCust;
        
        ApexPages.currentPage().getParameters().put('userSelection', testCust.Id);
        Test.startTest();
        IR_User_RC_Queue_Extension cont = new IR_User_RC_Queue_Extension(new ApexPages.StandardController(testCust));        
        System.debug(cont.refreshScreen());
        cont.acceptCustomer();        
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF HAPPY DAY SCENARIO*********************/
    /********************************************************************/

}