trigger NoteIncident on Note (after insert, after update) {
	
	List<Id> IdInc = new List<Id>();
	
	for (Note n : trigger.new){
		IdInc.add(n.ParentId);
	}
	
	system.debug('aaron: ' + IdInc.size());
	
	List<FM_Incident__c> Inc = [select id, name, AttachmentAndNoteTimeStamp__c, Status__c from FM_Incident__c where Id IN :IdInc];
	
	system.debug('aaron: ' + Inc.size());
	
	for (FM_Incident__c i : Inc){
		if (i.AttachmentAndNoteTimeStamp__c <> datetime.now() && i.AttachmentAndNoteTimeStamp__c <> null)
			i.AttachmentAndNoteTimeStamp__c = datetime.now();
			update i;
	}

}