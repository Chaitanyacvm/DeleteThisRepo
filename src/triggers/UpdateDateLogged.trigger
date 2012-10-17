trigger UpdateDateLogged on Feedback__c (before insert) {
    NextActionDueController controller = new NextActionDueController();
    
    for (Feedback__c fb : trigger.new) {
    	fb.Logged_Time__c = controller.EffectiveTime(DateTime.Now());
    }
}