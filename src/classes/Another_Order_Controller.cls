public class Another_Order_Controller 
{
    private Order__c order;
    public Boolean redirectNeeded{get; set;}
    
    public Another_Order_Controller(ApexPages.StandardController stdcontroller) {
        //this.order = (Order__c)stdcontroller.getRecord();
        this.order = [SELECT o.Transfer_Status__c, o.SystemModstamp, o.Start_Ship_Date__c, 
                             o.Special_Instructions__c, o.Sold_to__c, o.Ship_to_address_1__c, 
                             o.Ship_to__c, o.RecordTypeId, o.Number_Order_Items__c, o.Name, 
                             o.LastModifiedDate, o.LastModifiedById, o.IsDeleted, o.Id, 
                             o.Customer_Company__c, o.CreatedDate, o.CreatedById, o.Change_Status__c 
                        FROM Order__c o
                        WHERE id =: stdController.getRecord().Id];
        
        redirectNeeded = false;
    }
    
    public void save() {
        try 
        {
            if (Order_Global_Methods.exist_Order_Items(order))
            {
                order = Order_Global_Methods.Order_Done(order);       
                redirectNeeded = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Order submitted to PkMS'));
            }
            else
            {
                redirectNeeded = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot submit an order without order items.'));
            }
            if(GeneralException.testException)
                throw new GeneralException('TEST');
        } 
        catch (Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            
            redirectNeeded = false;
        }
    }
    
    public String createOrderURL {
        get 
        {
            return Page.Create_Order.getURL() + '?AccId=' + order.Customer_Company__c;
        }
        set;
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
        PageReference pageRef = Page.Another_Order;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        Another_Order_Controller controller = new Another_Order_Controller(stdController);
        
        // execute methods
        controller.save();
        PageReference backURL = controller.backURL();
        
        // create objects
        SKU__c sku = new SKU__c(Customer_Company__c = CustomerCompany.Id,
                                Style_Number__c = '12',
                                Packaging_Type__c = 'Blank');
        insert sku;
        
        Order_Item__c orderItem = new Order_Item__c(Order__c = order.Id,
                                                    SKU__c = sku.Id,
                                                    Quantity__c = 1,
                                                    Order_Item_Number__c = 1);
        insert orderItem;
        controller = new Another_Order_Controller(stdController);
        
        // execute methods
        controller.save();
        
        // execute methods
        GeneralException.testException = true;
        controller.save();
        
        controller.createOrderURL = 'test';
        String createOrderURL = controller.createOrderURL;
    }    
}