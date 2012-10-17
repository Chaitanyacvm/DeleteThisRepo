public with sharing class FM_CancelIncident 
{
    private final FM_Incident__c incident;
    public Boolean cancelled { get; set; }
    private Id recordTypeId;
    public FM_CancelIncident(ApexPages.StandardController stdController) 
    {
        this.incident = [ Select f.Id, f.RecordTypeId, f.Status__c , f.Sub_Status__c 
                            From FM_Incident__c f
                           Where Id =: stdController.getRecord().Id ];
        recordTypeId = [ Select Id
                           From RecordType
                          Where Name = 'Close' ].Id;
    }
    
    public void cancelIncident()
    {
        try
        {
            incident.RecordTypeId = recordTypeId;
            incident.Status__c = 'Closed';
            incident.Sub_Status__c = 'Cancelled';
            update incident;
            cancelled = true;
            ApexPages.addMessage( new ApexPages.message( ApexPages.severity.CONFIRM, 'The incident is successfully cancelled.' ) );
        }
        catch ( Exception e )
        {
            if ( !ApexPages.hasMessages() )
                ApexPages.addMessage( new ApexPages.message( ApexPages.severity.ERROR, 'Incident cannot be cancelled. Please contact your system administrator.' ) );
        }
    }
    
    public PageReference back()
    {
        return new ApexPages.StandardController( incident ).view().setRedirect( true );
    }
    
// Tests    
    private static testMethod void test_cancelIncident()
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
        incident.Sub_Status__c = 'Completed';
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
            PageReference pageRef = Page.CancelIncident;
            Test.setCurrentPage( pageRef );  
            ApexPages.StandardController stdController = new ApexPages.StandardController( incident );
            FM_CancelIncident controller = new FM_CancelIncident( stdController );
        
            controller.CancelIncident();
            PageReference back = controller.back();
            
            FM_Incident__c CanceledIncident = [ Select Id, Status__c, Sub_Status__c
                                          From FM_Incident__c
                                         Where Id =: incident.Id ];
            System.assertEquals( CanceledIncident.Status__c, 'Closed' );
            System.assertEquals( CanceledIncident.Sub_Status__c, 'Cancelled' );
        Test.stopTest();            
    }
}