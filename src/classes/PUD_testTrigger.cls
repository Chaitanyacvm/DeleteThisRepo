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
private class PUD_testTrigger 
{

    static testMethod void testbeforeInsertChecks() 
    {
    	try
    	{
	    	// single test - create depot, formSchedule & insert
	        Depot__c depot = new Depot__c(Name = 'TestDepot');
	        insert depot;
	        Form_Schedule__c formSchedule = new Form_Schedule__c(Start_Date__c = System.today(), Depot__c = depot.Id, Form__c = 'Fire Safety');
	        insert formSchedule;
	
			// bulk test - create depot, formSchedule & insert
			List<Form_Schedule__c> formScheduleList = new List<Form_Schedule__c>();
	        for (Integer i = 0; i < 200; i++)
	        {
	        	Form_Schedule__c fS = new Form_Schedule__c(Start_Date__c = System.today(), Depot__c = depot.Id, Form__c = 'Fire Safety');
	        	formScheduleList.add(fS);
	        }
	        insert formScheduleList;
    	}
    	catch (Exception e)
    	{
    		System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0) );
    	}
    }
    
    static testMethod void testPUD_BEFORE_Util_Configuration(){
    	// get RecordTypeId
    	try{
			Id recordTypeId = [Select Id From RecordType Where DeveloperName = 'PUD'].Id;
			// create record & insert
			UTIL_Configuration__c config = new UTIL_Configuration__c();
			config.RecordTypeId = recordTypeId;
			Test.startTest();
			insert config;
			config.PUD_Start_Batch_Dashboards__c = true;
			update config;
			Test.stopTest();
			//Boolean assertion = [Select PUD_Start_Batch_Dashboards__c From UTIL_Configuration__c Where RecordTypeId =: recordTypeId limit 1].PUD_Start_Batch_Dashboards__c;
			//System.assertEquals(assertion, false);
    	}catch(Exception ex){
    		system.debug('TEST_PUD_BEFORE_UTIL_CONFIG: '+ex);
    	}
    }
    
    static testMethod void testForm_Type_before_insert_update(){
    	// Form Type
    	PUD_Form_Type__c ft = new PUD_Form_Type__c();
    	ft.Name = 'TEST';
    	PUD_Form_Type__c ft2 = new PUD_Form_Type__c();
    	ft.Name = 'TEST';
    	Test.startTest();
    	insert ft;
    	insert ft2;
    	ft.Name = 'TEST 2';
    	update ft;
    	Test.stopTest();
    }
}