public class Form_Schedule_Matrix_Controller {
    public Depot__c depot{get; set;}
    public LIST<Form_Schedule__c> schedules{get; set;}
    
    public Form_Schedule_Matrix_Controller(ApexPages.StandardController stdController) {
        depot = [SELECT Id, Name FROM Depot__c WHERE Id = :((Depot__c)stdController.getRecord()).Id LIMIT 1];
        
        schedules = [SELECT Due_Monday__c, Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Due_Sunday__c, Schedule_Type__c, Due_September__c, Due_October__c, Due_November__c, Due_May__c, Due_March__c, Due_June__c, Due_July__c, Due_January__c, Due_February__c, Due_December__c, Due_August__c, Due_April__c, Depot__c, Form__c FROM Form_Schedule__c WHERE Depot__c = :depot.Id];
    }
    
    TestMethod static void test_Form_Schedule_Matrix_Controller() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Test.StartTest();
        Form_Schedule_Matrix_Controller cont = new Form_Schedule_Matrix_Controller(new ApexPages.StandardController(testDepot));
        Test.StopTest();
    }
}