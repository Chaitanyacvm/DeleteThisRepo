public class UpdateRecordType {
	
	public UpdateRecordType() {
	}
	
    public string id {
        get; 
        set;
    }
	
	public void DoUpdate(string recordTypeName) {
		RecordType rt = [select Id from RecordType where Name=:recordTypeName limit 1];
		System.Debug(rt.Id);
		Feedback__c[] feedbackList = [select Id, Name, RecordTypeId from feedback__c where Id=:id];
		for (Feedback__c fb : feedbacklist) {
			string d = 'Name ' + fb.Name + ' --- RecId ' + fb.RecordTypeId;
			System.debug(d);
			fb.RecordTypeId = rt.Id;
			try {
				Database.SaveResult SR = database.update(fb);
				
				string msg = '************ UPDATE SUCCESS ********** ' + sr.isSuccess();
				System.Debug(msg);
				
				for(Database.Error err: SR.getErrors())
				{
					string errMsg = '********** ERROR **************' + err;
					System.Debug(errMsg);
				}
			}
			catch (DmlException e){
				System.Debug(e);
			}
		}
		
	}
	
    public static testMethod void testUpdateRecordType() {
         
 		
        Feedback__c fb = new Feedback__c(first_name__c         = 'testController',
                                         last_name__c           = 'test',
                                         email__c               = 'test@test.com',
                                         customer_comments__c   = 'test',
                                         subject__c             = 'test subject',
                                         resolution_comments__c = 'comment',
                                         phone__c               = '3434343'
                                         );
        insert fb;
 		
 		UpdateRecordType upRec = new UpdateRecordType();
		upRec.id = fb.Id;
 		upRec.DoUpdate('General Feedback');
      
    }
	
}