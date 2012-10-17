public class IR_Booking_Get_Quote_Controller {
    public IR_Order__c order {get; set;}
    public LIST<IR_Consignment_Bundle> consignmentBundles {get; set;}
    public String unit {get; set;}
    private IR_Global_Class.RateCheckResult results {get; set;}
    public String selectedService {get; set;}
    public LIST<AvailableOption> serviceOptions {get; set;}
    public Integer weeksSinceTrading {get; set;}
    public Boolean gotQuote {get; set;}
    private Id newCustomersQueueId {get; set;}
    public Boolean allowShipping {get; set;}
    public String selectedOptionId {get; set;}    
           
    public IR_Booking_Get_Quote_Controller() {
        Id orderId = ApexPages.currentPage().getParameters().get('oid');
        order = new IR_Order__c();      
        //for storing the browser version
        order.Browser_Version__c = ApexPages.currentPage().getParameters().get('browserVr');
        consignmentBundles = new LIST<IR_Consignment_Bundle>();
        consignmentBundles.add(new IR_Consignment_Bundle());
        results = new IR_Global_Class.RateCheckResult();
        serviceOptions = new LIST<AvailableOption>();
        weeksSinceTrading = 13;
        unit = 'Metric';
        gotQuote = false;
        allowShipping = false;
        
        if (orderId != null) {
            refreshData(orderId);
        }
    }
    
    public String serviceDescription {
        get {
            return '<p><b>National time-definite delivery service options:</b><br/>9:00 Express<br/>Guaranteed next morning delivery before 9am of the next working day.<br/><br/>10:00 Express<br/>Guaranteed next morning delivery before 10am of the next working day.<br/><br/>12:00 Express<br/>Guaranteed delivery for the morning of the next working day.<br/><br/>Express<br/>Guaranteed delivery before close of business on the next or earliest possible working day.<br/></p><br/><p><b>International - day and time-definite delivery service options:</b><br/>9:00 Express<br/>Guaranteed next morning delivery before 9am to major cities in over 40 countries.<br/><br/>10:00 Express<br/>Guaranteed next morning delivery before 10am to major cities in over 60 countries.<br/><br/>12:00 Express<br/>Guaranteed next morning delivery to major cities in over 60 countries.<br/><br/>Express<br/>Guaranteed next day delivery to most of Europe, and fastest possible services to the rest of the world.<br/><br/>12:00 Economy Express<br/>Day-definite delivery before noon for less urgent shipments, offering economical delivery to EU countries (2-4 days depending on destination) and the rest of Europe (2-6 days).<br/><br/>Economy Express<br/>Day-definite scheduled delivery to Europe and the rest of the world.<br/></p>';
        }
    }
    
    public LIST<SelectOption> units {
        get {
            LIST<SelectOption> unitOptions = new LIST<SelectOption>();
            unitOptions.add(new SelectOption('Metric', 'Metric'));
            unitOptions.add(new SelectOption('Imperial', 'Imperial'));
            
            return unitOptions;
        }
    }
    
    public PageReference changeUnits() {
        if (unit == 'Metric') {
            unit = 'Imperial';
        } else {
            unit = 'Metric';
        }
        
        return null;
    }
    
    public String lengthCode {
        get {
            if (unit == 'Metric') {
                return 'cm';
            } else {
                return 'in';
            }
        }
    }
    
    public String weightCode {
        get {
            if (unit == 'Metric') {
                return 'kg';
            } else {
                return 'lb';
            }
        }
    }
    
    public PageReference addPackage() {
        consignmentBundles[0].addPackage();
        allowShipping = false;
        
        return null;
    }
    
    public PageReference removePackage() {
        consignmentBundles[0].removePackage();
        allowShipping = false;
        
        return null;
    }
    
    public LIST<SelectOption> consignmentTypes {
        get {
            LIST<SelectOption> options = new LIST<SelectOption>();
            
            options.add(new SelectOption('', '--Please Select--'));
            for (Schema.PicklistEntry consignmentTypeDesc : IR_Consignment__c.Type__c.getDescribe().getPicklistValues()) {
                if (consignmentTypeDesc.isActive()) {
                    options.add(new SelectOption(consignmentTypeDesc.getValue(), consignmentTypeDesc.getLabel()));
                }
            }
            
            return options;
        }
    }
    
    public Boolean hasResults {
        get {
            return (serviceOptions == null || serviceOptions.size() == 0 ? false : true);
        }
    }
    
    public PageReference getQuote() {
        allowShipping = false;
        
        try {
            Boolean valid = true;
            
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                if (consignmentBundle.consignment.Type__c == null || consignmentBundle.consignment.Type__c == '') {
                    consignmentBundle.consignment.Type__c.addError('Please specify a Consignment Type');
                    
                    valid = false;
                    allowShipping = false;
                }else if(consignmentBundle.consignment.Customer_Email_Address__c == ''){
                    
                    consignmentBundle.consignment.Customer_Email_Address__c.addError('Please specify a Email address');
                    
                    valid = false;
                    allowShipping = false;
                }else if(consignmentBundle.to_requiresPostcode && consignmentBundle.consignment.To_Postcode__c == null){
                    consignmentBundle.consignment.To_Postcode__c.addError('A Ship To Postcode is required');
                    
                    valid = false;
                    allowShipping = false;     
                }
            }
            
            if (!IR_Global_Class.validatePackage(consignmentBundles)) {
                valid = false;
                allowShipping = false;
                selectedOptionId = '';
                gotQuote = false;
            }
            
            if (valid) {
                if (unit == 'Imperial') {
                    consignmentBundles = IR_Global_Class.convertToMetric(consignmentBundles);
                    unit = 'Metric';
                }
                
                for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                    consignmentBundle.consignment.Service_Code__c = null;
                    consignmentBundle.consignment.Option_Code__c = null;
                    order.Customer_Email__c = consignmentBundle.consignment.Customer_Email_Address__c;
                }
                                    
                    
                results = IR_Global_Class.getQuote(order, consignmentBundles);
                    
                if (!ApexPages.hasMessages()) {
                    setAvailableOptions(results);
                    refreshData(order.Id);
                    gotQuote = true;
                    
                    for (IR_Global_Class.RateCheckError error : results.errors) {
                        if (error.message != null) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, error.message));
                        }
                    }
                }
            }
            
            return null;
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
            
            return null;
        }
    }
    
    public PageReference serviceCheckAction() {
        allowShipping = false;
        
        for (AvailableOption serviceOption : serviceOptions) {
            if (serviceOption.selected) {
                if (serviceOption.optionId == selectedOptionId) {
                    allowShipping = true;
                } else {
                    serviceOption.selected = false;
                }
            }
        }
        
        return null;
    }
    
    
    private void setAvailableOptions(IR_Global_Class.RateCheckResult newResults) {
        serviceOptions = new LIST<AvailableOption>();
        
        for (IR_Global_Class.RateCheckRate rate : results.orderedCombinedRates) {
            AvailableOption option = new AvailableOption(rate.serviceString, rate.rate);
            option.serviceCode = rate.serviceCode;
            option.optionCode = rate.optionCode;
            option.rate = rate.rate;
            
            serviceOptions.add(option);
        }
    }
    
    private void refreshData(Id orderId) {
        order = IR_Global_Class.getOrder(orderId);
        
        LIST<Id> consignmentIds = new LIST<Id>();
        for (IR_Consignment__c consignment : order.Consignments__r) {
            consignmentIds.add(consignment.Id);
        }
        consignmentBundles = IR_Global_Class.getConsignmentBundles(IR_Global_Class.getConsignments(consignmentIds));
    }
    
    public PageReference termsConditions() {
        PageReference pr = Page.IR_Booking_Terms_And_Conditions_Page;
        pr.setRedirect(true);
        
        return pr;
    }
    
    public PageReference justRegister() {
        PageReference pr = Page.IR_Booking_Register_Page;
        
        if (order != null && order.Id != null) {
            pr.getParameters().put('oid', order.Id);
        }
        
        pr.setRedirect(true);
        
        return pr;
    }
    
    public PageReference registerAndShip() {
        Boolean rateSelected = false;
        
        for (AvailableOption serviceOption : serviceOptions) {
            if (serviceOption.selected) {
                order.Amount_Quoted__c = serviceOption.rate;                
                update order;
                
                for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                    consignmentBundle.consignment.Service_Code__c = serviceOption.serviceCode;
                    consignmentBundle.consignment.Option_Code__c = serviceOption.optionCode;
                    consignmentBundle.consignment.Service__c = serviceOption.service;
                                        
                    if(consignmentBundle.consignment.To_Postcode__c == null){
                        consignmentBundle.consignment.To_Postcode__c.addError('You must enter a value');
                    }else if(consignmentBundle.consignment.Customer_Email_Address__c == ''){
                        consignmentBundle.consignment.Customer_Email_Address__c.addError('You must enter a value'); 
                    }else{            
                        update consignmentBundle.consignment;                       
                    }
                }
                
                rateSelected = true;
            }
        }
        
        if (!rateSelected || order.Amount_Quoted__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must select a Quote to proceed'));
        }
        
        if (!ApexPages.hasMessages()) {
            PageReference pr = Page.IR_Booking_Complete_Booking_Page;
            pr.getParameters().put('oid', order.Id);
            pr.setRedirect(true);
            
            return pr;
        } else {
            return null;
        }
    }
    
    public class AvailableOption {
        public Boolean selected {get; set;}
        public String service {get; set;}
        public String serviceCode {get; set;}
        public String optionCode {get; set;}
        public String rateString {get; set;}
        public Decimal rate {get; set;}
        
        public AvailableOption(String service, Decimal rate) {
            this.service = service;
            
            rate.setScale(2, System.RoundingMode.UP);
            this.rateString = rate.toPlainString();
        }
        
        public String optionId {
            get {
                return serviceCode + optionCode;
            }
        }
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
        IR_Booking_Get_Quote_Controller cont = new IR_Booking_Get_Quote_Controller();
        System.debug(cont.units);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.consignmentTypes);
        System.debug(cont.hasResults);
        cont.unit = 'Imperial';
        System.debug(cont.getQuote());
        System.debug(cont.termsConditions());
        System.debug(cont.justRegister());
        System.debug(cont.registerAndShip());
        System.debug(cont.hasResults);
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
        IR_Booking_Get_Quote_Controller cont = new IR_Booking_Get_Quote_Controller();
        System.debug(cont.units);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.consignmentTypes);
        System.debug(cont.hasResults);
        cont.unit = 'Imperial';
        System.debug(cont.getQuote());
        System.debug(cont.termsConditions());
        System.debug(cont.justRegister());
        
        IR_Global_Class.RateCheckResult testResult = new IR_Global_Class.RateCheckResult();
        IR_Global_Class.RateCheckRate testRate = new IR_Global_Class.RateCheckRate();
        testRate.rateId = '1';
        testRate.rate = 1;
        testRate.rateCurrency = 'GBP';
        testRate.serviceCode = 'TEST';
        testRate.serviceDesc = 'TEST';
        testRate.optionCode = 'TEST';
        testRate.optionDesc = 'TEST';
        testResult.addRate(testRate);
        cont.setAvailableOptions(testResult);
        System.debug(cont.registerAndShip());
        
        System.debug(cont.hasResults);
        Test.stopTest();
    }
    
    //Testing the registerAndShip Method - This is done separately as ApexPages cannot contain messages
    TestMethod static void testComplete() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Get_Quote_Controller cont = new IR_Booking_Get_Quote_Controller();
        AvailableOption testOption = new AvailableOption('TEST', 1);
        testOption.selected = true;
        testOption.rate = 12;
        cont.serviceOptions.add(testOption);
        cont.order.Amount_Quoted__c = 1;
        
        System.debug(cont.registerAndShip());
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
        IR_Booking_Get_Quote_Controller cont = new IR_Booking_Get_Quote_Controller();
        System.debug(cont.units);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.consignmentTypes);
        System.debug(cont.hasResults);
        cont.unit = 'Imperial';
        System.debug(cont.getQuote());
        System.debug(cont.termsConditions());
        System.debug(cont.justRegister());
        System.debug(cont.registerAndShip());
        System.debug(cont.hasResults);
        Test.stopTest();
    }
    
    TestMethod static void testNoOrder() {
        Test.startTest();
        IR_Booking_Get_Quote_Controller cont = new IR_Booking_Get_Quote_Controller();
        System.debug(cont.units);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.consignmentTypes);
        System.debug(cont.hasResults);
        cont.unit = 'Imperial';
        System.debug(cont.getQuote());
        System.debug(cont.termsConditions());
        System.debug(cont.justRegister());
        System.debug(cont.registerAndShip());
        System.debug(cont.hasResults);
        Test.stopTest();
    }
    
    TestMethod static void testNoCon() {
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0);
        insert testOrder;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Get_Quote_Controller cont = new IR_Booking_Get_Quote_Controller();
        System.debug(cont.units);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.changeUnits());
        System.debug(cont.lengthCode);
        System.debug(cont.weightCode);
        System.debug(cont.consignmentTypes);
        System.debug(cont.hasResults);
        cont.unit = 'Imperial';
        System.debug(cont.getQuote());
        System.debug(cont.termsConditions());
        System.debug(cont.justRegister());
        System.debug(cont.registerAndShip());
        System.debug(cont.hasResults);
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF EXCEPTION SCENARIO*********************/
    /********************************************************************/
}