public class IR_Global_Class {
    
    public static IR_Customer__c getCustomer(Id customerId) {
        try {
            return [SELECT Customer_Withdrawn__c ,Confirmed_Off_Stop__c, eInvoicing_Account_Link_Task__c, Private_Individual_Check_OK__c,Comments__c, Dom_Rates_Loaded__c, Dom_Contacts_Loaded__c, Int_Rates_Loaded__c, Int_Contacts_Loaded__c,Dom_EInvoicing_Already_Registered__c, Int_EInvoicing_Already_Registered__c,Id, Name, International_Account_On_Stop__c, Domestic_Account_On_Stop__c, Potential_Private_Individual__c , Security_Check_Accepted__c, Security_Check_Fail__c, Booking_No_Longer_Required__c, MyTNT_Already_Registered__c, Booking_Complete__c, Account_Status_Int__c , Account_Status_Dom__c , Customer_To_Resubmit__c , Total_Rejection_Of_Request__c, Send_to_CE_Queue__c, Register_Only__c, Total_Cost__c, Approved__c, Has_Consignments__c, Order_Placed__c, Has_Multiple_Orders__c, Country__c, Registered_MyTNT__c, Extended_Transit_Liability_Setting__c, Rate_And_Offer_Terms__c, Terms_and_Conditions__c, Initial__c, Fax__c, Mobile_Phone__c, Job_Title__c, Title__c, Saved_Customer__c, Company__c, Complete__c, Country_Code__c, Telephone__c, OwnerId, International_Account_Number__c, Domestic_Account_Number__c, Town_City__c, Surname__c, Postcode__c, First_Name__c, County__c, Address_3__c, Address_2__c, Address_1__c, Email__c, Vat_Registration_Number__c, Sender_Reference__c, Registration_Status__c, Customer_Password__c, (SELECT Id, Name, Order_Status__c, Number_of_Consignments__c, Amount_Quoted__c, Customer__c, Consignment_Transit_Liability_Cost__c, Total_Cost__c, Customer__r.Has_Multiple_Orders__c FROM Orders__r),(SELECT To_Country_Code__c FROM Consignments__r) FROM IR_Customer__c WHERE Id = :customerId LIMIT 1];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static IR_Customer__c getCustomer(LIST<Id> customerIds) {
        try {
            return [SELECT Customer_Withdrawn__c ,Confirmed_Off_Stop__c, eInvoicing_Account_Link_Task__c, Private_Individual_Check_OK__c,Comments__c, Dom_Rates_Loaded__c, Dom_Contacts_Loaded__c, Int_Rates_Loaded__c, Int_Contacts_Loaded__c,Dom_EInvoicing_Already_Registered__c, Int_EInvoicing_Already_Registered__c,Id, Name, International_Account_On_Stop__c, Domestic_Account_On_Stop__c, Potential_Private_Individual__c , Security_Check_Accepted__c, Security_Check_Fail__c, Booking_No_Longer_Required__c, MyTNT_Already_Registered__c, Booking_Complete__c, Account_Status_Int__c , Account_Status_Dom__c , Customer_To_Resubmit__c , Total_Rejection_Of_Request__c, Send_to_CE_Queue__c, Register_Only__c, Total_Cost__c, Approved__c, Order_Placed__c, Has_Multiple_Orders__c, Has_Consignments__c, Country__c, Registered_MyTNT__c, Extended_Transit_Liability_Setting__c, Rate_And_Offer_Terms__c, Terms_and_Conditions__c, Initial__c, Fax__c, Mobile_Phone__c, Job_Title__c, Title__c, Saved_Customer__c, Company__c, Complete__c, Country_Code__c, Telephone__c, OwnerId, International_Account_Number__c, Domestic_Account_Number__c, Town_City__c, Surname__c, Postcode__c, First_Name__c, County__c, Address_3__c, Address_2__c, Address_1__c, Email__c, Vat_Registration_Number__c, Sender_Reference__c,Registration_Status__c, Customer_Password__c, (SELECT Id, Name, Order_Status__c, Number_of_Consignments__c, Amount_Quoted__c, Customer__c, Consignment_Transit_Liability_Cost__c, Total_Cost__c, Customer__r.Has_Multiple_Orders__c FROM Orders__r),(SELECT To_Country_Code__c FROM Consignments__r) FROM IR_Customer__c WHERE Id = :customerIds LIMIT 1000];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static IR_Order__c getOrder(Id orderId) {
        try {//, Total_Cube_Weight__c
            return [SELECT Id, Name, Customer__r.Has_Multiple_Orders__c, Total_Cost__c, SystemModstamp, OwnerId, Order_Status__c, Number_of_Consignments__c, LastModifiedDate, LastModifiedById, IsDeleted, Customer__c, CreatedDate, CreatedById, Consignment_Transit_Liability_Cost__c, Booked_Consignments__c, Amount_Quoted__c, All_Consignments_Booked__c, (SELECT Id, Name, From_Country__c, To_Country__c, Order_IR__c, Number_of_Packages__c, Transit_Liability__c, To_Address_1__c, To_Address_2__c, To_Address_3__c, To_County__c, To_Town_City__c, To_Postcode__c, From_Postcode__c, From_Address_1__c, From_Address_2__c, From_Address_3__c, From_County__c, From_Town_City__c, Delivered_on__c, Pickup_Collection_Date__c, Instructions__c, Service__c, Pickup_Collection_Time_from__c, Pickup_Collection_Time_to__c, Total_Actual_Weight__c, Total_Volume__c, Service_Code__c, Type_Identifier__c, Type__c, To_Company__c, To_Contact_Name__c, To_Contact_Number__c, From_Company__c, From_Contact_Name__c, From_Contact_Number__c, Option_Code__c, Description_of_Goods__c, Estimated_Value__c, National_International__c, Saved_From_Address__c, Saved_To_Address__c, Account_Number__c, Commercial_Invoice__c, From_EU__c, To_EU__c, Total_Chargeable_Weight__c, Booking_Complete__c, Booking_Result__c, To_Country_Code__c, From_Country_Code__c, Account_ETL_Setting__c, Show_Del_Address__c, Show_Col_Address__c, Show_Ship_Details__c FROM Consignments__r) FROM IR_Order__c WHERE Id = :orderId LIMIT 1];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static LIST<IR_Order__c> getOrders(LIST<Id> orderIds) {
        try {//Total_Cube_Weight__c,
            return [SELECT Id, Name, Customer__r.Has_Multiple_Orders__c, Total_Cost__c, SystemModstamp, OwnerId, Order_Status__c, Number_of_Consignments__c, LastModifiedDate, LastModifiedById, IsDeleted, Customer__c, CreatedDate, CreatedById, Consignment_Transit_Liability_Cost__c, Booked_Consignments__c, Amount_Quoted__c, All_Consignments_Booked__c, (SELECT Id, Name, From_Country__c, To_Country__c, Order_IR__c, Number_of_Packages__c, Transit_Liability__c, To_Address_1__c, To_Address_2__c, To_Address_3__c, To_County__c, To_Town_City__c, To_Postcode__c, From_Postcode__c, From_Address_1__c, From_Address_2__c, From_Address_3__c, From_County__c, From_Town_City__c, Delivered_on__c, Pickup_Collection_Date__c, Instructions__c, Service__c, Pickup_Collection_Time_from__c, Pickup_Collection_Time_to__c, Total_Actual_Weight__c, Total_Volume__c, Service_Code__c, Type_Identifier__c, Type__c, To_Company__c, To_Contact_Name__c, To_Contact_Number__c, From_Company__c, From_Contact_Name__c, From_Contact_Number__c, Option_Code__c, Description_of_Goods__c, Estimated_Value__c, National_International__c, Saved_From_Address__c, Saved_To_Address__c, Account_Number__c, Commercial_Invoice__c, From_EU__c, To_EU__c, Total_Chargeable_Weight__c, Booking_Complete__c, Booking_Result__c, To_Country_Code__c, From_Country_Code__c, Account_ETL_Setting__c, Show_Del_Address__c, Show_Col_Address__c, Show_Ship_Details__c FROM Consignments__r) FROM IR_Order__c WHERE Id IN :orderIds LIMIT 1000];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static IR_Consignment__c getConsignment(Id consignmentId) {
        try {//Total_Cube_Weight__c,
            return [SELECT Id,Customer_Email_Address__c, Account_ETL_Setting__c, To_Country_Code__c, From_Country_Code__c, Booking_Result__c, Booking_Complete__c, Total_Chargeable_Weight__c, Type_Identifier__c, From_EU__c, To_EU__c, Account_Number__c, Commercial_Invoice__c, Saved_From_Address__c, Saved_To_Address__c, National_International__c, Estimated_Value__c, To_Company__c, Description_of_Goods__c, To_Contact_Name__c, To_Contact_Number__c, From_Company__c, From_Contact_Name__c, From_Contact_Number__c, Type__c, Option_Code__c, Service_Code__c, Total_Actual_Weight__c, Total_Volume__c, Number_Of_Packages__c, From_Country__c, To_Country__c, Transit_Liability__c, To_Address_1__c, To_Address_2__c, To_Address_3__c, To_County__c, To_Town_City__c, To_Postcode__c, From_Postcode__c, From_Address_1__c, From_Address_2__c, From_Address_3__c, From_County__c, From_Town_City__c, Order_IR__c, Pickup_Collection_Date__c, Instructions__c, Service__c, Pickup_Collection_Time_from__c, Pickup_Collection_Time_to__c, Show_Del_Address__c, Show_Col_Address__c, Show_Ship_Details__c, (SELECT Id, Consignment_IR__c, Length__c, Height__c, Width__c, weight_kg__c, Sequence__c FROM Packages__r ORDER BY Sequence__c ASC) FROM IR_Consignment__c WHERE Id = :consignmentId LIMIT 1];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static LIST<IR_Consignment__c> getConsignments(LIST<Id> consignmentIds) {
        try {//, Total_Cube_Weight__c
            return [SELECT Id, Customer_Email_Address__c,Account_ETL_Setting__c, To_Country_Code__c, From_Country_Code__c, Booking_Result__c, Booking_Complete__c, Total_Chargeable_Weight__c, Type_Identifier__c, From_EU__c, To_EU__c, Account_Number__c, Commercial_Invoice__c, Saved_From_Address__c, Saved_To_Address__c, National_International__c, Estimated_Value__c, To_Company__c, Description_of_Goods__c, To_Contact_Name__c, To_Contact_Number__c, From_Company__c, From_Contact_Name__c, From_Contact_Number__c, Type__c, Option_Code__c, Service_Code__c, Total_Actual_Weight__c, Total_Volume__c, Number_Of_Packages__c, From_Country__c, To_Country__c, Transit_Liability__c, To_Address_1__c, To_Address_2__c, To_Address_3__c, To_County__c, To_Town_City__c, To_Postcode__c, From_Postcode__c, From_Address_1__c, From_Address_2__c, From_Address_3__c, From_County__c, From_Town_City__c, Order_IR__c, Pickup_Collection_Date__c, Instructions__c, Service__c, Pickup_Collection_Time_from__c, Pickup_Collection_Time_to__c, Show_Del_Address__c, Show_Col_Address__c, Show_Ship_Details__c, (SELECT Id, Consignment_IR__c, Length__c, Height__c, Width__c, weight_kg__c, Sequence__c FROM Packages__r ORDER BY Sequence__c ASC) FROM IR_Consignment__c WHERE Id IN:consignmentIds LIMIT 1000];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static LIST<IR_Consignment__c> getConsignmentsByOrder(Id orderId) {
        try {//Total_Cube_Weight__c,
            return [SELECT Id, Customer_Email_Address__c, Account_ETL_Setting__c, To_Country_Code__c, From_Country_Code__c, Booking_Result__c, Booking_Complete__c, Total_Chargeable_Weight__c, Type_Identifier__c, From_EU__c, To_EU__c, Account_Number__c, Commercial_Invoice__c, Saved_From_Address__c, Saved_To_Address__c, National_International__c, Estimated_Value__c, To_Company__c, Description_of_Goods__c, To_Contact_Name__c, To_Contact_Number__c, From_Company__c, From_Contact_Name__c, From_Contact_Number__c, Type__c, Option_Code__c, Service_Code__c, Total_Actual_Weight__c, Total_Volume__c, Number_Of_Packages__c, From_Country__c, To_Country__c, Transit_Liability__c, To_Address_1__c, To_Address_2__c, To_Address_3__c, To_County__c, To_Town_City__c, To_Postcode__c, From_Postcode__c, From_Address_1__c, From_Address_2__c, From_Address_3__c, From_County__c, From_Town_City__c, Order_IR__c, Pickup_Collection_Date__c, Instructions__c, Service__c, Pickup_Collection_Time_from__c, Pickup_Collection_Time_to__c,Show_Del_Address__c, Show_Col_Address__c, Show_Ship_Details__c, (SELECT Id, Consignment_IR__c, Length__c, Height__c, Width__c, weight_kg__c, Sequence__c FROM Packages__r ORDER BY Sequence__c ASC) FROM IR_Consignment__c WHERE Order_IR__c = :orderId LIMIT 1000];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static LIST<IR_Consignment__c> getConsignmentsByOrder(LIST<Id> orderIds) {
        try {//Total_Cube_Weight__c,
            return [SELECT Id, Customer_Email_Address__c, Account_ETL_Setting__c, To_Country_Code__c, From_Country_Code__c, Booking_Result__c, Booking_Complete__c, Total_Chargeable_Weight__c, Type_Identifier__c, From_EU__c, To_EU__c, Account_Number__c, Commercial_Invoice__c, Saved_From_Address__c, Saved_To_Address__c, National_International__c, Estimated_Value__c, To_Company__c, Description_of_Goods__c, To_Contact_Name__c, To_Contact_Number__c, From_Company__c, From_Contact_Name__c, From_Contact_Number__c, Type__c, Option_Code__c, Service_Code__c, Total_Actual_Weight__c, Total_Volume__c, Number_Of_Packages__c, From_Country__c, To_Country__c, Transit_Liability__c, To_Address_1__c, To_Address_2__c, To_Address_3__c, To_County__c, To_Town_City__c, To_Postcode__c, From_Postcode__c, From_Address_1__c, From_Address_2__c, From_Address_3__c, From_County__c, From_Town_City__c, Order_IR__c, Pickup_Collection_Date__c, Instructions__c, Service__c, Pickup_Collection_Time_from__c, Pickup_Collection_Time_to__c, Show_Del_Address__c, Show_Col_Address__c, Show_Ship_Details__c, (SELECT Id, Consignment_IR__c, Length__c, Height__c, Width__c, weight_kg__c, Sequence__c FROM Packages__r ORDER BY Sequence__c ASC) FROM IR_Consignment__c WHERE Order_IR__c IN :orderIds LIMIT 1000];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static IR_Package__c getPackage(Id packageId) {
        try {
            return [SELECT Id, Consignment_IR__c, Length__c, Height__c, Width__c, weight_kg__c, Sequence__c FROM IR_Package__c WHERE Id = :packageId ORDER BY Sequence__c ASC LIMIT 1];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static LIST<IR_Package__c> getPackages(LIST<Id> packageIds) {
        try {
            return [SELECT Id, Consignment_IR__c, Length__c, Height__c, Width__c, weight_kg__c, Sequence__c FROM IR_Package__c WHERE Id = :packageIds ORDER BY Sequence__c ASC LIMIT 1000];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static LIST<IR_Package__c> getPackagesByConsignment(Id consignmentId) {
        try {
            return [SELECT Id, Consignment_IR__c, Length__c, Height__c, Width__c, weight_kg__c, Sequence__c FROM IR_Package__c WHERE Consignment_IR__c = :consignmentId ORDER BY Sequence__c ASC LIMIT 1000];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static LIST<IR_Consignment_Bundle> getConsignmentBundles(LIST<IR_Consignment__c> consignments) {
        try {
            LIST<IR_Consignment_Bundle> consignmentBundles = new LIST<IR_Consignment_Bundle>();
            
            for (IR_Consignment__c consignment : consignments) {
                IR_Consignment_Bundle consignmentBundle = new IR_Consignment_Bundle(consignment);
                
                System.debug('consignmentBundle=' + consignmentBundle);
                consignmentBundles.add(consignmentBundle);
            }
            
            return consignmentBundles;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static String encodeXML(String value){
        value = value.replace('&', '&amp;');
        value = value.replace('<', '&lt;');
        value = value.replace('>', '&gt;');
        value = value.replace('"', '&quot;');
        value = value.replace('\'', '&apos;');
    
        return EncodingUtil.urlEncode(value, 'UTF-8');
    }
    
    public static String validatePostcode(String postcode) {
        try {
            if (postcode == null) {
                return '';
            } else {
                return postcode.toUpperCase().trim().replaceAll(' ', '');
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static Boolean inEU(String countryCode) {
        try {
            MAP<String, Boolean> euCountryCodes = new MAP<String, Boolean> { 'GB'=>TRUE, 'BE'=>TRUE, 'BG'=>TRUE, 'CZ'=>TRUE, 'DK'=>TRUE, 'DE'=>TRUE, 'EE'=>TRUE, 'IE'=>TRUE, 'EL'=>TRUE, 'ES'=>TRUE, 'FR'=>TRUE, 'IT'=>TRUE, 'CY'=>TRUE, 'LV'=>TRUE, 'LT'=>TRUE, 'LU'=>TRUE, 'HU'=>TRUE, 'MT'=>TRUE, 'NL'=>TRUE, 'AT'=>TRUE, 'PL'=>TRUE, 'PT'=>TRUE, 'RO'=>TRUE, 'SI'=>TRUE, 'SK'=>TRUE, 'FI'=>TRUE, 'SE'=>TRUE, 'GG' => TRUE, 'JE' => TRUE, 'IM' => TRUE, 'AC' => TRUE };
            return euCountryCodes.containsKey(countryCode);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return false;
        }
    }
    
    public static Boolean requiresPostcode(String countryCode) {
        try {
            Map<String, CountryList__c> countriesCode = CountryList__c.getAll();            
            MAP<String, Boolean> nonePCCountryCodes = new MAP<String, Boolean>();
            LIST<String> CountryNameList = new LIST<String>();
            CountryNameList.addAll(countriesCode.keySet());
            
             for (String countryName : CountryNameList) {
                CountryList__c country = countriesCode.get(countryName);
                nonePCCountryCodes.put(String.valueOf(country.Country_Code__c), true);
            }
            return !nonePCCountryCodes.containsKey(countryCode);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return false;
        }
    }
        
    public static String formatPostcode(String thePostcode) {
        try {
            if (thePostcode != null) {
                thePostcode = thePostcode.ReplaceAll(' ', '').toUpperCase();
                
                if (thePostcode.Length() == 5) {
                    thePostcode = thePostcode.substring(0, 2) + ' ' + thePostcode.substring(2, 5);
                } else if (thePostcode.Length() == 6) {
                    thePostcode = thePostcode.substring(0, 3) + ' ' + thePostcode.substring(3, 6);
                } else if (thePostcode.ReplaceAll(' ', '').Length() == 7) {
                    thePostcode = thePostcode.substring(0, 4) + ' ' + thePostcode.substring(4, 7);
                }
            }
            
            return thePostcode;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static RateCheckRequest createRequest(IR_Consignment_Bundle consignmentBundle) {
        try {
            RateCheckRequest request = new RateCheckRequest();
            
            request.serviceCode = consignmentBundle.consignment.Service_Code__c;
            request.optionCode = consignmentBundle.consignment.Option_Code__c;
            Datetime collection_date = consignmentBundle.consignment.Pickup_Collection_Date__c;
            String collection_date_string = collection_date.format('dd/MM/yyyy');                       
            request.pickup_collection_date = collection_date_string;
            
            if (consignmentBundle.consignment != null) {
                
                system.debug('-----------');
                system.debug('==>From Country ' + consignmentBundle.consignment.From_Country__c);
                system.debug('==>From Country Code ' + (consignmentBundle.consignment.From_Country__c != null ? getCountryCode(consignmentBundle.consignment.From_Country__c) : ''));
                system.debug('==>To Country '+ consignmentBundle.consignment.To_Country__c);
                system.debug('==>To Country Code '+ (consignmentBundle.consignment.To_Country__c != null ? getCountryCode(consignmentBundle.consignment.To_Country__c) : ''));
                system.debug('-----------');
                request.origin_townName = (consignmentBundle.consignment.From_Town_City__c != null ? consignmentBundle.consignment.From_Town_City__c : '');
                request.origin_postcode = (consignmentBundle.consignment.From_Postcode__c != null ? consignmentBundle.consignment.From_Postcode__c : '');
                request.origin_country = (consignmentBundle.consignment.From_Country__c != null ? getCountryCode(consignmentBundle.consignment.From_Country__c) : '');
                request.dest_townName = (consignmentBundle.consignment.To_Town_City__c != null ? consignmentBundle.consignment.To_Town_City__c : '');
                request.dest_postcode = (consignmentBundle.consignment.To_Postcode__c != null ? consignmentBundle.consignment.To_Postcode__c : '');
                request.dest_country = (consignmentBundle.consignment.To_Country__c != null ? getCountryCode(consignmentBundle.consignment.To_Country__c) : '');
               //request.conType = ((inEU(consignmentBundle.consignment.From_Postcode__c) && inEU(consignmentBundle.consignment.To_Postcode__c) || consignmentBundle.totalActualWeight >= 5) ? 'N' : (consignmentBundle.consignment.Type__c == 'Document' ? 'D' : 'N'));
               request.conType = (consignmentBundle.consignment.Type__c == 'Document' ? 'D' : 'N');
            }
            
            for (IR_Package_Bundle packageBundle : consignmentBundle.packageBundlesMap.values()) {
                if (packageBundle.thePackage != null) {
                    request.addPackage(packageBundle);
                }
            }
            
            return request;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return new RateCheckRequest();
        }
    }
    
    public static  LIST<IR_Consignment_Bundle> convertToMetric(LIST<IR_Consignment_Bundle> consignmentBundles) {
        try {
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                for (IR_Package_Bundle packageBundle : consignmentBundle.packageBundlesMap.values()) {
                    packageBundle.thePackage.Height__c = inchTocm(packageBundle.thePackage.Height__c);
                    packageBundle.thePackage.Length__c = inchTocm(packageBundle.thePackage.Length__c);
                    packageBundle.thePackage.Width__c = inchTocm(packageBundle.thePackage.Width__c);
                    packageBundle.thePackage.Weight_kg__c = lbTokg(packageBundle.thePackage.Weight_kg__c);
                }
            }
            
            return consignmentBundles;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return new LIST<IR_Consignment_Bundle>();
        }
    }
    
    private static Decimal inchTocm(Decimal inches) {
        try {
            return (inches * 2.54).setScale(2);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    private static Decimal lbTokg(Decimal lbs) {
        try {
            return (lbs * 0.45359237).setScale(2);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    
    public class RateCheckRequest {
        private String rateName {get; set;}
        public String origin_country {get; set;}
        public String origin_townName {get; set;}
        public String origin_postcode {get; set;}
        public String origin_townGroup {get; set;}
        public String dest_country {get; set;}
        public String dest_townName {get; set;}
        public String dest_postcode {get; set;}
        public String dest_townGroup {get; set;}
        public String conType {get; set;}
        public String rateCurrency {get; set;}        
        public Decimal actual_weight {get; set;}
        public Decimal height {get; set;}
        public Decimal width {get; set;}
        public Decimal length {get; set;}
        public Decimal volume {get; set;}
        private Decimal total_calc_weight {get; set;}
        private String natRateAccount {get; set;}
        private String intRateAccount {get; set;}
        public Integer items {get; set;}
        public String serviceCode {get; set;}
        public String optionCode {get; set;}
        public LIST<IR_Package__c> packages = new LIST<IR_Package__c>();
        public String pickup_collection_date {get; set;}
        
        public RateCheckRequest() {
            try {
                this.rateName = 'rate';
                this.origin_country = 'GB';
                this.origin_townName = '';
                this.origin_postcode = '';
                this.origin_townGroup = '';
                this.dest_country = 'NL';
                this.dest_townName = '';
                this.dest_postcode = '';
                this.dest_townGroup = '';
                this.conType = 'D';
                this.rateCurrency = 'GBP';                
                this.actual_weight = 0;
                this.height = 0;
                this.width = 0;
                this.length = 0;
                this.volume = 0;
                this.natRateAccount = '0510510469';
                this.intRateAccount = '1553792';
                this.items = 0;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        public Decimal weight {
            get {
                Decimal cubeWeight = this.volume * 250;
                             
                return (actual_weight > cubeWeight ? actual_weight : cubeWeight);               
            }
        }
        
        public void addPackage(IR_Package_Bundle packageBundle) {
            try {
                Decimal thisHeight = (packageBundle.thePackage.Height__c != null ? packageBundle.thePackage.Height__c : 0);
                this.height += thisHeight;
                
                Decimal thisWidth = (packageBundle.thePackage.Width__c != null ? packageBundle.thePackage.Width__c : 0);
                this.width += thisWidth;
                
                Decimal thisLength = (packageBundle.thePackage.Length__c != null ? packageBundle.thePackage.Length__c : 0);
                this.length += thisLength;
                
                Decimal thisVolume = calcVolume(thisHeight, thisWidth, thisLength);
                this.volume += thisVolume;              
                this.actual_weight += (packageBundle.thePackage.Weight_kg__c != null ? packageBundle.thePackage.Weight_kg__c : 0);
                
                this.items++;
                this.packages.add(packageBundle.thePackage);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));                
            }
        }
        
        public String rateId {
            get {
                try {
                    return this.rateName;
                } catch (Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                    
                    return null;
                }
            }
        }
        
        public Decimal toMeters(Decimal value) {
            try {
                return value / 100;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return null;
            }
        }
        
        private Decimal calcVolume(Decimal height, Decimal width, Decimal length) {
            try {
                return (toMeters(height) * toMeters(width) * toMeters(length));
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return null;
            }
        }
        
        public String rateAccount {
            get {
                try {
                    return (domestic ? this.natRateAccount : this.intRateAccount);
                } catch (Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                    
                    return null;
                }
            }
        }
        
        public Boolean domestic {
            get {
                try {
                    return (this.origin_country == 'GB' && this.dest_country == 'GB' ? true : false);
                } catch (Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                    
                    return false;
                }
            }
        }
    }
    
    public class RateCheckResult {
        private MAP<String, RateCheckResultElement> rateCheckElementMap {get; set;}
        private MAP<String, String> errorOverridesMap {get; set;}
        public MAP<String, RateCheckRate> combinedRates {get; set;}
        public LIST<RateCheckError> errors = new LIST<RateCheckError>();        
        public Boolean success {get; set;}
        public RateCheckResult() {
            try {
                rateCheckElementMap = new MAP<String, RateCheckResultElement>();
                combinedRates = new MAP<String, RateCheckRate>();             
                errorOverridesMap = new MAP<String, String>();
                success = false;
                errorOverridesMap.put('P7', 'There was a problem, please check details entered and try again');
                errorOverridesMap.put('IR_ERR_INV_DEL_PC', 'Delivery Postcode Not Available For Online Services');
                errorOverridesMap.put('IR_ERR_INV_COL_PC', 'Collection Postcode Not Available For Online Services');
                errorOverridesMap.put('999', 'There was a problem, please check details entered and try again');                
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        public void addError(RateCheckError error) {
                         
            String customErrorMessage = errorOverridesMap.get(error.code);
            
            if (customErrorMessage == null) {
                error.code = 'TNT-IR';
                error.message = 'There was a problem, please check details entered and try again';
            }else{
                error.code = 'TNT-IR';
                error.message = customErrorMessage;
            }
            if(error.code == '999'){
                success = false;
            }
            errors.add(error);
        }
        
        public void addRate(RateCheckRate rate) {
            try {
                if (rateCheckElementMap.get(rate.rateId) == null) {
                    RateCheckResultElement newElement = new RateCheckResultElement();
                    newElement.addRate(rate);
                    
                    rateCheckElementMap.put(rate.rateId, newElement);
                } else {
                    rateCheckElementMap.get(rate.rateId).addRate(rate);
                }
                
                if (combinedRates.get(rate.serviceCode + '|' + rate.optionCode) == null) {
                    combinedRates.put(rate.serviceCode + '|' + rate.optionCode, rate);
                } else {
                    combinedRates.get(rate.serviceCode + '|' + rate.optionCode).rate += rate.rate;
                }
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        public Decimal bestRate {
            get {
                try {
                    Decimal currentBest;
                    
                    for (RateCheckRate combinedRate : combinedRates.values()) {
                        if (currentBest == null || combinedRate.rate < currentBest) {
                            currentBest = combinedRate.rate;
                        }
                    }
                    
                    return currentBest;
                } catch (Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                    
                    return null;
                }
            }
        }
        
        public LIST<RateCheckRate> orderedCombinedRates {
            get {
                try {
                    LIST<String> services = new LIST<String>();
                    LIST<String> textServices = new LIST<String>();
                    LIST<String> numericServices = new LIST<String>();
                    MAP<String, RateCheckRate> combinedRatesMap = new MAP<String, RateCheckRate>();
                    LIST<RateCheckRate> orderedRates = new LIST<RateCheckRate>();
                    
                    for (RateCheckRate combinedRate : combinedRates.values()) {
                        if (startsWithNumber(combinedRate.serviceString)) {
                            numericServices.add(combinedRate.serviceString);
                        } else {
                            textServices.add(combinedRate.serviceString);
                        }
                        
                        combinedRatesMap.put(combinedRate.serviceString, combinedRate);
                    }
                    
                    services.addAll(sortByTime(numericServices));
                    
                    textServices.sort();
                    services.addAll(textServices);
                    
                    for (String service : services) {
                        orderedRates.add(combinedRatesMap.get(service));
                    }
                    
                    return orderedRates;
                } catch (Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                    
                    return new LIST<RateCheckRate>();
                }
            }
        }
    }
    
    public static LIST<String> sortByTime(LIST<String> numList) {
        try {
            LIST<String> sortedNumList = new LIST<String>();
            for (String num : numList) {
                Integer i=0;
                for (String sortedNum : sortedNumList) {
                    if (getStartNumber(num) < getStartNumber(sortedNum)) {
                        break;
                    }
                    
                    i++;
                }
                
                if (i >= sortedNumList.size()) {
                    sortedNumList.add(num);
                } else {
                    sortedNumList.add(i, num);
                }
            }
            
            return sortedNumList;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return new LIST<String>();
        }
    }
    
    public static Boolean startsWithNumber(String str) {
        try {
            return isNumber(str.substring(0, 1));
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static Double getStartNumber(String str) {
        try {
            String numStr = getStartNumberString(str);
        
            return Double.valueOf(numStr);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static String getStartNumberString(String str) {
        try {
            String numStr = '';
            
            if (startsWithNumber(str)) {
                numStr += str.substring(0, 1);
                
                if (str.length() > 0) {
                    numStr += getStartNumberString(str.substring(1, str.length()));
                }
            }
            
            return numStr;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static Boolean isNumber(String str) {
        try {
            try {
                Double i = Double.valueOf(str);
                return true;
            } catch (Exception ex) {
                return false;
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return false;
        }
    }
    
    public class RateCheckResultElement {
        private LIST<RateCheckError> errors {get; set;}
        public LIST<RateCheckRate> rates {get; set;}
        
        public RateCheckResultElement() {
            try {
                this.errors = new LIST<RateCheckError>();
                this.rates = new LIST<RateCheckRate>();
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }       
        
        public void addRate(RateCheckRate rate) {
            try {
                this.rates.add(rate);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }       
    }
    
    public class RateCheckError {
        public String code {get; set;}
        public String message {get; set;}
    }
    
    public class RateCheckRate {
        public String rateId {get; set;}
        public Decimal rate {get; set;}
        public String rateCurrency {get; set;}
        public String serviceCode {get; set;}
        public String serviceDesc {get; set;}
        public String optionCode {get; set;}
        public String optionDesc {get; set;}
        
        public RateCheckRate() {
            try {
                rateCurrency = 'GBP';
                serviceCode = '';
                serviceDesc = '';
                optionCode = 'NONE';
                optionDesc = '';
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        public String serviceString {
            get {
                try {
                    return serviceDesc + (optionCode == 'NONE' ? '' : ' - ' + optionDesc);
                } catch (Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                    
                    return null;
                }
            }
        }
    }
    
    public static RateCheckResult rateCheck(IR_Consignment_Bundle consignmentBundle) {
        try {
            IR_Global_Class.RateCheckRequest request = IR_Global_Class.createRequest(consignmentBundle);
            Boolean domestic = true;
            
            if (!request.domestic) {
                domestic = false;
                
                Map<String, String> itemMap = new Map<String, String>();
                itemMap.put('PCOD', request.origin_postcode);
                itemMap.put('ISOC', IR_Global_Class.getThreeDigitCode(request.origin_country));
                
                IR_Postcode_Check custCheck = new IR_Postcode_Check();
                custCheck.getAddresses(itemMap);
                
                if (custCheck.getAddressList().size() > 0) {
                    request.origin_townName = custCheck.getTown('0');
                }
            }
                Integer rateTries = 0;
                IR_Global_Class.RateCheckResult results = new IR_Global_Class.RateCheckResult();                
                while(!results.success && rateTries < 3){
                    system.debug('==>rateTries' + rateTries);                   
                    results = IR_ExpressConnect.rateCheck(request, domestic);                                   
                    rateTries ++;
                }

                IR_Global_Class.insertLogResponseXML();
                
            return results;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return new RateCheckResult();
        }
    }   
    
    public static BookResult makeBooking(IR_Customer__c customer, IR_Order__c order, IR_Consignment__c consignment) {
        try {
            BookResult result = new BookResult();
            
            Integer iTries = 0;
                // the multiple attempts to the express connect was removed for the ussie stated in the log v_52 Referenc number: 286           
           // while (!result.success && iTries < 3) {
                result = IR_ExpressConnect.book(customer, order, consignment);                             
                System.debug('==>Result-ExpCNT'+ result.success);    
                iTries++;
            //}
            System.debug('==>ExpCNT-iTries' + iTries);
            
            return result;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return new BookResult();
        }
    }
    public static Boolean validatePackage (LIST<IR_Consignment_Bundle> consignmentBundles){
        boolean valid = true;
        
        if (consignmentBundles != null) {
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                for (IR_Package_Bundle packageBundle : consignmentBundle.packageBundlesMap.values()) {
                    if (packageBundle.thePackage.Height__c == null || packageBundle.thePackage.Height__c <= 0 || packageBundle.thePackage.Height__c > 150) {
                        packageBundle.thePackage.Height__c.addError('Height must be greater than 0 and Max height 150cm');
                        
                        valid = false;
                    }
                    
                    if (packageBundle.thePackage.Length__c == null || packageBundle.thePackage.Length__c <= 0 || packageBundle.thePackage.Length__c > 120) {
                        packageBundle.thePackage.Length__c.addError('Length must be greater than 0 and Max length 120cm');
                        
                        valid = false;
                    }
                    
                    if (packageBundle.thePackage.Width__c == null || packageBundle.thePackage.Width__c <= 0 || packageBundle.thePackage.Width__c > 120) {
                        packageBundle.thePackage.Width__c.addError('Width must be greater than 0 and Max height 120cm');
                        
                        valid = false;
                    }
                    
                    if (packageBundle.thePackage.Weight_kg__c == null || packageBundle.thePackage.Weight_kg__c <= 0 || packageBundle.thePackage.Weight_kg__c > 300) {
                        packageBundle.thePackage.Weight_kg__c.addError('Weight must be greater than 0 and Max weight 300Kg');
                        
                        valid = false;
                    }
                }
            }
        }
        
        return valid;
    }
    public class IR_Exception extends Exception { }
    
    public static RateCheckResult getQuote(IR_Order__c thisOrder, LIST<IR_Consignment_Bundle> consignmentBundles) {
        try {
            RateCheckResult results = new RateCheckResult();
            LIST<IR_Consignment__c> consignmentsList = new LIST<IR_Consignment__c>();
            LIST<Id> conIds = new LIST<Id>();
            
            
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                                                        
                    results = IR_Global_Class.rateCheck(consignmentBundle);                 
                        thisOrder.Amount_Quoted__c = (results.bestRate != null ? results.bestRate : 0);
                        thisOrder.Order_Status__c = 'Quote';                    
                        upsert thisOrder;                   
                
                if (consignmentBundle.consignment.Order_IR__c == null) {
                    consignmentBundle.consignment.Order_IR__c = thisOrder.Id;
                }
                
                consignmentBundle.consignment.From_Postcode__c = (IR_Global_Class.validatePostcode(consignmentBundle.consignment.From_Postcode__c) == null ? consignmentBundle.consignment.From_Postcode__c : IR_Global_Class.validatePostcode(consignmentBundle.consignment.From_Postcode__c));
                consignmentBundle.consignment.To_Postcode__c = (IR_Global_Class.validatePostcode(consignmentBundle.consignment.To_Postcode__c) == null ? consignmentBundle.consignment.To_Postcode__c : IR_Global_Class.validatePostcode(consignmentBundle.consignment.To_Postcode__c));
                
                consignmentsList.add(consignmentBundle.consignment);                
            }
            
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                if (consignmentBundle.consignment != null && consignmentBundle.consignment.Id != null) {
                    conIds.add(consignmentBundle.consignment.Id);
                }
            }
            
            LIST<IR_Package__c> existingPackages = [SELECT Id FROM IR_Package__c WHERE Consignment_IR__c = :conIds];
            
            upsert consignmentsList;
            
            LIST<IR_Package__c> packageList = new LIST<IR_Package__c>();
            Integer i = 0;
            for (IR_Consignment_Bundle consignmentBundle : consignmentBundles) {
                for (IR_Package_Bundle packageBundle : consignmentBundle.packageBundlesMap.values()) {
                    packageBundle.thePackage = packageBundle.thePackage.clone(false, true);
                    
                    if (packageBundle.thePackage.Consignment_IR__c == null) {
                        packageBundle.thePackage.Consignment_IR__c = consignmentsList[i].Id;
                    }
                    
                    packageList.add(packageBundle.thePackage);
                }
                
                i++;
            }
            
            delete existingPackages;
            insert packageList;
            
            return results;
        } catch (Exception ex) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return new RateCheckResult();
        }
    }

    public class BookResult {
        public Boolean success {get; set;}
        public String confirmationCode {get; set;}
        public String errorResponse {get; set;}
        
        public BookResult() {
            try {
                success = false;
                confirmationCode = '';
                errorResponse = '';
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
    }
    
    public static Id getCustomersExperienceQueueId() {
        try {
            return [SELECT Id, Queue.Id FROM QueueSobject WHERE SobjectType = 'IR_Customer__c' AND Queue.Name = 'IR_Customer_Experience' LIMIT 1].Queue.Id;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
     public static Id getRatesandContactsQueueId() {
        try {
            return [SELECT Id, Queue.Id FROM QueueSobject WHERE SobjectType = 'IR_Customer__c' AND Queue.Name = 'IR_Rates_and_Contacts' LIMIT 1].Queue.Id;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
        
    public static Id getNewCustomersQueueId() {
        try {
            return [SELECT Id, Queue.Id FROM QueueSobject WHERE SobjectType = 'IR_Customer__c' AND Queue.Name = 'IR_New_Customers' LIMIT 1].Queue.Id;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public class QueueCustomer {
        public IR_Customer__c customer {get; set;}
        
        public QueueCustomer(IR_Customer__c customer) {
            try {
                this.customer = customer;
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
    }
    
    public static String generatePassword() {
        try {
            String password = '';
            LIST<String> validChars = new String[] {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
            
            for (Integer i=0; i<8; i++) {
                Integer j = (Math.random() * 100).intValue();
                while (j >= validChars.size()) {
                    j = (Math.random() * 100).intValue();
                }
                
                password += validChars[j];
            }
            
            return password;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static MAP<Date, String> getHolidays(Date dateFrom, Date dateTo) {
        try {
            MAP<Date, String> returnMap = new MAP<Date, String>();
            
            for (Holiday hol : [SELECT Id, Name, ActivityDate FROM Holiday WHERE IsAllDay = TRUE AND (ActivityDate >= :dateFrom AND ActivityDate <= :dateTo) LIMIT 1000]) {
                returnMap.put(hol.ActivityDate, hol.Name);
            }
            
            return returnMap;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return new MAP<Date, String>();
        }
    }
    
    public static void logIRError(String errorCode, String errorMessage) {
        try {           
            Log__c resLog = new Log__c();
            Map<String, Schema.RecordTypeInfo> logTypes = Log__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            resLog.RecordTypeId = logTypes.get('Internet Registration').getRecordTypeId();
            resLog.Error_Code__c = errorCode;
            resLog.Error_Message__c = errorMessage;     
            responseLog.add(resLog);            
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public static LIST<Log__c> responseLog = new LIST<Log__c>();
    
    
    public static void insertLogResponseXML(){
        try{
            insert responseLog;
        }catch(exception e){
            system.debug('Error while inserting the response xml to log. ERROR: ' + e.getMessage());
        }
    }
     
/*  public static void logResponseXml(String ServiceName, String responseXml){
        try{        
        Log__c resLog = new Log__c();
        Map<String, Schema.RecordTypeInfo> logTypes = Log__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        resLog.RecordTypeId = logTypes.get('Internet Registration').getRecordTypeId();
        resLog.Error_Code__c = ServiceName;
        resLog.Error_Message__c = responseXML;      
        responseLog.add(resLog);        
        }catch(exception e){
            system.debug('Error in logResponseXMl funciton.  Error:'+ e.getMessage());
        }                       
    }*/ 
    public class TelephoneField {
        public String countryCode {get; set;}
        public String std {get; set;}
        public String phoneNumber {get; set;}
        
        public telephoneField() {
            try {
                countryCode = '+44';
                std = '';
                phoneNumber = '';
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
        
        public telephoneField(String theField) {
            try {
                if (theField != null && theField.split(' ').size() == 3) {
                    countryCode = theField.split(' ')[0];
                    std = theField.split(' ')[1];
                    phoneNumber = theField.split(' ')[2];
                } else {
                    countryCode = '+44';
                    std = '';
                    phoneNumber = '';
                }
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
            }
        }
        
        public String plainStd {
            get {
                return std.replace('(', '').replace(')', '');
            }
            
            set {
                std = value;
            }
        }
        
        public String format {
            get {
                try {
                    String formattedCountryCode = formatCountryCode;
                    String formattedStd = formatStd;
                    String formattedPhoneNumber = formatPhoneNumber;
                    
                    if (formattedCountryCode.length() == 0 || formattedStd.length() == 0 || formattedPhoneNumber.length() == 0) {
                        return '';
                    } else {
                        return formattedCountryCode + ' ' + formattedStd + ' ' + formattedPhoneNumber;
                    }
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
                    
                    return null;
                }
            }
        }
        
        private String formatCountryCode {
            get {
                try {
                    String tempCountryCode = countryCode.replaceAll(' ', '').replaceAll('\\+', '');
                    
                    return '+' + tempCountryCode;
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
                    
                    return null;
                }
            }
        }
        
        private String formatStd {
            get {
                try {
                    String tempStd = std.replaceAll(' ', '').replaceAll('\\(', '').replaceAll('\\)', '').replaceFirst('0','');
                    
                    return '(0)' + tempStd;
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
                    
                    return null;
                }
            }
        }
        
        private String formatPhoneNumber {
            get {
                try {
                    String tempPhoneNumber = phoneNumber.replaceAll(' ', '');
                    
                    return tempPhoneNumber;
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
                    
                    return null;
                }
            }
        }
    }
    
    private static String formatTel(String tel) {
        try {
            return tel.replaceAll('\\(', '').replaceAll('\\)', '');
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static String urlEncodeXML(String xml) {
        try {
            XmlStreamReader reader = new XmlStreamReader(xml);
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument(null, '1.0');
            System.debug(xml);
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    w.writeStartElement(null, reader.getLocalName(), null);
                    
                    for (Integer i=0;i<reader.getAttributeCount();i++) {
                        String prefix = reader.getAttributePrefix(i);
                        String namespace = reader.getAttributeNamespace(i);
                        
                        if (prefix != null && namespace != null) {
                            w.writeAttribute(prefix, namespace, reader.getAttributeLocalName(i), reader.getAttributeValueAt(i));
                        } else {
                            w.writeAttribute(null, null, reader.getAttributeLocalName(i), reader.getAttributeValueAt(i));
                        }
                    }
                } else if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    w.writeEndElement();
                } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                    if (reader.getText().replaceAll('\n', '').trim().length() > 0 && reader.getText() != '\n' && reader.getText() != '\r') {
                        System.debug(reader.getText());
                        //w.writeCharacters(reader.getText().replaceAll(' ', '%20'));
                        //w.writeCharacters(EncodingUtil.urlEncode(reader.getText(), 'UTF-8'));
                        w.writeCharacters(reader.getText());
                    } else {
                        w.writeCharacters(reader.getText());
                    }
                }
                
                reader.next();
            }
             
            w.writeEndDocument();
            String xmlOutput = w.getXmlString().replaceAll('<\\?.*\\?>', '');
            w.close();
            
            return xmlOutput;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static Boolean withinWorkingHours {
        get {
            try {
                Integer hour = System.now().time().hour();
                
                if (hour >= 9 && hour < 17) {
                    return true;
                } else {
                    return false;
                }
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                
                return false;
            }
        }
    }
    
    public static String getCountryString(String countryCode) {
        try {
            /*New List updated on 04102011
            *'GB'=>'United Kingdom' , 'AL'=>'Albania' , 'DZ'=>'Algeria' , 'AS'=>'American Samoa' , 'AD'=>'Andorra' , 'AO'=>'Angola' , 'AI'=>'Anguilla' , 'AG'=>'Antigua And Barbuda' , 'AR'=>'Argentina' , 'AM'=>'Armenia' , 'AW'=>'Aruba' , 'AU'=>'Australia' , 'AT'=>'Austria' , 'AZ'=>'Azerbaijan' , 'BS'=>'Bahamas' , 'BH'=>'Bahrain' , 'BD'=>'Bangladesh' , 'BB'=>'Barbados' , 'BY'=>'Belarus' , 'BE'=>'Belgium' , 'BZ'=>'Belize' , 'BJ'=>'Benin' , 'BM'=>'Bermuda' , 'BT'=>'Bhutan' , 'BO'=>'Bolivia' , 'BA'=>'Bosnia Herzegovina' , 'BW'=>'Botswana' , 'BR'=>'Brazil' , 'BN'=>'Brunei Darussalam' , 'BG'=>'Bulgaria' , 'BF'=>'Burkina Faso' , 'BI'=>'Burundi' , 'KH'=>'Cambodia' , 'CM'=>'Cameroon' , 'CA'=>'Canada' , 'CV'=>'Cape Verde' , 'KY'=>'Cayman Islands' , 'CF'=>'Central African Repu' , 'TD'=>'Chad' , 'CL'=>'Chile' , 'CN'=>'China' , 'CO'=>'Colombia' , 'KM'=>'Comoros Islands' , 'CG'=>'Congo' , 'CD'=>'Congo Democratic Re' , 'CK'=>'Cook Islands' , 'CR'=>'Costa Rica' , 'CI'=>'Cote D Ivoire' , 'HR'=>'Croatia' , 'CU'=>'Cuba' , 'CY'=>'Cyprus' , 'CZ'=>'Czech Republic' , 'DK'=>'Denmark' , 'DJ'=>'Djibouti' , 'DM'=>'Dominica' , 'DO'=>'Dominican Republic' , 'EC'=>'Ecuador' , 'EG'=>'Egypt' , 'SV'=>'El Salvador' , 'GQ'=>'Equatorial Guinea' , 'ER'=>'Eritrea' , 'EE'=>'Estonia' , 'ET'=>'Ethiopia' , 'FK'=>'Falkland Islands' , 'FO'=>'Faroe Islands' , 'FJ'=>'Fiji' , 'FI'=>'Finland' , 'FR'=>'France' , 'GF'=>'French Guiana' , 'PF'=>'French Polynesia' , 'GA'=>'Gabon' , 'GM'=>'Gambia' , 'GE'=>'Georgia' , 'DE'=>'Germany' , 'GH'=>'Ghana' , 'GI'=>'Gibraltar' , 'GR'=>'Greece' , 'GL'=>'Greenland' , 'GD'=>'Grenada' , 'GP'=>'Guadeloupe' , 'GU'=>'Guam' , 'GT'=>'Guatemala' , 'GN'=>'Guinea' , 'GW'=>'Guinea Bissau' , 'GY'=>'Guyana' , 'HT'=>'Haiti' , 'HN'=>'Honduras' , 'HK'=>'Hong Kong' , 'HU'=>'Hungary' , 'IS'=>'Iceland' , 'IN'=>'India' , 'ID'=>'Indonesia' , 'IR'=>'Iran' , 'IQ'=>'Iraq' , 'IE'=>'Ireland' , 'IL'=>'Israel' , 'IT'=>'Italy' , 'JM'=>'Jamaica' , 'JP'=>'Japan' , 'JO'=>'Jordan' , 'KZ'=>'Kazakhstan ' , 'KE'=>'Kenya' , 'KI'=>'Kiribati' , 'KP'=>'Korea North' , 'KR'=>'Korea South' , 'YK'=>'Kosovo' , 'KW'=>'Kuwait' , 'KG'=>'Kyrgyzstan' , 'LA'=>'Lao People S Dem Re' , 'LV'=>'Latvia' , 'LB'=>'Lebanon' , 'LS'=>'Lesotho' , 'LR'=>'Liberia' , 'LY'=>'Libya' , 'LI'=>'Liechtenstein' , 'LT'=>'Lithuania' , 'LU'=>'Luxembourg' , 'MO'=>'Macau' , 'MK'=>'Macedonia' , 'MG'=>'Madagascar' , 'MW'=>'Malawi' , 'MY'=>'Malaysia' , 'MV'=>'Maldives' , 'ML'=>'Mali' , 'MT'=>'Malta' , 'MH'=>'Marshall Islands' , 'MQ'=>'Martinique' , 'MR'=>'Mauritania' , 'MU'=>'Mauritius' , 'YT'=>'Mayotte' , 'MX'=>'Mexico' , 'FM'=>'Micronesia' , 'MN'=>'Moldova' , 'MC'=>'Monaco' , 'MN'=>'Mongolia' , 'YM'=>'Montenegro' , 'ME'=>'Montenegro' , 'MS'=>'Montserrat' , 'MA'=>'Morocco' , 'MZ'=>'Mozambique' , 'MM'=>'Myanmar' , 'NA'=>'Namibia' , 'NR'=>'Nauru' , 'NP'=>'Nepal' , 'NL'=>'Netherlands' , 'AN'=>'Netherlands Antilles' , 'NC'=>'New Caledonia' , 'NZ'=>'New Zealand' , 'NI'=>'Nicaragua' , 'NE'=>'Niger' , 'NG'=>'Nigeria' , 'NF'=>'Norfolk Island' , 'MP'=>'Northern Mariana Isl' , 'NO'=>'Norway' , 'OM'=>'Oman' , 'PK'=>'Pakistan' , 'PW'=>'Palau' , 'PA'=>'Panama' , 'PG'=>'Papua New Guinea' , 'PY'=>'Paraguay' , 'PE'=>'Peru' , 'PH'=>'Philippines' , 'PL'=>'Poland' , 'PT'=>'Portugal' , 'PR'=>'Puerto Rico' , 'QA'=>'Qatar' , 'RE'=>'Reunion' , 'RO'=>'Romania' , 'RU'=>'Russian Federation' , 'RW'=>'Rwanda' , 'LC'=>'Saint Lucia' , 'WS'=>'Samoa' , 'SM'=>'San Marino' , 'ST'=>'Sao Tome And Princip' , 'SA'=>'Saudi Arabia' , 'SN'=>'Senegal' , 'RS'=>'Serbia' , 'SC'=>'Seychelles' , 'SL'=>'Sierra Leone' , 'SG'=>'Singapore' , 'SK'=>'Slovakia' , 'SI'=>'Slovenia' , 'SB'=>'Solomon Islands' , 'ZA'=>'South Africa' , 'ES'=>'Spain' , 'LK'=>'Sri Lanka' , 'KN'=>'St Kitts And Nevis' , 'VC'=>'St Vincent' , 'SD'=>'Sudan' , 'SR'=>'Suriname' , 'SZ'=>'Swaziland' , 'SE'=>'Sweden' , 'CH'=>'Switzerland' , 'SY'=>'Syria' , 'TW'=>'Taiwan' , 'TJ'=>'Tajikistan' , 'TZ'=>'Tanzania' , 'TH'=>'Thailand' , 'TG'=>'Togo' , 'TO'=>'Tonga' , 'TT'=>'Trinidad' , 'TN'=>'Tunisia' , 'TR'=>'Turkey' , 'TM'=>'Turkmenistan' , 'TC'=>'Turks And Caicos Isl' , 'TV'=>'Tuvalu' , 'UG'=>'Uganda' , 'UA'=>'Ukraine' , 'AE'=>'United Arab Emirates' , 'US'=>'United States' , 'UY'=>'Uruguay' , 'UZ'=>'Uzbekistan' , 'VU'=>'Vanuatu' , 'VE'=>'Venezuela' , 'VN'=>'Vietnam' , 'VG'=>'Virgin Islands  Brit' , 'VI'=>'Virgin Islands U S' , 'YE'=>'Yemen' , 'YU'=>'Yugoslavia' , 'ZM'=>'Zambia' , 'ZW'=>'Zimbabwe'
            *******************************/
            /* Old List
            * 'AD'=>'Andorra' , 'AE'=>'United Arab Emirates' , 'AR'=>'Argentina' , 'AT'=>'Austria' , 'AU'=>'Australia' , 'BE'=>'Belgium' , 'BG'=>'Bulgaria' , 'BH'=>'Bahrain' , 'BR'=>'Brazil' , 'CA'=>'Canada' , 'CH'=>'Switzerland' , 'CL'=>'Chile' , 'CN'=>'China' , 'CY'=>'Cyprus' , 'CZ'=>'Czech Republic' , 'DE'=>'Germany' , 'DE1'=>'Germany' , 'DK'=>'Denmark' , 'EE'=>'Estonia' , 'EG'=>'Egypt' , 'ES'=>'Spain' , 'FI'=>'Finland' , 'FR'=>'France' , 'GB'=>'United Kingdom' , 'GR'=>'Greece' , 'HK'=>'Hong Kong' , 'HU'=>'Hungary' , 'ID'=>'Indonesia' , 'IE'=>'Ireland' , 'IL'=>'Israel' , 'IN'=>'India' , 'IS'=>'Iceland' , 'IT'=>'Italy' , 'JO'=>'Jordan' , 'JP'=>'Japan' , 'KH'=>'Cambodia' , 'KR'=>'Korea, Republic of' , 'KW'=>'Kuwait' , 'LT'=>'Lithuania' , 'LU'=>'Luxembourg' , 'LV'=>'Latvia' , 'MC'=>'Monaco' , 'MG'=>'Madagascar' , 'MT'=>'Malta' , 'MU'=>'Mauritius' , 'MY'=>'Malaysia' , 'NA'=>'Nambia' , 'NL'=>'Netherlands' , 'NO'=>'Norway' , 'NP'=>'Nepal' , 'NZ'=>'New Zealand' , 'PH'=>'Philippines' , 'PL'=>'Poland' , 'PT'=>'Portugal' , 'RO'=>'Romania' , 'RU'=>'Russian Federation' , 'SA'=>'Saudi Arabia' , 'SE'=>'Sweden' , 'SG'=>'Singapore' , 'SI'=>'Slovenia' , 'SK'=>'Slovakia' , 'SY'=>'Syrian Arab Republic' , 'TH'=>'Thailand' , 'TR'=>'Turkey' , 'TW'=>'Taiwan, Province of China' , 'UA'=>'Ukraine' , 'US'=>'United States of America' , 'VN'=>'Vietnam' , 'ZA'=>'South Africa'
            *******************************/
            Map<String, String> countryCodesMap = new Map<String, String> { 'GB'=>'United Kingdom' , 'AL'=>'Albania' , 'DZ'=>'Algeria' , 'AS'=>'American Samoa' , 'AD'=>'Andorra' , 'AO'=>'Angola' , 'AI'=>'Anguilla' , 'AG'=>'Antigua And Barbuda' , 'AR'=>'Argentina' , 'AM'=>'Armenia' , 'AW'=>'Aruba' , 'AU'=>'Australia' , 'AT'=>'Austria' , 'AZ'=>'Azerbaijan' , 'BS'=>'Bahamas' , 'BH'=>'Bahrain' , 'BD'=>'Bangladesh' , 'BB'=>'Barbados' , 'BY'=>'Belarus' , 'BE'=>'Belgium' , 'BZ'=>'Belize' , 'BJ'=>'Benin' , 'BM'=>'Bermuda' , 'BT'=>'Bhutan' , 'BO'=>'Bolivia' , 'BA'=>'Bosnia Herzegovina' , 'BW'=>'Botswana' , 'BR'=>'Brazil' , 'BN'=>'Brunei Darussalam' , 'BG'=>'Bulgaria' , 'BF'=>'Burkina Faso' , 'BI'=>'Burundi' , 'KH'=>'Cambodia' , 'CM'=>'Cameroon' , 'CA'=>'Canada' , 'CV'=>'Cape Verde' , 'KY'=>'Cayman Islands' , 'CF'=>'Central African Repu' , 'TD'=>'Chad' , 'CL'=>'Chile' , 'CN'=>'China' , 'CO'=>'Colombia' , 'KM'=>'Comoros Islands' , 'CG'=>'Congo' , 'CD'=>'Congo Democratic Re' , 'CK'=>'Cook Islands' , 'CR'=>'Costa Rica' , 'CI'=>'Cote D Ivoire' , 'HR'=>'Croatia' , 'CU'=>'Cuba' , 'CY'=>'Cyprus' , 'CZ'=>'Czech Republic' , 'DK'=>'Denmark' , 'DJ'=>'Djibouti' , 'DM'=>'Dominica' , 'DO'=>'Dominican Republic' , 'EC'=>'Ecuador' , 'EG'=>'Egypt' , 'SV'=>'El Salvador' , 'GQ'=>'Equatorial Guinea' , 'ER'=>'Eritrea' , 'EE'=>'Estonia' , 'ET'=>'Ethiopia' , 'FK'=>'Falkland Islands' , 'FO'=>'Faroe Islands' , 'FJ'=>'Fiji' , 'FI'=>'Finland' , 'FR'=>'France' , 'GF'=>'French Guiana' , 'PF'=>'French Polynesia' , 'GA'=>'Gabon' , 'GM'=>'Gambia' , 'GE'=>'Georgia' , 'DE'=>'Germany' , 'GH'=>'Ghana' , 'GI'=>'Gibraltar' , 'GR'=>'Greece' , 'GL'=>'Greenland' , 'GD'=>'Grenada' , 'GP'=>'Guadeloupe' , 'GU'=>'Guam' , 'GT'=>'Guatemala' , 'GN'=>'Guinea' , 'GW'=>'Guinea Bissau' , 'GY'=>'Guyana' , 'HT'=>'Haiti' , 'HN'=>'Honduras' , 'HK'=>'Hong Kong' , 'HU'=>'Hungary' , 'IS'=>'Iceland' , 'IN'=>'India' , 'ID'=>'Indonesia' , 'IR'=>'Iran' , 'IQ'=>'Iraq' , 'IE'=>'Ireland' , 'IL'=>'Israel' , 'IT'=>'Italy' , 'JM'=>'Jamaica' , 'JP'=>'Japan' , 'JO'=>'Jordan' , 'KZ'=>'Kazakhstan ' , 'KE'=>'Kenya' , 'KI'=>'Kiribati' , 'KP'=>'Korea North' , 'KR'=>'Korea South' , 'YK'=>'Kosovo' , 'KW'=>'Kuwait' , 'KG'=>'Kyrgyzstan' , 'LA'=>'Lao People S Dem Re' , 'LV'=>'Latvia' , 'LB'=>'Lebanon' , 'LS'=>'Lesotho' , 'LR'=>'Liberia' , 'LY'=>'Libya' , 'LI'=>'Liechtenstein' , 'LT'=>'Lithuania' , 'LU'=>'Luxembourg' , 'MO'=>'Macau' , 'MK'=>'Macedonia' , 'MG'=>'Madagascar' , 'MW'=>'Malawi' , 'MY'=>'Malaysia' , 'MV'=>'Maldives' , 'ML'=>'Mali' , 'MT'=>'Malta' , 'MH'=>'Marshall Islands' , 'MQ'=>'Martinique' , 'MR'=>'Mauritania' , 'MU'=>'Mauritius' , 'YT'=>'Mayotte' , 'MX'=>'Mexico' , 'FM'=>'Micronesia' , 'MN'=>'Moldova' , 'MC'=>'Monaco' , 'MN'=>'Mongolia' , 'YM'=>'Montenegro' , 'ME'=>'Montenegro' , 'MS'=>'Montserrat' , 'MA'=>'Morocco' , 'MZ'=>'Mozambique' , 'MM'=>'Myanmar' , 'NA'=>'Namibia' , 'NR'=>'Nauru' , 'NP'=>'Nepal' , 'NL'=>'Netherlands' , 'AN'=>'Netherlands Antilles' , 'NC'=>'New Caledonia' , 'NZ'=>'New Zealand' , 'NI'=>'Nicaragua' , 'NE'=>'Niger' , 'NG'=>'Nigeria' , 'NF'=>'Norfolk Island' , 'MP'=>'Northern Mariana Isl' , 'NO'=>'Norway' , 'OM'=>'Oman' , 'PK'=>'Pakistan' , 'PW'=>'Palau' , 'PA'=>'Panama' , 'PG'=>'Papua New Guinea' , 'PY'=>'Paraguay' , 'PE'=>'Peru' , 'PH'=>'Philippines' , 'PL'=>'Poland' , 'PT'=>'Portugal' , 'PR'=>'Puerto Rico' , 'QA'=>'Qatar' , 'RE'=>'Reunion' , 'RO'=>'Romania' , 'RU'=>'Russian Federation' , 'RW'=>'Rwanda' , 'LC'=>'Saint Lucia' , 'WS'=>'Samoa' , 'SM'=>'San Marino' , 'ST'=>'Sao Tome And Princip' , 'SA'=>'Saudi Arabia' , 'SN'=>'Senegal' , 'RS'=>'Serbia' , 'SC'=>'Seychelles' , 'SL'=>'Sierra Leone' , 'SG'=>'Singapore' , 'SK'=>'Slovakia' , 'SI'=>'Slovenia' , 'SB'=>'Solomon Islands' , 'ZA'=>'South Africa' , 'ES'=>'Spain' , 'LK'=>'Sri Lanka' , 'KN'=>'St Kitts And Nevis' , 'VC'=>'St Vincent' , 'SD'=>'Sudan' , 'SR'=>'Suriname' , 'SZ'=>'Swaziland' , 'SE'=>'Sweden' , 'CH'=>'Switzerland' , 'SY'=>'Syria' , 'TW'=>'Taiwan' , 'TJ'=>'Tajikistan' , 'TZ'=>'Tanzania' , 'TH'=>'Thailand' , 'TG'=>'Togo' , 'TO'=>'Tonga' , 'TT'=>'Trinidad' , 'TN'=>'Tunisia' , 'TR'=>'Turkey' , 'TM'=>'Turkmenistan' , 'TC'=>'Turks And Caicos Isl' , 'TV'=>'Tuvalu' , 'UG'=>'Uganda' , 'UA'=>'Ukraine' , 'AE'=>'United Arab Emirates' , 'US'=>'United States' , 'UY'=>'Uruguay' , 'UZ'=>'Uzbekistan' , 'VU'=>'Vanuatu' , 'VE'=>'Venezuela' , 'VN'=>'Vietnam' , 'VG'=>'Virgin Islands  Brit' , 'VI'=>'Virgin Islands U S' , 'YE'=>'Yemen' , 'YU'=>'Yugoslavia' , 'ZM'=>'Zambia' , 'ZW'=>'Zimbabwe' };
            
            String countryString = '';
            if (countryCode != null && countryCodesMap.get(countryCode) != null) {
                countryString = countryCodesMap.get(countryCode);
            }
            
            return countryString;
            
            //Commented out for more efficient process
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL , ex.getMessage()));
            
            return null;
        }
    }
    
    public static String getCountryCode(String countryString) {
        try {
            /*New Countries List*
            * 'United Kingdom'=>'GB' , 'Albania'=>'AL' , 'Algeria'=>'DZ' , 'American Samoa'=>'AS' , 'Andorra'=>'AD' , 'Angola'=>'AO', 'Anguilla'=>'AI', 'Antigua And Barbuda'=>'AG', 'Argentina'=>'AR', 'Armenia'=>'AM', 'Aruba'=>'AW', 'Australia'=>'AU', 'Austria'=>'AT', 'Azerbaijan'=>'AZ', 'Bahamas'=>'BS', 'Bahrain'=>'BH', 'Bangladesh'=>'BD', 'Barbados'=>'BB', 'Belarus'=>'BY', 'Belgium'=>'BE', 'Belize'=>'BZ', 'Benin'=>'BJ', 'Bermuda'=>'BM', 'Bhutan'=>'BT', 'Bolivia'=>'BO', 'Bosnia Herzegovina'=>'BA', 'Botswana'=>'BW', 'Brazil'=>'BR', 'Brunei Darussalam'=>'BN', 'Bulgaria'=>'BG', 'Burkina Faso'=>'BF', 'Burundi'=>'BI', 'Cambodia'=>'KH', 'Cameroon'=>'CM', 'Canada'=>'CA', 'Cape Verde'=>'CV', 'Cayman Islands'=>'KY', 'Central African Repu'=>'CF', 'Chad'=>'TD', 'Chile'=>'CL', 'China'=>'CN', 'Colombia'=>'CO', 'Comoros Islands'=>'KM', 'Congo'=>'CG', 'Congo Democratic Re'=>'CD', 'Cook Islands'=>'CK', 'Costa Rica'=>'CR', 'Cote D Ivoire'=>'CI', 'Croatia'=>'HR', 'Cuba'=>'CU', 'Cyprus'=>'CY', 'Czech Republic'=>'CZ', 'Denmark'=>'DK', 'Djibouti'=>'DJ', 'Dominica'=>'DM', 'Dominican Republic'=>'DO', 'Ecuador'=>'EC', 'Egypt'=>'EG', 'El Salvador'=>'SV', 'Equatorial Guinea'=>'GQ', 'Eritrea'=>'ER', 'Estonia'=>'EE', 'Ethiopia'=>'ET', 'Falkland Islands'=>'FK', 'Faroe Islands'=>'FO', 'Fiji'=>'FJ', 'Finland'=>'FI', 'France'=>'FR', 'French Guiana'=>'GF', 'French Polynesia'=>'PF', 'Gabon'=>'GA', 'Gambia'=>'GM', 'Georgia'=>'GE', 'Germany'=>'DE', 'Ghana'=>'GH', 'Gibraltar'=>'GI', 'Greece'=>'GR', 'Greenland'=>'GL', 'Grenada'=>'GD', 'Guadeloupe'=>'GP', 'Guam'=>'GU', 'Guatemala'=>'GT', 'Guinea'=>'GN', 'Guinea Bissau'=>'GW', 'Guyana'=>'GY', 'Haiti'=>'HT', 'Honduras'=>'HN', 'Hong Kong'=>'HK', 'Hungary'=>'HU', 'Iceland'=>'IS', 'India'=>'IN', 'Indonesia'=>'ID', 'Iran'=>'IR', 'Iraq'=>'IQ', 'Ireland'=>'IE', 'Israel'=>'IL', 'Italy'=>'IT', 'Jamaica'=>'JM', 'Japan'=>'JP', 'Jordan'=>'JO', 'Kazakhstan '=>'KZ', 'Kenya'=>'KE', 'Kiribati'=>'KI', 'Korea North'=>'KP', 'Korea South'=>'KR', 'Kosovo'=>'YK', 'Kuwait'=>'KW', 'Kyrgyzstan'=>'KG', 'Lao People S Dem Re'=>'LA', 'Latvia'=>'LV', 'Lebanon'=>'LB', 'Lesotho'=>'LS', 'Liberia'=>'LR', 'Libya'=>'LY', 'Liechtenstein'=>'LI', 'Lithuania'=>'LT', 'Luxembourg'=>'LU', 'Macau'=>'MO', 'Macedonia'=>'MK', 'Madagascar'=>'MG', 'Malawi'=>'MW', 'Malaysia'=>'MY', 'Maldives'=>'MV', 'Mali'=>'ML', 'Malta'=>'MT', 'Marshall Islands'=>'MH' , 'Martinique'=>'MQ' , 'Mauritania'=>'MR' , 'Mauritius'=>'MU' , 'Mayotte'=>'YT', 'Mexico'=>'MX' , 'Micronesia'=>'FM', 'Moldova'=>'MN' , 'Monaco'=>'MC', 'Mongolia'=>'MN' , 'Montenegro'=>'YM', 'Montenegro'=>'ME' , 'Montserrat'=>'MS', 'Morocco'=>'MA', 'Mozambique'=>'MZ', 'Myanmar'=>'MM', 'Namibia'=>'NA', 'Nauru'=>'NR', 'Nepal'=>'NP', 'Netherlands'=>'NL', 'Netherlands Antilles'=>'AN', 'New Caledonia'=>'NC', 'New Zealand'=>'NZ', 'Nicaragua'=>'NI', 'Niger'=>'NE', 'Nigeria'=>'NG', 'Norfolk Island'=>'NF', 'Northern Mariana Isl'=>'MP', 'Norway'=>'NO', 'Oman'=>'OM', 'Pakistan'=>'PK', 'Palau'=>'PW', 'Panama'=>'PA', 'Papua New Guinea'=>'PG', 'Paraguay'=>'PY', 'Peru'=>'PE', 'Philippines'=>'PH', 'Poland'=>'PL', 'Portugal'=>'PT', 'Puerto Rico'=>'PR', 'Qatar'=>'QA', 'Reunion'=>'RE', 'Romania'=>'RO', 'Russian Federation'=>'RU', 'Rwanda'=>'RW', 'Saint Lucia'=>'LC', 'Samoa'=>'WS', 'San Marino'=>'SM', 'Sao Tome And Princip'=>'ST', 'Saudi Arabia'=>'SA', 'Senegal'=>'SN', 'Serbia'=>'RS', 'Seychelles'=>'SC', 'Sierra Leone'=>'SL', 'Singapore'=>'SG', 'Slovakia'=>'SK', 'Slovenia'=>'SI', 'Solomon Islands'=>'SB', 'South Africa'=>'ZA', 'Spain'=>'ES', 'Sri Lanka'=>'LK', 'St Kitts And Nevis'=>'KN', 'St Vincent'=>'VC', 'Sudan'=>'SD', 'Suriname'=>'SR', 'Swaziland'=>'SZ', 'Sweden'=>'SE', 'Switzerland'=>'CH', 'Syria'=>'SY', 'Taiwan'=>'TW', 'Tajikistan'=>'TJ', 'Tanzania'=>'TZ', 'Thailand'=>'TH', 'Togo'=>'TG' , 'Tonga'=>'TO' , 'Trinidad'=>'TT', 'Tunisia'=>'TN' , 'Turkey'=>'TR', 'Turkmenistan'=>'TM' , 'Turks And Caicos Isl'=>'TC'  , 'Tuvalu'=>'TV' , 'Uganda'=>'UG' , 'Ukraine'=>'UA' , 'United Arab Emirates'=>'AE' , 'United States'=>'US' , 'Uruguay'=>'UY' , 'Uzbekistan'=>'UZ' , 'Vanuatu'=>'VU' , 'Venezuela'=>'VE' , 'Vietnam'=>'VN' , 'Virgin Islands Brit'=>'VG', 'Virgin Islands U S'=>'VI', 'Yemen'=>'YE', 'Yugoslavia'=>'YU', 'Zambia'=>'ZM', 'Zimbabwe'=>'ZW'
            *********************/
            /* Old list 
            * 'Andorra'=>'AD' , 'United Arab Emirates'=>'AE' , 'Argentina'=>'AR' , 'Austria'=>'AT' , 'Australia'=>'AU' , 'Belgium'=>'BE' , 'Bulgaria'=>'BG' , 'Bahrain'=>'BH' , 'Brazil'=>'BR' , 'Canada'=>'CA' , 'Switzerland'=>'CH' , 'Chile'=>'CL' , 'China'=>'CN' , 'Cyprus'=>'CY' , 'Czech Republic'=>'CZ' , 'Germany'=>'DE' , 'Denmark'=>'DK' , 'Estonia'=>'EE' , 'Egypt'=>'EG' , 'Spain'=>'ES' , 'Finland'=>'FI' , 'France'=>'FR' , 'United Kingdom'=>'GB' , 'Greece'=>'GR' , 'Hong Kong'=>'HK' , 'Hungary'=>'HU' , 'Indonesia'=>'ID' , 'Ireland'=>'IE' , 'Israel'=>'IL' , 'India'=>'IN' , 'Iceland'=>'IS' , 'Italy'=>'IT' , 'Jordan'=>'JO' , 'Japan'=>'JP' , 'Cambodia'=>'KH' , 'Korea, Republic of'=>'KR' , 'Kuwait'=>'KW' , 'Lithuania'=>'LT' , 'Luxembourg'=>'LU' , 'Latvia'=>'LV' , 'Monaco'=>'MC' , 'Madagascar'=>'MG' , 'Malta'=>'MT' , 'Mauritius'=>'MU' , 'Malaysia'=>'MY' , 'Nambia'=>'NA' , 'Netherlands'=>'NL' , 'Norway'=>'NO' , 'Nepal'=>'NP' , 'New Zealand'=>'NZ' , 'Philippines'=>'PH' , 'Poland'=>'PL' , 'Portugal'=>'PT' , 'Romania'=>'RO' , 'Russian Federation'=>'RU' , 'Saudi Arabia'=>'SA' , 'Sweden'=>'SE' , 'Singapore'=>'SG' , 'Slovenia'=>'SI' , 'Slovakia'=>'SK' , 'Syrian Arab Republic'=>'SY' , 'Thailand'=>'TH' , 'Turkey'=>'TR' , 'Taiwan, Province of China'=>'TW' , 'Ukraine'=>'UA' , 'United States of America'=>'US' , 'Vietnam'=>'VN' , 'South Africa'=>'ZA' 
            **********************/
            
            Map<String, String> countriesMap = new Map<String, String> { 'United Kingdom'=>'GB' , 'Albania'=>'AL' , 'Algeria'=>'DZ' , 'American Samoa'=>'AS' , 'Andorra'=>'AD' , 'Angola'=>'AO', 'Anguilla'=>'AI', 'Antigua And Barbuda'=>'AG', 'Argentina'=>'AR', 'Armenia'=>'AM', 'Aruba'=>'AW', 'Australia'=>'AU', 'Austria'=>'AT', 'Azerbaijan'=>'AZ', 'Bahamas'=>'BS', 'Bahrain'=>'BH', 'Bangladesh'=>'BD', 'Barbados'=>'BB', 'Belarus'=>'BY', 'Belgium'=>'BE', 'Belize'=>'BZ', 'Benin'=>'BJ', 'Bermuda'=>'BM', 'Bhutan'=>'BT', 'Bolivia'=>'BO', 'Bosnia Herzegovina'=>'BA', 'Botswana'=>'BW', 'Brazil'=>'BR', 'Brunei Darussalam'=>'BN', 'Bulgaria'=>'BG', 'Burkina Faso'=>'BF', 'Burundi'=>'BI', 'Cambodia'=>'KH', 'Cameroon'=>'CM', 'Canada'=>'CA', 'Cape Verde'=>'CV', 'Cayman Islands'=>'KY', 'Central African Repu'=>'CF', 'Chad'=>'TD', 'Chile'=>'CL', 'China'=>'CN', 'Colombia'=>'CO', 'Comoros Islands'=>'KM', 'Congo'=>'CG', 'Congo Democratic Re'=>'CD', 'Cook Islands'=>'CK', 'Costa Rica'=>'CR', 'Cote D Ivoire'=>'CI', 'Croatia'=>'HR', 'Cuba'=>'CU', 'Cyprus'=>'CY', 'Czech Republic'=>'CZ', 'Denmark'=>'DK', 'Djibouti'=>'DJ', 'Dominica'=>'DM', 'Dominican Republic'=>'DO', 'Ecuador'=>'EC', 'Egypt'=>'EG', 'El Salvador'=>'SV', 'Equatorial Guinea'=>'GQ', 'Eritrea'=>'ER', 'Estonia'=>'EE', 'Ethiopia'=>'ET', 'Falkland Islands'=>'FK', 'Faroe Islands'=>'FO', 'Fiji'=>'FJ', 'Finland'=>'FI', 'France'=>'FR', 'French Guiana'=>'GF', 'French Polynesia'=>'PF', 'Gabon'=>'GA', 'Gambia'=>'GM', 'Georgia'=>'GE', 'Germany'=>'DE', 'Ghana'=>'GH', 'Gibraltar'=>'GI', 'Greece'=>'GR', 'Greenland'=>'GL', 'Grenada'=>'GD', 'Guadeloupe'=>'GP', 'Guam'=>'GU', 'Guatemala'=>'GT', 'Guinea'=>'GN', 'Guinea Bissau'=>'GW', 'Guyana'=>'GY', 'Haiti'=>'HT', 'Honduras'=>'HN', 'Hong Kong'=>'HK', 'Hungary'=>'HU', 'Iceland'=>'IS', 'India'=>'IN', 'Indonesia'=>'ID', 'Iran'=>'IR', 'Iraq'=>'IQ', 'Ireland'=>'IE', 'Israel'=>'IL', 'Italy'=>'IT', 'Jamaica'=>'JM', 'Japan'=>'JP', 'Jordan'=>'JO', 'Kazakhstan '=>'KZ', 'Kenya'=>'KE', 'Kiribati'=>'KI', 'Korea North'=>'KP', 'Korea South'=>'KR', 'Kosovo'=>'YK', 'Kuwait'=>'KW', 'Kyrgyzstan'=>'KG', 'Lao People S Dem Re'=>'LA', 'Latvia'=>'LV', 'Lebanon'=>'LB', 'Lesotho'=>'LS', 'Liberia'=>'LR', 'Libya'=>'LY', 'Liechtenstein'=>'LI', 'Lithuania'=>'LT', 'Luxembourg'=>'LU', 'Macau'=>'MO', 'Macedonia'=>'MK', 'Madagascar'=>'MG', 'Malawi'=>'MW', 'Malaysia'=>'MY', 'Maldives'=>'MV', 'Mali'=>'ML', 'Malta'=>'MT', 'Marshall Islands'=>'MH' , 'Martinique'=>'MQ' , 'Mauritania'=>'MR' , 'Mauritius'=>'MU' , 'Mayotte'=>'YT', 'Mexico'=>'MX' , 'Micronesia'=>'FM', 'Moldova'=>'MN' , 'Monaco'=>'MC', 'Mongolia'=>'MN' , 'Montenegro'=>'YM', 'Montenegro'=>'ME' , 'Montserrat'=>'MS', 'Morocco'=>'MA', 'Mozambique'=>'MZ', 'Myanmar'=>'MM', 'Namibia'=>'NA', 'Nauru'=>'NR', 'Nepal'=>'NP', 'Netherlands'=>'NL', 'Netherlands Antilles'=>'AN', 'New Caledonia'=>'NC', 'New Zealand'=>'NZ', 'Nicaragua'=>'NI', 'Niger'=>'NE', 'Nigeria'=>'NG', 'Norfolk Island'=>'NF', 'Northern Mariana Isl'=>'MP', 'Norway'=>'NO', 'Oman'=>'OM', 'Pakistan'=>'PK', 'Palau'=>'PW', 'Panama'=>'PA', 'Papua New Guinea'=>'PG', 'Paraguay'=>'PY', 'Peru'=>'PE', 'Philippines'=>'PH', 'Poland'=>'PL', 'Portugal'=>'PT', 'Puerto Rico'=>'PR', 'Qatar'=>'QA', 'Reunion'=>'RE', 'Romania'=>'RO', 'Russian Federation'=>'RU', 'Rwanda'=>'RW', 'Saint Lucia'=>'LC', 'Samoa'=>'WS', 'San Marino'=>'SM', 'Sao Tome And Princip'=>'ST', 'Saudi Arabia'=>'SA', 'Senegal'=>'SN', 'Serbia'=>'RS', 'Seychelles'=>'SC', 'Sierra Leone'=>'SL', 'Singapore'=>'SG', 'Slovakia'=>'SK', 'Slovenia'=>'SI', 'Solomon Islands'=>'SB', 'South Africa'=>'ZA', 'Spain'=>'ES', 'Sri Lanka'=>'LK', 'St Kitts And Nevis'=>'KN', 'St Vincent'=>'VC', 'Sudan'=>'SD', 'Suriname'=>'SR', 'Swaziland'=>'SZ', 'Sweden'=>'SE', 'Switzerland'=>'CH', 'Syria'=>'SY', 'Taiwan'=>'TW', 'Tajikistan'=>'TJ', 'Tanzania'=>'TZ', 'Thailand'=>'TH', 'Togo'=>'TG' , 'Tonga'=>'TO' , 'Trinidad'=>'TT', 'Tunisia'=>'TN' , 'Turkey'=>'TR', 'Turkmenistan'=>'TM' , 'Turks And Caicos Isl'=>'TC'  , 'Tuvalu'=>'TV' , 'Uganda'=>'UG' , 'Ukraine'=>'UA' , 'United Arab Emirates'=>'AE' , 'United States'=>'US' , 'Uruguay'=>'UY' , 'Uzbekistan'=>'UZ' , 'Vanuatu'=>'VU' , 'Venezuela'=>'VE' , 'Vietnam'=>'VN' , 'Virgin Islands Brit'=>'VG', 'Virgin Islands U S'=>'VI', 'Yemen'=>'YE', 'Yugoslavia'=>'YU', 'Zambia'=>'ZM', 'Zimbabwe'=>'ZW' };        
            
            String countryCode = '';
            if (countryString != null && countriesMap.get(countryString) != null) {
                countryCode = countriesMap.get(countryString);
            }
            
            return countryCode;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static String getThreeDigitCode(String twoDigitCode) {
        try {
            Map<String, String> twoDigitCodesMap = new Map<String, String> { 'AF'=>'AFG' , 'AX'=>'ALA' , 'AL'=>'ALB' , 'DZ'=>'DZA' , 'AS'=>'ASM' , 'AD'=>'AND' , 'AO'=>'AGO' , 'AI'=>'AIA' , 'AQ'=>'ATA' , 'AG'=>'ATG' , 'AR'=>'ARG' , 'AM'=>'ARM' , 'AW'=>'ABW' , 'AU'=>'AUS' , 'AT'=>'AUT' , 'AZ'=>'AZE' , 'BS'=>'BHS' , 'BH'=>'BHR' , 'BD'=>'BGD' , 'BB'=>'BRB' , 'BY'=>'BLR' , 'BE'=>'BEL' , 'BZ'=>'BLZ' , 'BJ'=>'BEN' , 'BM'=>'BMU' , 'BT'=>'BTN' , 'BO'=>'BOL' , 'BQ'=>'BES' , 'BA'=>'BIH' , 'BW'=>'BWA' , 'BV'=>'BVT' , 'BR'=>'BRA' , 'IO'=>'IOT' , 'BN'=>'BRN' , 'BG'=>'BGR' , 'BF'=>'BFA' , 'BI'=>'BDI' , 'KH'=>'KHM' , 'CM'=>'CMR' , 'CA'=>'CAN' , 'CV'=>'CPV' , 'KY'=>'CYM' , 'CF'=>'CAF' , 'TD'=>'TCD' , 'CL'=>'CHL' , 'CN'=>'CHN' , 'CX'=>'CXR' , 'CC'=>'CCK' , 'CO'=>'COL' , 'KM'=>'COM' , 'CG'=>'COG' , 'CD'=>'COD' , 'CK'=>'COK' , 'CR'=>'CRI' , 'CI'=>'CIV' , 'HR'=>'HRV' , 'CU'=>'CUB' , 'CW'=>'CUW' , 'CY'=>'CYP' , 'CZ'=>'CZE' , 'DK'=>'DNK' , 'DJ'=>'DJI' , 'DM'=>'DMA' , 'DO'=>'DOM' , 'EC'=>'ECU' , 'EG'=>'EGY' , 'SV'=>'SLV' , 'GQ'=>'GNQ' , 'ER'=>'ERI' , 'EE'=>'EST' , 'ET'=>'ETH' , 'FK'=>'FLK' , 'FO'=>'FRO' , 'FJ'=>'FJI' , 'FI'=>'FIN' , 'FR'=>'FRA' , 'GF'=>'GUF' , 'PF'=>'PYF' , 'TF'=>'ATF' , 'GA'=>'GAB' , 'GM'=>'GMB' , 'GE'=>'GEO' , 'DE'=>'DEU' , 'GH'=>'GHA' , 'GI'=>'GIB' , 'GR'=>'GRC' , 'GL'=>'GRL' , 'GD'=>'GRD' , 'GP'=>'GLP' , 'GU'=>'GUM' , 'GT'=>'GTM' , 'GG'=>'GGY' , 'GN'=>'GIN' , 'GW'=>'GNB' , 'GY'=>'GUY' , 'HT'=>'HTI' , 'HM'=>'HMD' , 'VA'=>'VAT' , 'HN'=>'HND' , 'HK'=>'HKG' , 'HU'=>'HUN' , 'IS'=>'ISL' , 'IN'=>'IND' , 'ID'=>'IDN' , 'IR'=>'IRN' , 'IQ'=>'IRQ' , 'IE'=>'IRL' , 'IM'=>'IMN' , 'IL'=>'ISR' , 'IT'=>'ITA' , 'JM'=>'JAM' , 'JP'=>'JPN' , 'JE'=>'JEY' , 'JO'=>'JOR' , 'KZ'=>'KAZ' , 'KE'=>'KEN' , 'KI'=>'KIR' , 'KP'=>'PRK' , 'KR'=>'KOR' , 'KW'=>'KWT' , 'KG'=>'KGZ' , 'LA'=>'LAO' , 'LV'=>'LVA' , 'LB'=>'LBN' , 'LS'=>'LSO' , 'LR'=>'LBR' , 'LY'=>'LBY' , 'LI'=>'LIE' , 'LT'=>'LTU' , 'LU'=>'LUX' , 'MO'=>'MAC' , 'MK'=>'MKD' , 'MG'=>'MDG' , 'MW'=>'MWI' , 'MY'=>'MYS' , 'MV'=>'MDV' , 'ML'=>'MLI' , 'MT'=>'MLT' , 'MH'=>'MHL' , 'MQ'=>'MTQ' , 'MR'=>'MRT' , 'MU'=>'MUS' , 'YT'=>'MYT' , 'MX'=>'MEX' , 'FM'=>'FSM' , 'MD'=>'MDA' , 'MC'=>'MCO' , 'MN'=>'MNG' , 'ME'=>'MNE' , 'MS'=>'MSR' , 'MA'=>'MAR' , 'MZ'=>'MOZ' , 'MM'=>'MMR' , 'NA'=>'NAM' , 'NR'=>'NRU' , 'NP'=>'NPL' , 'NL'=>'NLD' , 'NC'=>'NCL' , 'NZ'=>'NZL' , 'NI'=>'NIC' , 'NE'=>'NER' , 'NG'=>'NGA' , 'NU'=>'NIU' , 'NF'=>'NFK' , 'MP'=>'MNP' , 'NO'=>'NOR' , 'OM'=>'OMN' , 'PK'=>'PAK' , 'PW'=>'PLW' , 'PS'=>'PSE' , 'PA'=>'PAN' , 'PG'=>'PNG' , 'PY'=>'PRY' , 'PE'=>'PER' , 'PH'=>'PHL' , 'PN'=>'PCN' , 'PL'=>'POL' , 'PT'=>'PRT' , 'PR'=>'PRI' , 'QA'=>'QAT' , 'RE'=>'REU' , 'RO'=>'ROU' , 'RU'=>'RUS' , 'RW'=>'RWA' , 'BL'=>'BLM' , 'SH'=>'SHN' , 'KN'=>'KNA' , 'LC'=>'LCA' , 'MF'=>'MAF' , 'PM'=>'SPM' , 'VC'=>'VCT' , 'WS'=>'WSM' , 'SM'=>'SMR' , 'ST'=>'STP' , 'SA'=>'SAU' , 'SN'=>'SEN' , 'RS'=>'SRB' , 'SC'=>'SYC' , 'SL'=>'SLE' , 'SG'=>'SGP' , 'SX'=>'SXM' , 'SK'=>'SVK' , 'SI'=>'SVN' , 'SB'=>'SLB' , 'SO'=>'SOM' , 'ZA'=>'ZAF' , 'GS'=>'SGS' , 'ES'=>'ESP' , 'LK'=>'LKA' , 'SD'=>'SDN' , 'SR'=>'SUR' , 'SJ'=>'SJM' , 'SZ'=>'SWZ' , 'SE'=>'SWE' , 'CH'=>'CHE' , 'SY'=>'SYR' , 'TW'=>'TWN' , 'TJ'=>'TJK' , 'TZ'=>'TZA' , 'TH'=>'THA' , 'TL'=>'TLS' , 'TG'=>'TGO' , 'TK'=>'TKL' , 'TO'=>'TON' , 'TT'=>'TTO' , 'TN'=>'TUN' , 'TR'=>'TUR' , 'TM'=>'TKM' , 'TC'=>'TCA' , 'TV'=>'TUV' , 'UG'=>'UGA' , 'UA'=>'UKR' , 'AE'=>'ARE' , 'GB'=>'GBR' , 'US'=>'USA' , 'UM'=>'UMI' , 'UY'=>'URY' , 'UZ'=>'UZB' , 'VU'=>'VUT' , 'VE'=>'VEN' , 'VN'=>'VNM' , 'VG'=>'VGB' , 'VI'=>'VIR' , 'WF'=>'WLF' , 'EH'=>'ESH' , 'YE'=>'YEM' , 'ZM'=>'ZMB' , 'ZW'=>'ZWE' };
            
            String threeDigitCode = '';
            if (twoDigitCode != null && twoDigitCodesMap.get(twoDigitCode) != null) {
                threeDigitCode = twoDigitCodesMap.get(twoDigitCode);
            }
            
            return threeDigitCode;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    public static Boolean pcLookupSupported(String countryCode) {
        try {
            LIST<String> supportedCountryCodes = new LIST<String> { 'GB' };
            
            for (String supportedCountryCode : supportedCountryCodes) {
                if (supportedCountryCode.equals(countryCode)) {
                    return true;
                }
            }
            
            return false;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return false;
        }
    }
    
    public static void checkETLValue(IR_Consignment__c consignment) {
        if (consignment.Transit_Liability__c && consignment.National_International__c == 'International') {
            if (consignment.Type__c == 'Document' && (consignment.Estimated_Value__c <= 0 || consignment.Estimated_Value__c > 300)) {
                consignment.Estimated_Value__c = 0.00;
                consignment.Estimated_Value__c.addError('Enhanced liability for documents is not available for values greater than £300. Please enter a value between £1 and £300');
            } else if (consignment.Estimated_Value__c <= 0 || consignment.Estimated_Value__c > 15000){
                consignment.Estimated_Value__c = 0.00;
                consignment.Estimated_Value__c.addError('Enhanced liability for non-documents is not available for values greater than £15,000. Please enter a value between £1 and £15,000');
            }
        }
    }

    public static Decimal getETLValue(String etlSelection) {
        if (etlSelection == null) {
            return 0;
        } else if (etlSelection.equals('£5,000')) {
            return 5000;
        } else if (etlSelection.equals('£10,000')) {
            return 10000;
        } else if (etlSelection.equals('£15,000')) {
            return 15000;
        } else {
            return 0;
        }
    }
    
    public static List<SelectOption> accountETLOptions {
        get {
            List<SelectOption> etlOptions = new List<SelectOption>();
            etlOptions.add(new SelectOption('', '-- Please Select --'));
            
            for (Schema.PicklistEntry etlValue : IR_Customer__c.Extended_Transit_Liability_Setting__c.getDescribe().getPicklistValues()) {              
                etlOptions.add(new SelectOption(etlValue.getValue(), etlValue.getLabel()));
            }
            
            return etlOptions;
        }
    }
    
    public static String roundHalfUp(Decimal value) {
        try {
            value = value.setScale(1);
            String[] valueSplit = value.toPlainString().split('\\.');
            
            if (valueSplit.size() == 2) {
                Integer valueDec = Integer.valueOf(valueSplit[1]);
                Integer whole = Integer.valueOf(valueSplit[0]);
                Integer dec;
                
                if (valueDec == 0) {
                    dec = 0;
                } else if (valueDec == 5) {
                    dec = 5;
                } else if (valueDec > 5) {
                    dec = 0;
                    whole++;
                } else {
                    dec = 5;
                }
                
                if (dec == null) {
                    return String.valueOf(whole + '.' + 0);
                } else {
                    return String.valueOf(whole + '.' + dec);
                }
            }
            
            return '';
        } catch (Exception e) {
            System.debug(e);
            
            return '';
        }
    }
    
    /******************TEST METHODS********************/
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
        To_Country__c = 'United Kingdom',
        From_Country__c = 'United Kingdom',
        Order_IR__c=testOrder.Id,
        From_Postcode__c='SE10HS',
        To_Postcode__c='SE10HS',
        Type__c='Document',     
        Transit_Liability__c = true,          
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
        List<Id> cID = new List<Id>();
        cID.add(testCust.Id);
        IR_Global_Class.getCustomer(cID);
        System.debug(IR_Global_Class.getCustomersExperienceQueueId());
                       
        testOrder = IR_Global_Class.getOrder(testOrder.Id);
        List<Id> oID = new List<Id>();
        oID.add(testOrder.Id);
        System.debug(IR_Global_Class.getOrders(oID));               
        
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        List<Id> cnID = new List<Id>();
        cnID.add(testCon.Id);
        System.debug(IR_Global_Class.getConsignments(cnID));
        System.debug(IR_Global_Class.getConsignmentsByOrder(testOrder.Id));
        System.debug(IR_Global_Class.getConsignmentsByOrder(oID));
        
        pac = IR_Global_Class.getPackage(pac.Id);
        List<Id> pcID = new List<Id>(); 
        pcID.add(pac.Id);
        System.debug(IR_Global_Class.getPackages(pcID));
        System.debug(IR_Global_Class.getPackagesByConsignment(testCon.Id));
        List<IR_Consignment__c> consignments = new List<IR_Consignment__c>();
        consignments.add(testCon);          
        System.debug(IR_Global_Class.getConsignmentBundles(consignments));
        
        System.debug(IR_Global_Class.encodeXML('NAME'));
        System.debug(IR_Global_Class.validatePostcode('SE10HS'));
        System.debug(IR_Global_Class.requiresPostcode('IE'));
        System.debug(IR_Global_Class.formatPostcode('E126UE'));
        IR_Consignment_Bundle bundle = new IR_Consignment_Bundle(testCon);      
        System.debug(IR_Global_Class.createRequest(bundle));
        IR_Global_Class.RateCheckRequest rt = new IR_Global_Class.RateCheckRequest();
        System.debug(rt.weight);        
        System.debug(rt.rateAccount);
        System.debug(rt.domestic);
        System.debug(rt.rateId); 
        List<IR_Consignment_Bundle> bundleList = new List<IR_Consignment_Bundle>();
        bundleList.add(bundle);     
        System.debug(IR_Global_Class.convertToMetric(bundleList));    
        System.debug(IR_Global_Class.inchTocm(10.00));      
        System.debug(IR_Global_Class.lbTokg(10.00));
        List<String> numList = new List<String>();
        numList.add('10');
        numList.add('14');
        numList.add('17');
        System.debug(IR_Global_Class.sortByTime(numList));
        String str = '12';
        System.debug(IR_Global_Class.startsWithNumber(str));
        
        try{
            IR_Global_Class.getStartNumber(str);        
        System.debug(IR_Global_Class.getStartNumberString(str));
        }catch(Exception e){
            System.debug(e);
        }
        System.debug(IR_Global_Class.isNumber(str));
        try{
        System.debug(IR_Global_Class.rateCheck(bundle));
        }catch(Exception e){
            System.debug(e);
        }
        try{
        System.debug(IR_Global_Class.makeBooking(testCust, testOrder, testCon));
        }catch(Exception e){
            System.debug(e);
        }
        try{
        System.debug(IR_Global_Class.getQuote(testOrder, bundleList));
        }catch(Exception e){
            System.debug(e);
        }       
        System.debug(IR_Global_Class.getRatesandContactsQueueId());
        System.debug(IR_Global_Class.getNewCustomersQueueId());
        IR_Global_Class.logIRError('tetsERR', 'test method');       
        System.debug(IR_Global_Class.formatTel('+44020567897'));
        System.debug(IR_Global_Class.urlEncodeXML('<?xml version="1.0" encoding="UTF-8"?><external-registration-response> <status>FAILURE</status> -<errors> <error ref="300">Account number must be a valid numeric value</error> <error ref="300">Account number must be a valid numeric value</error> </errors> </external-registration-response>'));
        List<String> cnt = new List<String>();
        cnt.add('Andorra');
        cnt.add('United Arab Emirates');
        cnt.add('Argentina');
        cnt.add('Austria');
        cnt.add('Australia');
        cnt.add('Belgium');
        cnt.add('Bulgaria');
        cnt.add('Bahrain');
        cnt.add('Brazil');
        cnt.add('Canada');
        cnt.add('Switzerland');
        cnt.add('Chile');
        cnt.add('China');
        cnt.add('Cyprus');
        cnt.add('Czech Republic');
        cnt.add('Germany');
        cnt.add('Denmark');
        cnt.add('Estonia');
        cnt.add('Egypt');
        cnt.add('Spain');
        cnt.add('Finland');
        cnt.add('France');
        cnt.add('United Kingdom');
        cnt.add('Greece');
        cnt.add('Hong Kong');
        cnt.add('Hungary');
        cnt.add('Indonesia');
        cnt.add('Ireland');
        cnt.add('Israel');
        cnt.add('India');
        cnt.add('Iceland');
        cnt.add('Italy');
        cnt.add('Jordan');
        cnt.add('Japan');
        cnt.add('Cambodia');
        cnt.add('Korea, Republic of');
        cnt.add('Kuwait');
        cnt.add('Lithuania');
        cnt.add('Luxembourg');
        cnt.add('Latvia');
        cnt.add('Monaco');
        cnt.add('Madagascar');
        cnt.add('Malta');
        cnt.add('Mauritius');
        cnt.add('Malaysia');
        cnt.add('Nambia');
        cnt.add('Netherlands');
        cnt.add('Norway');
        cnt.add('Nepal');
        cnt.add('New Zealand');
        cnt.add('Philippines');
        cnt.add('Poland');
        cnt.add('Portugal');
        cnt.add('Romania');
        cnt.add('Russian Federation');
        cnt.add('Saudi Arabia');
        cnt.add('Sweden');
        cnt.add('Singapore');
        cnt.add('Slovenia');
        cnt.add('Slovakia');
        cnt.add('Syrian Arab Republic');
        cnt.add('Thailand');
        cnt.add('Turkey');
        cnt.add('Taiwan, Province of China');
        cnt.add('Ukraine');
        cnt.add('United States of America');
        cnt.add('Vietnam');
        cnt.add('South Africa');
        cnt.add('blah blah');       
    List<String> code = new List<String>();
    code.add(null);
    code.add('DE1');
        for(String country : cnt){
                        
            code.add(IR_Global_Class.getCountryCode(country));  
        }           
        code.add('JE');
        code.add('KZ');
        code.add('YE');
        code.add('ZW');
        code.add('AF');                 
        code.add('AX');
        code.add('AL');
        code.add('DZ');
        code.add('AS');
        code.add('AO');
        code.add('AI');
        code.add('AQ');
        code.add('AG');
        code.add('AM');
        code.add('AW');
        code.add('AZ');
        code.add('BS');
        code.add('BD');
        code.add('BB');
        code.add('BY');
        code.add('BZ');
        code.add('BJ');                 
        code.add('BM');
        code.add('BT');
        code.add('BO');
        code.add('BQ');
        code.add('BA');
        code.add('BW');
        code.add('BV');
        code.add('IO');
        code.add('BN');
        code.add('BF');
        code.add('BI');
        code.add('CM');
        code.add('CV');
        code.add('KY');
        code.add('CF');
        code.add('TD');
        code.add('CX');
        code.add('CC');
        code.add('CO');
        code.add('KM');
        code.add('CG');
        code.add('CD');
        code.add('CK');
        code.add('CR');
        code.add('CI');
        code.add('HR');
        code.add('CU');
        code.add('CW');
        code.add('DJ');
        code.add('DM');
        code.add('DO');
        code.add('EC');
        code.add('SV');
        code.add('GQ');
        code.add('ER');
        code.add('ET');
        code.add('FK');
        code.add('FO');
        code.add('FJ');
        code.add('GF');
        code.add('PF');
        code.add('TF');
        code.add('GA');
        code.add('GM');
        code.add('GE');
        code.add('GH');
        code.add('GI');
        code.add('GL');
        code.add('GD');
        code.add('GP');
        code.add('GU');
        code.add('GT');
        code.add('GG');
        code.add('GN');
        code.add('GW');
        code.add('GY');
        code.add('HT');
        code.add('HM');
        code.add('VA');
        code.add('HN');
        code.add('IR');
        code.add('IQ');
        code.add('IM');
        code.add('JM');
        code.add('KE');
        code.add('KI');
        code.add('KP');
        code.add('KG');
        code.add('LA');
        code.add('LB');
        code.add('LS');
        code.add('LR');
        code.add('LY');
        code.add('LI');
        code.add('MO');
        code.add('MK');
        code.add('MG');
        code.add('MW');
        code.add('MY');
        code.add('MV');     
        code.add('ML');
        code.add('MH');
        code.add('MQ');
        code.add('MR');
        code.add('YT');
        code.add('MX');
        code.add('FM');
        code.add('MD');
        code.add('MN');
        code.add('ME');
        code.add('MS');
        code.add('MA');
        code.add('MZ');
        code.add('MM');
        code.add('NR');
        code.add('NC');
        code.add('NI');
        code.add('NE');
        code.add('NG');
        code.add('NU');
        code.add('NF');
        code.add('MP');
        code.add('OM');
        code.add('PK');
        code.add('PW');
        code.add('PS');
        code.add('PA');
        code.add('PG');
        code.add('PY');
        code.add('PE');
        code.add('PN');
        code.add('PR');
        code.add('QA');
        code.add('RE');
        code.add('RW');
        code.add('BL');
        code.add('SH');
        code.add('KN');
        code.add('LC');
        code.add('MF');
        code.add('PM');
        code.add('VC');
        code.add('WS');
        code.add('SM');
        code.add('ST');
        code.add('SN');
        code.add('RS');
        code.add('SC');
        code.add('SL');
        code.add('SX');
        code.add('SB');
        code.add('SO');
        code.add('GS');
        code.add('LK');
        code.add('SD');
        code.add('SR');
        code.add('SJ');
        code.add('SZ');
        code.add('TJ');
        code.add('TZ');
        code.add('TL');
        code.add('TG');
        code.add('TK');
        code.add('TO');
        code.add('TT');
        code.add('TN');
        code.add('TM');
        code.add('TC');
        code.add('TV');
        code.add('UG');
        code.add('UM');
        code.add('UY');
        code.add('UZ');
        code.add('VU');
        code.add('VE');
        code.add('VG');
        code.add('VI');
        code.add('WF');
        code.add('EH');
        code.add('EH');
        code.add('ZM');
        code.add('ZM');
        code.add('17');                 
        for(String countryCode:code){
            System.debug(IR_Global_Class.getCountryString(countryCode));
            System.debug(IR_Global_Class.getThreeDigitCode(countryCode));
            System.debug(IR_Global_Class.pcLookupSupported(countryCode));   
        }               
        IR_Global_Class.checkETLValue(testCon);
        List<String> etl = new List<String>();
        etl.add(null);
        etl.add('£5,000');
        etl.add('£10,000');
        etl.add('£15,000');
        for(String val:etl){
            System.debug(IR_Global_Class.getETLValue(val)); 
        }
        IR_Global_Class.RateCheckResult rateCheckResult = new IR_Global_Class.RateCheckResult();
        
        IR_Global_Class.RateCheckError  rateCheckError = new IR_Global_Class.RateCheckError();
        
        IR_Global_Class.RateCheckRate rate = new IR_Global_Class.RateCheckRate();
        
        
        rateCheckError.message = 'test message';
        rateCheckError.code = 'Test Code string';
        rateCheckResult.addError(rateCheckError);       
        rateCheckResult.addRate(rate);
        System.debug(rateCheckResult.combinedRates);
        System.debug(rateCheckResult.errors);
        System.debug(rateCheckResult.orderedCombinedRates);
        System.debug(rateCheckResult.bestRate);
        IR_Global_Class.BookResult res = new IR_Global_Class.BookResult();      
        IR_Global_Class.QueueCustomer qu = new IR_Global_Class.QueueCustomer(testCust);     
        /*System.debug(qu.showAmber);
        System.debug(qu.showGreen);
        System.debug(qu.showRed);*/
        
        IR_Global_Class.TelephoneField tel = new IR_Global_Class.TelephoneField();
        
        //System.debug(tel.telephoneField('+44 020 123456'));
        System.debug(tel.countryCode = '+44');
        System.debug(tel.phoneNumber='123456');
        System.debug(tel.plainStd='(0)20');
        System.debug(tel.plainStd);
        System.debug(tel.std='020');
        System.debug(tel.format);               
        
        System.debug(IR_Global_Class.withinWorkingHours);
        IR_Global_Class.checkETLValue(testCon);
    }
    
      TestMethod static void test_all_Excp(){
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
        try{
        testCust = IR_Global_Class.getCustomer(testCust.Id);
        }catch(Exception e){
            System.debug(e);
        }
        List<Id> cID = new List<Id>();
        try{
        cID.add(testCust.Id);
        }catch(Exception e){
            System.debug(e);
        }
        try{
        IR_Global_Class.getCustomer(cID);
        }catch(Exception e){
            System.debug(e);
        }
        System.debug(IR_Global_Class.getCustomersExperienceQueueId());
        try{              
        testOrder = IR_Global_Class.getOrder(testOrder.Id);
        }catch(Exception e){
            System.debug(e);
        }
        List<Id> oID = new List<Id>();
        oID.add(testOrder.Id);
        try{
        System.debug(IR_Global_Class.getOrders(oID));
        }catch(Exception e){
            System.debug(e);
        }               
        try{
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        }catch(Exception e){
            System.debug(e);
        }
        List<Id> cnID = new List<Id>();
        cnID.add(testCon.Id);
        try{
        System.debug(IR_Global_Class.getConsignments(cnID));
        }catch(Exception e){
            System.debug(e);
        }
        try{
        System.debug(IR_Global_Class.getConsignmentsByOrder(testOrder.Id));
        }catch(Exception e){
            System.debug(e);
        }
        try{
        System.debug(IR_Global_Class.getConsignmentsByOrder(oID));
        }catch(Exception e){
            System.debug(e);
        }
        try{
        pac = IR_Global_Class.getPackage(pac.Id);
        }catch(Exception e){
            System.debug(e);
        }
        List<Id> pcID = new List<Id>(); 
        pcID.add(pac.Id);
        try{
        System.debug(IR_Global_Class.getPackages(pcID));
        }catch(Exception e){
            System.debug(e);
        }
        try{
        System.debug(IR_Global_Class.getPackagesByConsignment(testCon.Id));
        }catch(Exception e){
            System.debug(e);
        }
        List<IR_Consignment__c> consignments = new List<IR_Consignment__c>();
        consignments.add(testCon);
        try{            
        System.debug(IR_Global_Class.getConsignmentBundles(consignments));
        }catch(Exception e){
            System.debug(e);
        }
        
        System.debug(IR_Global_Class.encodeXML('NAME'));
        System.debug(IR_Global_Class.validatePostcode('SE10HS'));
        System.debug(IR_Global_Class.requiresPostcode('IE'));
        System.debug(IR_Global_Class.formatPostcode('E126UE'));
        IR_Consignment_Bundle bundle = new IR_Consignment_Bundle(testCon);      
        System.debug(IR_Global_Class.createRequest(bundle));
        IR_Global_Class.RateCheckRequest rt = new IR_Global_Class.RateCheckRequest();
        System.debug(rt.weight);        
        System.debug(rt.rateAccount);
        System.debug(rt.domestic);
        System.debug(rt.rateId); 
        List<IR_Consignment_Bundle> bundleList = new List<IR_Consignment_Bundle>();
        bundleList.add(bundle);     
        System.debug(IR_Global_Class.convertToMetric(bundleList));    
        System.debug(IR_Global_Class.inchTocm(10.00));      
        System.debug(IR_Global_Class.lbTokg(10.00));
        List<String> numList = new List<String>();
        numList.add('10');
        numList.add('14');
        numList.add('17');
        System.debug(IR_Global_Class.sortByTime(numList));
        String str = '12';
        System.debug(IR_Global_Class.startsWithNumber(str));
        //IR_Global_Class.getStartNumber(str);
        System.debug(IR_Global_Class.getStartNumberString(str));
        System.debug(IR_Global_Class.isNumber(str));
        
        //System.debug(IR_Global_Class.rateCheck(bundle));
        //System.debug(IR_Global_Class.makeBooking(testCust, testOrder, testCon));
        
        //System.debug(IR_Global_Class.getQuote(testOrder, bundleList));        
        System.debug(IR_Global_Class.getRatesandContactsQueueId());
        System.debug(IR_Global_Class.getNewCustomersQueueId());
        IR_Global_Class.logIRError('tetsERR', 'test method');       
        System.debug(IR_Global_Class.formatTel('+44020567897'));
        System.debug(IR_Global_Class.urlEncodeXML('<?xml version="1.0" encoding="UTF-8"?><external-registration-response> <status>FAILURE</status> -<errors> <error ref="300">Account number must be a valid numeric value</error> <error ref="300">Account number must be a valid numeric value</error> </errors> </external-registration-response>'));
        List<String> cnt = new List<String>();
        cnt.add('Andorra');
        cnt.add('United Arab Emirates');
        cnt.add('Argentina');
        cnt.add('Austria');
        cnt.add('Australia');
        cnt.add('Belgium');
        cnt.add('Bulgaria');
        cnt.add('Bahrain');
        cnt.add('Brazil');
        cnt.add('Canada');
        cnt.add('Switzerland');
        cnt.add('Chile');
        cnt.add('China');
        cnt.add('Cyprus');
        cnt.add('Czech Republic');
        cnt.add('Germany');
        cnt.add('Denmark');
        cnt.add('Estonia');
        cnt.add('Egypt');
        cnt.add('Spain');
        cnt.add('Finland');
        cnt.add('France');
        cnt.add('United Kingdom');
        cnt.add('Greece');
        cnt.add('Hong Kong');
        cnt.add('Hungary');
        cnt.add('Indonesia');
        cnt.add('Ireland');
        cnt.add('Israel');
        cnt.add('India');
        cnt.add('Iceland');
        cnt.add('Italy');
        cnt.add('Jordan');
        cnt.add('Japan');
        cnt.add('Cambodia');
        cnt.add('Korea, Republic o');
        cnt.add('Kuwait');
        cnt.add('Lithuania');
        cnt.add('Luxembourg');
        cnt.add('Latvia');
        cnt.add('Monaco');
        cnt.add('Madagascar');
        cnt.add('Malta');
        cnt.add('Mauritius');
        cnt.add('Malaysia');
        cnt.add('Nambia');
        cnt.add('Netherlands');
        cnt.add('Norway');
        cnt.add('Nepal');
        cnt.add('New Zealand');
        cnt.add('Philippines');
        cnt.add('Poland');
        cnt.add('Portugal');
        cnt.add('Romania');
        cnt.add('Russian Federation');
        cnt.add('Saudi Arabia');
        cnt.add('Sweden');
        cnt.add('Singapore');
        cnt.add('Slovenia');
        cnt.add('Slovakia');
        cnt.add('Syrian Arab Republic');
        cnt.add('Thailand');
        cnt.add('Turkey');
        cnt.add('Taiwan, Province of China');
        cnt.add('Ukraine');
        cnt.add('United States of America');
        cnt.add('Vietnam');
        cnt.add('South Africa');
        cnt.add('blah blah');       
    List<String> code = new List<String>();
        for(String country : cnt){
                        
            code.add(IR_Global_Class.getCountryCode(country));  
        }                               
        for(String countryCode:code){
            System.debug(IR_Global_Class.getCountryString(countryCode));
            System.debug(IR_Global_Class.getThreeDigitCode(countryCode));
            System.debug(IR_Global_Class.pcLookupSupported(countryCode));   
        }               
        IR_Global_Class.checkETLValue(testCon);
        List<String> etl = new List<String>();
        etl.add(null);
        etl.add('£5,000');
        etl.add('£10,000');
        etl.add('£15,000');
        for(String val:etl){
            System.debug(IR_Global_Class.getETLValue(val)); 
        }       
    }   
}