public class Run_Scheduler_Page_Extension {
    public Id batchInstanceid {get; set;}
    private Form_Schedule__c schedule {get; set;}

    public Run_Scheduler_Page_Extension(ApexPages.StandardController controller) {
        schedule = (Form_Schedule__c)controller.getRecord();
    }
    
    public void runScheduler() {
        try {
            batchInstanceid = database.executeBatch(new batchScheduleFormTasks(), 1);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The scheduler is running with Id ' + batchInstanceid));
        } catch (Exception ex) {
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
    }
    
    public PageReference back() {
        PageReference pr = new ApexPages.StandardController(schedule).view();
        pr.setRedirect(true);
        
        return pr;
    } 
}