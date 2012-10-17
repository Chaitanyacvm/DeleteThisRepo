global class Order_Global_Methods {
    public static Order__c Order_Done(Order__c order) 
    {
        order.RecordTypeId = Order__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Locked Order').getRecordTypeId();
        order.Transfer_Status__c = 'Pending-Transfer';
        order.Change_Status__c = 'C';
        //order.OwnerId = [SELECT Id FROM User WHERE Name = 'Transfer User' LIMIT 1].Id;
        
        update order;

        return order;
    }
    
    public static boolean exist_Order_Items(Order__c order)
    {
        if(order.Number_Order_Items__c == 0)
            return false;
        else
            return true;
    }
}