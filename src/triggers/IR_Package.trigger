trigger IR_Package on IR_Package__c (before insert, before update, after insert, after update) {
    if (trigger.isBefore) {
        if (trigger.isInsert) {
        } else if (trigger.isUpdate) {
        }
    } else if (trigger.isAfter) {
        if (trigger.isInsert) {
        } else if (trigger.isUpdate) {
        }
    }
}