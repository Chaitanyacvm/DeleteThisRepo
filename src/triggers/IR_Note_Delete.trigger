trigger IR_Note_Delete on Note (after delete, before delete) {
	if (trigger.isBefore) {
		Map<Id, Profile> irProfilesMap = new Map<Id, Profile>([SELECT Id FROM Profile WHERE Name like 'IR%']);
		
		for (Note thisNote : trigger.old) {
			if (irProfilesMap.get(UserInfo.getProfileId()) != null) {
				thisNote.addError('You do not have permission to delete Notes');
			}
		}
	} else if (trigger.isAfter) {
		
	}
}