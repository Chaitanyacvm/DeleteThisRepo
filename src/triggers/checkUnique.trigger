trigger checkUnique on Order_Item__c (before insert) 
{

    //create set of existing SKU-Id's relating to Customer Companies
    Set<Id> existingOrderItems = new Set<Id>();
    
    //add Id's
    for (Order_Item__c item : trigger.new)
    {
        existingOrderItems.add(item.Order__c);
    } 
    
    //Select all existing SKU-Ids for orders  
    Map<Id, Order_Item__c> ItemSKU = new Map<Id, Order_Item__c>([Select SKU__c
                                                               From Order_Item__c
                                                               WHERE Order__c IN: existingOrderItems]);

    //real trigger
    for (Order_Item__c item: trigger.new)
    {
        if (ItemSKU != null)
        {
            //loop over all found addressNames & compare names
            for(Order_Item__c o : ItemSKU.values())
            {
                if(item.SKU__c == o.SKU__c && item.Id != o.Id)
                {
                   item.addError('SKU is already added to the order');
                }
            }
        }
    }
}