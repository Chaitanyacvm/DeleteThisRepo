global class Idea_scheduler implements Schedulable {
  
  global void execute(SchedulableContext SC){
        
        
      User[] email_recipient_users = [SELECT Id, Email FROM User WHERE Idea_Admin_Role__c = 'Idea Champion'];  
      
      List<Id> user_id = new List<Id>();
      
      for(User u : email_recipient_users){
          user_id.add(u.Id);
      }
      
      ID template_id = [SELECT Id FROM EmailTemplate WHERE Name = 'Idea Champion Report'].Id;
      
      Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
      
      //mail.setToAddresses(user_emails);
      
      mail.setTargetObjectIds(user_id);
      
      mail.setReplyTo('tnt@tnt.co.uk');
      
      mail.setSenderDisplayName('TNT Idea');
            
      mail.setTemplateID(template_id);
      
      mail.setSaveAsActivity(false);
      
      Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    
  }
  
  //@istest
  
  static testmethod void test() {
   Test.startTest();

      Account a = new Account();
      a.name = 'testScheduledApexFromTestMethod';
      insert a;

   // Schedule the test job  
    

      String jobId = System.schedule('testBasicScheduledApex',
      '0 22 * ? * MON-FRI', 
      new Idea_scheduler());
   // Get the information from the CronTrigger API object  
    

      CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same  
    
      System.assertEquals('0 22 * ? * MON-FRI', 
         ct.CronExpression);

   // Verify the job has not run  
    
      System.assertEquals(0, ct.TimesTriggered);

      
   Test.stopTest();

   
   }
  
  
}