trigger Depot_Before_Insert_Update on Depot__c (before insert, before update) {
    for (Depot__c depot : Trigger.New) {
        depot.Post_Code__c = depot.Post_Code__c.replaceAll(' ', '').toUpperCase();
    }
}