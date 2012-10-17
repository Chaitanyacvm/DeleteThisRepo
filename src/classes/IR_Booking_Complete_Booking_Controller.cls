public class IR_Booking_Complete_Booking_Controller {
    public IR_Customer__c customer {get; set;}
    public IR_Order__c thisOrder {get; set;}
    
    public LIST<IR_Consignment_Bundle> consignmentBundles {get; set;}
    public IR_Global_Class.TelephoneField tel {get; set;}
    public IR_Global_Class.TelephoneField mob {get; set;}
    public IR_Global_Class.TelephoneField fax {get; set;}
    
    public Boolean showCustAddress {get; set;}       
    
    public Boolean editCustDetails {get; set;}
    
    public Boolean allowCustAddressInput {get; set;}
    public Boolean allowComplete {get; set;}
    
    public Boolean showEditPackageTable {get; set;}    
    
    public String custEmailConf {get; set;}
    public String selectedCustAddress {get; set;}
    
    private IR_Postcode_Check custCheck {get; set;}
    private IR_Global_Class.RateCheckResult results {get; set;}
    
    public IR_Booking_Complete_Booking_Controller() {
        try {
        	showCustAddress = true;
        	
        	showEditPackageTable = false;
        	
            Id orderId = ApexPages.currentPage().getParameters().get('oid');
            customer = new IR_Customer__c();
            custCheck = new IR_Postcode_Check();
            tel = new IR_Global_Class.TelephoneField();
            mob = new IR_Global_Class.TelephoneField();
            fax = new IR_Global_Class.TelephoneField();
            editCustDetails = true;
            allowCustAddressInput = true;
            custEmailConf = customer.Email__c;
            customer.OwnerId = IR_Global_Class.getNewCustomersQueueId();
            allowComplete = true;
            
            if (orderId == null) {
                thisOrder = new IR_Order__c();
                
                consignmentBundles = new LIST<IR_Consignment_Bundle>();
                consignmentBundles.add(new IR_Consignment_Bundle());
            } else {
                refreshData(orderId);
            }
        } catch (Exception ex) {
            //if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            //}
        }
    }
    
    public List<SelectOption> accountETLOptions {
        get {
            return IR_Global_Class.accountETLOptions;
        }
    }
    
    public Boolean savedFrom {
        get {
            try {
                return consignmentBundles[0].consignment.Saved_From_Address__c;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    private void refreshData(String orderId) {
        try {
            thisOrder = IR_Global_Class.getOrder(orderId);
            
            LIST<Id> consignmentIds = new LIST<Id>();
            for (IR_Consignment__c consignment : thisOrder.Consignments__r) {
                consignmentIds.add(consignment.Id);
            }
            
            LIST<IR_Consignment__c> consignments = IR_Global_Class.getConsignments(consignmentIds);
            
            if (consignments != null && consignments.size() > 0) {
                consignmentBundles = IR_Global_Class.getConsignmentBundles(consignments);
                
                if (thisOrder.Customer__c != null) {
                    customer = IR_Global_Class.getCustomer(thisOrder.Customer__c);
                } else {
                    if (consignmentBundles != null && consignmentBundles.size() > 0) {
                        customer = new IR_Customer__c(/*VAT_Registration_Number__c='GB'*/);
                        
                        customer.Postcode__c = consignmentBundles[0].consignment.From_Postcode__c;
                        customer.Country__c = consignmentBundles[0].consignment.From_Country__c;
                        customer.Country_Code__c = consignmentBundles[0].consignment.From_Country_Code__c;
                        customer.Email__c = consignmentBundles[0].consignment.Customer_Email_Address__c;
                    }
                }
                
                tel = new IR_Global_Class.TelephoneField(customer.Telephone__c);
                mob = new IR_Global_Class.TelephoneField(customer.Mobile_Phone__c);
                fax = new IR_Global_Class.TelephoneField(customer.Fax__c);
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public Boolean national {
        get {
            try {
                for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                    if (!consignmentBundle.nationalConsignment) {
                        return false;
                    }
                }
                
                return (customer.Country_Code__c == 'GB' ? true : false);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public LIST<SelectOption> services {
        get {
            try {
                LIST<SelectOption> options = new LIST<SelectOption>();
                options.add(new SelectOption('09:00 Express', '09:00 Express'));
                options.add(new SelectOption('10:00 Express', '10:00 Express'));
                options.add(new SelectOption('12:00 Express', '12:00 Express'));
                options.add(new SelectOption('Express', 'Express'));
                
                return options;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return new LIST<SelectOption>();
            }
        }
    }
    
    public PageReference lookupCustAddress() {
        try {
            customer.Postcode__c = IR_Global_Class.formatPostcode(customer.Postcode__c);
            
            Map<String, String> itemMap = new Map<String, String>();
            itemMap.put('THOR', customer.Address_1__c);
            itemMap.put('TOWN', customer.Town_City__c);
            itemMap.put('PCOD', customer.Postcode__c);
            itemMap.put('ISOC', IR_Global_Class.getThreeDigitCode(customer.Country_Code__c));
            
            custCheck.getAddresses(itemMap);
            
            if (custCheck.getAddressList().size() > 1) {
                allowCustAddressInput = false;
            } else {
                allowCustAddressInput = true;
            }
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        return null;
    }
        
    public Boolean showCustAddrLookup {
        get {
            try {
                return IR_Global_Class.pcLookupSupported(customer.Country_Code__c);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public Boolean hasAddress {
        get {
            try {
                return (custCheck == null || custCheck.getAddressList() == null || custCheck.getAddressList().size() == 1 ? false : true);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public LIST<SelectOption> custAddressOptions {
        get {
            try {
                return custCheck.getAddressList();
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return new LIST<SelectOption>();
            }
        }
    }
    
    public PageReference selectCustAddress() {
        try {
            customer.Address_1__c = custCheck.getAddressLine1(selectedCustAddress);
            customer.Address_2__c = custCheck.getAddressLine2(selectedCustAddress);
            customer.Address_3__c = custCheck.getAddressLine3(selectedCustAddress);
            customer.Town_City__c = custCheck.getTown(selectedCustAddress);
            customer.County__c = custCheck.getCounty(selectedCustAddress);
            
            if (custCheck.getCompanyName(selectedCustAddress) != null) {
                //customer.Company__c = custCheck.getCompanyName(selectedCustAddress);
            }
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference quickSaveCustAddress() {
        try {
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
            	consignmentBundle.consignment.Pickup_Collection_Time_from__c = consignmentBundle.selectedFromTime;
            	consignmentBundle.consignment.Pickup_Collection_Time_to__c = consignmentBundle.selectedToTime;
            	
                upsert consignmentBundle.consignment;
            }
            
            customer.Vat_Registration_Number__c = (customer.Vat_Registration_Number__c == null ? null : (customer.Vat_Registration_Number__c.startsWith('GB') || customer.Vat_Registration_Number__c.length() > 10 ? customer.Vat_Registration_Number__c : 'GB' + customer.Vat_Registration_Number__c));
            customer.Telephone__c = tel.format;
            customer.Mobile_Phone__c = mob.format;
            customer.Fax__c = fax.format;
            upsert customer;
            
            thisOrder.Customer__c = customer.Id;
            upsert thisOrder;
            
            refreshData(thisOrder.Id);
        } catch (Exception ex) {
            customer.Saved_Customer__c = false;
            
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference saveCustAddress() {
        try {
            if (!(customer.Email__c == custEmailConf)) {
                customer.Email__c.addError('Email Addresses do not match');
            }                     
            System.debug('Address_1__c'+customer.Address_1__c);
            if (customer.Address_1__c == null || customer.Address_1__c.length() == 0) {
                String errorMessage = 'Please enter an Address Line 1';
                
                customer.Address_1__c.addError(errorMessage);
            }
            System.debug('Town_City__c'+customer.Town_City__c);
            if (customer.Town_City__c == null || customer.Town_City__c.length() == 0) {
                String errorMessage = 'Please enter a Town or City';
                
                customer.Town_City__c.addError(errorMessage);
            }
            System.debug('Rate_And_Offer_Terms__c'+ customer.Rate_And_Offer_Terms__c);
            if (!customer.Rate_And_Offer_Terms__c) {
                String errorMessage = 'You must accept the Rate Agreement and Terms of Offer';
                
                customer.Rate_And_Offer_Terms__c.addError(errorMessage);
            }
            System.debug('Terms_and_Conditions__c'+ customer.Terms_and_Conditions__c);
            if (!customer.Terms_and_Conditions__c) {
                String errorMessage = 'You must accept the Terms and Conditions of Carriage';
                
                customer.Terms_and_Conditions__c.addError(errorMessage);
            }
            System.debug('tel.plainStd:'+ tel.plainStd);
            if (tel.plainStd == null || tel.plainStd.length() == 0 || tel.plainStd.length() > 5) {
            	String errorMessage = 'Please specify a valid Telephone dialling code that is no greater than 5 characters long';

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage));
            }
            System.debug('tel.phoneNumber:'+ tel.phoneNumber);
            if (tel.phoneNumber == null || tel.phoneNumber.length() == 0 || tel.phoneNumber.length() > 7) {
            	String errorMessage = 'Please specify a valid Telephone number that is no greater than 7 characters long';

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage));
            }            
            if (mob.plainStd == null && (mob.plainStd.length() == 0 || mob.plainStd.length() > 5)) {
            	String errorMessage = 'Please specify a valid Mobile dialling code that is no greater than 5 characters long';

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage));
            }
            
            if (mob.phoneNumber == null && (mob.phoneNumber.length() == 0 || mob.phoneNumber.length() > 7)) {
            	String errorMessage = 'Please specify a valid Mobile number that is no greater than 7 characters long';

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage));
            }
            
            if (fax.plainStd == null && (fax.plainStd.length() == 0 || fax.plainStd.length() > 5)) {
            	String errorMessage = 'Please specify a valid Fax dialling code that is no greater than 5 characters long';

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage));
            }
            
            if (fax.phoneNumber == null && (fax.phoneNumber.length() == 0 || fax.phoneNumber.length() > 7)) {
            	String errorMessage = 'Please specify a valid Fax number that is no greater than 7 characters long';

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage));
            }
            
            if (customer.VAT_Registration_Number__c != null && (customer.VAT_Registration_Number__c.replaceAll(' ', '').replaceAll('GB', '').length() < 9 || customer.VAT_Registration_Number__c.replaceAll(' ', '').replaceAll('GB', '').length() > 12)) {
                String errorMessage = 'The VAT Registration Number must be between 9 and 12 characters long (excluding the "GB" prefix)';
                
                customer.VAT_Registration_Number__c.addError(errorMessage);
            }
            
        	if (customer.VAT_Registration_Number__c != null) {
	            try {
	            	Decimal vatNumber = Integer.valueOf(customer.VAT_Registration_Number__c.replaceAll(' ', '').replaceAll('GB', ''));
	            } catch (Exception e) {
	                String errorMessage = 'The VAT Registration Number must be numeric (excluding the "GB" prefix)';
	                
	                customer.VAT_Registration_Number__c.addError(errorMessage);
	            }
        	}
            
            if (customer.Extended_Transit_Liability_Setting__c == null) {
                String errorMessage = 'Please select an Account Enhanced Transit Liability Setting';
                
                customer.Extended_Transit_Liability_Setting__c.addError(errorMessage);
            }
            
            if (!ApexPages.hasMessages()) {
                for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                    upsert consignmentBundle.consignment;
                }
                
                customer.Saved_Customer__c = true;
                customer.Vat_Registration_Number__c = (customer.Vat_Registration_Number__c == null ? null : (customer.Vat_Registration_Number__c.startsWith('GB') ? customer.Vat_Registration_Number__c : 'GB' + customer.Vat_Registration_Number__c));
                customer.Telephone__c = tel.format;
                customer.Mobile_Phone__c = mob.format;
                customer.Fax__c = fax.format;
                upsert customer;
                
                thisOrder.Customer__c = customer.Id;
                upsert thisOrder;
                
                //refreshData(thisOrder.Id);
                
                for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                    consignmentBundle.consignment.From_Address_1__c = customer.Address_1__c;
                    consignmentBundle.consignment.From_Address_2__c = customer.Address_2__c;
                    consignmentBundle.consignment.From_Address_3__c = customer.Address_3__c;
                    consignmentBundle.consignment.From_Town_City__c = customer.Town_City__c;
                    consignmentBundle.consignment.From_County__c = customer.County__c;
                    consignmentBundle.consignment.From_Company__c = customer.Company__c;
                    if(consignmentBundle.consignment.Show_Col_Address__c == false){
                    consignmentBundle.consignment.Show_Col_Address__c = true;
                    consignmentBundle.consignment.Show_Del_Address__c = false;                    
                    }else{
                    	consignmentBundle.consignment.Show_Col_Address__c = true;
                    consignmentBundle.consignment.Show_Del_Address__c = true;
                    }                    
                    if(consignmentBundle.showETLCheckbox == false){
                    	consignmentBundle.consignment.Transit_Liability__c = false;	
                    }
                    
                    upsert consignmentBundle.consignment;
                    
                    consignmentBundle.allowFromInput = false;
                }
                
                refreshData(thisOrder.Id);
            }
        } catch (Exception ex) {
            customer.Saved_Customer__c = false;
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
            	consignmentBundle.consignment.Show_Col_Address__c = false;
                consignmentBundle.consignment.Show_Del_Address__c = false;
            }
            
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference editCustAddress() {
        try {
            customer.Saved_Customer__c = false;
            upsert customer;
            
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
	            consignmentBundle.showColAddress = false;
	            consignmentBundle.showDelAddress = false;
            }
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public String fullCustAddress {
        get {
            return customer.Address_1__c + (customer.Address_2__c == null ? '' : ', ' + customer.Address_2__c) + (customer.Address_3__c == null ? '' : ', ' + customer.Address_3__c) + (customer.Town_City__c == null ? '' : ', ' + customer.Town_City__c) + (customer.County__c == null ? '' : ', ' + customer.County__c) + (customer.Postcode__c == null ? '' : ', ' + customer.Postcode__c) + ', ' + customer.Country__c;
        }
    }
    
    public PageReference addPackage() {
        try {
            consignmentBundles[0].addPackage();
            disableComplete();
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference removePackage() {
        try {
            consignmentBundles[0].removePackage();
            disableComplete();
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference editPackageDetails(){
    	try{
    		showEditPackageTable = true;		
    		disableComplete();
    		return null;	
    	} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference savePackageDetails(){
    	try{
    		showEditPackageTable = false;    		
    		disableComplete();
    		return null;	
    	} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference recalculatePrices() {
        try {
            disableComplete();
            LIST<IR_Consignment__c> consignments = new LIST<IR_Consignment__c>();            
            LIST<Id> conIds = new LIST<Id>();
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
            	consignmentBundle.consignment.Pickup_Collection_Time_from__c = consignmentBundle.selectedFromTime;
            	consignmentBundle.consignment.Pickup_Collection_Time_to__c = consignmentBundle.selectedToTime;
            	if (consignmentBundle.consignment.Transit_Liability__c) {
            		IR_Global_Class.checkETLValue(consignmentBundle.consignment);
            	}else{
            		consignmentBundle.consignment.Estimated_Value__c = 0.00;
            	}
            	
                consignments.add(consignmentBundle.consignment);
                conIds.add(consignmentBundle.consignment.Id);                
            }
            
            upsert customer;
            upsert consignments;
            upsert thisOrder;
            
            LIST<IR_Package__c> existingPackages = [SELECT Id FROM IR_Package__c WHERE Consignment_IR__c = :conIds];

            LIST<IR_Package__c> packageList = new LIST<IR_Package__c>();
            Integer i = 0;
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                for (IR_Package_Bundle packageBundle : consignmentBundle.packageBundlesMap.values()) {
                    packageBundle.thePackage = packageBundle.thePackage.clone(false, true);
                    
                    if (packageBundle.thePackage.Consignment_IR__c == null) {
                        packageBundle.thePackage.Consignment_IR__c = consignments[i].Id;
                    }
                    
                    packageList.add(packageBundle.thePackage);
                }
                
                i++;
            }
            
            insert packageList;
            delete existingPackages;
            
            refreshData(thisOrder.Id);
        } catch (Exception ex) {
            disableComplete();
            
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference reQuote() {
    	if(showEditPackageTable){
    		showEditPackageTable = false;
    	}
    	if (IR_Global_Class.validatePackage(consignmentBundles)) {
	        try {
	            results = IR_Global_Class.getQuote(thisOrder, consignmentBundles);
	            
	            if (results.errors != null && results.errors.size() > 0) {
	                for (IR_Global_Class.RateCheckError error : results.errors) {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, error.code + ': ' + error.message));
	                }
	                
		        	thisOrder.Amount_Quoted__c = 0;
		        	update thisOrder;
		        	
		        	thisOrder = IR_Global_Class.getOrder(thisOrder.Id);
	                disableComplete();
	            } else if (results.combinedRates != null) {
	                thisOrder.Amount_Quoted__c = results.combinedRates.get(consignmentBundles[0].consignment.Service_Code__c + '|' + consignmentBundles[0].consignment.Option_Code__c).rate;
	                upsert thisOrder;
	                
	                enableComplete();
	            }
	            
	            upsert customer;
	            refreshData(thisOrder.Id);
	            
	            return null;
	        } catch (Exception ex) {
	            if (!ApexPages.hasMessages()) {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, '1' + ex.getMessage()));
	            }
	            
	            return null;
	        }
    	} else {
        	thisOrder.Amount_Quoted__c = 0;
        	upsert thisOrder;
        	
        	thisOrder = IR_Global_Class.getOrder(thisOrder.Id);
            disableComplete();
            
            return null;
    	}
    }
    
    public PageReference termsConditions() {
        try {
            PageReference pr = Page.IR_Booking_Terms_And_Conditions_Page;
            pr.setRedirect(true);
            
            return pr;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference completeBooking() {
        try {
            if (!customer.Saved_Customer__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please ensure you save the Account and Billing Details'));
            }
            
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
            	consignmentBundle.consignment.Pickup_Collection_Time_from__c = consignmentBundle.selectedFromTime;
            	consignmentBundle.consignment.Pickup_Collection_Time_to__c = consignmentBundle.selectedToTime;
            	
                if (!consignmentBundle.consignment.Saved_From_Address__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please ensure you save the  Ship From Address'));
                }
                
                if (!consignmentBundle.consignment.Saved_To_Address__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please ensure you save the  Ship To Address'));
                }
                
                if (consignmentBundle.renderCommercialInv && !consignmentBundle.consignment.Commercial_Invoice__c) {
                    String errorMessage = 'You must agree to the "Commercial Invoice Terms and Conditions"';
                    
                    consignmentBundle.consignment.Commercial_Invoice__c.addError(errorMessage);                    
                }
                
                if (consignmentBundle.consignment.Pickup_Collection_Time_from__c == null || consignmentBundle.consignment.Pickup_Collection_Time_from__c.length() == 0) {
                    String errorMessage = 'Please enter a "Pickup available from" time';
                    
                    consignmentBundle.consignment.Pickup_Collection_Time_from__c.addError(errorMessage);                    
                }
                
                if (consignmentBundle.consignment.Pickup_Collection_Time_to__c == null || consignmentBundle.consignment.Pickup_Collection_Time_to__c.length() == 0) {
                    String errorMessage = 'Please enter a "Location open until" time';
                    
                    consignmentBundle.consignment.Pickup_Collection_Time_to__c.addError(errorMessage);                    
                }
                
                if (!consignmentBundle.nationalConsignment && consignmentBundle.consignment.Transit_Liability__c && consignmentBundle.consignment.Estimated_Value__c == null) {
                    String errorMessage = 'The Estimated Value is required when the Consignment is International';
                    
                    consignmentBundle.consignment.Transit_Liability__c.addError(errorMessage);                    
                }
                if (consignmentBundle.consignment.Description_of_Goods__c == null || consignmentBundle.consignment.Description_of_Goods__c.length() == 0) {
                    String errorMessage = 'Please enter a "Description of Goods"';
                    
                    consignmentBundle.consignment.Description_of_Goods__c.addError(errorMessage);                    
                }
                if(showEditPackageTable == true){
                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please save the package details.'));
                }
                
                IR_Global_Class.checkETLValue(consignmentBundle.consignment);
            }
            
            if (!ApexPages.hasMessages()) {
                customer.OwnerId = IR_Global_Class.getNewCustomersQueueId();
                customer.Order_Placed__c = true;
                customer.Registration_Status__c = 'Awaiting Email Verification';
                update customer;
                
                thisOrder.Customer__c = customer.Id;
                thisOrder.Order_Status__c = 'Order';
                upsert thisOrder;
                
                LIST<IR_Consignment__c> updatedConsignments = new LIST<IR_Consignment__c>();
                for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
	            	consignmentBundle.consignment.Pickup_Collection_Time_from__c = consignmentBundle.selectedFromTime;
	            	consignmentBundle.consignment.Pickup_Collection_Time_to__c = consignmentBundle.selectedToTime;
	            	
                    if (consignmentBundle.consignment.Estimated_Value__c == null) {
                        consignmentBundle.consignment.Estimated_Value__c = 0;
                    }
                    
                    updatedConsignments.add(consignmentBundle.consignment);
                }
                update updatedConsignments;
                
                PageReference pr = Page.IR_Booking_Complete_Conf_Page;
                pr.getParameters().put('oid', thisOrder.Id);
                pr.setRedirect(true);
                
                return pr;
            } else {
                return null;
            }
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage() + ' - ' + ex.getStackTraceString()));
            }
            
            return null;
        }
    }
    
    public PageReference back() {
        try {
            PageReference pr = Page.IR_Booking_Get_Quote_Page;
            pr.getParameters().put('oid', thisOrder.Id);
            pr.setRedirect(true);
            
            return pr;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference enableComplete() {
        try {
            allowComplete = true;
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference disableComplete() {
        try {
            allowComplete = false;
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
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
                
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        testOrder = IR_Global_Class.getOrder(testOrder.Id);
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();
        System.assert(cont.thisOrder.Id == testOrder.Id);
        System.assert(cont.consignmentBundles[0].consignment.Id == testCon.Id);
        
        System.debug(cont.services);
        
        System.debug(cont.editCustAddress());
        
        System.debug(cont.lookupCustAddress());
        
        System.assert(!cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.lookupCustAddress());
        
        System.assert(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.saveCustAddress());
        
        cont.customer.Address_1__c = 'Addr1';
        cont.customer.Address_2__c = 'Addr2';
        cont.customer.Address_3__c = 'Addr3';
        cont.customer.Town_City__c = 'TownCity';
        cont.customer.County__c = 'County';
        cont.customer.Postcode__c = 'SE10HS';
        
        System.assert(cont.fullCustAddress == 'Addr1, Addr2, Addr3, TownCity, County, SE10HS, United Kingdom');
        
        System.debug(cont.recalculatePrices());
        
        System.debug(cont.reQuote());
        
        System.assert(cont.termsConditions().getURL() == Page.IR_Booking_Terms_And_Conditions_Page.getURL());
        
        System.debug(cont.completeBooking());
        
        PageReference pr = Page.IR_Booking_Get_Quote_Page;
        pr.getParameters().put('oid', testOrder.Id);
        System.assert(cont.back().getURL() == pr.getURL());
        Test.stopTest();
    }
    
   /* TestMethod static void testAll() {
        IR_Customer__c testCust = new IR_Customer__c(
        Company__c = 'TEST', 
        Title__c='MR', 
        First_Name__c ='TESTNAME', 
        Surname__c = 'TEST', 
        Job_Title__c='TEST', 
        Telephone__c='+44 (0)20 123456',
        Address_1__c = 'TestAddr1',
        Town_City__c = 'London',
        County__c='County', 
        Email__c='TEST@TEST.com', 
        Postcode__c = 'E126UE', 
        Extended_Transit_Liability_Setting__c = '£5,000',
        Rate_And_Offer_Terms__c = true, 
        Terms_and_Conditions__c = true
        );
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(
        Order_IR__c=testOrder.Id,
        To_Contact_Number__c = '+44 (0)20 17879',
        From_Contact_Number__c = '+44 (0)20 17879',
        To_Country__c = 'United Kingdom',
        From_Postcode__c='SE10HS',
        To_Postcode__c='SE10HS',
        Type__c='Document',
        Pickup_Collection_Date__c=System.today()
        );
        insert testCon;
        
        testCust = IR_Global_Class.getCustomer(testCust.Id);
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        testOrder = IR_Global_Class.getOrder(testOrder.Id);
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();
        cont.custEmailConf = 'TEST@TEST.com';
        System.assert(cont.customer.Id == testCust.Id);
        System.assert(cont.thisOrder.Id == testOrder.Id);
        System.assert(cont.consignmentBundles[0].consignment.Id == testCon.Id);
		System.debug(cont.quickSaveCustAddress());		        
        System.debug(cont.services);
        
        System.debug(cont.editCustAddress());
        
        System.debug(cont.lookupCustAddress());
        
        System.assert(!cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.lookupCustAddress());
        
        System.assert(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        cont.customer.Rate_And_Offer_Terms__c = true;
        cont.customer.Terms_and_Conditions__c = true;                
        cont.customer.Address_1__c = 'Addr1';
        cont.customer.Address_2__c = 'Addr2';
        cont.customer.Address_3__c = 'Addr3';
        cont.customer.Town_City__c = 'TownCity';
        cont.customer.Telephone__c = '+44 (0)20 124562';
        cont.customer.County__c = 'County';
        cont.customer.Postcode__c = 'SE10HS';
        System.assert(cont.fullCustAddress == 'Addr1, Addr2, Addr3, TownCity, County, SE10HS, United Kingdom');
        
        System.debug(cont.recalculatePrices());
        
        System.debug(cont.reQuote());
        
        System.assert(cont.termsConditions().getURL() == Page.IR_Booking_Terms_And_Conditions_Page.getURL());
        
        
        System.debug(cont.savedFrom);        
        System.debug(cont.national);
        System.assert(cont.showCustAddrLookup);
        cont.customer.Terms_and_Conditions__c = true;
        cont.customer.Rate_And_Offer_Terms__c = true;
        cont.customer.Address_1__c = 'addr1 test addr';
        cont.customer.Address_2__c = 'addr2 test addr';
        cont.customer.Address_3__c = 'addr3 test addr';        
        cont.customer.Telephone__c = '+44 (0)20 123456';
        cont.tel.plainStd = '020';
        cont.tel.phoneNumber ='123456';
        System.debug('@cont.customer@'+cont.customer);
        System.debug('@@saveCustAddress@'+cont.saveCustAddress());
        cont.consignmentBundles[0].consignment.Pickup_Collection_Time_from__c = '12:00';
        cont.consignmentBundles[0].consignment.Pickup_Collection_Time_to__c = '15:00';
        cont.consignmentBundles[0].consignment.Saved_From_Address__c = true;
        cont.consignmentBundles[0].consignment.Saved_To_Address__c = true;
        cont.consignmentBundles[0].consignment.Description_of_Goods__c = 'Test goods';
        System.debug(cont.completeBooking());
        
        PageReference pr = Page.IR_Booking_Get_Quote_Page;
        pr.getParameters().put('oid', testOrder.Id);
        System.assert(cont.back().getURL() == pr.getURL());
        Test.stopTest();
    }*/
   //Testing the complete Internet registration process for Domestic consignments 
    TestMethod static void testAll_Case1(){
    	IR_Customer__c testCust = new IR_Customer__c(
    	Address_1__c = 'Test street 1',
    	Address_2__c = 'Test street 2',
    	Town_City__c = 'TestTown',    	    
    	Company__c = 'TEST', 
    	Title__c='MR', 
    	First_Name__c ='TESTNAME', 
    	Surname__c = 'TEST', 
    	Job_Title__c='TEST', 
    	Telephone__c='044020678906', 
    	Mobile_Phone__c='04487588288209',
    	Email__c='TEST@TEST.com', 
    	Postcode__c = 'E12 6UE',     	
    	Rate_And_Offer_Terms__c = true, 
    	Terms_and_Conditions__c = true
    	);
    	
    	insert testCust;
    		
		IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Country__c ='United Kingdom',To_Country__c = 'United Kingdom',From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;    		
    	
    	testCust = IR_Global_Class.getCustomer(testCust.Id);
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        testOrder = IR_Global_Class.getOrder(testOrder.Id);
        
    	ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
    	IR_Booking_Complete_Booking_Controller compBk = new IR_Booking_Complete_Booking_Controller();
    	compBK.custEmailConf = 'TEST@TEST.com';
    	compBk.customer = testCust;
    	compBk.thisOrder = testOrder;
    	compBk.consignmentBundles[0].consignment = testCon;
    	compBK.quickSaveCustAddress();
    	compBK.lookupCustAddress();
    	compBk.tel.plainStd = '020';
        compBk.tel.phoneNumber ='123456';
    	compBk.saveCustAddress();    
    	System.debug('Messages@@@'+ ApexPages.getMessages());   	 	
    }
    //Testing the saveCustAddress Method - This is done separately as ApexPages cannot contain messages
    TestMethod static void testSave() {
        IR_Customer__c testCust = new IR_Customer__c(
        Surname__c='TEST',
        Postcode__c='SE10HS',
        Email__c='TEST@TEST.TEST',
        Mobile_Phone__c='0123456789',
        Fax__c='0123456789',
        First_Name__c='TEST',
        Address_1__c='TEST',
        Telephone__c='+44 (0)20 123463',
        Company__c='TEST',
        Job_Title__c='TEST',
        Town_City__c = 'Test Town',
        Rate_And_Offer_Terms__c = true,
        Terms_and_Conditions__c = true
        );
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(
        Amount_Quoted__c=0,
        Customer__c=testCust.Id
        );
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(
        Order_IR__c=testOrder.Id,
        From_Postcode__c='SE10HS',
        To_Postcode__c='SE10HS',
        Type__c='Document',
        Pickup_Collection_Date__c=System.today()
        );
        insert testCon;
        
        
        IR_Package__c pac = new IR_Package__c(
        Height__c = 10.00,
        Length__c = 10.00,
        Width__c = 10.00,
        Weight_Kg__c = 10.00,
        Consignment_IR__c = testCon.Id
        );  
        insert pac;
        
        testCust = IR_Global_Class.getCustomer(testCust.Id);
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        pac = IR_Global_Class.getPackage(pac.Id);
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();
        cont.custEmailConf = 'TEST@TEST.TEST';                
        cont.customer.Vat_Registration_Number__c = '123456789';
        cont.customer.Town_City__c = 'Test Town';
        cont.customer.Rate_And_Offer_Terms__c = true;
        cont.customer.Terms_and_Conditions__c = true;
       	cont.customer.Telephone__c = '+44 (0)20 87283';
       	System.debug(cont.quickSaveCustAddress());       	
        System.debug(cont.saveCustAddress());       
        System.debug(cont.editCustAddress());
        System.debug(cont.fullCustAddress);
        System.debug(cont.lookupCustAddress());
        System.debug(cont.showCustAddrLookup);
        cont.addPackage();
        cont.removePackage();
        cont.enableComplete();
        
        
        Test.stopTest();
    }    
    //Testing the completeBooking Method - This is done separately as ApexPages cannot contain messages
    TestMethod static void testComplete() {
        IR_Customer__c testCust = new IR_Customer__c(
        Surname__c='TEST',
        Postcode__c='SE10HS',
        Email__c='TEST@TEST.TEST',
        Mobile_Phone__c='0123456789',
        Fax__c='0123456789',
        First_Name__c='TEST',
        Address_1__c='TEST',
        Telephone__c='+44 (0)20 123463',
        Company__c='TEST',
        Job_Title__c='TEST',
        Town_City__c = 'Test Town',
        Rate_And_Offer_Terms__c = true,
        Terms_and_Conditions__c = true
        );
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(
        Amount_Quoted__c=0,
        Customer__c=testCust.Id
        );
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(
        Order_IR__c=testOrder.Id,
        From_Postcode__c='SE10HS',
        To_Postcode__c='SE10HS',
        Type__c='Document',
        Pickup_Collection_Date__c=System.today().addDays(2),
        Pickup_Collection_Time_from__c = '10:00',
        Pickup_Collection_Time_to__c = '14:00'
        );
        insert testCon;
        
        
        IR_Package__c pac = new IR_Package__c(
        Height__c = 10.00,
        Length__c = 10.00,
        Width__c = 10.00,
        Weight_Kg__c = 10.00,
        Consignment_IR__c = testCon.Id
        );  
        insert pac;
        
        testCust = IR_Global_Class.getCustomer(testCust.Id);
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        pac = IR_Global_Class.getPackage(pac.Id);
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();
        
        cont.editCustDetails = false;
      cont.custEmailConf = 'TEST@TEST.TEST';                
        cont.customer.Vat_Registration_Number__c = '123456789';
        cont.customer.Town_City__c = 'Test Town';
        cont.customer.Rate_And_Offer_Terms__c = true;
        cont.customer.Terms_and_Conditions__c = true;
       	cont.customer.Telephone__c = '+44 (0)20 87283';       	     
        System.debug(cont.saveCustAddress());       
        cont.consignmentBundles[0].consignment.Saved_From_Address__c = true;
        cont.consignmentBundles[0].consignment.Saved_To_Address__c = true;
        cont.consignmentBundles[0].consignment.Pickup_Collection_Date__c = System.today().addDays(1);        
        cont.consignmentBundles[0].consignment.Pickup_Collection_Time_from__c = '10:00';
        cont.consignmentBundles[0].consignment.Pickup_Collection_Time_to__c = '14:00';
        cont.consignmentBundles[0].consignment.Description_of_Goods__c = 'test';
        System.debug(cont.completeBooking());
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
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();
        System.debug(cont.savedFrom);
        System.debug(cont.services);
        System.debug(cont.editCustAddress());
        System.debug(cont.lookupCustAddress());
        System.debug(cont.hasAddress);
        System.debug(cont.custAddressOptions);
        System.debug(cont.lookupCustAddress());
        System.debug(cont.hasAddress);
        System.debug(cont.custAddressOptions);
        System.debug(cont.selectCustAddress());
        System.debug(cont.saveCustAddress());
        System.debug(cont.fullCustAddress);
        System.debug(cont.recalculatePrices());
        System.debug(cont.reQuote());
        System.debug(cont.termsConditions());
        cont.completeBooking();
        
        cont.disableComplete();
        cont.enableComplete();
        Test.stopTest();
    }
    
    TestMethod static void testNoOrder() {
        Test.startTest();
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();
        
        System.debug(cont.services);
        
        System.debug(cont.lookupCustAddress());
        
        System.assert(!cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.lookupCustAddress());
        
        System.assert(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.saveCustAddress());
        
        cont.customer.Address_1__c = 'Addr1';
        cont.customer.Address_2__c = 'Addr2';
        cont.customer.Address_3__c = 'Addr3';
        cont.customer.Town_City__c = 'TownCity';
        cont.customer.County__c = 'County';
        cont.customer.Postcode__c = 'SE10HS';
        
        System.assert(cont.fullCustAddress == 'Addr1, Addr2, Addr3, TownCity, County, SE10HS, null');
        
        System.debug(cont.recalculatePrices());
        
        System.debug(cont.reQuote());
        
        System.assert(cont.termsConditions().getURL() == Page.IR_Booking_Terms_And_Conditions_Page.getURL());
        
        System.debug(cont.completeBooking());
        Test.stopTest();
    }
    
    TestMethod static void testNoCon() {
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0);
        insert testOrder;
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();
        System.assert(cont.thisOrder.Id == testOrder.Id);
        
        System.debug(cont.services);
        
        System.debug(cont.lookupCustAddress());
        
        System.assert(!cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.custCheck.addresses.add(new MAP<String, String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'});
        System.debug(cont.lookupCustAddress());
        
        System.assert(cont.hasAddress);
        
        System.debug(cont.custAddressOptions);
        
        cont.selectedCustAddress = '0';
        System.debug(cont.selectCustAddress());
        
        System.debug(cont.saveCustAddress());
        
        cont.customer.Address_1__c = 'Addr1';
        cont.customer.Address_2__c = 'Addr2';
        cont.customer.Address_3__c = 'Addr3';
        cont.customer.Town_City__c = 'TownCity';
        cont.customer.County__c = 'County';
        cont.customer.Postcode__c = 'SE10HS';        
        System.assert(cont.fullCustAddress == 'Addr1, Addr2, Addr3, TownCity, County, SE10HS, null');
        
        System.debug(cont.recalculatePrices());
        
        System.debug(cont.reQuote());
        
        System.assert(cont.termsConditions().getURL() == Page.IR_Booking_Terms_And_Conditions_Page.getURL());
        
        System.debug(cont.completeBooking());
        
        PageReference pr = Page.IR_Booking_Get_Quote_Page;
        pr.getParameters().put('oid', testOrder.Id);
        System.assert(cont.back().getURL() == pr.getURL());
        Test.stopTest();
    }
     TestMethod static void testSave_ex() {
        IR_Customer__c testCust = new IR_Customer__c(
        Surname__c='TEST',
        Postcode__c='SE10HS',
        Email__c='TEST@TEST.TEST',
        
        Telephone__c = '1234567686',
        First_Name__c='TEST',
        Address_1__c='TEST',
        
        Company__c='TEST',
        Job_Title__c='TEST',
        Town_City__c = 'Test Town',
        Rate_And_Offer_Terms__c = true,
        Terms_and_Conditions__c = true
        );
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(
        Amount_Quoted__c=0,
        Customer__c=testCust.Id
        );
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(
        Order_IR__c=testOrder.Id,
        From_Postcode__c='SE10HS',
        To_Postcode__c='SE10HS',
        Type__c='Document',
        Pickup_Collection_Date__c=System.today()
        );
        insert testCon;
        
        
        IR_Package__c pac = new IR_Package__c(
        Height__c = 10.00,
        Length__c = 10.00,
        Width__c = 10.00,
        Weight_Kg__c = 10.00,
        Consignment_IR__c = testCon.Id
        );  
        insert pac;
        
        testCust = IR_Global_Class.getCustomer(testCust.Id);
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        pac = IR_Global_Class.getPackage(pac.Id);
        
        ApexPages.currentPage().getParameters().put('oid', testOrder.Id);
        Test.startTest();
        IR_Booking_Complete_Booking_Controller cont = new IR_Booking_Complete_Booking_Controller();                       
        cont.customer.Vat_Registration_Number__c = '123456789';
        cont.customer.Town_City__c = 'Test Town';
        cont.customer.Telephone__c = '';
        cont.customer.Mobile_Phone__c='1234 1234 12345678890786232';
        cont.customer.Fax__c='1234 123479 123465758729388098';
        cont.customer.VAT_Registration_Number__c = 'GBhagjgshdfhg1236489172364';
        cont.mob.plainStd = '12634619237461823048102374';
        cont.mob.countryCode ='12634619237461823048102374';
        cont.mob.phoneNumber ='12634619237461823048102374';
        cont.fax.phoneNumber = '12345678 912837 81297381972380108';
        cont.fax.plainStd = '12345678 912837 81297381972380108';
        cont.fax.countryCode = '12345678 912837 81297381972380108';
        cont.customer.Rate_And_Offer_Terms__c = false;
        cont.customer.Terms_and_Conditions__c = false;       	
       	System.debug(cont.quickSaveCustAddress());       	
        System.debug(cont.saveCustAddress());       
        System.debug(cont.editCustAddress());
        System.debug(cont.fullCustAddress);
        System.debug(cont.lookupCustAddress());
        System.debug(cont.showCustAddrLookup);
        cont.addPackage();
        cont.enableComplete();
        cont.addPackage();
        cont.removePackage();
        cont.removePackage();
        cont.removePackage();
        cont.removePackage();
        
        
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF EXCEPTION SCENARIO*********************/
    /********************************************************************/
}