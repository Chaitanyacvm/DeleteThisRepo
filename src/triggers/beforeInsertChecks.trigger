trigger beforeInsertChecks on Form_Schedule__c (before insert) {
    LIST<Id> relatedDepots = new LIST<Id>();
    MAP<Id, MAP<String, Boolean>> existingSchedules = new MAP<Id, MAP<String, Boolean>>();
    
    for (Form_Schedule__c fs : Trigger.New) {
        relatedDepots.add(fs.Depot__c);
        existingSchedules.put(fs.Depot__c, new MAP<String, Boolean>());
    }
    
    for (Form_Schedule__c fs : [SELECT Id, Name, Form__c, Depot__c FROM Form_Schedule__c WHERE Depot__c IN :relatedDepots]) {
        existingSchedules.get(fs.Depot__c).put(fs.Form__c, TRUE);
    }
    
    for (Form_Schedule__c fs : Trigger.New) {
        if (existingSchedules.get(fs.Depot__c).get(fs.Form__c) != null && existingSchedules.get(fs.Depot__c).get(fs.Form__c)) {
            fs.Form__c.addError('A schedule has already been created for this report');
        } else {
            existingSchedules.get(fs.Depot__c).put(fs.Form__c, TRUE);
        }
    }
}