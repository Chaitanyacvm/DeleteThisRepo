public class Create_Address_Controller {
    private Address__c address;
    private Address_Postcode_Check_Controller AddressController{get; set;}

    public String Postcode{get;set;}
    public List<selectOption> AddressList{get;set;}
    public Boolean findAddr{get;set;}
    public String selectedAddress{get;set;}
    
    public String customerCompanyName { get; set; }
        
    public Create_Address_Controller(ApexPages.StandardController stdController) {
        if (ApexPages.currentPage().getParameters().get('id') == null) {
            this.address = (Address__c)stdController.getRecord();
            
            try {
                customerCompanyName = [SELECT Customer_Company_Name__c FROM Account WHERE Id =: address.Customer_Company__c].Customer_Company_Name__c;
            } catch (Exception e) {
            }
        } else {
            this.address = (Address__c)stdController.getRecord();
            this.address.Post_Code__c = [SELECT Post_Code__c FROM Address__c WHERE Id = :stdController.getRecord().Id].Post_Code__c;
            Postcode = this.address.Post_Code__c; 
        }
        
        AddressController = new Address_Postcode_Check_Controller();
    }

    public void findAddress() {
        try {
            //isRequired = false;
            Postcode = formatPostcode(Postcode);
            address.Post_Code__c = Postcode;
            
            if (Postcode.ReplaceAll(' ', '').Length() < 5) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid postcode!'));
            } else {
                AddressController.getAddresses(Postcode);
                AddressList = AddressController.getAddressList();
                findAddr = true;
                selectedAddress = '';
            }
            
            if (GeneralException.testException) {
                throw new GeneralException('TEST');
            }
        } catch (Exception e) {
            System.debug(e);
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid postcode!'));
        }
    }
    
    public void populateAddress() {
        try {
            address = AddressController.setAddress(selectedAddress, address);
            //isRequired = true;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() ));
        }
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
    
    public PageReference save() {
        try {
            boolean validAddress = true;
            
            Postcode = formatPostcode(Postcode);
            address.Post_Code__c = Postcode;
            
            if (address.Name == null || address.Name.length() == 0) {
                validAddress = false;
                
                address.Name.addError('Please enter a valid Address Reference');
            }
            
            if (address.Country__c == null || address.Country__c.length() == 0) {
                validAddress = false;
                
                address.Country__c.addError('Please enter a valid Country');
            }
            
            //If a Country is selected
            if (address.Country__c != null) {
                String[] country_Split = address.Country__c.split(';');
                
                //If the selected Country Code is GB or UK
                if (country_Split.size() > 1 && (country_Split[1] == 'GB' || country_Split[1] == 'UK')) {
                    //If the Postcode is blank
                    if (address.Post_Code__c == null || address.Post_Code__c.length() == 0) {
                        validAddress = false;
                        
                        address.Post_Code__c.addError('Please enter a valid Postcode');
                    }
                    
                    if (address.Post_Code__c != null && (address.Post_Code__c.length() < 5 || address.Post_Code__c.length() > 7)) {
                        validAddress = false;
                        
                        address.Post_Code__c.addError('Please enter a valid Postcode');
                    }
                }
            }
            
            if (validAddress) {
                if (address.Tel_No__c == null) {
                    address.Tel_No__c = 'unavailable';
                }
                
                upsert address;
                
                if(GeneralException.testException) {
                    throw new GeneralException('TEST');
                }
                
                Account customerCompany = [SELECT Id, Name FROM Account WHERE Id =: address.Customer_Company__c];
                
                return new ApexPages.StandardController(customerCompany).view().setRedirect(true);
            }
         } catch (Exception e) {
             //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
         }   
         
         return null;
    }
    
    // Tests    
    public static testMethod void testThis() {
        // create objects
        Account CustomerCompany = new Account(Name='cc',Default_Packaging_Type__c='Blank');
        insert CustomerCompany;
        
        Address__c address = new Address__c(Name='test',Customer_Company__c=CustomerCompany.Id,Company_Name__c='company',Post_Code__c='B79 9EY',Address_1__c='street',Town__c='town',Country__c='United Kingdom;GB',Tel_No__c='123',Contact_Name__c='contact');
        insert address;
        
        // initialise page & controller
        PageReference pageRef = Page.Create_Address;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(address);
        Create_Address_Controller controller = new Create_Address_Controller(stdController);
        
        // execute methods
        controller.Postcode = 'N52SH';
        try {
            controller.findAddress();
            controller.populateAddress();
        } catch (Exception e) {
            
        }
        PageReference save = controller.save();
        
        // execute methods
        controller.Postcode = '1';
        try {
            controller.findAddress();
        } catch (Exception e) {
            
        }
        
        // execute methods
        GeneralException.testException = true;
        try {
            controller.findAddress();
        } catch (Exception e) {
            
        }
        save = controller.save();
        
        // edit
        ApexPages.currentPage().getParameters().put('id', 'test');
        controller = new Create_Address_Controller(stdController);
    }    
}