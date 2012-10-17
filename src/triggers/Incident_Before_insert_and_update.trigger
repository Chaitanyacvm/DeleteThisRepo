trigger Incident_Before_insert_and_update on FM_Incident__c (before insert, before update) {
    Set<Id> uSet = new Set<Id>();

    for(FM_Incident__c i: Trigger.New){
        uSet.add(i.OwnerId);
    }

    Map<Id, User> uMap = new Map<Id,User> ([select Id, Email , FirstName, LastName from  User where Id in :uSet]);

    for(FM_Incident__c i: Trigger.New){
        i.Owner_Email__c = uMap.get(i.OwnerId).Email;
        i.Owner_Name__c = uMap.get(i.OwnerId).FirstName + ' ' + uMap.get(i.OwnerId).LastName;
    }
}