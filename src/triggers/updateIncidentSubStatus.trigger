trigger updateIncidentSubStatus on FM_Quote__c (after Update) {

    // key set
    Set<Id> quoteAcceptedIncidentIds = new Set<Id>();
    
    // put all keys into key set
    for ( FM_Quote__c quote : trigger.New ){
        if (quote.Status__c == 'Accepted')
        {
            QuoteAcceptedIncidentIds.add( quote.Incident__c );
        }
    }
    // select all incidents through key set
    Map<Id, FM_Incident__c> quoteAcceptedIncidents = new Map<Id, FM_Incident__c>([ Select Id, Status__c, Sub_Status__c, Name, Subject__c
                                                                                        From FM_Incident__c
                                                                                       Where Id IN: quoteAcceptedIncidentIds ]);
    
    // set all sub status updates
    for (FM_Quote__c quote : trigger.New )
    {
        if (quote.Status__c == 'Accepted')
        {
                quoteAcceptedIncidents.get( quote.Incident__c ).Sub_Status__c = 'Quote Authorised';
                quoteAcceptedIncidents.get( quote.Incident__c ).Status__c = 'Supplier Progress';
        }
        
    // update incidents
        update quoteAcceptedIncidents.Values();
    }
}