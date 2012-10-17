global class scheduleFormTasks implements Schedulable{
   global void execute(SchedulableContext SC) {
       Id batchinstanceid = database.executeBatch(new batchScheduleFormTasks(), 1);
   }
   
   TestMethod static void test_scheduleFormTasks() {
       Test.StartTest();
       String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new scheduleFormTasks());
       Test.StopTest();
   }
}