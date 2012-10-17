public class IR_Consignment_Bundle {
    public IR_Consignment__c consignment {get; set;}
    private Integer packageRef {get; set;}
    public Integer selectedIndex {get; set;}
    public Quote_Settings__c conSettings {get; set;}
    public Map<Integer, IR_Package_Bundle> packageBundlesMap {get; set;}
    public List<SelectOption> consignmentServices {get; set;}
    private IR_Postcode_Check toCheck {get; set;}
    private IR_Postcode_Check fromCheck {get; set;}
    public String selectedToAddress {get; set;}
    public String selectedFromAddress {get; set;}
    public Boolean allowFromInput {get; set;}
    public Boolean allowToInput {get; set;}
    public IR_Global_Class.TelephoneField toTel {get; set;}
    public IR_Global_Class.TelephoneField fromTel {get; set;}
    
    public Boolean showColAddress {get; set;}
    public Boolean showDelAddress {get; set;}
    public Boolean showShipDetails {get; set;}
    
    private final List<Integer> fromTimeOptions = new List<Integer> { 9 , 10 , 11 , 12 , 13 , 14 , 15 };
    private final List<Integer> toTimeOptions = new List<Integer> { 11 , 12 , 13 , 14 , 15 , 16 , 17 };
    public String selectedFromTime {get; set;}
    public String selectedToTime {get; set;} 
    
    public IR_Consignment_Bundle(IR_Consignment__c consignment) {
        try {
            sub_Constructor(consignment);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public IR_Consignment_Bundle() {
        try {           
            sub_Constructor(new IR_Consignment__c());
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    private void sub_Constructor(IR_Consignment__c consignment) {
        showColAddress = false;
        showDelAddress = false;
        showShipDetails = false;
                
        this.consignment = consignment;
        this.packageBundlesMap = new Map<Integer, IR_Package_Bundle>();
        this.consignmentServices = new List<SelectOption>();
        toTel = new IR_Global_Class.TelephoneField();
        fromTel = new IR_Global_Class.TelephoneField();
        
        conSettings = new Quote_Settings__c();
        toCheck = new IR_Postcode_Check();
        fromCheck = new IR_Postcode_Check();
        allowFromInput = false;
        
        if (this.consignment.To_Postcode__c == null || this.consignment.To_Postcode__c.length() == 0) {
            allowToInput = true;
        } else {
            allowToInput = false;
        }
        
        packageRef = 0;
        
        Integer i = 0;
        if (consignment.Packages__r != null && consignment.Packages__r.size() > 0) {
            for (IR_Package__c thisPackage : consignment.Packages__r) {
                IR_Package_Bundle packageBundle = new IR_Package_Bundle((thisPackage.Sequence__c == null ? packageRef : thisPackage.Sequence__c.intValue()), thisPackage);
                
                if (thisPackage.Sequence__c != null && thisPackage.Sequence__c > packageRef) {
                    packageRef = (thisPackage.Sequence__c + 1).intValue();
                } else {
                    packageRef++;
                }
                
                packageBundlesMap.put(packageBundle.index, packageBundle);
            }
        } else if (packageBundlesMap.size() == 0) {
            IR_Package_Bundle packageBundle = new IR_Package_Bundle(packageRef, new IR_Package__c());
            packageRef++;
            packageBundlesMap.put(packageBundle.index, packageBundle);
        }
        
        toTel = new IR_Global_Class.TelephoneField(consignment.To_Contact_Number__c);
        fromTel = new IR_Global_Class.TelephoneField(consignment.From_Contact_Number__c);
        
        if (consignment.To_Country__c == null || consignment.To_Country__c.length() == 0) {
            consignment.To_Country__c = 'United Kingdom';
        }
        
        if (consignment.To_Country_Code__c == null || consignment.To_Country_Code__c.length() == 0) {
            consignment.To_Country_Code__c = 'GB';
        }
        
        if (consignment.From_Country__c == null || consignment.From_Country__c.length() == 0) {
            consignment.From_Country__c = 'United Kingdom';
        }
        
        if (consignment.From_Country_Code__c == null || consignment.From_Country_Code__c.length() == 0) {
            consignment.From_Country_Code__c = 'GB';
        }
        
        selectedFromTime = consignment.Pickup_Collection_Time_from__c;
        selectedToTime = consignment.Pickup_Collection_Time_to__c;
    }
    
    public List<SelectOption> availableDates {
    	get {
	        List<SelectOption> dates = new List<SelectOption>();
	        
	        Integer numAdded = 0;
	        DateTime thisDate = (System.now().hour() >= 14 ? System.now().addDays(1) : System.now());
	        Map<Date, String> publicHolidays = IR_Global_Class.getHolidays(System.today(), System.today().addDays(30));
	        while (numAdded < 10) {
	            if (thisDate.format('EEE').toLowerCase() != 'sun' && thisDate.format('EEE').toLowerCase() != 'sat') {
	                if (!publicHolidays.containsKey(thisDate.date())) {
	                    dates.add(new SelectOption(thisDate.format('yyyyMMdd'), thisDate.format('dd MMMM yyyy (EEEE)')));
	                }
	                
	                numAdded++;
	            }
	            
	            thisDate = thisDate.addDays(1);
	        }
	        
	        return dates;
    	}
    }
    
    public List<SelectOption> pickFromTimes {
        get {
            List<SelectOption> availableTimeOptions = new List<SelectOption>();
            availableTimeOptions.add(new SelectOption('', '-- Please Select --'));
            
            Integer startTime;
            if (consignment.Pickup_Collection_Date__c == System.today()) {
                startTime = Integer.valueOf(System.now().format('HH', 'Europe/London'));
            } else {
                startTime = 0;
            }
            
            for (String availableTime : getAvailableTimes(true, startTime)) {            	
                availableTimeOptions.add(new SelectOption(availableTime, availableTime));
            }
            
            return availableTimeOptions;
        }
    }
    
    public PageReference updateTimeFrom() {
        consignment.Pickup_Collection_Time_from__c = selectedFromTime;
        update consignment;
        
        selectedToTime = null;
        
        return null;
    }
    
    public boolean disableOpenUntil {
        get {
            return (consignment.Pickup_Collection_Time_from__c == null);
        }
    }
    
    public List<SelectOption> openUntilTimes {
        get {
            List<SelectOption> availableTimeOptions = new List<SelectOption>();
            availableTimeOptions.add(new SelectOption('', '-- Please Select --'));
            
            Integer startTime;
            if (consignment.Pickup_Collection_Time_from__c == null) {
                startTime = 0;
            } else {
                startTime = Integer.valueOf(consignment.Pickup_Collection_Time_from__c.split(':')[0]) + 1;
            }
            
            for (String availableTime : getAvailableTimes(false, startTime)) {             	           	
                availableTimeOptions.add(new SelectOption(availableTime, availableTime));
            }
            
            return availableTimeOptions;
        }
    }
    
    private List<String> getAvailableTimes(Boolean fromTime, Integer startTime) {
        List<String> availableTimes = new List<String>();
        
        List<Integer> timeOptions;
        if (fromTime) {
            timeOptions = fromTimeOptions;
        } else {
            timeOptions = toTimeOptions;
        }
        
        for (Integer timeOption : timeOptions) {
            if (timeOption > startTime) {
            	String val = String.valueOf(timeOption);
            	String options = val.length() == 1 ? '0'+ val: val;            	
                availableTimes.add(options + ':00');
            }
        }
        
        return availableTimes;
    }
    
    public String Total_Weight_Lbl {
        get{            
            if(consignment.National_International__c == 'International'){
                schema.Describefieldresult Total_Actual_Weight = IR_Consignment__c.Total_Actual_Weight__c.getDescribe();                
                return Total_Actual_Weight.getLabel();
            }else{
                schema.Describefieldresult Total_Chargeable_Weight = IR_Consignment__c.Total_Chargeable_Weight__c.getDescribe();
                return Total_Chargeable_Weight.getLabel();
            }
        }
    }
    
    public Decimal Total_Weight_Val {
        get{
            if(consignment.National_International__c == 'International'){
                
                return consignment.Total_Actual_Weight__c;
            }else{
                return consignment.Total_Chargeable_Weight__c;
            }
        }
    }
    
    public Boolean showToAddrLookup {
        get {
            try {
                return IR_Global_Class.pcLookupSupported(consignment.To_Country_Code__c);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public Boolean hasToPostcode {
        get {
            try {
                return (consignment.To_Postcode__c == null || consignment.To_Postcode__c.length() == 0 ? false : true);
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
                
                return false;
            }
        }
    }
    
    public Boolean showFromAddrLookup {
        get {
            try {
                return IR_Global_Class.pcLookupSupported(consignment.From_Country_Code__c);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public List<SelectOption> fromCountries {
        get {
            try {
                List<SelectOption> options = new List<SelectOption>();
                
                for (Schema.PicklistEntry entry : IR_Customer__c.Country__c.getDescribe().getPicklistValues()) {
                    options.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
                
                return options;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return new List<SelectOption>();
            }
        }
    }
    
    public List<SelectOption> toCountries {
        get {
            try {
                List<SelectOption> options = new List<SelectOption>();
                
                for (Schema.PicklistEntry entry : IR_Customer__c.Country__c.getDescribe().getPicklistValues()) {
                    options.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
                
                return options;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return new List<SelectOption>();
            }
        }
    }
    
    public List<IR_Package_Bundle> orderedPackageBundles {
        get {
            try {
                List<Integer> packageRefs = new List<Integer>();
                Map<Integer, Integer> packageRefIndexMap = new Map<Integer, Integer>();
                
                for (Integer index : packageBundlesMap.keySet()) {
                    Integer packageRef = packageBundlesMap.get(index).packageRef;
                    
                    packageRefs.add(packageRef);
                    packageRefIndexMap.put(packageRef, index);
                }
                
                packageRefs.sort();
                
                List<IR_Package_Bundle> packageBundles = new List<IR_Package_Bundle>();
                for (Integer packageRef : packageRefs) {
                    packageBundles.add(packageBundlesMap.get(packageRefIndexMap.get(packageRef)));
                }
                
                return packageBundles;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return new List<IR_Package_Bundle>();
            }
        }
    }
    
    public PageReference addPackage() {
        try {
            IR_Package_Bundle packageBundle = new IR_Package_Bundle(packageRef, new IR_Package__c());
            packageRef++;
            packageBundlesMap.put(packageBundle.index, packageBundle);
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference removePackage() {
        try {
        	if(packageBundlesMap.size() > 1){
            packageBundlesMap.remove(selectedIndex);
        	}else{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You need at least one package to process your booking'));
        	}
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference lookupToAddress() {
        try {
            consignment.To_Postcode__c = IR_Global_Class.formatPostcode(consignment.To_Postcode__c);
            
            Map<String, String> itemMap = new Map<String, String>();
            itemMap.put('THOR', consignment.To_Address_1__c);
            itemMap.put('TOWN', consignment.To_Town_City__c);
            itemMap.put('PCOD', consignment.To_Postcode__c);
            itemMap.put('ISOC', IR_Global_Class.getThreeDigitCode(consignment.To_Country_Code__c));
            
            toCheck.getAddresses(itemMap);
            
            if (toCheck.getAddressList().size() > 1) {
                allowToInput = false;
            } else {
                allowToInput = true;
            }
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public Boolean hasToAddress {
        get {
            try {
                return (toCheck == null || toCheck.getAddressList() == null || toCheck.getAddressList().size() == 1 ? false : true);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public List<SelectOption> toAddressOptions {
        get {
            try {
                return toCheck.getAddressList();
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return new List<SelectOption>();
            }
        }
    }
    
    public PageReference selectToAddress() {
        try {
            consignment.To_Address_1__c = toCheck.getAddressLine1(selectedToAddress);
            consignment.To_Address_2__c = toCheck.getAddressLine2(selectedToAddress);
            consignment.To_Address_3__c = toCheck.getAddressLine3(selectedToAddress);
            consignment.To_Town_City__c = toCheck.getTown(selectedToAddress);
            consignment.To_County__c = toCheck.getCounty(selectedToAddress);
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference saveToAddress() {
        try {
            Boolean validAddress = true;
            
            if (consignment.To_Address_1__c == null || consignment.To_Address_1__c.length() == 0) {
                validAddress = false;
                String errorMessage = 'Please enter a Ship To Address Line 1';
                
                consignment.To_Address_1__c.addError(errorMessage);                
            }
            if (consignment.To_Town_City__c == null || consignment.To_Town_City__c.length() == 0) {
                validAddress = false;
                String errorMessage = 'Please enter a Town or City';
                
                consignment.To_Town_City__c.addError(errorMessage);                
            }
            
            if (consignment.To_Company__c == null || consignment.To_Company__c.length() == 0) {
                validAddress = false;
                String errorMessage = 'Please enter a To Company Name';
                
                consignment.To_Company__c.addError(errorMessage);                
            }
            
            if (toTel.format == null || (toTel.countryCode == null || toTel.countryCode.length() == 0) || (toTel.std == null || toTel.std.length() == 0) || (toTel.phoneNumber == null || toTel.phoneNumber.length() == 0)) {
                validAddress = false;
                String errorMessage = 'Please enter a Ship To Contact Number';
                
                consignment.To_Contact_Number__c.addError(errorMessage);                
            }
            
            if (validAddress) {
                consignment.Saved_To_Address__c = true;
                consignment.To_Contact_Number__c = toTel.format;
               
                if (consignment.Saved_From_Address__c) {
                    consignment.Show_Ship_Details__c = true;
                }else{
                    consignment.Show_Ship_Details__c = false;   
                }
                update consignment;               
            } 
        } catch (Exception ex) {
            consignment.Saved_To_Address__c = false;
            
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference editToAddress() {
        try {
            consignment.Saved_To_Address__c = false;
            update consignment;
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public String fullToAddress {
        get {
            try {
                return consignment.To_Address_1__c + (consignment.To_Address_2__c == null ? '' : ', ' + consignment.To_Address_2__c) + (consignment.To_Address_3__c == null ? '' : ', ' + consignment.To_Address_3__c) + (consignment.To_Town_City__c == null ? '' : ', ' + consignment.To_Town_City__c) + (consignment.To_County__c == null ? '' : ', ' + consignment.To_County__c) + (consignment.To_Postcode__c == null ? '' : ', ' + consignment.To_Postcode__c) + ', ' + consignment.To_Country__c;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return null;
            }
        }
    }
    
    public PageReference lookupFromAddress() {
        try {
            consignment.From_Postcode__c = IR_Global_Class.formatPostcode(consignment.From_Postcode__c);
            
            Map<String, String> itemMap = new Map<String, String>();
            itemMap.put('THOR', consignment.From_Address_1__c);
            itemMap.put('TOWN', consignment.From_Town_City__c);
            itemMap.put('PCOD', consignment.From_Postcode__c);
            itemMap.put('ISOC', IR_Global_Class.getThreeDigitCode(consignment.From_Country_Code__c));
            
            fromCheck.getAddresses(itemMap);
        
            if (fromCheck.getAddressList().size() > 1) {
                allowFromInput = false;
            } else {
                allowFromInput = true;
            }
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public Boolean hasFromAddress {
        get {
            try {
                return (fromCheck == null || fromCheck.getAddressList() == null || fromCheck.getAddressList().size() == 1 ? false : true);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public List<SelectOption> fromAddressOptions {
        get {
            try {
                return fromCheck.getAddressList();
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return new List<SelectOption>();
            }
        }
    }
    
    public PageReference selectFromAddress() {
        try {
            consignment.From_Address_1__c = fromCheck.getAddressLine1(selectedfromAddress);
            consignment.From_Address_2__c = fromCheck.getAddressLine2(selectedfromAddress);
            consignment.From_Address_3__c = fromCheck.getAddressLine3(selectedfromAddress);
            consignment.From_Town_City__c = fromCheck.getTown(selectedfromAddress);
            consignment.From_County__c = fromCheck.getCounty(selectedfromAddress);
            
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public PageReference saveFromAddress() {
        try {
            Boolean validAddress = true;
            
            if (consignment.From_Address_1__c == null || consignment.From_Address_1__c.length() == 0) {
                validAddress = false;
                String errorMessage = 'Please enter a Ship From Address Line 1';
                
                consignment.From_Address_1__c.addError(errorMessage);                
            }
            
            if (consignment.From_Town_City__c == null || consignment.From_Town_City__c.length() == 0) {
                validAddress = false;
                String errorMessage = 'Please enter a Town or City';
                
                consignment.To_Town_City__c.addError(errorMessage);                
            }
            
            if (fromTel.format == null || (fromTel.countryCode == null || fromTel.countryCode.length() == 0) || (fromTel.std == null || fromTel.std.length() == 0) || (fromTel.phoneNumber == null || fromTel.phoneNumber.length() == 0)) {
                validAddress = false;
                String errorMessage = 'Please enter a Ship From Contact Number';
                
                consignment.From_Contact_Number__c.addError(errorMessage);                
            }
            
            if (validAddress) {
                consignment.Saved_From_Address__c = true;
                consignment.From_Contact_Number__c = fromTel.format;
                consignment.Show_Del_Address__c = true;
                
                if (consignment.Saved_To_Address__c) {
                    consignment.Show_Ship_Details__c = true;                    
                } else {
                    consignment.Show_Ship_Details__c = false;   
                }
                
                update consignment;
            }
        } catch (Exception ex) {
            consignment.Saved_From_Address__c = false;
            
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public PageReference editFromAddress() {
        try {
            consignment.Saved_From_Address__c = false;
            update consignment;
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        return null;
    }
    
    public String fullFromAddress {
        get {
            try {
                return consignment.From_Address_1__c + (consignment.From_Address_2__c == null ? '' : ', ' + consignment.From_Address_2__c) + (consignment.From_Address_3__c == null ? '' : ', ' + consignment.From_Address_3__c) + (consignment.From_Town_City__c == null ? '' : ', ' + consignment.From_Town_City__c) + (consignment.From_County__c == null ? '' : ', ' + consignment.From_County__c) + (consignment.From_Postcode__c == null ? '' : ', ' + consignment.From_Postcode__c) + ', ' + consignment.From_Country__c;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return null;
            }
        }
    }
    
    public Integer quantity {
        get {
            try {
                return packageBundlesMap.size();
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return null;
            }
        }
    }
    
    public String selectedDate {
        get {
            try {
                return (consignment.Pickup_Collection_Date__c == null ? '' : DateTime.newInstance(consignment.Pickup_Collection_Date__c, System.now().time()).format('yyyyMMdd'));
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return null;
            }
        }
        
        set {
            try {
                consignment.Pickup_Collection_Date__c = Date.newInstance(Integer.valueOf(value.substring(0,4)), Integer.valueOf(value.substring(4,6)), Integer.valueOf(value.substring(6,8)));
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
    }
    
    public Boolean to_requiresPostcode {
        get {
            try {
            	Boolean postcodeRequired = IR_Global_Class.requiresPostcode(IR_Global_Class.getCountryCode(consignment.To_Country__c));
            	
            	if (!postcodeRequired) {
        			consignment.To_Postcode__c = '';
            	}
            	
            	return postcodeRequired;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public Boolean showETLCheckbox {
        get {
            try {
                if (nationalConsignment) {
                	//if con.acc  || 
                	//update cons
                	//recalculate                
                	return (consignment.Account_ETL_Setting__c != null && consignment.Account_ETL_Setting__c != 'None');
                } else {
                    return true;
                }
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public Boolean nationalConsignment {
        get {
            try {
                return (consignment.National_International__c == 'National' ? true : false);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public Boolean showEstVal {
        get {
            try {
                return (!nationalConsignment && consignment.Transit_Liability__c);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public Boolean renderCommercialInv {
        get {
            try {
                Map<String,Boolean> CmInvNtRq = new Map<String, Boolean>{'Austria'=>TRUE,'Germany'=>TRUE,'Poland'=>TRUE,'Belgium'=>TRUE,'Greece'=>TRUE,'Portugal'=>TRUE,'Bulgaria'=>TRUE,'Hungary'=>TRUE,'Romania'=>TRUE,'Cyprus'=>TRUE,'Ireland'=>TRUE,'Nertherlands'=>TRUE,'Czech Republic'=>TRUE,''=>TRUE,'Italy'=>TRUE,'Slovakia'=>TRUE,'Denmark'=>TRUE,'Latvia'=>TRUE,'Slovenia'=>TRUE,'Estonia'=>TRUE,'Lithuania'=>TRUE,'Spain'=>TRUE,'Finland'=>TRUE,'Luxembourg'=>TRUE,'Sweden'=>TRUE,'France'=>TRUE,'Malta'=>TRUE,'United Kingdom'=>TRUE};
                return !CmInvNtRq.containsKey(consignment.To_Country__c);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public Decimal totalActualWeight {
        get {
            try {
                Decimal total = 0;
                
                for (IR_Package_Bundle packageBundle : packageBundlesMap.values()) {
                    total += (packageBundle.thePackage.Weight_kg__c == null ? 0 : packageBundle.thePackage.Weight_kg__c);
                }
                
                return total;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return null;
            }
        }
    }
    
    /*************************Test Methods***************************/
    
    TestMethod static void test_all(){
    	
    	IR_Customer__c testCust = new IR_Customer__c(
    	Company__c = 'TEST', 
    	Title__c='MR', 
    	First_Name__c ='TESTNAME', 
    	Surname__c = 'TEST', 
    	Job_Title__c='TEST', 
    	Telephone__c='02012345',
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
        testOrder = IR_Global_Class.getOrder(testOrder.Id);
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        pac = IR_Global_Class.getPackage(pac.Id);
        
                
        IR_Consignment_Bundle con = new IR_Consignment_Bundle(testCon);
        System.debug(con.pickFromTimes);
        System.debug(con.disableOpenUntil);
        System.debug(con.openUntilTimes);                
        System.debug(con.fromAddressOptions);
        System.debug(con.fromCountries);
        System.debug(con.showToAddrLookup);
        System.debug(con.showShipDetails);
        System.debug(con.showFromAddrLookup);
        System.debug(con.showETLCheckbox);
        System.debug(con.showEstVal);
        System.debug(con.showDelAddress);
        System.debug(con.showColAddress);
        System.debug(con.totalActualWeight);
        System.debug(con.Total_Weight_Val);
        System.debug(con.Total_Weight_Lbl);
        System.debug(con.toAddressOptions);
        System.debug(con.toCountries);
        System.debug(con.orderedPackageBundles);
        System.debug(con.toAddressOptions);
        con.selectedToAddress = '0';
        con.selectToAddress();
        System.debug(con.fromAddressOptions);        
        con.selectedFromAddress = '0';
        con.selectFromAddress();
        
        con.addPackage();
        con.removePackage();
        con.lookupToAddress();
        con.lookupFromAddress();
        con.editToAddress();
        
        con.consignment.To_Address_1__c = 'test';
        con.consignment.To_Address_2__c = 'tets';
        con.consignment.To_Town_City__c = 'test';
        con.consignment.To_Company__c = 'testcompma';
        con.toTel.phoneNumber = '123456';
        con.toTel.std='+44';
        con.saveToAddress();
        con.editFromAddress();
        
        con.consignment.From_Address_1__c ='test';
        con.consignment.From_Company__c = 'test';
        con.consignment.From_Town_City__c = 'test';
        con.fromTel.phoneNumber = '123456';
        con.fromTel.std = '+44';
        con.saveFromAddress();
        System.debug(con.hasToAddress);                       
		System.debug(con.hasFromAddress);
		System.debug(con.fullFromAddress);
		System.debug(con.hasToPostcode);
		System.debug(con.fullToAddress);
		System.debug(con.quantity);		
		System.debug(con.selectedDate);
		System.debug(con.to_requiresPostcode);
		System.debug(con.renderCommercialInv);		
    }
    /******************Test Method fro Exception*******************/
    TestMethod static void test_all_Ex(){
    	
    	IR_Customer__c testCust = new IR_Customer__c(
    	Company__c = 'TEST', 
    	Title__c='MR', 
    	First_Name__c ='TESTNAME', 
    	Surname__c = 'TEST', 
    	Job_Title__c='TEST', 
    	Telephone__c='02012345',
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
                
        
        testCust = IR_Global_Class.getCustomer(testCust.Id);        
        testOrder = IR_Global_Class.getOrder(testOrder.Id);               
        
                
        IR_Consignment_Bundle con = new IR_Consignment_Bundle();
        System.debug(con.pickFromTimes);
        System.debug(con.disableOpenUntil);
        System.debug(con.openUntilTimes);                
        System.debug(con.fromAddressOptions);
        System.debug(con.fromCountries);
        System.debug(con.showToAddrLookup);
        System.debug(con.showShipDetails);
        System.debug(con.showFromAddrLookup);
        System.debug(con.showETLCheckbox);
        System.debug(con.showEstVal);
        System.debug(con.showDelAddress);
        System.debug(con.showColAddress);
        System.debug(con.totalActualWeight);
        System.debug(con.Total_Weight_Val);
        System.debug(con.Total_Weight_Lbl);
        System.debug(con.toAddressOptions);
        System.debug(con.toCountries);
        System.debug(con.orderedPackageBundles);
        con.selectToAddress();
        con.selectFromAddress();
        
        con.addPackage();
        con.removePackage();
        con.lookupToAddress();
        con.lookupFromAddress();
        con.editToAddress();        
        con.saveToAddress();
        con.editFromAddress();
        con.saveFromAddress();
        System.debug(con.hasToAddress);                       
		System.debug(con.hasFromAddress);
		System.debug(con.fullFromAddress);
		System.debug(con.hasToPostcode);
		System.debug(con.fullToAddress);
		System.debug(con.quantity);		
		System.debug(con.selectedDate);
		System.debug(con.to_requiresPostcode);
		System.debug(con.renderCommercialInv);		
    }
}