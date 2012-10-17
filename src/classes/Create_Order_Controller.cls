public class Create_Order_Controller
{
    private final Order__c order;
    private Address_Postcode_Check_Controller soldToAddressController{get; set;}
    private Address_Postcode_Check_Controller shipToAddressController{get; set;}
    
    public Boolean findPCshipTo{get;set;}
    public Boolean findPCSoldto{get;set;}
    public Boolean sameAsSoldAddress{get; set;}
    public String soldToPostcode{get; set;}
    public String shipToPostcode{get; set;}
    public List<selectOption> soldToAddressList{get;set;} 
    public List<selectOption> shipToAddressList{get;set;}
    public String selectedSoldToAddress{get;set;}
    public String selectedshipToAddress{get;set;}
    
    public Boolean soldtoDisabled {get;set;}
    public Boolean shiptoDisabled {get;set;}
    
    public String customerCompanyName { get; set; }
     
    public Address__c shipTo {
        get {
            if (shipTo == null){
                shipTo = new Address__c();
            } 
            return shipTo; 
        }
        
        set;
    }
    
    public Address__c soldto {
        get {
            if (soldto== null) {
                soldto= new Address__c();
            }
            
            return soldto;
        }
        
        set;
    }
    
    public Create_Order_Controller(ApexPages.StandardController stdController) {
        soldToAddressController = new Address_Postcode_Check_Controller();
        shipToAddressController = new Address_Postcode_Check_Controller();
        sameAsSoldAddress = false;
        findPCSoldto = false;
        findPCshipTo = false;
        
        //if (ApexPages.currentPage().getParameters().get('id') == null && ApexPages.currentPage().getParameters().get('CF00NA0000003kh93_lkid') == null)
        //{
            this.order = (Order__c)stdController.getRecord();
            try {
                customerCompanyName = [ Select a.Customer_Company_Name__c
                                          From Account a
                                         Where Id =: order.Customer_Company__c ].Customer_Company_Name__c;
            } catch (Exception e) {
                try {
                    String UserID = UserInfo.getUserId();
                    User user = [SELECT Contact.AccountId FROM User WHERE Id=:UserID limit 1];    
                    this.order.Customer_Company__c = user.contact.AccountId;
                    customerCompanyName = [ Select a.Customer_Company_Name__c
                                              From Account a
                                             Where Id =: order.Customer_Company__c ].Customer_Company_Name__c;
                 } catch (Exception ex) {
                    if(ApexPages.currentPage().getParameters().get('AccId') != null){
                        this.order.Customer_Company__c = ApexPages.currentPage().getParameters().get('AccId');
                        customerCompanyName = [ Select a.Customer_Company_Name__c
                                          From Account a
                                         Where Id =: order.Customer_Company__c ].Customer_Company_Name__c;
                    }
                 }
            }
            
            //String UserID = UserInfo.getUserId();
            //User user = [SELECT Contact.AccountId FROM User WHERE Id=:UserID limit 1];    
            //this.order.Customer_Company__c = user.contact.AccountId;
        //}
        //else 
        //{
        //    this.order = (Order__c)stdController.getRecord();
        //    if(ApexPages.currentPage().getParameters().get('CF00NA0000003kh93_lkid') != null)
        //    {
        //        this.order.Customer_Company__c = ApexPages.currentPage().getParameters().get('CF00NA0000003kh93_lkid');
        //    }
        //}
    }
    
    public PageReference start(){
        //if(order.Locked__c){
        //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'This record is locked.'));
        //    return new ApexPages.StandardController(order).view().setRedirect(true);
        //}
        if(order.sold_to__c != null)
            disableSoldto();
        if(order.ship_to__c != null)
            disableShipto();
        if(sameAsSoldAddress)
            sameAsSoldAddress();
        return null;
    }
    
    public Boolean saveAddresses() {
        try {
            if (GeneralException.testException) {
                throw new GeneralException('TEST');
            }
            
            if (shipTo.Name != null && shipTo.Name != '') {
                shipTo.Customer_Company__c = order.Customer_Company__c;
                shipto.Post_Code__c = shipToPostcode;
                upsert shipTo;
                
                this.order.Ship_To__c = shipTo.Id;
            }
            
            if (soldto.Name != null && soldto.Name != '') {
                soldto.Customer_Company__c = order.Customer_Company__c;
                soldto.Post_Code__c = soldToPostcode;
                upsert soldto;
                
                this.order.Sold_To__c = soldto.Id;
            }
            
            return false;
        } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new address.'));
              
              return true;
        }
    }
    
    
    public void sameAsSoldAddress() {
        if (order.Sold_To__c != null) {
            order.Ship_To__c = order.Sold_To__c;
        } else {
            System.Debug('===> ' + shipTo);
            shipTo = soldto;
            shipToPostcode = soldToPostcode;
        }
    }
    
    public void disableSoldto() {
        if (order.sold_to__c != null) {
            if (order.sold_to__c != order.ship_to__c && sameAsSoldAddress) {
                sameAsSoldDisable();
            }
            
            soldtoDisabled = true;
            soldto = [SELECT Town__c, Tel_No__c, SystemModstamp, Post_Code__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, Customer_Company__c, CreatedDate, CreatedById, Country_de__c, Country__c, Country_Code__c, Contact_Name__c, Company_Name__c, Address_Description__c, Address_3__c, Address_2__c, Address_1__c, State__c FROM Address__c WHERE Id =: order.sold_to__c];
            
            soldToPostcode = soldto.Post_Code__c;
        } else {
            soldtoDisabled = false;
            soldto = new Address__c();
            soldToPostcode = '';
        }
    }
    
    public void disableShipto() {
        if (order.ship_to__c != null) {       
            shiptoDisabled = true;
            shipto = [SELECT Town__c, Tel_No__c, SystemModstamp, Post_Code__c, Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, Customer_Company__c, CreatedDate, CreatedById, Country_de__c, Country__c, Country_Code__c, Contact_Name__c, Company_Name__c, Address_Description__c, Address_3__c, Address_2__c, Address_1__c, State__c FROM Address__c WHERE Id =: order.ship_to__c];
            
            shipToPostcode = shipto.Post_Code__c;
        } else if (order.sold_to__c == null && soldTo.Name != null && sameAsSoldAddress){
            shipToDisabled = true;
            shipTo = soldTo;
        } else {
            shiptoDisabled = false;
            shipto = new Address__c();
            shipToPostcode = '';
        }
    }
    
    public void sameAsSoldDisable() {
        if (sameAsSoldAddress) {
            order.ship_to__c = order.sold_to__c;
            disableShipto();
        } else {
            order.ship_to__c = null;
            sameAsSoldAddress();
            disableShipto();
        }
    }
    
    public PageReference save() {
        Boolean error = false;
        
        shipto.Post_Code__c = shipToPostcode;
        soldto.Post_Code__c = soldToPostcode;
        
        if ((shipTo.Name == null || shipTo.Name == '') && order.Ship_To__c == null && !sameAsSoldAddress) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You must specify a Ship To Address'));
            
            error = true;
        }
        
        if (shipTo.Country__c == null || shipTo.Country__c.length() == 0) {
                error = true;
                
                shipTo.Country__c.addError('Please enter a valid Ship To Country');
        }
        
        //If a Ship To Country is selected
        if (shipTo.Country__c != null) {
                String[] country_Split = shipTo.Country__c.split(';');
                
                //If the Ship To selected Country Code is GB or UK
                if (country_Split.size() > 1 && (country_Split[1] == 'GB' || country_Split[1] == 'UK')) {
                        //If the Ship To Postcode is blank
                        if (shipTo.Post_Code__c == null || shipTo.Post_Code__c.length() == 0) {
                                error = true;
                                
                                shipTo.Post_Code__c.addError('Please enter a valid Ship To Postcode');
                        }
                        
                        if (shipTo.Post_Code__c != null && (shipTo.Post_Code__c.length() < 5 || shipTo.Post_Code__c.length() > 7)) {
                                error = true;
                                
                                shipTo.Post_Code__c.addError('Please enter a valid Ship To Postcode');
                        }
                }
        }
        
        if ((soldto.Name == null || soldto.Name == '') && order.Sold_To__c == null ) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You must specify a Sold To Address'));
            
            error = true;
        }
        
        if (soldto.Country__c == null || soldto.Country__c.length() == 0) {
                error = true;
                
                soldto.Country__c.addError('Please enter a valid Sold To Country');
        }
        
        //If a Sold To Country is selected
        if (soldto.Country__c != null) {
                String[] country_Split = soldto.Country__c.split(';');
                
                //If the Sold To selected Country Code is GB or UK
                if (country_Split.size() > 1 && (country_Split[1] == 'GB' || country_Split[1] == 'UK')) {
                        //If the Sold To Postcode is blank
                        if (soldto.Post_Code__c == null || soldto.Post_Code__c.length() == 0) {
                                error = true;
                                
                                soldto.Post_Code__c.addError('Please enter a valid Sold To Postcode');
                        }
                        
                        if (soldto.Post_Code__c != null && (soldto.Post_Code__c.length() < 5 || soldto.Post_Code__c.length() > 7)) {
                                error = true;
                                
                                soldto.Post_Code__c.addError('Please enter a valid Sold To Postcode');
                        }
                }
        }
        
        try {
            Order__c old_order = [SELECT Name FROM Order__c WHERE Name =: order.Name AND Customer_Company__c =: order.Customer_Company__c];
            if (old_order != null && old_order.Id != order.Id) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Order Number must be unique.'));
                
                error = true;
            }
        } catch (System.QueryException e) {
        }
        
        if (!error) {
            //error = saveAddresses();
            try {
                if (shipTo.Name != null && shipTo.Name != '') {
                    if (shipTo.Customer_Company__c == null) {
                        shipTo.Customer_Company__c = order.Customer_Company__c;
                    }
                    
                    if (shipto.Tel_No__c == null) {
                        shipto.Tel_No__c = 'unavailable';
                    }
                    
                    upsert shipTo;
                    
                    this.order.Ship_To__c = shipTo.Id;
                }
                
                if (soldto.Name != null && soldto.Name != '') {
                    if (soldto.Customer_Company__c == null) {
                        soldto.Customer_Company__c = order.Customer_Company__c;
                    }
                    
                    if (soldto.Tel_No__c == null) {
                        soldto.Tel_No__c = 'unavailable';
                    }
                    
                    upsert soldto;
                    
                    this.order.Sold_To__c = soldto.Id;
                }
                
                            
                if (sameAsSoldAddress) {
                    sameAsSoldAddress();
                }
                
                upsert order;
                
                if(GeneralException.testException) {
                    throw new GeneralException('TEST');
                }
                    
                return new ApexPages.StandardController(order).view().setRedirect(true);
            } catch (Exception e) {
                if (!ApexPages.hasMessages()) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
                }
                
                return null;
            }
        } else {
            return null;
        }
    }
            
    public void findSoldToAddress() {
        try {
            if(GeneralException.testException) {
                throw new GeneralException('TEST');
            }
            
            soldToPostcode = formatPostcode(soldToPostcode);
            soldto.Post_Code__c = soldToPostcode;
            
            if (soldToPostcode.ReplaceAll(' ', '').Length() < 5) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid postcode!'));
            } else {
                soldToAddressController.getAddresses(soldToPostcode);
                soldToAddressList = soldToAddressController.getAddressList();
                findPCSoldto = true;
                selectedSoldToAddress = '';
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid postcode!'));
        }
    }
    
    public void findshipToAddress() {
        try {
            if(GeneralException.testException) {
                throw new GeneralException('TEST');
            }
            
            shipToPostcode = formatPostcode(shipToPostcode);
            shipTo.Post_Code__c = shipToPostcode;
            
            if (shipToPostcode.ReplaceAll(' ', '').Length() < 5) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid postcode!'));
            } else {
                shipToAddressController.getAddresses(shipToPostcode);
                shipToAddressList = shipToAddressController.getAddressList();
                findPCshipTo = true;
                selectedShipToAddress = '';
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid postcode!'));
        }
    }
    
    public void populateSoldToAddress() {
        soldTo = soldToAddressController.setAddress(selectedSoldToAddress, soldTo);
    }
    
    public void populateshipToAddress() {    
        shipTo = shipToAddressController.setAddress(selectedShipToAddress, shipTo);
    }
    
    public String formatPostcode(String thePostcode) {
        thePostcode = thePostcode.ReplaceAll(' ', '').toUpperCase();
        
        if (thePostcode.Length() == 5) {
            thePostcode = thePostcode.substring(0, 2) + ' ' + thePostcode.substring(2, 5);
        } else if (thePostcode.Length() == 6) {
            thePostcode = thePostcode.substring(0, 3) + ' ' + thePostcode.substring(3, 6);
        } else if (thePostcode.ReplaceAll(' ', '').Length() == 7) {
            thePostcode = thePostcode.substring(0, 4) + ' ' + thePostcode.substring(4, 7);
        }
        
        return thePostcode;
    }
    
    // Tests    
    public static testMethod void testSave() {
        // create objects
        Account CustomerCompany = new Account(Name='cc',Default_Packaging_Type__c='Blank');
        insert CustomerCompany;
        
        Order__c order = new Order__c(Customer_Company__c=CustomerCompany.Id,Name='123',Start_Ship_Date__c=System.today());
        insert order;
        
        Address__c address = new Address__c(Name='test',Customer_Company__c=CustomerCompany.Id,Company_Name__c='company',Post_Code__c='B79 9EY',Address_1__c='street',Town__c='town',Country__c='United Kingdom',Tel_No__c='123',Contact_Name__c='contact');
        insert address;
        
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // execute methods
        controller.save();
        
        // execute methods
        Address__c addr = new Address__c(Name='test',Customer_Company__c=null,Company_Name__c='company',Post_Code__c='B79 9EY',Address_1__c='street',Town__c='town',Country__c='United Kingdom',Tel_No__c='123',Contact_Name__c='contact');
        order.Sold_to__c = order.Ship_to__c = addr.Id;
        controller.save();
            
        // execute methods
        order.Sold_to__c = address.Id;
        controller.sameAsSoldAddress();
        controller.save();
        
        // execute methods
        order.Sold_to__c = order.Ship_to__c = address.Id;
        controller.save();      
        
        // execute methods
        GeneralException.testException = true;
        controller.save();
        
        // duplicat order name
        Order__c order_duplicate = new Order__c(Customer_Company__c=CustomerCompany.Id,Name='123',Start_Ship_Date__c=System.today());
        
        // initialise page & controller
        pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        stdController = new ApexPages.StandardController(order_duplicate);
        ApexPages.currentPage().getParameters().put('id', 'test');
        controller = new Create_Order_Controller(stdController);
        
        // execute methods
        order_duplicate.Sold_to__c = address.Id;
        controller.sameAsSoldAddress();
        controller.save();
    }

    public static testMethod void testController()
    {
        // create objects
        Account CustomerCompany = new Account(Name='cc',Default_Packaging_Type__c='Blank');
        insert CustomerCompany;
        
        Order__c order = new Order__c(Customer_Company__c=CustomerCompany.Id,Name='123',Start_Ship_Date__c=System.today());
        insert order;
        
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // Parameter Branch
        ApexPages.currentPage().getParameters().put('id', null);
        try{controller = new Create_Order_Controller(stdController);}catch(Exception e){}
    }

    public static testMethod void testParameter()
    {
        // create objects
        Account CustomerCompany = new Account(Name='cc',Default_Packaging_Type__c='Blank');
        insert CustomerCompany;
        
        Order__c order = new Order__c(Customer_Company__c=CustomerCompany.Id,Name='123',Start_Ship_Date__c=System.today());
        insert order;
        
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        Address__c address = controller.shipTo;
        address = controller.soldto;
    } 

    public static testMethod void testsaveAddresses()
    {
        // create objects
        Account CustomerCompany = new Account(Name='cc',Default_Packaging_Type__c='Blank');
        insert CustomerCompany;
        
        Order__c order = new Order__c(Customer_Company__c=CustomerCompany.Id,Name='UNIQUE',Start_Ship_Date__c=System.today());
        insert order;
        
        Address__c shipto_address = new Address__c(Name='test',Customer_Company__c = CustomerCompany.Id,Company_Name__c='company',Post_Code__c='B79 9EY',Address_1__c='street',Town__c='town',Country__c='United Kingdom;GB',Tel_No__c='123',Contact_Name__c='contact');

        Address__c soldto_address = new Address__c(Name='stest',Customer_Company__c=CustomerCompany.Id,Company_Name__c='company',Post_Code__c='B79 9EY',Address_1__c='street',Town__c='town',Country__c='United Kingdom;GB',Tel_No__c='123',Contact_Name__c='contact');
        
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // execute methods  
        controller.soldto = soldto_address;
        controller.shipTo = shipto_address;
        controller.saveAddresses();
              
        // execute methods
        GeneralException.testException = true;
        try {
                controller.saveAddresses();
        } catch(Exception e) {
        }
    }  
    
    public static testMethod void testsameAsSoldToAddresses() {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        Address__c address = new Address__c(Name = 'test', 
                                            Customer_Company__c = CustomerCompany.Id,
                                            Company_Name__c = 'company',
                                            Post_Code__c = 'B79 9EY',
                                            Address_1__c = 'street',
                                            Town__c = 'town',
                                            Country__c = 'United Kingdom',
                                            Tel_No__c = '123',
                                            Contact_Name__c = 'contact');
        insert address;
                                                    
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // execute methods
        controller.sameAsSoldAddress();
        order.Sold_to__c = address.Id;
        update order;        
        controller.sameAsSoldAddress();
    }  
    
    public static testMethod void testfindSoldToAddresses()
    {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        Address__c address = new Address__c(Name = 'test', 
                                            Customer_Company__c = CustomerCompany.Id,
                                            Company_Name__c = 'company',
                                            Post_Code__c = 'B79 9EY',
                                            Address_1__c = 'street',
                                            Town__c = 'town',
                                            Country__c = 'United Kingdom',
                                            Tel_No__c = '123',
                                            Contact_Name__c = 'contact');
                                                    
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // execute methods
        controller.soldToPostcode = '12345';
        controller.findSoldToAddress();
        
        // execute methods
        controller.soldToPostcode = '1';
        controller.findsoldToAddress();
        
        // execute methods
        GeneralException.testException = true;
        controller.findSoldToAddress();
    }  
    
    public static testMethod void testfindShipToAddresses()
    {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        Address__c address = new Address__c(Name = 'test', 
                                            Customer_Company__c = CustomerCompany.Id,
                                            Company_Name__c = 'company',
                                            Post_Code__c = 'B79 9EY',
                                            Address_1__c = 'street',
                                            Town__c = 'town',
                                            Country__c = 'United Kingdom',
                                            Tel_No__c = '123',
                                            Contact_Name__c = 'contact');
                                                    
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // execute methods
        controller.shipToPostcode = '12345';
        controller.findshipToAddress();
        
        // execute methods
        controller.shipToPostcode = '1';
        controller.findshipToAddress();
        
        // execute methods
        GeneralException.testException = true;
        controller.findshipToAddress();
    }  
    
    public static testMethod void testformatPostcode()
    {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        Address__c address = new Address__c(Name = 'test', 
                                            Customer_Company__c = CustomerCompany.Id,
                                            Company_Name__c = 'company',
                                            Post_Code__c = 'B79 9EY',
                                            Address_1__c = 'street',
                                            Town__c = 'town',
                                            Country__c = 'United Kingdom',
                                            Tel_No__c = '123',
                                            Contact_Name__c = 'contact');
                                                    
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // execute methods
        controller.shipToPostcode = '12345';
        controller.findshipToAddress();
        
        // execute methods
        controller.shipToPostcode = '123456';
        controller.findshipToAddress();
                
        // execute methods
        controller.shipToPostcode = '1234567';
        controller.findshipToAddress();
    }

    
    public static testMethod void testPopulateAddress()
    {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
                                                    
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        // execute methods
        try{controller.populateSoldToAddress();}catch (Exception e){}
        try{controller.populateShipToAddress();}catch (Exception e){}
    }   
    
    public static testMethod void testSoldToStuff(){
    	// create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        // initialise page & controller
        PageReference pageRef = Page.Create_Order;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('id', 'test');
        Create_Order_Controller controller = new Create_Order_Controller(stdController);
        
        controller.start();
        controller.disableShipto();
        controller.disableSoldto();
        controller.sameAsSoldAddress();
        controller.sameAsSoldDisable();
    }
}