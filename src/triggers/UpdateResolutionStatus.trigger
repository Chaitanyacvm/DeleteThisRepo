trigger UpdateResolutionStatus on Feedback__c (before update) {

	System.Debug('/n/n/n***UpdateResolutionStatus START *****************************/n/n/n');
    NextActionDueController controller = new NextActionDueController();
    for (Feedback__c fb : trigger.new) {
    	
		System.Debug('Assigned to Dept   : ' + fb.Assigned_to_dept__c);
		System.Debug('Department resolved: ' + fb.Department_Resolved__c);
    	
    	if (fb.Status__c == 'Completed') {
    		
	    	string id = fb.Id;
    		Feedback__History[] fh = [Select f.ParentId, f.OldValue, f.NewValue, f.Field, f.CreatedDate From Feedback__History f
				where f.ParentId = :fb.Id and f.Field='Status__c' order by f.CreatedDate];
				
			if (fh.size() > 0) {
				
				for (Feedback__History f : fh) {
					if (f.NewValue == 'Dept Resolved' && f.OldValue == 'Dept Acknowledged Receipt') {
						
						System.Debug('Got the resolve date from the history: ' + f.CreatedDate);
						
						fb.Department_Resolved__c = f.CreatedDate;
						break;
					}
				}
			}	
    		
    		if ((fb.Department_Resolved__c != null) && (fb.Assigned_to_dept__c != null)) { 
    		
	    		Decimal daysToComplete = controller.Difference(fb.Assigned_to_dept__c, fb.Department_Resolved__c);
	    		
	    		System.Debug('DaysToComplete: ' + daysToComplete);
	    		
	    		if (daysToComplete < 5.0) {
	    			fb.Closed_within_5_days__c = true;
	    		}
    		}
    		else {
    			fb.Closed_within_5_days__c = true;
    		}
    	}
    	
    	if ((fb.Status__c == 'Dept Resolved') && (fb.Department_Resolved__c == null)) {
    		fb.Department_Resolved__c = DateTime.Now();
    	}
    	
    }
	System.Debug('/n/n/n****UpdateResolutionStatus END *************************/n/n/n');

}