/************************************************************************************************************
* CHANGES
* 2011/04/12 - Makepositive - Technical Architect - Florian Hoehn - +44 (0)20 7928 1497 - CREATED
*************************************************************************************************************
* DESCRIPTION
*       This batch job deletes Round & Stop Data that is over 14 days old or for any specific day.
************************************************************************************************************/
global class PUD_Batch_Delete_RoundsStops implements Database.Batchable<sObject> {
    private Date day;
    // constructor
    global PUD_Batch_Delete_RoundsStops() {
        day = System.today() - 14;
    }
    // constructor
    global PUD_Batch_Delete_RoundsStops(Date specificDay) {
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
	        // select old Rounds & Stops to delete
	        List<PUD_Round__c> rounds = new List<PUD_Round__c>([Select Id From PUD_Round__c Where Date__c <=: day AND Depot_Code__c =: depot.Depot_Code__c limit 2000]);
	        delete rounds;
	        List<PUD_Stop__c> stops = new List<PUD_Stop__c>([Select Id From PUD_Stop__c Where Date__c <=: day AND Depot_Code__c =: depot.Depot_Code__c limit 8000]);
	        delete stops;   
        }
    }
    // finish up
    global void finish(Database.BatchableContext BC) { 
    }
    
    // test methods
    TestMethod static void PUD_Batch_Delete_RoundsStops() {
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
        PUD_Batch_Delete_RoundsStops deleteConsignments = new PUD_Batch_Delete_RoundsStops();
        ID batchprocessid = Database.executeBatch(deleteConsignments);
        Test.StopTest();
    }
}