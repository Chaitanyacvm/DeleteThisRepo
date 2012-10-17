public with sharing class FM_CalendarView_Controller {
    public boolean showCalendar {get; set;}
    public String selectedLocation {get; set;}
    public List<SelectOption> soLocations {get; set;}
    public List<SelectOption> soTimeFrame {get; set;}
    public String selectedTimeFrame {get; set;}
    private final FM_Location__c loc;
    
    public FM_CalendarView_Controller(ApexPages.StandardController stdController){
        // create TimeFrame SelectOptions
        soTimeFrame = new List<selectOption>();
        soTimeFrame.add(new Selectoption('this_year', 'current year'));
        soTimeFrame.add(new Selectoption('last_year', 'last year'));
        soTimeFrame.add(new Selectoption('next_year', 'next year'));
        // create location SelectOptions
        List<FM_Location__c> locations = [Select Id, Name From FM_Location__c];
        soLocations = new List<selectOption>();
        soLocations.add(new SelectOption('0', '--None--'));
        for(FM_Location__c location : locations){
            soLocations.add(new SelectOption(location.Id, location.Name));
        }
        
        format = 'pdf';
    }
    
    // on select of the location dropbox
    public void getLocations(){
        if(selectedLocation != '0'){
            showCalendar = true;
        } else{
            showCalendar = false;
        }
    }
    
    public String format {get; set;}
    public PageReference exportCalendar(){
        return new PageReference('/apex/FM_CalendarViewExport?selectedTimeFrame=' + selectedTimeFrame + '&selectedLocation=' + selectedLocation + '&format=' + format);
    }
    
    static testMethod void test_CalendarView() {
        // create location
        FM_Location__c location = new FM_Location__c ();
        location.Name = 'TestLocation';
        location.Midlands_Cluster__c = true;
        insert location;
        
        Test.startTest();
          PageReference pageRef = Page.FM_CalendarView;
            Test.setCurrentPage( pageRef );  
            ApexPages.StandardController stdController = new ApexPages.StandardController( location );
          FM_CalendarView_Controller controller = new FM_CalendarView_Controller(stdController);
          controller.selectedTimeFrame = 'this_year';
          controller.selectedLocation = location.Id;
          controller.getLocations();
        Test.stopTest();
        
        System.Assert(controller.showCalendar);
    }
}