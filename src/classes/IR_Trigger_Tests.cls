@istest
private class IR_Trigger_Tests {
    TestMethod static void test_IR_Customer() {
        IR_Customer__c testCustomer = new IR_Customer__c(Domestic_Account_Number__c ='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        
        Test.startTest();
        insert testCustomer;
        
        update testCustomer;
        Test.stopTest();
    }
    
    TestMethod static void test_IR_Order() {
        IR_Customer__c testCustomer = new IR_Customer__c(Domestic_Account_Number__c ='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCustomer;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCustomer.Id);
        
        Test.startTest();
        insert testOrder;
        
        update testOrder;
        Test.stopTest();
    }
    
    TestMethod static void test_IR_Consignment() {
        IR_Customer__c testCustomer = new IR_Customer__c(Domestic_Account_Number__c ='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCustomer;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCustomer.Id);
        insert testOrder;
        
        IR_Consignment__c testConsignment = new IR_Consignment__c(From_Contact_Number__c='+44 (0)20 123456',To_Contact_Number__c='+44 (0)20 1234567',Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        
        Test.startTest();
        insert testConsignment;
        
        update testConsignment;
        Test.stopTest();
    }
    
    TestMethod static void test_IR_Package() {
        IR_Customer__c testCustomer = new IR_Customer__c(Domestic_Account_Number__c ='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCustomer;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCustomer.Id);
        insert testOrder;
        
        IR_Consignment__c testConsignment = new IR_Consignment__c(From_Contact_Number__c='+44 (0)20 123456',To_Contact_Number__c='+44 (0)20 1234567',Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testConsignment;
        
        IR_Package__c testPackage = new IR_Package__c(Height__c=1,Length__c=1,Width__c=1,Weight_kg__c=1,Consignment_IR__c=testConsignment.Id);
        
        Test.startTest();
        insert testPackage;
        
        update testPackage;
        Test.stopTest();
    }
    
    TestMethod static void test_IR_Note() {
        IR_Customer__c testCustomer = new IR_Customer__c(Domestic_Account_Number__c ='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCustomer;
        
        Note testNote = new Note(ParentId=testCustomer.Id,Title='Test',Body='Test');
        
        Test.startTest();
        insert testNote;
        
        update testNote;
        Test.stopTest();
    }
    
    TestMethod static void test_IR_Note_Delete() {
        IR_Customer__c testCustomer = new IR_Customer__c(Domestic_Account_Number__c ='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCustomer;
        
        Note testNote = new Note(ParentId=testCustomer.Id,Title='Test',Body='Test');
        insert testNote;
        
        Test.startTest();
        delete testNote;
        Test.stopTest();
    }
}