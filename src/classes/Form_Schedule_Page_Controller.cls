public class Form_Schedule_Page_Controller {
    public Form_Schedule__c schedule{get; set;}
    public Boolean isEdit{get; set;}
    public String DisplayValue{get;set;}

    public Form_Schedule_Page_Controller(ApexPages.StandardController stdController) {
        schedule = (Form_Schedule__c)stdController.getRecord();
        
        if (schedule.Id == null) {
            isEdit = false;
            DisplayValue = 'none';
        } else {
               schedule = [SELECT Start_Date__c, Form__c, Name, Id, Due_September__c, Due_October__c, Due_November__c, Due_May__c, Due_March__c, Due_June__c, Due_July__c, Due_January__c, Due_February__c, Due_December__c, Due_August__c, Due_April__c, Due_Monday__c, Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Due_Sunday__c, Schedule_Type__c, Depot__c FROM Form_Schedule__c WHERE Id = :schedule.Id LIMIT 1];
                DisplayValue = 'block';
            isEdit = true;
        }
    }
    
    public void setDisplayValue(String value){
        this.DisplayValue = value;
    }
    
    public String getDisplayValue(){
        return this.DisplayValue;
    }
    
    public LIST<SelectOption> getFormTypes() {
        return formMethods.getFormTypes();
    }
    
    public LIST<SelectOption> getScheduleTypes() {
        return formMethods.getScheduleType();
    }
    
    public PageReference save() {
        try {
            upsert schedule;
            
            return new ApexPages.StandardController(schedule).view();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    TestMethod static void test_Form_Schedule_Page_Controller() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        insert testFS;
        
        Test.StartTest();
        Form_Schedule_Page_Controller cont = new Form_Schedule_Page_Controller(new ApexPages.StandardController(testFS));
        cont.getFormTypes();
        cont.save();
        Test.StopTest();
    }
}