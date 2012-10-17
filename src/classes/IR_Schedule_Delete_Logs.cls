global class IR_Schedule_Delete_Logs implements Schedulable {
	
	global IR_Schedule_Delete_Logs(){
		
	}

	global void execute(SchedulableContext ctx){
		try{
		Date d = Date.today()-2;
		List<Log__c> logs = new List<Log__c>([SELECT Id FROM Log__c WHERE CreatedDate < :d]);
		Delete logs; 
		}catch(Exception e){
			system.debug('==>IR_Schedule_Delete_Logs: ' + e.getMessage());
		}
	}
}