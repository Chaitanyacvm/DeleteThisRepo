public class PKMS_CustomerPortalHeader_Controller {
    public Account account {get; set;}
    private Id accountId;
    public PKMS_CustomerPortalHeader_Controller(){
        try{
            accountId = [Select u.Contact.AccountId From User u Where Id =: UserInfo.getUserId()].Contact.AccountId;
            account = [Select a.Name, a.Customer_Company_Name__c From Account a Where Id =: accountId];
        } catch (System.QueryException e){
            System.Debug('===> AccountId: ' + accountId);
            System.Debug('===> Account: ' + account);
        }
    }
    
    static testMethod void testThis(){
    	try{PKMS_CustomerPortalHeader_Controller controller = new PKMS_CustomerPortalHeader_Controller();}catch(exception e){}
    }
}