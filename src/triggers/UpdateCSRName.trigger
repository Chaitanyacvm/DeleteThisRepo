trigger UpdateCSRName on Feedback__c (before insert, before update) {
    for (Feedback__c fb : trigger.new) {
    	try {
    		User u = [select FirstName, LastName from User where id=:fb.OwnerId];
    		fb.Case_Owner__c = u.FirstName + ' ' + u.LastName;
    	}
    	catch (System.Queryexception ex) {
    		fb.Case_Owner__c = 'Customer Experience Team';
    	}
    }
}