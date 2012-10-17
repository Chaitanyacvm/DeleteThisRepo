public with sharing class ideaSMS {
	
	
	
	
	@future(callout=true)
	
	public static void sendSMS(String msg, String smsNumber){
	
		HttpRequest req = new HttpRequest();
		
		req.setEndpoint('https://dragon.operatelecom.com:1089/Gateway');
		req.setMethod('POST');
		
		String userName = '147017';
		String passWord = '731ydw6p';
		
		//String Body = getXML();
		
		String Body = '<?xml version="1.0"?>' +
							'<methodCall>' +
							  '<methodName>EAPIGateway.SendSMS</methodName>' +
							  '<params>' +
							    '<param>' +
							      '<value>' +
							        '<struct>' +
								  '<member>' +
								    '<name>Service</name>' +
								    '<value><int>147017</int></value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Password</name>' +
								    '<value>731ydw6p</value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Channel</name>' +
								    '<value><int>13964</int></value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Numbers</name>' +
								    '<value>' + smsNumber + '</value>' +
								  '</member>' +
								  '<member>' +
								    '<name>SMSText</name>' +
								    '<value>' + msg + '</value>' +
								  '</member>' +
								  /*'<member>' +
								    '<name>Delivery</name>' +
								    '<value><dateTime.iso8601>20110802T17:17:00</dateTime.iso8601></value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Expiry</name>' +
								    '<value><dateTime.iso8601>20110802T19:44:00</dateTime.iso8601></value>' +
								  '</member>' +*/
								  '<member>' +
								    '<name>Source</name>' +
								    '<value>TNT Idea</value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Priority</name>' +
								    '<value>Standard</value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Receipt</name>' +
								    '<value>Y</value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Replace</name>' +
								    '<value><int>1</int></value>' +
								  '</member>' +
								  '<member>' +
								    '<name>MaxSegments</name>' +
								    '<value><int>1</int></value>' +
								  '</member>' +
								  '<member>' +
								    '<name>Unicode</name>' +
								    '<value>N</value>' +
								  '</member>' +
								'</struct>' +
							      '</value>' +
							    '</param>' +
							  '</params>' +
							'</methodCall>';
							
		req.setBody(Body);
		
		Http http = new Http();
		
		try{
		
			HTTPResponse res = http.send(req);
			
			
		} catch(system.CalloutException e){
			/*
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        	message.setReplyTo('TNT.UK.Ideas@tnt.co.uk');
        	message.setSenderDisplayName('TNT Idea');
        	message.setSubject('SMS Fail');
			String[] toAddresses = new String[] {'TNT.UK.Ideas@tnt.co.uk'};
            message.setToAddresses(toAddresses);
            message.setHtmlBody(e.getMessage());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            */
		}

	}
	
	static testMethod void testSMS() {
	
		ideaSMS controller = new ideaSMS();	
		
		ideaSMS.sendSMS('TEST SMS', '07411787917');
		
	}
	
}