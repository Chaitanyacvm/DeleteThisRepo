global class FM_JobsEmailInboundHandler implements Messaging.InboundEmailHandler 
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        try
        {
            String jobName = email.Subject.Substring( 4, 10 );
            FM_Job_Instance__c job = [ Select f.System__c, f.SystemModstamp, f.Status__c, f.Stage__c, f.OwnerId, f.Name, f.LastModifiedDate, f.LastModifiedById, f.Job_Type__c, f.IsDeleted, f.Id, f.Deadline__c, f.CreatedDate, f.CreatedById, f.Comments__c, f.Calendar_View__c, f.Assigned_To__c, f.Asset__c, f.Asset_Managed_By__c 
                                         From FM_Job_Instance__c f
                                        Where Name =: jobName ];
            
            String[] mailMessage = email.plainTextBody.Split(':', 2);
            job.Comments__c = mailMessage[1];
            job.Status__c = mailMessage[0];
            update job;
     
            System.debug( '===> Updated Job ' + job.Id );
        } catch ( Exception e )
        {
            result.success = false;
            result.message = e.getMessage();
        }
        return result;
    }

    static testMethod void test_handleInboundEmail() 
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
        
        FM_Job_Type__c jobType = new FM_Job_Type__c();
        jobType.Name = 'TestJobType';
        jobType.Specs_Number__c = '6.16W';
        insert jobType;
        
        FM_Asset__c asset = new FM_Asset__c();
        asset.Name = 'TestAssedCode';
        insert asset;
        
        FM_Job_Instance__c jobInstance = new FM_Job_Instance__c();
        jobInstance.Job_Type__c = jobType.Id;
        jobInstance.Deadline__c = System.Today() + 1;
        jobInstance.Status__c = 'Planned';
        jobInstance.Asset__c = asset.Id;
        insert jobInstance; 
        
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     
        // setup the data for the email
        String jobName = [ Select Name From FM_Job_Instance__c Where Id =: jobInstance.Id ].Name;
        System.Debug( '===> ' + jobInstance );
        System.Debug( '===> ' + jobName );
        email.subject = 'RE: ' + jobName;
        email.fromname = 'FirstName LastName';
        email.plainTextBody = 'Completed: comments';
        env.fromAddress = 'someaddress@email.com';
        
        // error coz Incident.Name is not set in subject
        System.Debug( '===>' + email );
     
        // call the email service class and test it with the data in the testMethod
        FM_JobsEmailInboundHandler emailProcess = new FM_JobsEmailInboundHandler();
        
        Test.StartTest();
            emailProcess.handleInboundEmail( email, env );
        
            // query for the Supplier response the email service created
            //FM_Supplier_Response__c supplierResponse = [ Select Id, Incident_Status__c, Message_Body__c, Incident__c
            //                                               From FM_Supplier_Response__c
            //                                              Where Incident_Status__c= 'Completed' limit 1 ];
         
            //System.assertEquals( supplierResponse.Incident__c, incident.Id ); 
        Test.StopTest();
    }
}