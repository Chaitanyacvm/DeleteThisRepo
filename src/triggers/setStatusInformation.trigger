trigger setStatusInformation on SKU__c (before insert, before update) 
{
    if (trigger.isInsert)
    {   
        for (SKU__c sku : trigger.new)
        {
            sku.Transfer_Status__c = 'Pending-Transfer';
            sku.Change_Status__c = 'C';
        }
    }
    else if (trigger.isUpdate)
    {
        for (SKU__c sku : trigger.new)
        {
            if (sku.Transfer_Status__c == 'Completed-Transfer' && !sku.batch__c)
            {
                sku.Transfer_Status__c = 'Pending-Transfer';
                sku.Change_Status__c = 'U';
            }
            if(sku.batch__c){
                sku.batch__c = false;
            }
        }
    }
}