@isTest
private class FM_Incident_TEST_BEFORE{

    static testMethod void testSubStatusChange(){
        Id recordTypeIdWithSupplier = [Select Id From RecordType Where DeveloperName = 'With_Supplier' And SobjectType = 'FM_Incident__c'].Id;
        Id recordTypeIdOpen = [Select Id From RecordType Where DeveloperName = 'Open' And SobjectType = 'FM_Incident__c'].Id;
        BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];
            
        // create supplier
        FM_Supplier__c supplier = new FM_Supplier__c();
        supplier.Name = 'TestSupplier';
        insert supplier;
        
        // create location
        FM_Location__c location = new FM_Location__c ();
        location.Name = 'TestLocation';
        insert location;
        
        //create location level
        FM_Location_Level__c level = new FM_Location_Level__c ();
        level.Name = 'TestLocationLevel';
        level.Location__c= location.Id;
        insert level;
        
        //create location room
        FM_Location_Room__c room = new FM_Location_Room__c ();
        room.Name = 'TestLocationRoom';
        room.Location_Level__c= level.Id;
        insert room;
        
        //create location area
        FM_Location_Area__c area = new FM_Location_Area__c ();
        area.Name = 'TestLocationRoom';
        area.Location_Room__c= room.Id;
        insert area;
        
        // create rule
        FM_Service_Level__c rule = new FM_Service_Level__c ();
        rule.Location__c = location.Id;
        rule.Scope__c = 'Cleaning';
        rule.Supplier__c = supplier.Id;
        rule.In_Hours_Acknowledgement_SLA__c = 2.5;
        rule.Out_Hours_Acknowledgement_SLA__c = 5;
        rule.Start_In_Hours__c = 9;
        rule.End_In_Hours__c = 17;
        rule.Business_Hours_In__c = stdBusinessHours.Id;
        rule.Business_Hours_Out__c = stdBusinessHours.Id;
        rule.Priority_Level__c = 'P4';
        insert rule;
        
        // create incident for test
        FM_Incident__c incident = new FM_Incident__c ();
        incident.Location__c = location.Id;
        incident.Subject__c = 'IncidentTitle';
        incident.Description__c = 'IncidentDescription';
        incident.Status__c = 'With Supplier';
        incident.Service__c = 'Cleaning';
        incident.Type__c = 'Cleaning';
        incident.Sub_Type__c = 'Cleaning';
        //incident.Syb_Type__c = '';
        incident.Raised_By__c = 'TestName';
        incident.Phone__c = '12345';
        incident.Email__c = 'test@test.com';
        Incident.Any_Risk_Applicable__c = 'No';
        incident.PO_Number__c = '123';
        
        // create asset for location
        FM_Asset__c locationasset = new FM_Asset__c();
        locationAsset.Name = 'LOC Asset';
        locationAsset.Location__c= location.id;
        
        // create asset for level
        FM_Asset__c levelasset = new FM_Asset__c();
        levelasset.Name = 'LEV Asset';
        levelasset.Location_Level__c= level.id;
        
        // create asset for room
        FM_Asset__c roomasset = new FM_Asset__c();
        roomasset.Name = 'ROOM Asset';
        roomasset.Location_Room__c= room.id;
        
        // create asset for area
        FM_Asset__c areaasset = new FM_Asset__c();
        areaasset.Name = 'AREA Asset';
        areaasset.Location_Area__c= area.id;
        
        Test.startTest();
            // insert test
            insert incident;
            
            // update tests
            // case1: acknowledged
            incident.Sub_Status__c = 'Acknowledged';
            update incident;
            System.Assert([SELECT Id, RecordTypeId FROM FM_Incident__c WHERE Id =: incident.Id].RecordTypeId == recordTypeIdWithSupplier);
            
            // case2:  Information Required
            incident.Sub_Status__c =  'Information Required';
            update incident;
            System.Assert([SELECT Id, RecordTypeId FROM FM_Incident__c WHERE Id =: incident.Id].RecordTypeId == recordTypeIdOpen);
            
            // case3:  Completed
            incident.Sub_Status__c =  'Completed';
            update incident;
            System.Assert([SELECT Id, RecordTypeId FROM FM_Incident__c WHERE Id =: incident.Id].RecordTypeId == recordTypeIdOpen);
            
            // case4:  Not Verified
            incident.Status__c = 'Closed';
            incident.Sub_Status__c =  'Not Verified';
            update incident;
            System.Assert([SELECT Id, RecordTypeId FROM FM_Incident__c WHERE Id =: incident.Id].RecordTypeId == recordTypeIdOpen);
        Test.stopTest();
    }
}