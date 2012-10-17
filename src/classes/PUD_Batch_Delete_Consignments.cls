/************************************************************************************************************
* CHANGES
* 2011/04/12 - Makepositive - Technical Architect - Florian Hoehn - +44 (0)20 7928 1497 - CREATED
*************************************************************************************************************
* DESCRIPTION
*       This batch job deletes Consignment & Stop Data that is over 14 days old or for any specific day.
************************************************************************************************************/
global class PUD_Batch_Delete_Consignments implements Database.Batchable<sObject> {
    private Date day;
    // constructor
    global PUD_Batch_Delete_Consignments() {
        day = System.today() - 14;
    }
    // constructor
    global PUD_Batch_Delete_Consignments(Date specificDay) {
        day = specificDay;
    }
    // start method - select all consignment data uploaded today
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select d.Depot_Code__c From Depot__c d Where Type__c = 'Depot' Order By Depot_Code__c]);
    }
    // execute - functionality
    global void execute(Database.BatchableContext BC, List<Depot__c> depots) {
        // loop over depots
        System.Debug('===> ' + depots);
        for(Depot__c depot : depots){
	        List<PUD_Consignment__c> consignments = new List<PUD_Consignment__c>([Select Id From PUD_Consignment__c Where Col_Date__c <=: day AND Depot__c =: depot.Depot_Code__c limit 10000]);
	        delete consignments;
        }
    }
    // finish up
    global void finish(Database.BatchableContext BC) { 
    }
    
    // test methods
    TestMethod static void PUD_Batch_Delete_Consignments() {
    	// create depot
    	Depot__c depot = new Depot__c();
    	depot.Name = 'TEST';
    	depot.Depot_Code__c = 'AAA';
    	depot.Type__c = 'Depot';
    	insert depot;
    	// create consignments
        List<PUD_Consignment__c> consignments = new List<PUD_Consignment__c>();
        for(Integer i = 0; i < 5; i++){
            PUD_Consignment__c consignment = new PUD_Consignment__c();
            consignment.Col_Date__c = System.Today();
            consignment.Depot__c = 'AAA';
            consignment.Round__c = String.ValueOf(Math.mod(i, 12));
            consignment.Time_Alloc__c = System.now();
            consignment.Post_Code__c = 'N' + String.ValueOf(Math.mod(i,3)) + 'ABZ';
            consignment.Company__c = 'TestCompany' + i;
            consignments.add(consignment);
        }
        insert consignments;
        Test.StartTest();
        PUD_Batch_Delete_Consignments deleteConsignments = new PUD_Batch_Delete_Consignments();
        ID batchprocessid = Database.executeBatch(deleteConsignments);
        Test.StopTest();
    }
}