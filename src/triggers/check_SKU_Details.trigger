trigger check_SKU_Details on SKU__c (before insert, before update) 
{
//    for (SKU__c sku : trigger.new)
//    {
//       if (sku.Name == null)
//            sku.Name = 'blank';
//    }

    //create set of existing SKU-Id's relating to Customer Companies
    Set<Id> existingSKUs = new Set<Id>();
    
    //add Id's
    for (SKU__c sku: trigger.new)
    {
        existingSKUs.add(sku.Customer_Company__c);
    } 
    
    //Select all existing SKU-Details for Customer Companies   
    Map<Id, SKU__c> SKUDetails = new Map<Id, SKU__c>([Select s.Style__c, s.Style_Suffix__c, s.Style_Number__c, 
                                                            s.Size_Dimension__c, s.Colour_Suffix__c, s.Customer_Company__c, s.UPC_Barcode__c 
                                                       From SKU__c s 
                                                      WHERE Customer_Company__c IN: existingSKUs]);
                                                      
    MAP<Id, LIST<SKU__c>> companySKUs = new MAP<Id, LIST<SKU__c>>();
    for(SKU__c s : SKUDetails.values()) {
        if (companySKUs.get(s.Customer_Company__c) == null) {
            LIST<SKU__c> skus = new LIST<SKU__c>();
            skus.add(s);
            
            companySKUs.put(s.Customer_Company__c, skus);
        } else {
            companySKUs.get(s.Customer_Company__c).add(s);
        }
    }
    
    //real trigger
    for (SKU__c sku: trigger.new)
    {
        if (companySKUs.get(sku.Customer_Company__c) != null)
        {
            System.debug(companySKUs.get(sku.Customer_Company__c));
            //loop over all found addressNames & compare names
            for(SKU__c s : companySKUs.get(sku.Customer_Company__c))
            {
                if (sku.Customer_Company__c == s.Customer_Company__c) {
                    if(sku.Style__c == s.Style__c &&
                       sku.Style_Suffix__c == s.Style_Suffix__c && 
                       sku.Style_Number__c == s.Style_Number__c &&
                       sku.Size_Dimension__c == s.Size_Dimension__c &&
                       sku.Colour_Suffix__c == s.Colour_Suffix__c &&
                       sku.Id != s.Id)
                    {
                        sku.addError('SKU details have to be unique');
                    }
                }
            }
        }
    }
}