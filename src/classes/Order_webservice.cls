global class Order_webservice 
{
    webservice static List<Order__c> getOrders() 
    {
        try
        {
            List<Order__c> order = [Select o.Transfer_Status__c, o.SystemModstamp, o.Start_Ship_Date__c, 
                                           o.Special_Instructions__c, o.Sold_to__r.Country__c, 
                                           o.Sold_to__r.Address_Description__c, 
                                           o.Sold_to__r.Customer_Company__c, o.Sold_to__r.Company_Name__c, 
                                           o.Sold_to__r.Contact_Name__c, o.Sold_to__r.Tel_No__c, 
                                           o.Sold_to__r.Address_3__c, o.Sold_to__r.Address_2__c, 
                                           o.Sold_to__r.Address_1__c, o.Sold_to__r.Post_Code__c, 
                                           o.Sold_to__r.Country_de__c, o.Sold_to__r.Town__c, o.Sold_to__r.Country_Code__c,
                                           o.Sold_to__r.SystemModstamp, o.Sold_to__r.LastModifiedById, 
                                           o.Sold_to__r.LastModifiedDate, o.Sold_to__r.CreatedById, 
                                           o.Sold_to__r.CreatedDate, o.Sold_to__r.Name, 
                                           o.Sold_to__r.IsDeleted, o.Sold_to__r.Id, o.Sold_to__c, 
                                           o.Sold_to__r.State__c, o.Sold_to__r.State_Code__c, 
                                           o.Ship_to__r.Country__c, o.Ship_to__r.Address_Description__c, o.Ship_to__r.Country_Code__c,
                                           o.Ship_to__r.Customer_Company__c, o.Ship_to__r.Company_Name__c, 
                                           o.Ship_to__r.Contact_Name__c, o.Ship_to__r.Tel_No__c, 
                                           o.Ship_to__r.Address_3__c, o.Ship_to__r.Address_2__c, 
                                           o.Ship_to__r.Address_1__c, o.Ship_to__r.Post_Code__c, 
                                           o.Ship_to__r.Country_de__c, o.Ship_to__r.Town__c, 
                                           o.Ship_to__r.SystemModstamp, o.Ship_to__r.LastModifiedById, 
                                           o.Ship_to__r.LastModifiedDate, o.Ship_to__r.CreatedById, 
                                           o.Ship_to__r.CreatedDate, o.Ship_to__r.Name, 
                                           o.Ship_to__r.IsDeleted, o.Ship_to__r.Id, o.Ship_to__c, 
                                           o.Ship_to__r.State__c, o.Ship_to__r.State_Code__c,
                                           o.RecordTypeId, o.Number_Order_Items__c, o.Name, 
                                           o.LastModifiedDate, o.LastModifiedById, o.IsDeleted, o.Id, 
                                           o.Customer_Company__r.Customer_Company_Name__c, 
                                           o.Customer_Company__r.Name, o.Customer_Company__c, 
                                           o.CreatedDate, o.CreatedById, o.Change_Status__c, 
                                           (Select Id, IsDeleted, Name, CreatedDate, CreatedById, 
                                                   LastModifiedDate, LastModifiedById, SystemModstamp, 
                                                   Order__c, SKU__c, Order_Item_Number__c, Quantity__c 
                                              From Order_Items__r)
                                      From Order__c o  
                                     Where Number_Order_Items__c > 0
                                       And Transfer_Status__c = 'Pending-Transfer'
                                  Order by o.Customer_Company__c];
            if(GeneralException.testException)
                throw new GeneralException('TEST');
            return order;
        }
        catch (Exception e)
        {
            return null;
        }
    }
    
    webservice static boolean setSequenceNumber(List<String> IDs)
    {
        List<String> orderIDs = new List<String>(); 
        List<String> externalIDs = new List<String>();
        List<String> split;
        
        for (String id : IDs)
        {
            split = id.split(';');
            orderIDs.add(split.get(0));
            externalIDs.add(split.get(1));
        }
        
        try
        {
            List<Order__c> orderList = [Select o.Transfer_Status__c, o.SystemModstamp, o.Start_Ship_Date__c, 
                                               o.Special_Instructions__c, o.Sold_to__c, o.Ship_to__c, 
                                               o.RecordTypeId, o.Number_Order_Items__c, o.Name, 
                                               o.LastModifiedDate, o.LastModifiedById, o.IsDeleted, 
                                               o.Id, o.Customer_Company__c, o.CreatedDate, o.CreatedById, 
                                               o.Change_Status__c, o.batch__c
                                          From Order__c o
                                         Where Id IN: orderIDs];
                                     
            for (Integer i = 0; i < orderList.size(); i++)
            {
                orderList.get(i).Boomi_Sequence_Number__c = externalIDs.get(i);
                orderList.get(i).Transfer_Status__c = 'Completed-Transfer';
                orderList.get(i).batch__c = true;
            }
            
            update orderList;
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
    static testMethod void testThis() 
    {
        // create objects
        List<Order__c> orderList = new List<Order__c>();
        
        // execute methods
        test.startTest();
        orderList = getOrders();
        
        // assert
        System.assertNotEquals(null, orderList);

        //-----
        // exception handling 
        GeneralException.testException = true;
        
        // execute methods
        orderList = getOrders();
        
        // assert
        System.assertEquals(null, orderList);
    }
    
    static testMethod void testWSsetSequenceNumber() 
    {        
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                              Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        List<String> IDs = new List<String>();
        IDs.add(order.Id + ';' + 'Boomi Sequence Number');
        boolean ws = false;
        
        // execute methods
        test.startTest();
        ws = setSequenceNumber(IDs);
        
        // assert
        Order__c assertOrder = [SELECT Boomi_Sequence_Number__c FROM Order__c WHERE Id =: order.Id];
        System.assertEquals('Boomi Sequence Number', assertOrder.Boomi_Sequence_Number__c);
        
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