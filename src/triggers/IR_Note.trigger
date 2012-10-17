trigger IR_Note on Note (after insert, after update, before insert, before update) {
    if (trigger.isBefore) {
        if (trigger.isInsert) {
            
        } else if (trigger.isUpdate) {
            Map<Id, Profile> irProfilesMap = new Map<Id, Profile>([SELECT Id FROM Profile WHERE Name like 'IR%']);
            
            for (Note thisNote : trigger.new) {
                if (irProfilesMap.get(UserInfo.getProfileId()) != null) {
                    thisNote.addError('You do not have permission to edit Notes');
                }
            }
        }
    } else if (trigger.isAfter) {
        if (trigger.isInsert) {
            
        } else if (trigger.isUpdate) {
            
        }
    }
}