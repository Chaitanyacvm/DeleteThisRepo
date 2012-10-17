trigger Update1HourSLA on Feedback__c (before update) {
    
    BusinessHours bh = [select id, MondayStartTime, MondayEndTime from BusinessHours where Name = 'CustomerExperienceTeam'];
    string businessHoursId = bh.id;
    long milliSecsInAHour = 60L * 60L * 1000L;        
    
    for (Feedback__c fb : trigger.new) {
        if (fb.Assigned_to_dept__c != null)   {
            if (!fb.Re_opened__c) {
                
                if (fb.Logged_Time__c == null) {
                    fb.Logged_Time__c = fb.CreatedDate;
                }
             }   
            Long diff = BusinessHours.diff(businessHoursId, fb.Logged_Time__c, fb.Assigned_to_dept__c) ;

            System.Debug('Update1HourSLA ********************************************\n\n\n');
            System.Debug('StartTime : ' + fb.Logged_Time__c );
            System.Debug('EndTime   : ' + fb.Assigned_to_dept__c );
            System.Debug('Diff      : ' + diff );
            System.Debug('\n\n\n***********************************************************\n\n\n');

            if (fb.Assigned_within_1_hour__c == false)
            {               
                NextActionDueController ctrl = new NextActionDueController();
                fb.Assigned_within_1_hour__c = ctrl.IsWithin1Hour(fb);
                //fb.Assigned_within_1_hour__c = (diff < milliSecsInAHour);
            }
         
        }
        else {
        
            System.Debug ('*********** Department is unassigned ************** ');
        }
    }
}