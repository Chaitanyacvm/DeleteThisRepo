global class FM_FacilityManagement_Webservice
{
    // webservice to get all Incidents for one supplier
    webservice static List<FM_Incident__c> getIncidents(String supplier) 
    {
        // collect all Incidents that are submitted
        List<Fm_Incident__c> incidents = [ Select f.Submitted_Time__c, f.heath_safety__c, f.Type__c, f.Subject__c, f.Supplier__r.Name, f.Supplier_Comments__c, f.Sub_Type__c, f.Status__c, f.Raised_By__c, f.Priority__c, f.Phone__c, f.Owner.FirstName, f.Owner.LastName, f.FM_Out_of_Office__c, f.Other__c, f.Name, f.Location__r.Name, f.Location_Street__c, f.Location_County__c, f.Location_City__c, f.LastModifiedDate, f.Email__c, f.Description__c, f.CreatedDate, f.Additional_Information__c, (Select Title, Body, LastModifiedDate From Notes) 
                                             From FM_Incident__c f 
                                            Where Status__c = 'Supplier Progress'
                                              And (  Sub_Status__c = null
                                                  OR Sub_Status__c = 'Reopened' )
                                              And Supplier__r.Name =: supplier ];
        
        // set Status update and submitted time on incidents
        for ( FM_Incident__c incident : incidents )
        {
           incident.Sub_Status__c = 'Retrieved';
           incident.Submitted_Time__c = System.Now();
        }
        
        // update & return incidents
        update incidents;
        
        return incidents;
    }

    // webservice to set all status updates on incidents and return error log
    webservice static List<Log__c> setIncidentStatus( List<FM_Supplier_Response__c> supplierResponses ) 
    {
        // create error log with correct recordTypeId
        Map<String, Log__c> logs = new Map<String, Log__c>();
        Id recordTypeId = [ Select Id
                              From RecordType
                             Where Name = 'Facility Management' ].Id;
        
        // create Map with all supplierResponses, key is the Incident.Name
        Map<String, FM_Supplier_Response__c> responses = new Map<String, FM_Supplier_Response__c> ();
        List<Fm_Supplier_Response__c> responsesToInsert = new List<FM_Supplier_Response__c>();
        for ( FM_Supplier_Response__c response : supplierResponses )
        {
            responses.put( response.Incident_Number__c, response );
        }
        
        // Select all incident information with the help of the incident Map
        Map<String, FM_Incident__c> supplierResponseIncidents = new Map<String, FM_Incident__c>();
        for ( FM_Incident__c incident : [ Select f.Submitted_Time__c, f.heath_safety__c, f.Type__c, f.Subject__c, f.SystemModstamp, f.Supplier__c, f.Supplier__r.Name, f.Supplier_Comments__c, f.Sub_Type__c, f.Status__c, f.Raised_By__c, f.Priority__c, f.Phone__c, f.PO_Number__c, f.OwnerId, f.FM_Out_of_Office__c, f.Other__c, f.Operational_efficiency__c, f.On_Site_Arrival_Time__c, f.Name, f.Location__c, f.Location_Street__c, f.Location_County__c, f.Location_City__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Email__c, f.Description__c, f.CreatedDate, f.CreatedById, f.Additional_Information__c, f.Acknowledgement_Time__c, f.Acknowledgement_SLA_Status__c, f.Acknowledgement_Date_Time__c
                                            From FM_Incident__c f
                                           Where Name IN: responses.keySet() ] )
            supplierResponseIncidents.put( incident.Name, incident );                                                                                   
        
        // loop through all responses & check if Status is existing & Message Date is sent & Incident.Name exists 
        for ( FM_Supplier_Response__c response : supplierResponses )
        {
            Log__c log = new Log__c();
            log.recordTypeId = recordTypeId;
            try
            {
                if ( supplierResponseIncidents.get( response.Incident_Number__c ) != null )
                    if ( checkStatus( response.Incident_Status__c ) )
                        if ( response.Message_Date__c != null )
                        {
                            response.Incident__c = supplierResponseIncidents.get( response.Incident_Number__c ).Id;
                            responsesToInsert.add ( response );
                            // this is all done in a trigger now:
                            /*
                            // set Incident Status
                            incident.Sub_Status__c = responses.get( incident.Name ).Incident_Status__c;
                            // set Timestamps
                            //responses.get( incident.Name ).Message_Date__c = incident.Submitted_Time__c;
                            // set Title
                            responses.get( incident.Name ).Title__c = incident.Name + ' - ' + incident.Subject__c + ' - ' + incident.Status__c + ' - ' + responses.get( incident.Name ).Title__c;
                            */
                        }
                        else    
                            // error handling for 
                            throw new FM_Webservice_Exception( 'The Message Date is not filled for incident ' + response.Incident_Number__c + ': ' + response.Incident_Status__c );
                    else   
                        // error handling for 
                        throw new FM_Webservice_Exception( 'Wrong Status on incident ' + response.Incident_Number__c + ': ' + response.Incident_Status__c );
                else   
                    // error handling for 
                    throw new FM_Webservice_Exception( 'Incident ' + response.Incident_Number__c + ' does not exist in the system' );
                    
                // set log success Message
                log.Error_Message__c = supplierResponseIncidents.get( response.Incident_Number__c ).Name + ': ' + response.Incident_Status__c;
                log.Error_Code__c = 'SUCCESS';
                //log.Supplier_Response__c = response.Id;
                //log.Supplier_Response_Number__c = responses.get( incident.Name ).Name;
                logs.put( response.Name + response.Message_Date__c, log );
            } catch ( Exception e )
            {
                log.Error_Message__c = e.getMessage();
                log.Error_Code__c = e.getTypeName();
                //log.Supplier_Response__c = response.Id;
                //log.Supplier_Response_Number__c = responses.get( incident.Name ).Name;
                logs.put( response.Name + response.Message_Date__c, log );
            }
        }
        try
        {
            // insert responses & logs
            insert responsesToInsert;
            insert logs.Values();
            //done in trigger now
            //update incidentsToUpdate.Values();
        } catch ( Exception e ) {}
        return logs.Values();
    }
   
    private static Boolean checkStatus( String subStatus )
    {
        Schema.DescribeFieldResult fieldSubStatusResult = FM_Incident__c.Sub_Status__c.getDescribe();
        List<Schema.PicklistEntry> existingSubStati = fieldSubStatusResult.getPicklistValues();
        for ( Schema.PicklistEntry subStatusEntry : existingSubStati )
        {
            if ( subStatusEntry.getLabel() == subStatus )
                return true;
        }
        return false;
    }
    
 // Tests    
    private static testMethod void test_getIncidents()
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
        incident.Sub_Status__c = 'Acknowledged';
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
                
        // test call
        Test.startTest();
            List<FM_Incident__c> testList = FM_FacilityManagement_Webservice.getIncidents( supplier.Name );
        Test.stopTest();
        
        // test assertion
        //System.AssertEquals( testList.get(0).Subject__c, 'IncidentTitle' );
        //System.AssertEquals( testList.get(0).Sub_Status__c, 'Retrieved' );
    }
    
    private static testMethod void test_setIncidentStatus()
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
        
        // create supplier response
        FM_Supplier_Response__c supplierResponse = new FM_Supplier_Response__c ();
        supplierResponse.Title__c = 'TestResponseTitle';
        supplierResponse.Message_Body__c = 'TestResponseBody';
        supplierResponse.Message_Date__c = System.Now();
        supplierResponse.Incident_Status__c = 'Acknowledged';
        //supplierResponse.Incident__c = incident.Id;
        supplierResponse.Incident_Number__c = incident.Name;
        
        List<FM_Supplier_Response__c> supplierResponses = new List<FM_Supplier_Response__c> ();
        supplierResponses.Add( supplierResponse );
        
        Test.startTest();
            FM_FacilityManagement_Webservice.setIncidentStatus( supplierResponses );
        
            // test assertion
            List<FM_Incident__c> returnedIncidents = [ Select Id, Status__c, Sub_Status__c
                                                         From FM_Incident__c
                                                        Where Id =: incident.Id ];
            //System.AssertEquals( returnedIncidents.get(0).Sub_Status__c, 'Acknowledged' );
            //FM_Supplier_Response__c savedSupplierResponse = [ Select Id, Title__c, Message_Date__c, Message_Body__c, Incident__c, Incident_Status__c 
            //                                                    From FM_Supplier_Response__c
            //                                                   Where Incident__c =: returnedIncidents.get(0).Id limit 1 ];
            //System.Assert( savedSupplierResponse.Title__c.contains( 'TestResponseTitle' ) );
        Test.stopTest();
    }

    private static testMethod void test_checkStatus()
    {
        // set variables
        Boolean existingStatus;
        Boolean notExistingStatus;
        
        // test
        Test.startTest();
            existingStatus = FM_FacilityManagement_Webservice.checkStatus( 'Retrieved' );
            notExistingStatus = FM_FacilityManagement_Webservice.checkStatus( 'Test' );
        Test.stopTest();
        
        // test assertion
        System.AssertEquals( existingStatus , true );
        System.AssertEquals( notExistingStatus, false );
    }

