trigger set1HourSLA on Feedback__c (before insert) {
    
    BusinessHours bh = [select id from BusinessHours where Name = 'CustomerExperienceTeam'];
    
    for (Feedback__c fb : trigger.new) {
        
        if (fb.Next_Action_Due__c == null) {
        
            system.debug('set1HourSLA Trigger has fired');
            system.debug('CreatedDate ' + fb.CreatedDate); 
            
            
            Long milliSecsInAHour = 60 * 60 * 1000;
            
            fb.Next_Action_Due__c = BusinessHours.add(bh.id, 
                System.Now(), milliSecsInAHour);       
           
        }
    }

}