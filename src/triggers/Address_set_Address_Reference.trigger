trigger Address_set_Address_Reference on Address__c (before insert, before update) 
{
    //create set of existing Address-Id's relating to Customer Companies
    Set<Id> AddressCustomerCompanyNames = new Set<Id>();
    
    //add Id's
    for (Address__c address : trigger.new)
    {
        AddressCustomerCompanyNames.add(address.Customer_Company__c);
    } 
    
    //Select all existing Address-Names for Customer Companies   
    Map<Id, Address__c> AddressNames = new Map<Id, Address__c>([SELECT Name FROM Address__c WHERE Customer_Company__c IN: AddressCustomerCompanyNames]);

    //real trigger
    for (Address__c address : trigger.new)
    {
        if (AddressNames != null)
        {
            //loop over all found addressNames & compare names
            for(Address__c a : AddressNames.values())
            {
                if( a.Name != null )
                {
                    if(Address.Name == a.Name && Address.Id != a.Id)
                        address.Name.addError('Address Reference has to be unique');
                }
            }
        }
    }
}