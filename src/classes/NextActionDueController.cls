public class NextActionDueController {

    private string businessHoursId;
    private long hoursPerDay;
    private long milliSecsInAHour = 60L * 60L * 1000L;        
   
    //public NextActionDueController(string bi, long hours) {
    //    businessHoursId = bi;
    //    hoursPerDay = hours;
    //}
    
    public NextActionDueController() {
    
         BusinessHours bh = [select id, MondayStartTime, MondayEndTime from BusinessHours where Name = 'CustomerExperienceTeam'];
         businessHoursId = bh.id;
         
         DateTime startTime = datetime.newinstance(datetime.newinstance(2011,2,7).date(), bh.MondayStartTime);
         DateTime endTime = datetime.newinstance(datetime.newinstance(2011,2,7).date(), bh.MondayEndTime);
         

         Long Diff = BusinessHours.diff(businessHoursId, startTime, endTime);
         hoursPerDay = diff / milliSecsInAHour;


         System.Debug('***********************************************************\n\n\n');
         System.Debug('StartTime : ' + startTime );
         System.Debug('EndTime   : ' + endTime );

         System.Debug('Diff      : ' + diff );
         System.Debug('day Hours : ' + HoursPerDay );

         System.Debug('\n\n\n***********************************************************\n\n\n');
         
    
    }
    
    public boolean IsWithin1Hour(Feedback__c fb) {
    
         Long diff = BusinessHours.diff(businessHoursId, fb.Logged_Time__c, fb.Assigned_to_dept__c) ;
         
         System.Debug('*************** IsWithin1Hour : ' + diff);
         return (diff < milliSecsInAHour);
    }
    
    public DateTime EffectiveTime(DateTime now) {
        
        DateTime result = BusinessHours.add(businessHoursId, now, 1L); 
        
        return result; 
        
    }
    
    public Datetime Calc(Datetime startDate, Long daysToUpdate) {

        Long hoursToUpdate = hoursPerDay * daysToUpdate; // Assumes 10 hours working.
        Long temp = (hoursToUpdate * milliSecsInAHour);
        
        System.Debug('Millisecs to add: ' + temp);
        Datetime nextDueDate = BusinessHours.add(businessHoursId, startDate, temp);

        return nextDueDate;
    }
    
    public Decimal Difference(DateTime startDate, dateTime endDate) {
        
        // Get the number of millseconds ...
        Long diff = BusinessHours.diff(businessHoursId, startdate, enddate) ;
        
        // Convert to days
        System.Debug('***********************************************************\n\n\n');
        System.Debug('Raw Difference : ' + diff + ' millisecs');
        System.Debug('\n\n\n***********************************************************\n\n\n');
        
        return (diff / milliSecsInAHour / (hoursPerDay * 1.0));
        
        
    }
    
    public static testmethod void testeffectiveTime() {
        NextActionDueController controller = new NextActionDueController();
        
        // Within hours
        System.Debug('***WITHIN HOURS TEST **************************************\n\n\n');
        DateTime result = controller.EffectiveTime(DateTime.newInstance(2010, 11, 25, 10, 12, 0));
        System.Debug('Within hours (25/11/2010 10:12): ' + result);
        System.Debug('***********************************************************\n\n\n');

        // Outside hours
        result = controller.EffectiveTime(DateTime.newInstance(2010, 11, 25, 22, 50, 0));
        System.Debug('***OUTSIDE HOURS TEST *************************************\n\n\n');
        System.Debug('Outside hours (25/11/2010 22:50): ' + result);
        System.Debug('***********************************************************\n\n\n');
    
    }
    
    
    public static testMethod void testNextActionDueController() {
         
        //BusinessHours bh = [select id from BusinessHours where Name = 'CustomerExperienceTeam'];
        //NextActionDueController controller = new NextActionDueController(bh.id, 10L);
        NextActionDueController controller = new NextActionDueController();
        
        Datetime result = DateTime.Now();
        System.Debug('StartTime: ' + result);

        result = controller.Calc(result, 2L);

        System.Debug('Result: ' + result);
     
    }


    public static testMethod void testDifference() {
        
        //BusinessHours bh = [select id from BusinessHours where Name = 'CustomerExperienceTeam'];
        //NextActionDueController controller = new NextActionDueController(bh.id, 10L);
        
        NextActionDueController controller = new NextActionDueController();
        
        DateTime startdate = Datetime.newInstance(2010, 09, 24, 7, 59, 0);
        DateTime endDate = Datetime.newInstance(2010, 09, 28, 16, 0, 0);
        
        Decimal result = controller.Difference(startdate, endDate);
        
        System.Debug('***********************************************************\n\n\n');
        System.Debug('Difference : ' + result + ' days');
        System.Debug('\n\n\n***********************************************************\n\n\n');
        
        
    }


}