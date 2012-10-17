public with sharing class FM_SystemAssetsJobInstancesController {

    public List<FM_System_Asset_Job_Instances__c> systemAssetJobs {get; set;}

    public FM_SystemAssetsJobInstancesController(ApexPages.StandardController stdController) {
        systemAssetJobs = [SELECT Id, Name, Asset__c, Status__c, Job_Instance__c FROM FM_System_Asset_Job_Instances__c WHERE Job_Instance__c =: stdController.getRecord().Id ORDER BY Asset__c];
    }
    
    public PageReference save(){
        try{
            update systemAssetJobs;
        } catch (DMLException dml){
            // error handling
        }
        return null;
    }
    
    static testMethod void test_FM_SystemAssetsJobInstancesController() {
        //create business hours
        BusinessHours bH = [select id from businesshours where IsDefault=true];
      
        // create supplier
        FM_Supplier__c supplier = new FM_Supplier__c ();
        supplier.Name = 'TestSupplier';
        insert supplier;
        
        // create location
        FM_Location__c location = new FM_Location__c ();
        location.Name = 'TestLocation';
        location.Midlands_Cluster__c = true;
        insert location;
        
        // create rule
        FM_Service_Level__c rule = new FM_Service_Level__c ();
        rule.Location__c = location.Id;
        rule.Business_Hours_In__c = bH.Id;
        rule.Business_Hours_Out__c = bH.Id;
        rule.Scope__c = 'Cleaning';
        rule.Supplier__c = supplier.Id;
        rule.In_Hours_Acknowledgement_SLA__c = 2.5;
        rule.Out_Hours_Acknowledgement_SLA__c = 5;
        rule.Start_In_Hours__c = 9;
        rule.End_In_Hours__c = 17;
        rule.Priority_Level__c = 'P4';
        insert rule;
        
        // create incident for test
        FM_Incident__c incident = new FM_Incident__c ();
        incident.Location__c = location.Id;
        incident.Subject__c = 'IncidentTitle';
        incident.Description__c = 'IncidentDescription';
        incident.Status__c = 'Supplier Progress';
        incident.Service__c = 'Cleaning';
        incident.Type__c = 'Cleaning';
        incident.Sub_Type__c = 'Cleaning';
        incident.Any_Risk_Applicable__c ='No';
        incident.Raised_By__c = 'TestName';
        incident.Phone__c = '12345';
        incident.Email__c = 'test@test.com';
        incident.Any_Risk_Applicable__c = 'No';
        insert incident;
        
        FM_Job_Type__c jobType = new FM_Job_Type__c();
        jobType.Name = 'TestJobType';
        jobType.Frequency_Number__c = 1;
        jobType.Frequency_Period__c = 'week';
        jobType.Specs_Number__c = '6.16W';
        insert jobType;
        
        FM_Asset__c asset = new FM_Asset__c();
        asset.Location__c = location.Id;
        asset.Name = 'TestAssedCode';
        insert asset;
        
        FM_System__c sys = new FM_System__c();
        sys.Location__c = location.Id;
        sys.Name = 'TestSysCode';
        insert sys;
        
        List<FM_Job_Instance__c> jobInstanceList = new List<FM_Job_Instance__c>();
        for(Integer i = 0; i < 55; i++){
          FM_Job_Instance__c jobInstance = new FM_Job_Instance__c();
          jobInstance.Job_Type__c = jobType.Id;
          jobInstance.Deadline__c = Date.newInstance(System.today().year(), 1, 1) + i*7;
          jobInstance.Status__c = 'Planned';
          jobInstance.Asset__c = asset.Id;
          jobInstanceList.add(jobInstance);
        }
        
      FM_Job_Instance__c jobInstance = new FM_Job_Instance__c();
      jobInstance.Job_Type__c = jobType.Id;
      jobInstance.Deadline__c = System.today();
      jobInstance.Status__c = 'Planned';
      jobInstance.System__c = sys.Id;
      jobInstanceList.add(jobInstance);
      insert jobInstanceList; 
        
        Test.startTest();
            // initialise page & controller
            PageReference pageRef = Page.FM_SystemAssetsJobInstances;
            Test.setCurrentPage(pageRef);  
            ApexPages.StandardController stdController = new ApexPages.StandardController(jobInstance);
            FM_SystemAssetsJobInstancesController controller = new FM_SystemAssetsJobInstancesController(stdController);
            controller.save();
        Test.stopTest();
    }
}