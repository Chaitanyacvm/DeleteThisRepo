trigger Form_Type_before_insert_update on PUD_Form_Type__c (before insert, before update) {
    LIST<String> formTypes = new LIST<String>();
    MAP<String, PUD_Form_Type__c> formTypesMap = new MAP<String, PUD_Form_Type__c>();
    for (PUD_Form_Type__c formType : Trigger.New) {
        formTypes.add(formType.Name);
    }
    
    for (PUD_Form_Type__c formType : [SELECT Id, Name FROM PUD_Form_Type__c WHERE Name IN :formTypes]) {
        formTypesMap.put(formType.Name, formType);
    }
    
    for (PUD_Form_Type__c formType : Trigger.New) {
        if (formTypesMap.get(formType.Name) != null) {
            formType.Name.addError('The Form Type already exists');
        }
    }
}