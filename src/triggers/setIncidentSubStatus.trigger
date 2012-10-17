trigger setIncidentSubStatus on FM_Supplier_Response__c (before insert) 
{
    Id recordTypeIdWS = [Select Id From RecordType Where DeveloperName = 'With_Supplier' And SobjectType = 'FM_Incident__c'].Id;
    Id recordTypeIdO = [Select Id From RecordType Where DeveloperName = 'Open' And SobjectType = 'FM_Incident__c'].Id;
    //Map<String, Id> recordTypeMap = new Map<String, Id>();
    //for(RecordType rt : [Select Id, DeveloperName From RecordType Where DeveloperName = 'With_Supplier' Or DeveloperName = 'Open']){
    //    recordTypeMap.put(rt.DeveloperName, rt.Id);
    //}

    // key set
    Set<Id> supplierResponseIncidentIds = new Set<Id>();
    
    // put all keys into key set
    for ( FM_Supplier_Response__c supplierResponse : trigger.New )
        supplierResponseIncidentIds.add( supplierResponse.Incident__c );

    // select all incidents through key set
    Map<Id, FM_Incident__c> supplierResponseIncidents = new Map<Id, FM_Incident__c>([ Select Id, Sub_Status__c, Name, Subject__c
                                                                                        From FM_Incident__c
                                                                                       Where Id IN: supplierResponseIncidentIds ]);
    
    // set all sub status updates
    for ( FM_Supplier_Response__c supplierResponse : trigger.New )
    {
        supplierResponseIncidents.get( supplierResponse.Incident__c ).Sub_Status__c = supplierResponse.Incident_Status__c;
        supplierResponse.Title__c = supplierResponseIncidents.get( supplierResponse.Incident__c ).Name + ' - ' + supplierResponseIncidents.get( supplierResponse.Incident__c ).Subject__c + ' - ' + supplierResponse.Incident_Status__c + ' - ' + supplierResponse.Title__c;
        if(supplierResponse.Incident_Status__c == 'Acknowledged'){
            supplierResponseIncidents.get( supplierResponse.Incident__c ).RecordTypeId = recordTypeIdWS;//recordTypeMap.get('With_Supplier');
        } else if(supplierResponse.Incident_Status__c == 'Completed'){
            supplierResponseIncidents.get( supplierResponse.Incident__c ).RecordTypeId = recordTypeIdO;//recordTypeMap.get('Open');
        }
    }

    // update incidents
    update supplierResponseIncidents.Values();
}