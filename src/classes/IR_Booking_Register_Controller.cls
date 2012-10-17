public class IR_Booking_Register_Controller {
    public IR_Customer__c customer {get; set;}
    private IR_Postcode_Check custCheck {get; set;}
    public String selectedCustAddress {get; set;}
    private IR_Order__c order {get; set;}
    public String custEmailConf {get; set;}
    public Boolean allowAddrInput {get; set;}
    public Boolean editCustAddr {get; set;}
    public IR_Global_Class.TelephoneField tel {get; set;}
    public IR_Global_Class.TelephoneField mob {get; set;}
    public IR_Global_Class.TelephoneField fax {get; set;}
    
    public IR_Booking_Register_Controller() {
        customer = new IR_Customer__c();
        custCheck = new IR_Postcode_Check();
        order = new IR_Order__c();
        tel = new IR_Global_Class.TelephoneField();
        mob = new IR_Global_Class.TelephoneField();
        fax = new IR_Global_Class.TelephoneField();
        allowAddrInput = true;
        editCustAddr = true;
        
        Id orderId = ApexPages.currentPage().getParameters().get('oid');
        
        if (orderId != null) {
            order = IR_Global_Class.getOrder(orderId);
            
            if (order.Consignments__r != null && order.Consignments__r.size() > 0) {
                customer.Postcode__c = order.Consignments__r[0].From_Postcode__c.toUpperCase();
            }
        
            tel = new IR_Global_Class.TelephoneField(customer.Telephone__c);
            mob = new IR_Global_Class.TelephoneField(customer.Mobile_Phone__c);
            fax = new IR_Global_Class.TelephoneField(customer.Fax__c);
        }
    }
    
    public List<SelectOption> accountETLOptions {
        get {
            return IR_Global_Class.accountETLOptions;
        }
    }
        
    public PageReference lookupCustAddress() {
        Map<String, String> itemMap = new Map<String, String>();
        itemMap.put( Postcode_Checker_Methods.itemMapKeys.ISOC.Name(), 'GBR' );
        itemMap.put( Postcode_Checker_Methods.itemMapKeys.PCOD.Name(), customer.Postcode__c.toUpperCase() );
        
        custCheck.getAddresses( itemMap );
        
        if (custCheck.getAddressList().size() > 1) {
            allowAddrInput = false;
        } else {
            allowAddrInput = true;
        }
        
        return null;
    }
        
    public Boolean showCustAddrLookup {
        get {
            return IR_Global_Class.pcLookupSupported(customer.Country_Code__c);
        }
    }
    
    public Boolean hasAddress {
        get {
            return (custCheck == null || custCheck.getAddressList() == null || custCheck.getAddressList().size() == 1 ? false : true);
        }
    }
    
    public LIST<SelectOption> custAddressOptions {
        get {
            return custCheck.getAddressList();
        }
    }
    
    public PageReference selectCustAddress() {
        customer.Address_1__c = custCheck.getAddressLine1(selectedCustAddress);
        customer.Address_2__c = custCheck.getAddressLine2(selectedCustAddress);
        customer.Address_3__c = custCheck.getAddressLine3(selectedCustAddress);
        customer.Town_City__c = custCheck.getTown(selectedCustAddress);
        customer.County__c = custCheck.getCounty(selectedCustAddress);
        
        return null;
    }
    
    public PageReference back() {
        PageReference pr = Page.IR_Booking_Get_Quote_Page;
        
        if (order != null && order.Id != null) {
            pr.getParameters().put('oid', order.Id);
        }
        
        pr.setRedirect(true);
        
        return pr;
    }
    
    public PageReference quickSave() {
        try {
            customer.Telephone__c = tel.format;
            customer.Mobile_Phone__c = mob.format;
            customer.Fax__c = fax.format;
            upsert customer;
            
            return null;
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference register() {
        try {
        	Boolean valid = true;
        	
            if (custEmailConf == null || custEmailConf.length() == 0) {
                customer.Email__c.addError('Please confirm you Email Address');
                
                valid = false;
            } else if (!customer.Email__c.equals(custEmailConf)) {
                customer.Email__c.addError('Email Addresses do not match');
                
                valid = false;
            }
            
            if (customer.Address_1__c == null || customer.Address_1__c.length() == 0) {
                String errorMessage = 'Please enter an Address Line 1';
                
                customer.Address_1__c.addError(errorMessage);
                valid = false;
            }
            
            if (!customer.Rate_And_Offer_Terms__c) {
                String errorMessage = 'You must accept the Rate Agreement and Terms of Offer';
                
                customer.Rate_And_Offer_Terms__c.addError(errorMessage);
                valid = false;
            }
            
            if (!customer.Terms_and_Conditions__c) {
                String errorMessage = 'You must accept the Terms and Conditions of Carriage';
                
                customer.Terms_and_Conditions__c.addError(errorMessage);
                valid = false;
            }
            
            if (customer.Extended_Transit_Liability_Setting__c == null) {
                String errorMessage = 'Please select an Account Enhanced Transit Liability Setting';
                
                customer.Extended_Transit_Liability_Setting__c.addError(errorMessage);
                valid = false;
            }
            
            if (valid) {
                customer.Vat_Registration_Number__c = (customer.Vat_Registration_Number__c == null ? null : (customer.Vat_Registration_Number__c.startsWith('GB') || customer.Vat_Registration_Number__c.length() > 10 ? customer.Vat_Registration_Number__c : 'GB' + customer.Vat_Registration_Number__c));
                customer.Telephone__c = tel.format;
                customer.Mobile_Phone__c = mob.format;
                customer.Fax__c = fax.format;
                customer.Order_Placed__c = true;
                customer.Postcode__c = customer.Postcode__c.toUpperCase();
                customer.Registration_Status__c = 'Awaiting Email Verification';
                upsert customer;
                
                PageReference pr = Page.IR_Booking_Register_Conf_Page;
                pr.getParameters().put('cid', customer.Id);
                pr.setRedirect(true);
                
                return pr;
            }
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
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
        IR_Booking_Register_Controller cont = new IR_Booking_Register_Controller();
        
        cont.customer.Postcode__c = 'SE1 0HS';
        System.debug(cont.lookupCustAddress());
        
        System.debug(cont.hasAddress);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.back());
        
        cont.customer.Email__c = 'TEST@TEST.TEST';
        System.debug(cont.register());
        Test.stopTest();
    }
    
    TestMethod static void testAll() {
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Register_Controller cont = new IR_Booking_Register_Controller();
        
        cont.customer.Postcode__c = 'SE1 0HS';
        System.debug(cont.lookupCustAddress());
        
        System.debug(cont.hasAddress);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.back());
        
        cont.customer.Email__c = 'TEST@TEST.TEST';
        System.debug(cont.register());
        Test.stopTest();
    }
    
    //Testing the register Method - This is done separately as ApexPages cannot contain messages
    TestMethod static void testComplete() {
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Register_Controller cont = new IR_Booking_Register_Controller();
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        cont.customer.Email__c = 'TEST@TEST.TEST';
        cont.custEmailConf = cont.customer.Email__c;
        
        cont.customer.Surname__c = 'TEST';
        cont.tel.std = '01827';
        cont.tel.phoneNumber = '37296';
        cont.customer.Telephone__c='+44 (0)20 12345';
        cont.customer.Mobile_Phone__c = '+44 (0)7588288295';
        cont.customer.Fax__c = '0123456789';
        cont.customer.Email__c = 'TEST@TEST.TEST';
        cont.customer.First_Name__c='TEST';
        cont.customer.Address_1__c='TEST';
        cont.customer.Company__c='TEST';
        cont.customer.Job_Title__c='TEST';
        cont.customer.Rate_And_Offer_Terms__c = true;
        cont.customer.Terms_and_Conditions__c = true;
        System.debug(cont.quickSave());
        System.debug(cont.register());
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF HAPPY DAY SCENARIO*********************/
    /********************************************************************/
    
    /********************************************************************/
    /*********************START OF EXCEPTION SCENARIO********************/
    /********************************************************************/
    TestMethod static void testException() {
        Test.startTest();
        IR_Booking_Register_Controller cont = new IR_Booking_Register_Controller();
        
        cont.customer.Postcode__c = 'SE1 0HS';
        System.debug(cont.lookupCustAddress());
        
        System.debug(cont.hasAddress);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.back());
        
        cont.customer.Email__c = 'TEST@TEST.TEST';
        System.debug(cont.register());
        Test.stopTest();
    }
    
    TestMethod static void testNoOrder() {
        Test.startTest();
        IR_Booking_Register_Controller cont = new IR_Booking_Register_Controller();
        
        cont.customer.Postcode__c = 'SE1 0HS';
        System.debug(cont.lookupCustAddress());
        
        System.debug(cont.hasAddress);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.back());
        
        cont.customer.Email__c = 'TEST@TEST.TEST';
        System.debug(cont.register());
        Test.stopTest();
    }
    
    TestMethod static void testNoCon() {
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0);
        insert testOrder;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Register_Controller cont = new IR_Booking_Register_Controller();
        
        cont.customer.Postcode__c = 'SE1 0HS';
        System.debug(cont.lookupCustAddress());
        
        System.debug(cont.hasAddress);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.back());
        
        cont.customer.Email__c = 'TEST@TEST.TEST';
        System.debug(cont.register());
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF EXCEPTION SCENARIO*********************/
    /********************************************************************/
}