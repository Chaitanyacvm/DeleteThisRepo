global class FM_schedulePPMJobs implements Schedulable
{
   global void execute( SchedulableContext SC ) 
   {
       Id batchinstanceid = database.executeBatch( new FM_batchSchedulePPMJobs(), 1 );
   }
   
   TestMethod static void test_FM_schedulePPMJobs() 
   {
       Test.StartTest();
           String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new FM_schedulePPMJobs());
       Test.StopTest();
   }
}