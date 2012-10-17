public with sharing class FM_ConfirmIncident 
{
    private final FM_Incident__c incident;
    public Boolean confirmed { get; set; }
    private Id recordTypeId;
    public FM_ConfirmIncident(ApexPages.StandardController stdController) 
    {
        this.incident = [ Select f.Id, f.RecordTypeId, f.Status__c , f.Sub_Status__c, f.Feedback__c, f.Rating__c
                            From FM_Incident__c f
                           Where Id =: stdController.getRecord().Id ];
        recordTypeId = [ Select Id
                           From RecordType
                          Where Name = 'Close' ].Id;
    }
    
    public void confirmIncident()
    {
        if ( incident.Status__c == 'Supplier Progress' && incident.Sub_Status__c == 'Completed' )
        {
            if ( (incident.Feedback__c == null || incident.Feedback__c == '') || 
                 (incident.Rating__c == null || incident.Rating__c == '') )
                {
                    confirmed = false;
                    if ( !ApexPages.hasMessages() )
                        ApexPages.addMessage( new ApexPages.message( ApexPages.severity.INFO, 'Please provide feedback and rate the incident accordingly.' ) );
                }
            else
            {
                    try
                    {
                        incident.RecordTypeId = recordTypeId;
                        incident.Status__c = 'Closed';
                        incident.Sub_Status__c = 'Verified';
                        update incident;
                        confirmed = true;
                        ApexPages.addMessage( new ApexPages.message( ApexPages.severity.CONFIRM, 'The incident is successfully closed.' ) );
                    }

                    catch ( Exception e )
                    {
                        if ( !ApexPages.hasMessages() )
                            ApexPages.addMessage( new ApexPages.message( ApexPages.severity.ERROR, 'Incident cannot be closed. Please contact your system administrator.' ) );
                    }




            }
        }
        else
        {
            confirmed = false;
            if ( !ApexPages.hasMessages() )
                ApexPages.addMessage( new ApexPages.message( ApexPages.severity.INFO, 'Only incidents which are completed by supplier can be closed.' ) );
        }
    }
    
    public PageReference back()
    {
        return new ApexPages.StandardController( incident ).view().setRedirect( true );
    }
    
// Tests    
    private static testMethod void test_submitIncident()
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
        incident.Feedback__c = 'feedback';
        incident.Rating__c = '1';
        insert incident;

        Test.startTest();       
            // initialise page & controller
            PageReference pageRef = Page.ConfirmIncident;
            Test.setCurrentPage( pageRef );  
            ApexPages.StandardController stdController = new ApexPages.StandardController( incident );
            FM_ConfirmIncident controller = new FM_ConfirmIncident( stdController );
        
            controller.confirmIncident();
            PageReference back = controller.back();
            
            FM_Incident__c confirmedIncident = [ Select Id, Status__c, Sub_Status__c
                                          From FM_Incident__c
                                         Where Id =: incident.Id ];
            System.assertEquals( confirmedIncident.Status__c, 'Closed' );
            System.assertEquals( confirmedIncident.Sub_Status__c, 'Verified' );
            
            incident.Status__c = 'Open';
            update incident;
            
            controller = new FM_ConfirmIncident( stdController );
        
            controller.confirmIncident();
            back = controller.back();
            
            confirmedIncident = [ Select Id, Status__c, Sub_Status__c
                                          From FM_Incident__c
                                         Where Id =: incident.Id ];
            System.assertEquals( confirmedIncident.Status__c, 'Open' );
            
            incident.Feedback__c = null;
            update incident;
            
            controller.confirmIncident();
            back = controller.back();
            
            confirmedIncident = [ Select Id, Status__c, Sub_Status__c
                                          From FM_Incident__c
                                         Where Id =: incident.Id ];
        Test.stopTest();            
    }
}