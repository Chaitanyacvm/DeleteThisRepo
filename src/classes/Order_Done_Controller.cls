public class Order_Done_Controller {
    private Order__c order;
    public Boolean renderBack{get; set;}
    
    public Order_Done_Controller.Order_Done_Controller(ApexPages.StandardController stdController) {
        //this.order = (Order__c)stdController.getRecord();
        this.order = [SELECT o.Transfer_Status__c, o.SystemModstamp, o.Start_Ship_Date__c, 
                             o.Special_Instructions__c, o.Sold_to__c, o.Ship_to_address_1__c, 
                             o.Ship_to__c, o.RecordTypeId, o.Number_Order_Items__c, o.Name, 
                             o.LastModifiedDate, o.LastModifiedById, o.IsDeleted, o.Id, 
                             o.Customer_Company__c, o.CreatedDate, o.CreatedById, o.Change_Status__c 
                        FROM Order__c o
                       WHERE id =: stdController.getRecord().Id];
    }
    
    public void save() {
        try 
        {
            //if (Order_Global_Methods.exist_Order_Items(order))
            //{
                order = Order_Global_Methods.Order_Done(order);       
                renderBack = false;
            //}
            //else
            //{
            //    renderBack = true;
            //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot submit an order without order items.'));
            //}
            if(GeneralException.testException)
                throw new GeneralException('TEST');
            
        } catch (Exception ex) {
            renderBack = true;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
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
        PageReference pageRef = Page.Order_Done;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        Order_Done_Controller controller = new Order_Done_Controller(stdController);
        
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
        controller = new Order_Done_Controller(stdController);
        // execute methods
        controller.save();
        
        // execute methods
        GeneralException.testException = true;
        controller.save();
    }    
}