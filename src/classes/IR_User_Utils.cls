/************************************************************************************************************
* CHANGES
* 2011/04/20 - Makepositive - Technical Architect - James Tildesley - +44 (0)20 7928 1497
*************************************************************************************************************
* DESCRIPTION
* This class contains the main User methods for the Internet Registration Project Methods in this class use
* the Apex Page Message so please ensure they are called from within a Visualforce Page
************************************************************************************************************/

public class IR_User_Utils {
	public static IR_Customer__c SA_Proceed(IR_Customer__c thisCustomer) {		
		if (thisCustomer.Send_to_CE_Queue__c == 'Yes') {
			Boolean validForBooking = true;
			
			if(thisCustomer.Comments__c == null){
				validForBooking = false;
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please complete the comments'));
			}
			
			if (validForBooking) {
				//Send the Customer to the Customer Experience Queue
				thisCustomer = assign_To_CE_Queue(thisCustomer);
				thisCustomer = Create_Note_Attachement(thisCustomer,'Sales Admin Comments');
			}
		} else {
			Boolean validForBooking = true;
			
			/*if (thisCustomer.Booking_Complete__c) {
				validForBooking = false;
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'The booking has already been made'));
			}*/
			
			if (thisCustomer.Account_Status_Int__c == null) {
				validForBooking = false;
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please complete the International Account status'));
			}
			
			if (thisCustomer.Account_Status_Dom__c == null) {
				validForBooking = false;
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please complete the Domestic Account status'));
			}
			
			if(thisCustomer.Comments__c == null){
				validForBooking = false;
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please complete the comments'));
			}
			
			if (trading_Customer(thisCustomer)) {
				if ((thisCustomer.International_Account_Number__c == null && thisCustomer.Account_Status_Int__c == 'Trading') || (thisCustomer.Domestic_Account_Number__c == null && thisCustomer.Account_Status_Dom__c == 'Trading')) {
					if (thisCustomer.Account_Status_Int__c == 'Trading') {
						validForBooking = false;
			        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please complete the International Account Number'));
					} else {
						validForBooking = false;
			        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please complete the Domestic Account Number'));
					}
				}
			} else {
				if (thisCustomer.International_Account_Number__c == null || thisCustomer.Domestic_Account_Number__c == null) {
					validForBooking = false;
		        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please ensure the International Account Number'));
		        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please ensure the Domestic Account Number'));
				}
			}
			
			//Make the Express Connect Booking
			if (validForBooking) {
				
				Boolean domestic_booking = false;
				Boolean bookingSuccess=false;
				Integer counter = 0;
				//this part was chnaged for the issue raised 225, where if the booking is made agianst a non-trading account then it should be rejected.
															
				if(thisCustomer.Account_Status_Int__c == 'Trading' || thisCustomer.Account_Status_Dom__c == 'Trading'){					
					
					if(!thisCustomer.Register_Only__c){
						for(IR_Consignment__c consignment : thisCustomer.Consignments__r){
							
							if(consignment.To_Country_Code__c == 'UK' || consignment.To_Country_Code__c =='GB'){							
								domestic_booking = true;
							}							
							
							if(thisCustomer.Account_Status_Dom__c == 'Trading' && domestic_booking){								
								bookingSuccess = make_Booking(thisCustomer, counter);																		
							}else if(thisCustomer.Account_Status_Int__c == 'Trading' && !domestic_booking){								
								bookingSuccess = make_Booking(thisCustomer, counter);															
							}else{
								bookingSuccess = false;
								thisCustomer = reject_Customer(thiscustomer);								
							}												
						}//end for
					}else{
						//reject if the customer is register only!
						bookingSuccess = false;
						thisCustomer = reject_Customer(thiscustomer);
					}//end if register only.																					
				}else{						
						bookingSuccess = make_Booking(thisCustomer, counter);															
				}		
				if (bookingSuccess) {
					thisCustomer = complete_Booking(thisCustomer);
					thisCustomer = Create_Note_Attachement(thisCustomer,'Sales Admin Comments');
				}
			}
		}
		IR_Global_Class.insertLogResponseXML();
		return thisCustomer;
	}
	public static IR_Customer__c Create_Note_Attachement(IR_Customer__c customer, String title){
		if(customer.Comments__c != null && customer.Comments__c.length() > 0){
		Note notes = new Note();
		notes.Title = title;
		notes.Body = customer.Comments__c;
		notes.ParentId = customer.Id;		
		insert notes;
		customer.Comments__c = null;
		}
		return customer;
														
	}
	//used for rate card selection
	public static Integer getETLSettingVal(IR_Customer__c thisCustomer){		
		Integer etlSetting;
		if (thisCustomer.Extended_Transit_Liability_Setting__c == null) {
                etlSetting = 0;
            } else if (thisCustomer.Extended_Transit_Liability_Setting__c == '£5,000')  {
                etlSetting = 4;
            } else if (thisCustomer.Extended_Transit_Liability_Setting__c == '£10,000')  {
                etlSetting = 7;
            } else if (thisCustomer.Extended_Transit_Liability_Setting__c == '£15,000')  {
                etlSetting = 10;
            } else {
                etlSetting = 0;
            }
            System.debug('ETlSETTING****'+etlSetting);
            return etlSetting;				
	}
	
