public class IR_Booking_Rate_Card_Controller {
    public IR_Customer__c customer {get; set;}
    public Integer etlSetting {get; set;}
    public String df {get; set;}
    public Id custId {
   		get;				
		set {
			try {
				//value = ApexPages.CurrentPage().getParameters().get('cid');
				customer = IR_Global_Class.getCustomer(value);
				System.debug('cutomerEmailWElCOMEPACK'+ customer);
			} catch (Exception e) {
				etlSetting = 0;
				customer = new IR_Customer__c();
			}
		}
		
	}
    public IR_Booking_Rate_Card_Controller() {    	
    	//if df is 0 default Rate card ET0 will be displayed and If 1 then the dafault Rate Card will be ET
        try {
        	df = ApexPages.currentPage().getParameters().get('df');
        	if(df == '0'){
            customer = IR_Global_Class.getCustomer(ApexPages.currentPage().getParameters().get('cid'));            
            etlSetting = IR_User_Utils.getETLSettingVal(customer);
        	}else{
        		etlSetting = 11;
        	}
            System.debug('ETLSetting' + etlSetting);
        } catch (Exception e) {
            etlSetting = 0;
            
            System.debug(e.getMessage());
        }
    }
    
    /*************************TestMEthods***************************/
    TestMethod static void test_all(){
    	
    	IR_Customer__c testCust = new IR_Customer__c(
    	Company__c = 'TEST', 
    	Title__c='MR', 
    	First_Name__c ='TESTNAME', 
    	Surname__c = 'TEST', 
    	Job_Title__c='TEST', 
    	Telephone__c='02012345',
    	Address_1__c = 'TestAddr1',
    	Town_City__c = 'London',
    	County__c='County', 
    	Email__c='TEST@TEST.com',
    	Postcode__c = 'E126UE', 
    	Extended_Transit_Liability_Setting__c = '£5,000',
    	Rate_And_Offer_Terms__c = true, 
    	Terms_and_Conditions__c = true
    	);        
        insert testCust;
        
        
               
        testCust = IR_Global_Class.getCustomer(testCust.Id);        
        
        
    	IR_Booking_Rate_Card_Controller rateCard;
    	Apexpages.currentPage().getParameters().put('cid',testCust.Id);
    	Apexpages.currentPage().getParameters().put('df','0');
    	rateCard = new IR_Booking_Rate_Card_Controller();
    	
    	testCust.Extended_Transit_Liability_Setting__c = '£10,000';
    	upsert testCust;
    	rateCard = new IR_Booking_Rate_Card_Controller();
    	
    	testCust.Extended_Transit_Liability_Setting__c = '£15,000';
    	upsert testCust;
    	rateCard = new IR_Booking_Rate_Card_Controller();
    	
    	testCust.Extended_Transit_Liability_Setting__c = null;
    	upsert testCust;
    	rateCard = new IR_Booking_Rate_Card_Controller();
    	
    	testCust.Extended_Transit_Liability_Setting__c = 'None';
    	upsert testCust;
    	rateCard = new IR_Booking_Rate_Card_Controller();
    }
}