public with sharing class FM_SupplierContactController {
    private final FM_Supplier_Contact__c supplierContact;
    public FM_SupplierContactController(ApexPages.StandardController controller) {
        try{
            supplierContact = [Select Id From FM_Supplier_Contact__c Where related_User__c =: UserInfo.getUserId()];
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Engineer-Profile related to your User was found.'));
        }
    }
    
    public PageReference goToSupplierContactView(){
        if(supplierContact != null){
            return new ApexPages.StandardController(supplierContact).view().setRedirect(true);
        } else{
            return null;
        }
    }
	
	// Tests    
    private static testMethod void test_submitIncident()
    {
    	 // create supplier
        FM_Supplier__c supplier = new FM_Supplier__c ();
        supplier.Name = 'TestSupplier';
        insert supplier;
        
    	FM_Supplier_Contact__c supplierContact = new FM_Supplier_Contact__c();
    	supplierContact.Supplier__c = supplier.Id;
    	supplierContact.First_Name__c = 'test';
    	supplierContact.Last_Name__c = 'test';
    	supplierContact.Email__c = 'test@test.com';
    	supplierContact.related_User__c = UserInfo.getUserId();
    	insert supplierContact;
    	
    	Test.startTest();
    		// initialise page & controller
            PageReference pageRef = Page.FM_SupplierContactView;
            Test.setCurrentPage( pageRef );
            ApexPages.StandardController stdController = new ApexPages.StandardController( supplierContact );
            FM_SupplierContactController controller = new FM_SupplierContactController( stdController );
            controller.goToSupplierContactView();
    	Test.stopTest();
    }
}