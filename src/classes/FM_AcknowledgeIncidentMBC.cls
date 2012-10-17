public with sharing class FM_AcknowledgeIncidentMBC 
{
    private final FM_Incident__c incident;
    public Boolean submitted { get; set; }
    public FM_AcknowledgeIncidentMBC(ApexPages.StandardController stdController) 
    {
        this.incident = [ Select f.Is_Midlands_Cluster__c, f.Sub_Status__c, f.heath_safety__c, f.Type__c, f.Subject__c, f.SystemModstamp, f.Supplier__c, f.Supplier_Comments__c, f.Supplier_Ack_SLA__c, f.Sub_Type__c, f.Status__c, f.Raised_By__c, f.Priority__c, f.Phone__c, f.PO_Number__c, f.OwnerId, f.FM_Out_of_Office__c, f.Other__c, f.Operational_efficiency__c, f.On_Site_Arrival_Time__c, f.Name, f.Location__c, f.Location_Street__c, f.Location_County__c, f.Location_City__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Email__c, f.Description__c, f.Created_By_FM_Team__c, f.CreatedDate, f.CreatedById, f.Additional_Information__c, f.Acknowledgement_Time__c, f.Acknowledgement_SLA_Status__c, f.Acknowledgement_Date_Time__c 
                            From FM_Incident__c f
                           Where Id =: stdController.getRecord().Id ];
    }
    
    public void acknowledgeIncident()
    {
        if ( incident.Status__c == 'Supplier Progress' && incident.Sub_Status__c == 'Retrieved' && incident.Is_Midlands_Cluster__c == 'Y')
        {
                     
            FM_Supplier_Response__c supplierResponseAcknowledged = new FM_Supplier_Response__c();
            supplierResponseAcknowledged.Incident__c = incident.Id;
            supplierResponseAcknowledged.Message_Date__c = System.Now();
            supplierResponseAcknowledged.Title__c = 'INITIAL Rep';
            supplierResponseAcknowledged.Incident_Status__c = 'Acknowledged';
                  
            insert supplierResponseAcknowledged;
           
            ApexPages.addMessage( new ApexPages.message( ApexPages.severity.CONFIRM, 'The incident is now acknowledged.' ) );
        }
        else 
        {
            ApexPages.addMessage( new ApexPages.message( ApexPages.severity.INFO, 'Incident cannot be acknowledged. The incident must be at Status Supplier Progress and for an MBC site. ') );
        }
    }
    public PageReference back()
    {
        return new ApexPages.StandardController( incident ).view().setRedirect( true );
    }
    // Tests    
    private static testMethod void test_acknowledgeIncident()
    {
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
        incident.Sub_Status__c = 'Retrieved';
        incident.Service__c = 'Cleaning';
        incident.Type__c = 'Cleaning';
        incident.Sub_Type__c = 'Cleaning';
        incident.Any_Risk_Applicable__c ='No';
        //incident.Syb_Type__c = '';
        incident.Raised_By__c = 'TestName';
        incident.Phone__c = '12345';
        incident.Email__c = 'test@test.com';
        incident.Any_Risk_Applicable__c = 'No';
        insert incident;

        Test.startTest();       
            // initialise page & controller
            PageReference pageRef = Page.FM_Acknowledge_Incident;
            Test.setCurrentPage( pageRef );  
            ApexPages.StandardController stdController = new ApexPages.StandardController( incident );
            FM_AcknowledgeIncidentMBC controller = new FM_AcknowledgeIncidentMBC( stdController );
        
            controller.acknowledgeIncident();
            PageReference back = controller.back();
            
            FM_Incident__c acknowledgedIncident = [ Select Id, Status__c, Sub_Status__c
                                          From FM_Incident__c
                                         Where Id =: incident.Id ];
            System.assertEquals( acknowledgedIncident.Status__c, 'Supplier Progress' );
            System.assertEquals( acknowledgedIncident.Sub_Status__c, 'Acknowledged' );
            
            
        Test.stopTest();            
    }
    
}