	public static IR_Customer__c CE_Complete(IR_Customer__c thisCustomer) {
				
		if (thisCustomer.Total_Rejection_Of_Request__c && !thisCustomer.Customer_Withdrawn__c) {
				if (thisCustomer.Comments__c == null) {				
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter some Comments'));
				}else{
				thisCustomer = reject_Customer(thisCustomer);
				thisCustomer = Create_Note_Attachement(thisCustomer,'Customer Experience Comments');
				}			
		} else if (thisCustomer.Customer_To_Resubmit__c) {
			thisCustomer = request_Customer_Resubmit(thisCustomer);
		} else if (thisCustomer.Booking_No_Longer_Required__c) {
			//logic changed according to fix log V_53 and fix no:288			
			//thisCustomer = complete_Customer(thisCustomer);
			thisCustomer = assign_To_SA_Queue(thisCustomer);
			
		}else if(thisCustomer.Customer_Withdrawn__c){
				if (thisCustomer.Comments__c == null) {				
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter some Comments'));
				}else{
				thisCustomer = withdraw_Customer(thisCustomer);			
				}
							
		} else {
			Boolean validCustomer = true;
			
			//Check that the Comments have been entered
			if (thisCustomer.Comments__c == null) {
				validCustomer = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter some Comments'));
			}
			
			//Check that the Security Check has been approved (if required)
			if (thisCustomer.Security_Check_Fail__c && !thisCustomer.Security_Check_Accepted__c) {
				validCustomer = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'A Security Check is Required'));
			}
			
