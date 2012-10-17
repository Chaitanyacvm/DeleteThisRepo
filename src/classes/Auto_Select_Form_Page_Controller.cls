public class Auto_Select_Form_Page_Controller {
    private Task t;
    private Id depotId{get; set;}
    private Id recordTypeId{get; set;}
    private String formObjectPrefix{get; set;}
    
    public Auto_Select_Form_Page_Controller(ApexPages.StandardController stdController) {
        t = (Task)stdController.getRecord();
        
        Schema.DescribeSObjectResult formDescribe = Form__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> formRecordTypes = formDescribe.getRecordTypeInfosByName();
        Task tempTask = [SELECT Id, Task_Related_Form__c, WhatId FROM Task WHERE Id = :t.Id];
        
        depotId = tempTask.WhatId;
        recordTypeId = formRecordTypes.get(tempTask.Task_Related_Form__c).getRecordTypeId();
        formObjectPrefix = formDescribe.getKeyPrefix();
    }
    
    public PageReference redirectToForm() {
        return new PageReference('/' + formObjectPrefix + '/e?RecordType=' + recordTypeId + '&depotId=' + depotId);
    }
    
    TestMethod static void test_Auto_Select_Form_Page_Controller() {
        Task testTask = new Task();
        testTask.Subject = 'TEST';
        testTask.Task_Related_Form__c = 'Enviromental';
        insert testTask;
        
        Test.StartTest();
        Auto_Select_Form_Page_Controller cont = new Auto_Select_Form_Page_Controller(new ApexPages.StandardController(testTask));
        cont.redirectToForm();
        Test.StopTest();
    }
}