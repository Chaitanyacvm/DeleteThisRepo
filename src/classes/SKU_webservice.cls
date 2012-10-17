global class SKU_webservice 
{
    webservice static List<SKU__c> getSKUs() 
    {
        try
        {
            List<SKU__c> sku = [Select s.batch__c, s.UPC_Barcode__c, s.Transfer_Status__c, s.SystemModstamp, 
                                       s.Style__c, s.Style_Suffix__c, s.Style_Number__c, s.Style_Description__c, 
                                       s.Size_Dimension__c, s.Packaging_Type__c, s.Name, s.LastModifiedDate, 
                                       s.LastModifiedById, s.IsDeleted, s.Id, 
                                       s.Customer_Company__r.Customer_Company_Name__c, s.Customer_Company__r.Name, 
                                       s.Customer_Company__c, s.CreatedDate, s.CreatedById, s.Colour_Suffix__c, 
                                       s.Colour_Description__c, s.Change_Status__c 
                                  From SKU__c s         
                                  Where s.Transfer_Status__c = 'Pending-Transfer'
                                  Order by s.Change_Status__c];
            if(GeneralException.testException)
                throw new GeneralException('TEST');
            return sku;
        }
        catch (Exception e)
        {
            return null;
        }
    }
    
    webservice static boolean setSequenceNumber(List<String> IDs)
    {
        List<String> skuIDs = new List<String>(); 
        List<String> externalIDs = new List<String>();
        List<String> split;
        
        for (String id : IDs)
        {
            split = id.split(';');
            skuIDs.add(split.get(0));
            externalIDs.add(split.get(1));
        }
        System.Debug('===> ' + skuIDs);
        System.Debug('===> ' + externalIDs);
        
        try
        {
            List<SKU__c> skuList = [Select s.batch__c, s.UPC_Barcode__c, s.Transfer_Status__c, 
            							   s.Boomi_Sequence_Number__c,
                                           s.SystemModstamp, s.Style__c, s.Style_Suffix__c, 
                                           s.Style_Number__c, s.Style_Description__c, s.Size_Dimension__c, 
                                           s.Packaging_Type__c, s.Name, s.LastModifiedDate, s.LastModifiedById, 
                                           s.IsDeleted, s.Id, s.Customer_Company__c, s.CreatedDate, 
                                           s.CreatedById, s.Colour_Suffix__c, s.Colour_Description__c, 
                                           s.Change_Status__c 
                                      From SKU__c s
                                     Where Id IN: skuIDs];
                                     
            for (Integer i = 0; i < skuList.size(); i++)
            {
                skuList.get(i).Boomi_Sequence_Number__c = externalIDs.get(i);
                skuList.get(i).Transfer_Status__c = 'Completed-Transfer';
                skuList.get(i).batch__c = true;
            }
            
            System.Debug('===> ' + skuList);
            update skuList;
            if(GeneralException.testException)
                throw new GeneralException('TEST');
            return true;
        }
        catch (Exception e)
        {
            return false;
        }
    }
    
    // Tests   
    static testMethod void testWSgetSKUs() 
    {
        // create objects
        List<SKU__c> skuList = new List<SKU__c>();
        
        // execute methods
        test.startTest();
        skuList = getSKUs();
        
        // assert
        System.assertNotEquals(null, skuList);
        
        //-----
        // exception handling 
        GeneralException.testException = true;
        
        // execute methods
        skuList = getSKUs();
        
        // assert
        System.assertEquals(null, skuList);
        test.stopTest();
    }
    
    static testMethod void testWSsetSequenceNumber() 
    {        
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                              Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        
        SKU__c sku = new SKU__c(Customer_Company__c = CustomerCompany.Id,
                                Style_Number__c = '12',
                                Packaging_Type__c = 'Blank');
        insert sku;
        
        List<String> IDs = new List<String>();
        IDs.add(sku.Id + ';' + 'Boomi Sequence Number');
        boolean ws = false;
        
        // execute methods
        test.startTest();
        ws = setSequenceNumber(IDs);
        
        // assert
        SKU__c assertSKU = [SELECT Boomi_Sequence_Number__c FROM SKU__c WHERE Id =: sku.Id];
        System.assertEquals('Boomi Sequence Number', assertSKU.Boomi_Sequence_Number__c);
        
        //-----
        // exception handling 
        GeneralException.testException = true;
        
        // execute methods
        ws = setSequenceNumber(IDs);
        
        // assert
        System.assertEquals(ws, false);
        test.stopTest();
    }
}