			//Check that the Potential Private Individual Check has been approved (if required)
			if (thisCustomer.Potential_Private_Individual__c && !thisCustomer.Private_Individual_Check_OK__c) {
				validCustomer = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'A Private Individual Check is Required'));
			}
			
			//Check that the Customer has been Confirmed Off Stop (if required)
			if ((thisCustomer.Domestic_Account_On_Stop__c || thisCustomer.International_Account_On_Stop__c) && !thisCustomer.Confirmed_Off_Stop__c) {
				validCustomer = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'An Off Stop Check is Required'));
			}						
			//If the Customer has been completed successfully by the CE Team then assign it back to SA
			if (validCustomer) {
				thisCustomer = assign_To_SA_Queue(thisCustomer);
				thisCustomer = Create_Note_Attachement(thisCustomer,'Customer Experience Comments');
			}
		}
		
		return thisCustomer;
	}
	
	public static IR_Customer__c RC_Complete(IR_Customer__c thisCustomer) {
		Boolean completed = true;	
		Integer counter = 0;	
		if (!thisCustomer.Dom_Rates_Loaded__c) {
			completed = false;			
		}
		
		if (!thisCustomer.Dom_Contacts_Loaded__c) {
			completed = false;			
		}
		
		if (!thisCustomer.Int_Rates_Loaded__c) {
			completed = false;			
		}
		
		if (!thisCustomer.Int_Contacts_Loaded__c) {
			completed = false;			
		}
		
		if (completed) {			
			Boolean success = true;
			// this part was changed for the issue 218, as the eInvoicing should be triggred only when both the accounts have been flaged.
			//if (!thisCustomer.Dom_EInvoicing_Already_Registered__c || !thisCustomer.Int_EInvoicing_Already_Registered__c) 
			if (!thisCustomer.Dom_EInvoicing_Already_Registered__c && !thisCustomer.Int_EInvoicing_Already_Registered__c) {
				IR_Global_Class.logIRError('EInv - 1', 'Call to EInv Initiated');
				success = create_EInvoicing_User(thisCustomer,counter);				
			}
			
			if (success) {
				thisCustomer = complete_Customer(thisCustomer);
				thisCustomer = Create_Note_Attachement(thisCustomer,'Rates and Contacts Comments');
			}				
			}else {				
				thisCustomer = assign_To_RC_Queue(thisCustomer);
			}
		IR_Global_Class.insertLogResponseXML();
		return thisCustomer;
	}
	
	public static IR_Customer__c assign_To_SA_Queue(IR_Customer__c thisCustomer) {
		thisCustomer.OwnerId = IR_Global_Class.getNewCustomersQueueId();
		thisCustomer.Registration_Status__c = 'In Sales Admin Queue';
		thisCustomer.RecordTypeId = getCustomerRecordTypeId('Sales Admin');
		
		return thisCustomer;
	}
	
	public static IR_Customer__c assign_To_CE_Queue(IR_Customer__c thisCustomer) {
		thisCustomer.OwnerId = IR_Global_Class.getCustomersExperienceQueueId();
		thisCustomer.Registration_Status__c = 'In Customer Experience Queue';
		thisCustomer.RecordTypeId = getCustomerRecordTypeId('Customer Experience');
		
		return thisCustomer;
	}
	
	public static IR_Customer__c assign_To_RC_Queue(IR_Customer__c thisCustomer) {
		thisCustomer.OwnerId = IR_Global_Class.getRatesandContactsQueueId();
		thisCustomer.Registration_Status__c = 'In Rates and Contacts Queue';
		thisCustomer.RecordTypeId = getCustomerRecordTypeId('Rates and Contacts');
		
		return thisCustomer;
	}
	
	public static Id getCustomerRecordTypeId(String recordTypeName) {
		try {
			Schema.DescribeSObjectResult customerDescribe = Schema.SObjectType.IR_Customer__c; 
			Map<String,Schema.RecordTypeInfo> customerRecordTypesByName = customerDescribe.getRecordTypeInfosByName();
			
			return customerRecordTypesByName.get(recordTypeName).getRecordTypeId();
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error getting Customer Record Type ' + recordTypeName + ':' + e.getMessage()));
			
			return null;
		}
	}
	
	public static IR_Customer__c user_reject(IR_Customer__c thiscustomer){
				
		if (thisCustomer.Comments__c == null) {							
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter some Comments'));
				return thiscustomer;
		}else{
				IR_Customer__c customer = reject_Customer(thiscustomer);
				customer = Create_Note_Attachement(customer, 'Sales Admin Comments');  		
				upsert customer;
				return customer;
		}				
	}
	
	private static IR_Customer__c reject_Customer(IR_Customer__c thisCustomer) {
		thisCustomer.Registration_Status__c = 'Rejected';
		
		return thisCustomer;
	}
	
	private static IR_Customer__c withdraw_Customer(IR_Customer__c thisCustomer){
		thisCustomer.Registration_Status__c = 'Customer Withdrawn';
		
		return thisCustomer;	
	}
	
	private static IR_Customer__c request_Customer_Resubmit(IR_Customer__c thisCustomer) {
		thisCustomer.Registration_Status__c = 'Customer to Re-Submit';
		
		return thisCustomer;
	}
	
	private static IR_Customer__c complete_Booking(IR_Customer__c thisCustomer) {
		thisCustomer.Booking_Complete__c = true;
		
		if (trading_Customer(thisCustomer)) {
			thisCustomer = complete_Customer(thisCustomer);
		} else {
			thisCustomer = assign_To_RC_Queue(thisCustomer);
		}
		
		return thisCustomer;
	}
	
	
	private static IR_Customer__c complete_Customer(IR_Customer__c thisCustomer) {
		thisCustomer.Registration_Status__c = 'Complete';
		
		return thisCustomer;
	}
	
	
	private static Boolean trading_Customer(IR_Customer__c thisCustomer) {
		return (thisCustomer.Account_Status_Dom__c == 'Trading' || thisCustomer.Account_Status_Int__c == 'Trading');
	}
	
	private static Boolean make_Booking(IR_Customer__c thisCustomer, Integer counter) {
		
		counter ++;
    	LIST<IR_Consignment__c> consignments = new LIST<IR_Consignment__c>();
    	LIST<IR_Order__c> orders = new LIST<IR_Order__c>();
    	MAP<Id, Boolean> sendBookingEmailsMap = new MAP<Id, Boolean>(); 
    	
    	Boolean bookingSuccess = true;
        if (thisCustomer.Orders__r != null) {
        	LIST<Id> orderIds = new LIST<Id>();
        	for (IR_Order__c thisOrder : thisCustomer.Orders__r) {
    			orderIds.add(thisOrder.Id);
        	}
        	
        	Map<Id,LIST<IR_Consignment__c>> consignmentsMap = new Map<Id,LIST<IR_Consignment__c>>();
        	for (IR_Consignment__c thisConsignment : IR_Global_Class.getConsignmentsByOrder(orderIds)) {
        		if (consignmentsMap.get(thisConsignment.Order_IR__c) == null) {
        			consignmentsMap.put(thisConsignment.Order_IR__c, new LIST<IR_Consignment__c>());
        		}
        		
        		consignmentsMap.get(thisConsignment.Order_IR__c).add(thisConsignment);
        	}
        	
        	for (IR_Order__c thisOrder : thisCustomer.Orders__r) {
            	if(thisOrder.Order_Status__c != 'Complete' && consignmentsMap.get(thisOrder.Id) != null) {
			        Boolean orderSuccess = true;
			        if(!thisCustomer.Booking_No_Longer_Required__c){//logic changed according to fix log V_53 and fix no:288			        		
	            		for (IR_Consignment__c thisConsignment : consignmentsMap.get(thisOrder.Id)) {
	            			try {
	            				if (!thisConsignment.Booking_Complete__c) {
		            				IR_Global_Class.BookResult result = IR_Global_Class.makeBooking(thisCustomer, thisOrder, thisConsignment);          				
		            				thisConsignment.Booking_Result__c = (result.success ? result.confirmationCode : result.errorResponse);
									thisConsignment.Booking_Complete__c = result.success;
									
		                            if (!result.success) {
		                                orderSuccess = false;
		                            } else {
		                            	sendBookingEmailsMap.put(thisConsignment.Id, true);
		                            }		                            
		                    		consignments.add(thisConsignment);
	            				}		
	            			} catch(Exception e) {
	            				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
	            			}                    		
	            		}
			        }            		
            		if (orderSuccess &&  !thisCustomer.Booking_No_Longer_Required__c) {
						thisOrder.Order_Status__c = 'Complete';					
		        	} else if(orderSuccess && thisCustomer.Booking_No_Longer_Required__c){
		        		thisOrder.Order_Status__c = 'Cancelled';
		        	} else {
						bookingSuccess = false;
						thisOrder.Order_Status__c = 'Failed';
						
		        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'The order ' + thisOrder.Id + ' failed when booking'));
		        	}
		        	
            		orders.add(thisOrder);
            	}        		                   
            }
        }
        
		//If the customer is not trading and the MyTNT Account hasn't already been registered
		if (bookingSuccess && !trading_Customer(thisCustomer) && !thisCustomer.MyTNT_Already_Registered__c) {
			IR_Global_Class.logIRError('MYTNT - 1', 'Call to MYTNT Initiated');
        	
        	bookingSuccess = create_MyTNT_User(thisCustomer,counter);
        	
        	thisCustomer.Registered_MyTNT__c = bookingSuccess;
		}
		
        update consignments;
        update orders;
        
        return bookingSuccess;
	}
		
	private static Boolean create_MyTNT_User(IR_Customer__c thisCustomer,Integer counter) {
        try {
        	IR_Global_Class.logIRError('MYTNT - 2', 'In create_MyTNT_User function.==> Counter: ' + counter);
        	
	        MAP<String, String> myTNTResults = IR_External_Service_Registration.create_MyTNT_User(thisCustomer, counter);
	        	        
	       	if (myTNTResults == null || myTNTResults.keySet().size() == 0) {
	       		return true;
	       	} else {
	       		System.debug('@MAPMYNTNT@'+myTNTResults);
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'MyTNT user registration failed.'));
	       		
	       		for (String key : myTNTResults.keySet()) {
	       			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, key + ': ' + myTNTResults.get(key)));
	       		}
	       		
	       		return false;
	       	}
        } catch (Exception e) {
        	System.debug(e);
        	
        	return false;
        }
	}
	
	private static Boolean create_EInvoicing_User(IR_Customer__c thisCustomer, Integer counter) {
        try {
        	counter ++;
        	IR_Global_Class.logIRError('EInv - 2', 'In create_EInvoicing_User ==> Counter: ' + counter);
	        MAP<String, String> eInvoicingResults = IR_External_Service_Registration.create_EInvoicing_User(thisCustomer,counter);
	       	
	       	if (eInvoicingResults == null || eInvoicingResults.keySet().size() == 0) {
	       		return true;
	       	} else {
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'eInviocing registration failed.'));
	       		
	       		for (String key : eInvoicingResults.keySet()) {
	       			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, key + ': ' + eInvoicingResults.get(key)));
	       		}
	       		
	       		return false;
	       	}
        } catch (Exception e) {
        	System.debug(e);
        	
        	return false;
        }
	}
	//************************** Test Methods *****************************//
	
	TestMethod static void test_SA_Proceed_Case1(){
		IR_Customer__c testCust = new IR_Customer__c(Security_Check_Fail__c = true, Security_Check_Accepted__c = false, Potential_Private_Individual__c = true, Private_Individual_Check_OK__c= false, Domestic_Account_On_Stop__c=true, Confirmed_Off_Stop__c = false,International_Account_On_Stop__c = true, Booking_Complete__c=true,Account_Status_Int__c='New',Account_Status_Dom__c='New',International_Account_Number__c='123456789',Domestic_Account_Number__c='1234567890', Dom_Rates_Loaded__c = true, Dom_Contacts_Loaded__c = true, Int_Rates_Loaded__c =true,Int_Contacts_Loaded__c=true, Dom_EInvoicing_Already_Registered__c=true,Int_EInvoicing_Already_Registered__c=true, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='123456456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        IR_Customer__c testCust2 = IR_Global_Class.getCustomer(testCust.Id);
        System.debug(IR_User_Utils.SA_Proceed(testCust2));
	}
	TestMethod static void test_SA_Proceed_Case2(){		       
       //domestic  
        IR_Customer__c testCust = new IR_Customer__c(Booking_Complete__c=false,Account_Status_Int__c='Trading',Account_Status_Dom__c='Trading',International_Account_Number__c='123456789',Domestic_Account_Number__c='1234567890', Dom_Rates_Loaded__c = false, Dom_Contacts_Loaded__c = false, Int_Rates_Loaded__c =false,Int_Contacts_Loaded__c=false, Dom_EInvoicing_Already_Registered__c=true,Int_EInvoicing_Already_Registered__c=true, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='123456456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id, To_Country__c = 'United Kingdom',From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today(),Pickup_Collection_Time_from__c='11:00',Pickup_Collection_Time_to__c='14:00');
        insert testCon;
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        IR_Customer__c testCust2 = IR_Global_Class.getCustomer(testCust.Id);        
        System.debug(IR_User_Utils.SA_Proceed(testCust2));                
	}
	TestMethod static void test_SA_Proceed_Case3(){		       
       //domestic  
        IR_Customer__c testCust = new IR_Customer__c(Booking_Complete__c=false,Account_Status_Int__c='Trading',Account_Status_Dom__c='Trading',International_Account_Number__c='123456789',Domestic_Account_Number__c='1234567890', Dom_Rates_Loaded__c = false, Dom_Contacts_Loaded__c = false, Int_Rates_Loaded__c =false,Int_Contacts_Loaded__c=false, Dom_EInvoicing_Already_Registered__c=true,Int_EInvoicing_Already_Registered__c=true, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='123456456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id, To_Country__c = 'Australia',From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today(),Pickup_Collection_Time_from__c='11:00',Pickup_Collection_Time_to__c='14:00');
        insert testCon;
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        IR_Customer__c testCust2 = IR_Global_Class.getCustomer(testCust.Id);        
        System.debug(IR_User_Utils.SA_Proceed(testCust2));                
	}
	TestMethod static void test_SA_Proceed_Case4(){
		IR_Customer__c testCust2 = new IR_Customer__c(Booking_Complete__c=true,Account_Status_Int__c='Trading',Account_Status_Dom__c='Trading',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust2;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust2.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(To_Country_Code__c ='UK',Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today(),Pickup_Collection_Time_from__c='11:00',Pickup_Collection_Time_to__c='14:00');
        insert testCon;
        
        System.debug(IR_User_Utils.SA_Proceed(testCust2));        
	}
	TestMethod static void test_SA_Proceed_Case5(){
		IR_Customer__c testCust2 = new IR_Customer__c(Booking_Complete__c=true,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust2;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust2.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(To_Country_Code__c ='UK',Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today(),Pickup_Collection_Time_from__c='11:00',Pickup_Collection_Time_to__c='14:00');
        insert testCon;
        
        System.debug(IR_User_Utils.SA_Proceed(testCust2));		
	}
	TestMethod static void assign_To_RC(){
		IR_Customer__c testCust2 = new IR_Customer__c(Booking_Complete__c=true,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust2;
        
        System.debug(IR_User_Utils.assign_To_RC_Queue(testCust2));        
	}
	TestMethod static void complete_booking(){
		IR_Customer__c testCust2 = new IR_Customer__c(Booking_Complete__c=true,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust2;
        
        System.debug(IR_User_Utils.complete_Booking(testCust2));        
	}
	TestMethod static void user_reject(){
		IR_Customer__c testCust2 = new IR_Customer__c(Booking_Complete__c=true,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust2;
        
        System.debug(IR_User_Utils.user_reject(testCust2));        
	}
	TestMethod static void test_CE_Complete_happy_Case(){
		IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.CE_Complete(testCust));                
	}
	TestMethod static void test_CE_Complete_Case1(){
		IR_Customer__c testCust = new IR_Customer__c(Security_Check_Fail__c = true, Security_Check_Accepted__c = false, Potential_Private_Individual__c =true, Private_Individual_Check_OK__c=false, Domestic_Account_On_Stop__c =true,Confirmed_Off_Stop__c=false,Total_Rejection_Of_Request__c=true,Customer_To_Resubmit__c=true, Booking_No_Longer_Required__c=true,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.CE_Complete(testCust));
	}
	TestMethod static void test_CE_Complete_Case2(){
		IR_Customer__c testCust = new IR_Customer__c(Security_Check_Fail__c = true, Security_Check_Accepted__c = false, Potential_Private_Individual__c =true, Private_Individual_Check_OK__c=false, Domestic_Account_On_Stop__c =true,Confirmed_Off_Stop__c=false,Total_Rejection_Of_Request__c=false,Customer_To_Resubmit__c=true, Booking_No_Longer_Required__c=true,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.CE_Complete(testCust));
	}
	TestMethod static void test_CE_Complete_Case3(){
		IR_Customer__c testCust = new IR_Customer__c(Security_Check_Fail__c = false, Security_Check_Accepted__c = false, Potential_Private_Individual__c =true, Private_Individual_Check_OK__c=false, Domestic_Account_On_Stop__c =true,Confirmed_Off_Stop__c=false,Total_Rejection_Of_Request__c=false,Customer_To_Resubmit__c=false, Booking_No_Longer_Required__c=true,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.CE_Complete(testCust));
	}
	TestMethod static void test_CE_Complete_Case4(){
		IR_Customer__c testCust = new IR_Customer__c(Security_Check_Fail__c = true, Security_Check_Accepted__c = false, Potential_Private_Individual__c =true, Private_Individual_Check_OK__c=false, Domestic_Account_On_Stop__c =true,Confirmed_Off_Stop__c=false,Total_Rejection_Of_Request__c=false,Customer_To_Resubmit__c=false, Booking_No_Longer_Required__c=false,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.CE_Complete(testCust));
	}
	TestMethod static void test_CE_Complete_Case5(){
		IR_Customer__c testCust = new IR_Customer__c(Comments__c = 'Testing the comments to work',Security_Check_Fail__c = false, Security_Check_Accepted__c = false, Potential_Private_Individual__c =false, Private_Individual_Check_OK__c=false, Domestic_Account_On_Stop__c =true,Confirmed_Off_Stop__c=true,Total_Rejection_Of_Request__c=false,Customer_To_Resubmit__c=false, Booking_No_Longer_Required__c=false,Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.CE_Complete(testCust));
	}
	//RC_Complete
	TestMethod static void test_RC_Complete(){
		IR_Customer__c testCust = new IR_Customer__c(Dom_Rates_Loaded__c = true, Dom_Contacts_Loaded__c = true, Int_Rates_Loaded__c =true,Int_Contacts_Loaded__c=true, Dom_EInvoicing_Already_Registered__c=false,Int_EInvoicing_Already_Registered__c=false, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.RC_Complete(testCust));
	}
	TestMethod static void test_RC_Complete1(){
		IR_Customer__c testCust = new IR_Customer__c(Dom_Rates_Loaded__c = true, Dom_Contacts_Loaded__c = true, Int_Rates_Loaded__c =true,Int_Contacts_Loaded__c=true, Dom_EInvoicing_Already_Registered__c=true,Int_EInvoicing_Already_Registered__c=true, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.RC_Complete(testCust));
	}
	TestMethod static void test_RC_Complete_Case1(){
		IR_Customer__c testCust = new IR_Customer__c(Dom_Rates_Loaded__c = false, Dom_Contacts_Loaded__c = false, Int_Rates_Loaded__c =false,Int_Contacts_Loaded__c=false, Dom_EInvoicing_Already_Registered__c=false,Int_EInvoicing_Already_Registered__c=false, Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
        System.debug(IR_User_Utils.RC_Complete(testCust));
	}
	TestMethod static void test_Bookings(){
		IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getNewCustomersQueueId());
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        IR_User_Utils.make_Booking(testCust, 0);
	}
	TestMethod static void test_create_MyTNT_User(){
		IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
		IR_User_Utils.create_MyTNT_User(testCust, 0);
	}
	TestMethod static void create_EInvoicing_User(){
		IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST',OwnerId=IR_Global_Class.getCustomersExperienceQueueId());
        insert testCust;
		IR_User_Utils.create_EInvoicing_User(testCust,0);
	}
}