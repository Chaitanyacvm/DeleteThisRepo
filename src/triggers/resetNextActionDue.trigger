trigger resetNextActionDue on Feedback__c (before update) {
    
    // BusinessHours bh = [select id from BusinessHours where Name = 'CustomerExperienceTeam'];
    // NextActionDueController controller = new NextActionDueController(bh.id, 10L);
    
    NextActionDueController controller = new NextActionDueController();
    
    for (Feedback__c fb : trigger.new) {
        
        if (fb.Days_To_Update__c > 0) {
        
            system.debug('resetNextActionDue Trigger has fired');
            system.debug('CreatedDate ' + fb.CreatedDate); 
            system.debug('Days to Update ' + fb.Days_To_Update__c);
            
            
            Long days = Math.RoundToLong(fb.Days_To_Update__c);
             system.debug('days = ' + days);
            
            // Long milliSecsInAWorkingDay = 12 * 60 * 60 * 1000;
            // system.debug('millisecs = ' + milliSecsInAWorkingDay);
            
            //fb.Next_Action_Due__c = BusinessHours.add(bh.id, 
            //    fb.CreatedDate, days * milliSecsInAWorkingDay);       
           
            fb.Next_Action_Due__c = controller.Calc(fb.CreatedDate, days);
            fb.Days_To_Update__c = 0;
        }
    }
}