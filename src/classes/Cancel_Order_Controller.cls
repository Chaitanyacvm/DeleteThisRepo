public class Cancel_Order_Controller {
    private final Order__c order;
    public Boolean renderBack{get; set;}
    
    public Cancel_Order_Controller(ApexPages.StandardController stdcontroller) {
        this.order = (Order__c)stdcontroller.getRecord();
    }
    
    public void save() {
        try 
        {
            delete order;
            
            renderBack = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Order Cancelled'));
            if(GeneralException.testException)
                throw new GeneralException('TEST');
        } 
        catch (Exception ex) 
        {
            renderBack = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, ex.getMessage()));
        }
    }
    
    public PageReference backURL() {
        return new ApexPages.StandardController(order).view();
    }
    
    // Tests    
    public static testMethod void testThis()
    {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        // initialise page & controller
        PageReference pageRef = Page.Cancel_Order;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        Cancel_Order_Controller controller = new Cancel_Order_Controller(stdController);
        
        // execute methods
        controller.save();
        PageReference backURL = controller.backURL();
        
        // execute methods
        GeneralException.testException = true;
        controller.save();
    }    
}