/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testTriggerclass {

    static testMethod void testAddressTrigger() 
    {
        // Address__c - Address_set_Address_Reference 
        Account CustomerCompany = new Account(Name = 'cc', 
                                              Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
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
        
        // Address with same Name
        Address__c AddSameName = new Address__c(Name = 'test', 
                                                Customer_Company__c = CustomerCompany.Id,
                                                Company_Name__c = 'company',
                                                Post_Code__c = 'B79 9EY',
                                                Address_1__c = 'street',
                                                Town__c = 'town',
                                                Country__c = 'United Kingdom',
                                                Tel_No__c = '123',
                                                Contact_Name__c = 'contact'); 
        try
        {
            insert AddSameName;
        }
        catch (Exception e)
        {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('Name'));
            System.Assert(e.getMessage().contains('Address Reference has to be unique'));
        }
        
        // BULK
        List<Address__c> AddressList = new List<Address__c>();
        Integer i = 0;
        while (i < 200)
        {
            i++;
            AddressList.add(new Address__c( Name = 'test' + i, 
                                            Customer_Company__c = CustomerCompany.Id,
                                            Company_Name__c = 'company',
                                            Post_Code__c = 'B79 9EY',
                                            Address_1__c = 'street',
                                            Town__c = 'town',
                                            Country__c = 'United Kingdom',
                                            Tel_No__c = '123',
                                            Contact_Name__c = 'contact') );
        }
        AddressList.add(new Address__c( Name = 'test4', 
                                        Customer_Company__c = CustomerCompany.Id,
                                        Company_Name__c = 'company',
                                        Post_Code__c = 'B79 9EY',
                                        Address_1__c = 'street',
                                        Town__c = 'town',
                                        Country__c = 'United Kingdom',
                                        Tel_No__c = '123',
                                        Contact_Name__c = 'contact') );
        try
        {
            insert AddressList;
        }
        catch (Exception e)
        {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('Name'));
            System.Assert(e.getMessage().contains('Address Reference has to be unique'));
        }
    }
    
    static testMethod void testSKUTrigger() 
    {
        // SKU__c - rename_SKU_Name - setStatusInformation 
        Account CustomerCompany = new Account(Name = 'cc', 
                                              Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        
        SKU__c sku = new SKU__c(Customer_Company__c = CustomerCompany.Id,
                                Style_Number__c = '12',
                                Packaging_Type__c = 'Blank');
        insert sku;
        
        // Assertion
        SKU__c assertSku = [SELECT Name, Packaging_Type__c FROM SKU__c WHERE Id =: sku.Id];
        System.assertEquals('Blank', assertSku.Packaging_Type__c);
        
        // Update - setStatusInformation
        sku.Transfer_Status__c = 'Completed-Transfer';  
        sku.batch__c = false;
        update sku;
        
        // Assertion
        assertSku = [SELECT Transfer_Status__c, Change_Status__c FROM SKU__c WHERE Id =: sku.Id];
        System.assertEquals('Pending-Transfer', assertSku.Transfer_Status__c);
        System.assertEquals('U', assertSku.Change_Status__c);
        
        // BULK
        List<SKU__c> SKUList = new List<SKU__c>();
        Integer i = 0;
        while (i < 200)
        {
            i++;    
            SKUList.add(new SKU__c( Customer_Company__c = CustomerCompany.Id,
                                    Style_Number__c = String.valueOf(i),
                                    Style_Suffix__c = String.valueOf(i),
                                    Size_Dimension__c = String.valueOf(i),
                                    Packaging_Type__c = 'BlankAgain'));
        }
        insert SKUList;
        
        while (i < 100)
        {
            i++;    
            SKU__c oneSku = SKUList.get(i);
            oneSku.Transfer_Status__c = 'Completed-Transfer';
            oneSku.batch__c = false;
        }
        update SKUList;     
    }
}