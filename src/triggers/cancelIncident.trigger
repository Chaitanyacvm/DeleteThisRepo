trigger cancelIncident on FM_Incident__c (after insert, after update) 
{
    Set<Id> incidentsToCancelKeys = new Set<Id>();
    
    for ( FM_Incident__c incident : trigger.New )
        incidentsToCancelKeys.add( incident.replaced_Incident__c );
     
    Map<Id, FM_Incident__c> incidentsToCancel = new Map<Id, FM_Incident__c>([ Select Id, Status__c, Sub_Status__c
                                                                                From FM_Incident__c
                                                                               Where Id IN: incidentsToCancelKeys ]);
       
    for ( FM_Incident__c incident : incidentsToCancel.Values() )
    {
        incidentsToCancel.get( incident.Id ).Status__c = 'Closed';
        incidentsToCancel.get( incident.Id ).Sub_Status__c = 'Cancelled';
    }
    
    update incidentsToCancel.Values();
}