/*    
    webservice static void setIncidentStatus( List<FM_Incident__c> supplierIncidents ) 
    {
        Map<Id, FM_Incident__c> incidents = new Map<Id, FM_Incident__c> ( supplierIncidents );
        Map<Id, FM_Incident__c> incidentsToUpdate = new Map<Id, FM_Incident__c> ([ Select f.heath_safety__c, f.Type__c, f.Title__c, f.SystemModstamp, f.Supplier__c, f.Supplier__r.Name, f.Supplier_Comments__c, f.Sub_Type__c, f.Status__c, f.Raised_By__c, f.Priority__c, f.Phone__c, f.PO_Number__c, f.OwnerId, f.Out_of_Hours__c, f.Other__c, f.Operational_efficiency__c, f.On_Site_Arrival_Time__c, f.Name, f.Location__c, f.Location_Street__c, f.Location_County__c, f.Location_City__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Email__c, f.Description__c, f.CreatedDate, f.CreatedById, f.Additional_Information__c, f.Acknowledgement_Time__c, f.Acknowledgement_SLA_Status__c, f.Acknowledgement_Date_Time__c
                                                                                     From FM_Incident__c f
                                                                                    Where Id IN: incidents.keySet() ]);
        for ( FM_Incident__c incident : incidents.Values() )
        {
            if ( checkStatus( incident.Status__c ) )
            {
                incidentsToUpdate.get( incident.Id ).Status__c = incident.Status__c;
                if ( incidentsToUpdate.get( incident.Id ).Supplier_Comments__c == null )
                    incidentsToUpdate.get( incident.Id ).Supplier_Comments__c = '';
                incidentsToUpdate.get( incident.Id ).Supplier_Comments__c = incidentsToUpdate.get( incident.Id ).Supplier_Comments__c + incidentsToUpdate.get( incident.Id ).Supplier__r.Name + ' - ' + System.Now() + ' - ' + incident.Supplier_Comments__c + '\n';
            }
            else
            {    
                throw new FM_Webservice_Exception('Wrong Status on incident ' + incident.Name + ': ' + incident.Status__c);
            }
        }
        update incidentsToUpdate.Values();
    }
*/   
/*
    webservice static void setIncidentStatus( List<FM_Supplier_Response__c> supplierResponses ) 
    {
        Map<String, FM_Supplier_Response__c> responses = new Map<String, FM_Supplier_Response__c> ();
        for ( FM_Supplier_Response__c response : supplierResponses )
        {
            responses.put( response.Incident_Number__c, response );
        }
        
        Map<Id, FM_Incident__c> incidentsToUpdate = new Map<Id, FM_Incident__c> ([ Select f.Submitted_Time__c, f.heath_safety__c, f.Type__c, f.Subject__c, f.SystemModstamp, f.Supplier__c, f.Supplier__r.Name, f.Supplier_Comments__c, f.Sub_Type__c, f.Status__c, f.Raised_By__c, f.Priority__c, f.Phone__c, f.PO_Number__c, f.OwnerId, f.FM_Out_of_Office__c, f.Other__c, f.Operational_efficiency__c, f.On_Site_Arrival_Time__c, f.Name, f.Location__c, f.Location_Street__c, f.Location_County__c, f.Location_City__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Email__c, f.Description__c, f.CreatedDate, f.CreatedById, f.Additional_Information__c, f.Acknowledgement_Time__c, f.Acknowledgement_SLA_Status__c, f.Acknowledgement_Date_Time__c
                                                                                     From FM_Incident__c f
                                                                                    Where Name IN: responses.keySet() ]);
        for ( FM_Incident__c incident : incidentsToUpdate.Values() )
        {
            if ( checkStatus( responses.get( incident.Name ).Incident_Status__c ) )
            {
                incident.Status__c = responses.get( incident.Name ).Incident_Status__c;
                responses.get( incident.Name ).Message_Date__c = incident.Submitted_Time__c;
                responses.get( incident.Name ).Title__c = incident.Name + ' - ' + incident.Subject__c + ' - ' + incident.Status__c + ' - ' + responses.get( incident.Name ).Title__c;
            }
            else
            {    
                throw new FM_Webservice_Exception('Wrong Status on incident ' + incident.Name + ': ' + incident.Status__c);
            }
        }
        insert responses.Values();
        update incidentsToUpdate.Values();
    }
*/ 
/*    
    private static testMethod void test_setIncidentStatus()
    {
        // create supplier
        FM_Supplier__c supplier = new FM_Supplier__c ();
        supplier.Name = 'TestSupplier';
        insert supplier; 
    
        // create incident for test
        FM_Incident__c incident = new FM_Incident__c ();
        incident.Supplier__c = supplier.Id;
        incident.Title__c = 'IncidentTitle';
        incident.Description__c = 'IncidentDescription';
        incident.Status__c = 'Acknowledged';
        //incident.Type__c = '';
        //incident.Syb_Type__c = '';
        incident.Raised_By__c = 'TestName';
        incident.Phone__c = '12345';
        incident.Email__c = 'test@test.com';
        incident.Supplier_Comments__c = 'TestSupplierComments';
        insert incident;

        // create incident for test
        FM_Incident__c incident2 = new FM_Incident__c ();
        incident2.Supplier__c = supplier.Id;
        incident2.Title__c = 'Incident2Title';
        incident2.Description__c = 'Incident2Description';
        incident2.Status__c = 'TestStatus';
        //incident2.Type__c = '';
        //incident2.Syb_Type__c = '';
        incident2.Raised_By__c = 'TestName2';
        incident2.Phone__c = '123456';
        incident2.Email__c = 'test2@test.com';
        incident2.Supplier_Comments__c = 'Test2SupplierComments';
        insert incident2;
                
        List<FM_Incident__c> incidents = new List<FM_Incident__c> ();
        incidents.Add( incident );
        
        List<FM_Supplier_Response__c> supplierResponses = new List<FM_Supplier_Response__c> ();
        
        // test call
        Test.startTest();
            FM_FacilityManagement_Webservice.setIncidentStatus( incidents );
        
            // test assertion
            List<FM_Incident__c> returnedIncidents = [ Select Id, Status__c, Supplier_Comments__c 
                                                         From FM_Incident__c
                                                        Where Id IN: incidents ];
            System.AssertEquals( returnedIncidents.get(0).Status__c, 'Acknowledged' );
            System.Assert( returnedIncidents.get(0).Supplier_Comments__c.Contains( 'TestSupplierComments' ) );
                           
            incidents.Add( incident2 );
            // test call
            try
            {
                FM_FacilityManagement_Webservice.setIncidentStatus( incidents );
            }
            catch ( Exception e )
            {
                // test assertion
                System.Assert( e.getMessage().Contains( 'Wrong Status on incident' ) );
            }
        Test.stopTest();
    }
    */
}