public class IR_User_Welcomepack_Rate_Card_Controller {
	public IR_Customer__c customer {get; set;}
    public Integer etlSetting {get; set;}   
    
	public String pdfString {get; set;}
   	
   	public Id custId {
   		get;				
		set {
			try {
				//value = ApexPages.CurrentPage().getParameters().get('cid');
				customer = IR_Global_Class.getCustomer(value);
				etlSetting = IR_User_Utils.getETLSettingVal(customer);
				System.debug('cutomerEmailWElCOMEPACK'+ customer);
			} catch (Exception e) {
				etlSetting = 0;
				customer = new IR_Customer__c();
			}
		}
		
	}
     
    public IR_User_Welcomepack_Rate_Card_Controller() {
    	customer = new IR_Customer__c();    	    	
        /*try {
            etlSetting = IR_User_Utils.getETLSettingVal(customer);
            System.debug('ETLSetting' + etlSetting);
        } catch (Exception e) {
            etlSetting = 0;
            
            System.debug('WelcomePack_rate_card' + e.getMessage() +'@@'+ etlSetting);
        }
        
        StaticResource thePDF = [SELECT Id, Body FROM StaticResource WHERE Name = 'IR_Rate_Agreement_PDF_ET'];
        pdfString = EncodingUtil.base64Encode(thePDF.Body);*/
    }

}