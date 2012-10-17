/************************************************************************************************************
* CHANGES
* 2011/01/27 - Makepositive - Technical Architect - Florian Hoehn - +44 (0)20 7928 1497
*************************************************************************************************************
* DESCRIPTION
*       This scheduler class schedules the Import consignment job (PUD_Batch_Import_Consignments) to run 
*		10 depots per batch.
************************************************************************************************************/
global class PUD_Scheduled_Import_Consignments implements Schedulable
{
	private Date day;
	global PUD_Scheduled_Import_Consignments(){
	}
	global PUD_Scheduled_Import_Consignments(Date specificDay){
		day = specificDay;
	}
	
	global void execute(SchedulableContext SC) 
    {
    	if(day != null){
    		Id batchinstanceid = database.executeBatch(new PUD_Batch_Import_Consignments(day), 10);
    	} else{
    		Id batchinstanceid = database.executeBatch(new PUD_Batch_Import_Consignments(), 10);	
    	}
    }
   
	TestMethod static void PUD_Scheduled_Import_Consignments() {
		Date testDay = System.today() - 5;
		Test.StartTest();
        String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new PUD_Scheduled_Import_Consignments());
        jobId = System.schedule('testBasicScheduledApex2', '0 0 0 3 9 ? 2022', new PUD_Scheduled_Import_Consignments(testDay));
        Test.StopTest();
   } 
}