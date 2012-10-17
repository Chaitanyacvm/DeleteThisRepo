/************************************************************************************************************
* CHANGES
* 2011/01/24 - Makepositive - Technical Architect - Florian Hoehn - +44 (0)20 7928 1497
*************************************************************************************************************
* DESCRIPTION
* 		This trigger runs only before update and does not work for BULK updates. It schedules the Import
*		Consignment Job to a minute after this is triggered & saves the cronJobId of the scheduled Job in
*		the UTIL_Configuration record.
************************************************************************************************************/
trigger PUD_BEFORE_Util_Configuration on UTIL_Configuration__c (before update) 
{
	Id recordTypeId = [Select Id From RecordType Where DeveloperName = 'PUD'].Id;
	if ( trigger.new.Size() > 1 ){
		trigger.new[0].addError( 'No batch Insert available' );
	}
	else if ( trigger.new[0].RecordTypeId == recordTypeId && trigger.new[0].PUD_Start_Batch_Dashboards__c ){
		// start batch - Seconds  Minutes  Hours  Day_of_month  Month  Day_of_week  optional_year
		PUD_Scheduled_Import_Consignments pudJob = new PUD_Scheduled_Import_Consignments();
        Datetime timeJob = System.Now();
        Integer minuteJob = timeJob.Minute() + 1;
        String scheduleJob = timeJob.Second() + ' ' + minuteJob + ' ' + timeJob.Hour() + ' ' + timeJob.Day() + ' ' + timeJob.Month() + ' ? ' + timeJob.Year();
        // save cronJobId
        trigger.new[0].PUD_CronJobId__c = system.schedule('PUD Import Consignments Job', scheduleJob, pudJob);
		// reset flag 
		trigger.new[0].PUD_Start_Batch_Dashboards__c = false;	
	}
}