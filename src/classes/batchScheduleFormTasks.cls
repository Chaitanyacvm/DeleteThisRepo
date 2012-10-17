global class batchScheduleFormTasks implements Database.Batchable<sObject> {
    global batchScheduleFormTasks() {
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT OwnerId, Id, (SELECT Depot__c, Schedule_Type__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Due_Wednesday__c, Due_Monday__c, Due_Tuesday__c, Due_Sunday__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c');
    }

    global void execute(Database.BatchableContext BC, List<Depot__c> depots) {
        MAP<String, Schema.RecordTypeInfo> taskRecordTypes = Task.SObjectType.getDescribe().getRecordTypeInfosByName();
        Id formTaskRecordTypeId = taskRecordTypes.get('Form Task').getRecordTypeId();
        LIST<Task> depotTasks = new LIST<Task>();
        
        for (Depot__c depot : depots) {
             depotTasks = formMethods.createDepotTasks(depot);
        }
        
        insert depotTasks;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    TestMethod static void test_batchScheduleFormTasks() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        insert testDepot;
        
        Test.StartTest();
        batchScheduleFormTasks cont = new batchScheduleFormTasks();
        ID batchprocessid = Database.executeBatch(cont);
        Test.StopTest();
    }
}