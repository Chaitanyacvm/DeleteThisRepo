trigger SKU_Name_Barcode_unique on SKU__c (before insert, before update) 
{
    //create set of existing Address-Id's relating to Customer Companies
    Set<Id> SKUCustomerCompanyNames = new Set<Id>();
    
    //add Id's
    for (SKU__c sku : trigger.new)
    {
        SKUCustomerCompanyNames.add(sku.Customer_Company__c);
    } 
    
    //Select all existing Address-Names for Customer Companies   
    Map<Id, SKU__c> SKUNames = new Map<Id, SKU__c>([SELECT Name, UPC_Barcode__c FROM SKU__c WHERE Customer_Company__c IN: SKUCustomerCompanyNames]);

    //real trigger
    for (SKU__c sku : trigger.new)
    {
        if (skuNames != null)
        {
            //loop over all found skusNames & compare names
            for(SKU__c s : skuNames.values())
            {
                if( s.Name != null )
                {
                    if(sku.Name == s.Name && sku.Id != s.Id)
                        sku.Name.addError('SKU Reference has to be unique');
                }
                if( s.UPC_Barcode__c != null )
                {
                    if(sku.UPC_Barcode__c == s.UPC_Barcode__c && sku.Id != s.Id)
                        sku.UPC_Barcode__c.addError('UPC Barcode has to be unique');
                }
            }
        }
    }
}