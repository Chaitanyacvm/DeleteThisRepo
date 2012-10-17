/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class IR_Customer_After_WithDrawn_Test {
	//& Test methid for the trigger on Customer after withdrawn status.    
     static TestMethod void test_IR_Customer_after_withdrawn(){
         IR_Customer__c testCustomer = new IR_Customer__c(Domestic_Account_Number__c ='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST', Registration_Status__c = 'Quote', Send_Sales_Email__c = false);                 
         insert testCustomer;
         
         IR_Customer__c cus = IR_Global_Class.getCustomer(testCustomer.Id);
         cus.Registration_Status__c = 'Customer Withdrawn';
         Test.startTest();
         update cus;
         Test.stopTest();
     }
}