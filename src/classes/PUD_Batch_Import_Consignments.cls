/************************************************************************************************************
* CHANGES
* 2011/01/24 - Makepositive - Technical Architect - Florian Hoehn - +44 (0)20 7928 1497 - CREATED
* 2011/03/07 - Makepositive - Technical Architext - Florian Hoehn - +44 (0)20 7928 1497 - CHANGED DELETION PROCESSING
*************************************************************************************************************
* DESCRIPTION
*       This batch job is automatically scheduled whenever the daily upload of the PUD Consignment
*       data is finished. Then it selects all uploaded Consignments and create the help objects
*       PUD_Round__c & PUD_Stop__c. In these two objects the necessary data for the visualforce
*       page PUD_RoundOverview is saved. This is due to the huge amount of data needed for this.
*       At the end the job deletes Consignment & Stop Data that is over 14 days old.
************************************************************************************************************/
global class PUD_Batch_Import_Consignments implements Database.Batchable<sObject> {
    private Date day;
    // constructor
    global PUD_Batch_Import_Consignments() {
        day = System.today();
    }
    // constructor
    global PUD_Batch_Import_Consignments(Date specificDay) {
        day = specificDay;
    }
    // start method - select all consignment data uploaded today
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select d.Depot_Code__c From Depot__c d Where Type__c = 'Depot' Order By Depot_Code__c]);
    }
    // execute - functionality
    global void execute(Database.BatchableContext BC, List<Depot__c> depots) {
    	System.Debug(Logginglevel.INFO, '===> Day: ' + day);
    	Date dayPlusOne = day + 1;
        Set<String> depotCodes = new Set<String>();
        // loop over depots
        for(Depot__c depot : depots){
        	System.Debug(Logginglevel.INFO, '===> Depot Code: ' + depot.Depot_Code__c);
        	// fill depotCodes
        	depotCodes.add(depot.Depot_Code__c);
	        // create Map for Rounds
	        MAP<String, String> dateRounds = new MAP<String, String>();
	        // create Map for Info Fields
        	MAP<String, String> infos = new MAP<String, String>();
	        // loop over consignments imported today
	        for ( PUD_Consignment__c consignment : [Select p.Depot__c, p.Round__c, p.Col_Date__c, p.Post_Code__c, p.Time__c, p.Company__c From PUD_Consignment__c p Where CreatedDate >=: day AND CreatedDate <=: dayPlusOne AND Depot__c =: depot.Depot_Code__c Order By Round__c] ){
	            // create dateRounds
	            dateRounds.put( consignment.Depot__c + ',' + consignment.Col_Date__c,
	            				dateRounds.get(consignment.Depot__c + ',' + consignment.Col_Date__c) == null
	            				? consignment.Round__c
	            				: dateRounds.get(consignment.Depot__c + ',' + consignment.Col_Date__c).contains(consignment.Round__c)
	            				  ? dateRounds.get(consignment.Depot__c + ',' + consignment.Col_Date__c)
	            				  : dateRounds.get(consignment.Depot__c + ',' + consignment.Col_Date__c) + '%' + consignment.Round__c );
	            // set Infos
	            infos.put( consignment.Depot__c + ',' + consignment.Round__c + ',' + consignment.Col_Date__c, 
	                       infos.get(consignment.Depot__c + ',' + consignment.Round__c + ',' + consignment.Col_Date__c) == null 
	                       ? consignment.Time__c + ',' + consignment.Post_Code__c + ',' + consignment.Company__c
	                       : infos.get(consignment.Depot__c + ',' + consignment.Round__c + ',' + consignment.Col_Date__c) + '%' + consignment.Time__c + ',' + consignment.Post_Code__c  + ',' + consignment.Company__c);
	        }
	        // create new Rounds with dateRound Fields and Parts
	        List<PUD_Round__c> rounds = new List<PUD_Round__c>();
	        for(String key : dateRounds.KeySet()){
	        	List<String> oneDateRoundList = dateRounds.get(key).Split('%');
	        	List<String> oneKeyList = key.Split(',');
	        	Integer lim = 10;
	        	Integer part = 0;
	        	While(oneDateRoundList.Size() > 0){
	                if (oneDateRoundList.Size() < lim){
	                    lim = oneDateRoundList.Size();
	                }
	                SObject round = new PUD_Round__c();
	                round.put('Depot_Code__c', oneKeyList.get(0));
	                //round.put('Round__c', oneKeyList.get(1));
	                round.put('Date__c', Date.ValueOf(oneKeyList.get(1)));
	                round.put('Part__c', part);
	                for(Integer i = 1; i <= lim; i++){
	                    round.put('Round_' + i + '__c', oneDateRoundList.get(i - 1));
	                }
	                rounds.add((PUD_Round__c)round);
	                if (oneDateRoundList.Size() > lim){
	                    part++;
	                }
	                for(Integer i = lim; i > 0; i--){
	                    oneDateRoundList.remove(i - 1);
	                }
	            }
	        } 
	        // create new Stops with Info Fields and Parts
	        List<PUD_Stop__c> stops = new List<PUD_Stop__c>();
	        for(String key : infos.KeySet()){
	            List<String> oneInfoList = infos.get(key).Split('%');
	            List<String> oneKeyList = key.Split(',');
	            Integer lim = 10;
	            Integer part = 0;
	            While(oneInfoList.Size() > 0){
	                if (oneInfoList.Size() < lim){
	                    lim = oneInfoList.Size();
	                }
	                SObject stop = new PUD_Stop__c();
	                stop.put('Depot_Code__c', oneKeyList.get(0));
	                stop.put('Round__c', oneKeyList.get(1));
	                stop.put('Date__c', Date.ValueOf(oneKeyList.get(2)));
	                stop.put('Part__c', part);
	                for(Integer i = 1; i <= lim; i++){
	                    stop.put('Info_' + i + '__c', oneInfoList.get(i - 1));
	                }
	                stops.add((PUD_Stop__c)stop);
	                if (oneInfoList.Size() > lim){
	                    part++;
	                }
	                for(Integer i = lim; i > 0; i--){
	                    oneInfoList.remove(i - 1);
	                }
	            }
	        }
	        // debugging
	        System.Debug(Logginglevel.INFO, '===> InfosMAP: ' + infos.Values().Size() + ' ' + infos);  
	        System.Debug(Logginglevel.INFO, '===> RoundsMAP: ' + rounds.Size() + ' ' + rounds);
	        System.Debug(Logginglevel.INFO, '===> StopsLIST: ' + stops.Size() + ' ' + stops);  
	        // insert / upsert
	        try{
	            insert rounds;
	            insert stops;
	        } catch (Exception e){
	            System.Debug(Logginglevel.ERROR, '===> ERROR ' + e.getMessage());
	            System.Debug(Logginglevel.ERROR, '===> CAUSE ' + e.getCause());
	        }   
        }
    }
    // finish up
    global void finish(Database.BatchableContext BC) { 
        // deschedule the Job
        try{
            Id recordTypeId = [Select Id From RecordType Where DeveloperName = 'PUD'].Id;
            String cronJobId = [Select Id, PUD_CronJobId__c From UTIL_Configuration__c Where RecordTypeId =: recordTypeId].PUD_CronJobId__c;
            System.abortJob(cronJobId);
        } catch (Exception e){
            System.Debug(Logginglevel.ERROR, '===> ERROR ' + e.getMessage());
            System.Debug(Logginglevel.ERROR, '===> CAUSE ' + e.getCause());
        }
    }
    
    // test methods
    TestMethod static void PUD_Batch_Import_Consignments() {
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
        PUD_Batch_Import_Consignments importConsignments = new PUD_Batch_Import_Consignments();
        ID batchprocessid = Database.executeBatch(importConsignments);
        Test.StopTest();
    }
}