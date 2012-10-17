public class IR_Booking_Complete_Conf_Controller {
    public IR_Customer__c customer {get; set;}
    public IR_Order__c order {get; set;}
    public LIST<IR_Consignment_Bundle> consignmentBundles {get; set;}
    
    public IR_Booking_Complete_Conf_Controller() {
        Id orderId = ApexPages.currentPage().getParameters().get('oid');
        customer = new IR_Customer__c();
        refreshData(orderId);
    }
    
    private void refreshData(Id orderId) {
        try {
            order = IR_Global_Class.getOrder(orderId);
            
            LIST<Id> consignmentIds = new LIST<Id>();
            for (IR_Consignment__c consignment : order.Consignments__r) {
                consignmentIds.add(consignment.Id);
            }
            consignmentBundles = IR_Global_Class.getConsignmentBundles(IR_Global_Class.getConsignments(consignmentIds));
            
            if (order.Customer__c != null) {
                customer = IR_Global_Class.getCustomer(order.Customer__c);
            }
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
    }
        
    public String fullCustAddress {
        get {
            return customer.Address_1__c + (customer.Address_2__c == null ? '' : ', ' + customer.Address_2__c) + (customer.Address_3__c == null ? '' : ', ' + customer.Address_3__c) + (customer.Town_City__c == null ? '' : ', ' + customer.Town_City__c) + (customer.County__c == null ? '' : ', ' + customer.County__c) + ', ' + customer.Postcode__c + ', ' + customer.Country__c;
        }
    }
    // this feature is been disabled upon reuqest of client to enable please ucoment the below code and the button on the appropiate page.
/*    public PageReference anotherBooking() {
        IR_Order__c newOrder = new IR_Order__c(Customer__c=customer.Id,Amount_Quoted__c=0);
        insert newOrder;
        
        IR_Consignment__c newConsignment = new IR_Consignment__c(Order_IR__c=newOrder.Id);
        newConsignment.From_Address_1__c = consignmentBundles[0].consignment.From_Address_1__c;
        newConsignment.From_Address_2__c = consignmentBundles[0].consignment.From_Address_2__c;
        newConsignment.From_Address_3__c = consignmentBundles[0].consignment.From_Address_3__c;
        newConsignment.From_Town_City__c = consignmentBundles[0].consignment.From_Town_City__c;
        newConsignment.From_County__c = consignmentBundles[0].consignment.From_County__c;
        newConsignment.From_Country_Code__c = consignmentBundles[0].consignment.From_Country_Code__c;
        newConsignment.From_Country__c = consignmentBundles[0].consignment.From_Country__c;
        newConsignment.From_Postcode__c = consignmentBundles[0].consignment.From_Postcode__c;
        
        newConsignment.To_Address_1__c = consignmentBundles[0].consignment.To_Address_1__c;
        newConsignment.To_Address_2__c = consignmentBundles[0].consignment.To_Address_2__c;
        newConsignment.To_Address_3__c = consignmentBundles[0].consignment.To_Address_3__c;
        newConsignment.To_Town_City__c = consignmentBundles[0].consignment.To_Town_City__c;
        newConsignment.To_County__c = consignmentBundles[0].consignment.To_County__c;
        newConsignment.To_Country_Code__c = consignmentBundles[0].consignment.To_Country_Code__c;
        newConsignment.To_Country__c = consignmentBundles[0].consignment.To_Country__c;
        newConsignment.To_Postcode__c = consignmentBundles[0].consignment.To_Postcode__c;
        
        newConsignment.Type__c = consignmentBundles[0].consignment.Type__c;
        newConsignment.Pickup_Collection_Date__c = consignmentBundles[0].consignment.Pickup_Collection_Date__c;
        insert newConsignment;
        
        customer.Has_Multiple_Orders__c = true;
        update customer;
        
        PageReference pr = Page.IR_Booking_Get_Quote_Page;
        pr.getParameters().put('oid', newOrder.Id);
        
        return pr;
    }*/
    
    public Boolean withinWorkingHours {
        get {
            return IR_Global_Class.withinWorkingHours;
        }
    }
    
    /********************************************************************/
    /*********************START OF EXCEPTION SCENARIO********************/
    /********************************************************************/
    TestMethod static void testException() {
        Test.startTest();
        IR_Booking_Complete_Conf_Controller cont = new IR_Booking_Complete_Conf_Controller();
        System.debug(cont.fullCustAddress);
        Test.stopTest();
    }
    
    TestMethod static void testNoCon() {
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0);
        insert testOrder;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Conf_Controller cont = new IR_Booking_Complete_Conf_Controller();
        
        cont.customer.Address_1__c = 'Addr1';
        cont.customer.Address_2__c = 'Addr2';
        cont.customer.Address_3__c = 'Addr3';
        cont.customer.Town_City__c = 'TownCity';
        cont.customer.County__c = 'County';
        cont.customer.Postcode__c = 'SE10HS';
        System.debug(cont.fullCustAddress);        
        cont.refreshData(testOrder.Id);
        System.debug(cont.withinWorkingHours);
       // System.assert(cont.fullCustAddress == 'Addr1, Addr2, Addr3, TownCity, County, SE10HS');
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF EXCEPTION SCENARIO*********************/
    /********************************************************************/
    
    /********************************************************************/
    /*********************START OF HAPPY DAY SCENARIO********************/
    /********************************************************************/
    TestMethod static void testNoCust() {
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Conf_Controller cont = new IR_Booking_Complete_Conf_Controller();
        
        cont.customer.Address_1__c = 'Addr1';
        cont.customer.Address_2__c = 'Addr2';
        cont.customer.Address_3__c = 'Addr3';
        cont.customer.Town_City__c = 'TownCity';
        cont.customer.County__c = 'County';
        cont.customer.Postcode__c = 'SE10HS';
        System.debug(cont.fullCustAddress);        
        cont.refreshData(testOrder.Id);
        System.debug(cont.withinWorkingHours);
       // System.assert(cont.fullCustAddress == 'Addr1, Addr2, Addr3, TownCity, County, SE10HS');
        Test.stopTest();
    }
    
    TestMethod static void testAll() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Conf_Controller cont = new IR_Booking_Complete_Conf_Controller();
        
        cont.customer.Address_1__c = 'Addr1';
        cont.customer.Address_2__c = 'Addr2';
        cont.customer.Address_3__c = 'Addr3';
        cont.customer.Town_City__c = 'TownCity';
        cont.customer.County__c = 'County';
        cont.customer.Postcode__c = 'SE10HS';
        System.debug(cont.fullCustAddress);        
        cont.refreshData(testOrder.Id);
        System.debug(cont.withinWorkingHours);
        //System.assert(cont.fullCustAddress == 'Addr1, Addr2, Addr3, TownCity, County, SE10HS');
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF HAPPY DAY SCENARIO*********************/
    /********************************************************************/
    
    /*
    public String fullCustAddress {
        get {
            return customer.Address_1__c + (customer.Address_2__c == null ? '' : ', ' + customer.Address_2__c) + (customer.Address_3__c == null ? '' : ', ' + customer.Address_3__c) + (customer.Town_City__c == null ? '' : ', ' + customer.Town_City__c) + (customer.County__c == null ? '' : ', ' + customer.County__c) + ', ' + customer.Postcode__c;
        }
    }*/
}