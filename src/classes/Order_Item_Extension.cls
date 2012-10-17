public class Order_Item_Extension
{
    private final Order_Item__c order_item;
    
    private SKU__c sku;
    public SKU__c newsku
    {
        get
        {
            if (newsku == null)
                newsku = new SKU__c();
            return newsku;
        }
        set;
    }
    public Order__c order {get; set;}
    public Order_Item__c new_order_item
    {
        get
        {
            if (new_order_item == null)
                new_order_item = new Order_Item__c();
            return new_order_item;
        }
        set;
    }
    public String StyleNumber {get; set;}
    public String StyleSuffix {get; set;}
    public String ColourNumber {get; set;}
    public String ColourSuffix {get; set;}
    public String SizeDimension {get; set;}
    //public String UPCBarcode{get; set;}
    
    public Order_Item_Extension(ApexPages.StandardController stdController) 
    {
        //this.order_item = (Order_Item__c)stdController.getRecord();
        this.order_item = [Select o.SystemModstamp, o.SKU__c, o.Quantity__c, o.Order__c, 
                                  o.Order_Item_Number__c, o.Name, o.LastModifiedDate, o.LastModifiedById, 
                                  o.IsDeleted, o.Id, o.CreatedDate, o.CreatedById, o.Locked__c
                             From Order_Item__c o
                            Where Id =: stdController.getRecord().Id];
        sku = [Select s.batch__c, s.UPC_Barcode__c, s.Transfer_Status__c, s.SystemModstamp, s.Style__c, 
                      s.Style_Suffix__c, s.Style_Number__c, s.Style_Description__c, s.Size_Dimension__c, 
                      s.Packaging_Type__c, s.Name, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, 
                      s.Id, s.Customer_Company__c, s.CreatedDate, s.CreatedById, s.Colour_Suffix__c, 
                      s.Colour_Description__c, s.Change_Status__c, s.Boomi_Sequence_Number__c 
                 From SKU__c s
                Where Id =: order_item.SKU__c];
        order = [Select o.batch__c, o.Transfer_Status__c, o.SystemModstamp, o.Start_Ship_Date__c, 
                        o.Special_Instructions__c, o.Sold_to__c, o.Ship_to__c, 
                        o.RecordTypeId, o.Number_Order_Items__c, o.Name, o.LastModifiedDate, 
                        o.LastModifiedById, o.IsDeleted, o.Id, o.Customer_Company__r.Customer_Company_Name__c, 
                        o.Customer_Company__r.Default_Packaging_Type__c, o.Customer_Company__r.UPC_Barcode_enterable__c,
                        o.Customer_Company__r.Size_Dimension_Enterable__c, o.Customer_Company__r.Colour_Suffix_Enterable__c, 
                        o.Customer_Company__r.Colour_No_Enterable__c, o.Customer_Company__r.Style_Suffix_Enterable__c, 
                        o.Customer_Company__r.Type, o.Customer_Company__r.Name, o.Customer_Company__c, o.CreatedDate, 
                        o.CreatedById, o.Change_Status__c, o.Boomi_Sequence_Number__c 
                   From Order__c o
                  Where Id =: order_item.Order__c];
        newsku = sku;
        StyleNumber = sku.Style_Number__c;
        StyleSuffix = sku.Style_Suffix__c;
        ColourNumber = sku.Style__c;
        ColourSuffix = sku.Colour_Suffix__c;
        SizeDimension = sku.Size_Dimension__c;
        //UPCBarcode = sku.UPC_Barcode__c;
        new_order_item.Quantity__c = this.order_item.Quantity__c;
        new_order_item.Order_Item_Number__c = this.order_item.Order_Item_Number__c;
    }
    
    public PageReference checkRecord(){
        if (order_Item.Locked__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'This record is locked.'));
            return new ApexPages.StandardController(order_Item).view().setRedirect(true);
        }
        return null;
    }
    
    public pageReference addSKUtoOrderItem()
    {
        Savepoint sp = Database.setSavepoint();
        
        try
        {
            String Style_Suffix;
            if(Order.Customer_Company__r.Style_Suffix_Enterable__c)
                Style_Suffix = StyleSuffix; //newsku.Style_Suffix__c;
            
            String Colour_Number;
            if(Order.Customer_Company__r.Colour_No_Enterable__c)
                Colour_Number = ColourNumber; //newsku.Style__c;           
            
            String Colour_Suffix;
            if(Order.Customer_Company__r.Colour_Suffix_Enterable__c)
                Colour_Suffix = ColourSuffix; //newsku.Colour_Suffix__c; 
            
            String Size_Dimension;
            if(Order.Customer_Company__r.Size_Dimension_Enterable__c)
                Size_Dimension = SizeDimension; //newsku.Size_Dimension__c;
            
            //String UPC_Barcode;
            //if(Order.Customer_Company__r.UPC_Barcode_Enterable__c)
            //    UPC_Barcode = UPCBarcode; //newsku.UPC_Barcode__c;
            
            //System.Debug('===> ' + StyleNumber + ' - ' + Style_Suffix + ' - ' + Colour_Number + ' - ' + Colour_Suffix + ' - ' + Size_Dimension + ' - ' + UPC_Barcode);
            
            newsku = [SELECT Id, Style_Number__c,Style_Suffix__c, 
                             Style__c, Colour_Suffix__c, Size_Dimension__c
                        FROM SKU__c 
                        WHERE Style_Number__c =: StyleNumber //newsku.Style_Number__c
                          AND Style_Suffix__c =: Style_Suffix
                          AND Style__c =: Colour_Number
                          AND Colour_Suffix__c =: Colour_Suffix
                          AND Size_Dimension__c =: Size_Dimension
                          //AND UPC_Barcode__c =: UPC_Barcode
                          AND Customer_Company__c =: order.Customer_Company__c limit 1];
                    
            new_order_item.SKU__c = newsku.Id;
            new_order_item.Order__c = order.Id;    
            
            delete order_item;
            insert new_order_item;

            if(GeneralException.testException)
                throw new GeneralException('TEST');
                
            return new ApexPages.StandardController(order).view().setRedirect(true);
        }
        catch (Exception e) 
        {
            Database.rollback(sp);
            if(!ApexPages.hasMessages()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No SKU found.'));
            }
            return null;
        }
    }
    
    public static TestMethod void testThis() {
        Account testAcc = new Account();
        testAcc.Name = 'TEST';
        testAcc.Style_Suffix_Enterable__c = true;
        testAcc.Colour_No_Enterable__c = true;
        testAcc.Colour_Suffix_Enterable__c = true;
        testAcc.Size_Dimension_Enterable__c = true;
        insert testAcc;
        
        Order__c testOrder = new Order__c();
        testOrder.Name = 'TEST';
        testOrder.Start_Ship_Date__c = System.Today();
        testOrder.Customer_Company__c = testAcc.Id;
        insert testOrder;
        
        SKU__c testSKU = new SKU__c();
        testSKU.Style_Number__c = 'T1';
        testSKU.Style_Suffix__c = 'T1';
        testSKU.Style__c = 'T1';
        testSKU.Colour_Suffix__c = 'T1';
        testSKU.Size_Dimension__c = 'T1';
        testSKU.Customer_Company__c = testAcc.Id;
        insert testSKU;
        
        Order_Item__c testOI = new Order_Item__c();
        testOI.Order__c = testOrder.Id;
        testOI.SKU__c = testSKU.Id;
        testOI.Quantity__c = 1;
        insert testOI;
        
        Test.StartTest();
        Order_Item_Extension cont = new Order_Item_Extension(new ApexPages.StandardController(testOI));
        cont.addSKUtoOrderItem();
        Test.StopTest();
    }
    /*
    public String pageURL {set;}
    public Boolean reloadNeeded {get; set;}

    public String getPageURL() 
    {
        ApexPages.StandardController sc = new ApexPages.StandardController(order);  
        PageReference pageRef = sc.view();
        return pageRef.getUrl();        
    }
    public Decimal getNextNumber()
    {
        Decimal i = 1;
        
        try {
            Order_Item__c order_item_last = [SELECT Order_Item_Number__c 
                                                FROM Order_Item__c 
                                                WHERE Order__c =: order.Id 
                                                ORDER BY Order_Item_Number__c DESC limit 1];
            if(order_item_last != null)
                i = order_item_last.Order_Item_Number__c;
            if(GeneralException.testException)
                throw new GeneralException('TEST');
            return i + 1;
        } catch (Exception ex) {
            return i;
        }
    }

    // Tests    
    public static testMethod void testThis()
    {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '1',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        // initialise page & controller
        PageReference pageRef = Page.Order_Done;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        Order_Item_Inlay_Extension_Controller controller = new Order_Item_Inlay_Extension_Controller(stdController);
        
        // execute methods
        Order_Item__c orderItem = controller.order_item;
        SKU__c sku = controller.sku;
        controller.addSKUtoOrderItem();
        
        // create objects
        sku = new SKU__c(   Customer_Company__c = CustomerCompany.Id,
                            Style_Number__c = '12',
                            Packaging_Type__c = 'Blank');
        insert sku;
        
        orderItem = new Order_Item__c(  Order__c = order.Id,
                                        SKU__c = sku.Id,
                                        Quantity__c = 1,
                                        Order_Item_Number__c = 1);
        insert orderItem;                                   

        // execute methods
        GeneralException.testException = true;
        controller.addSKUtoOrderItem();
        String getPageURL = controller.getPageURL();
        Decimal getNextNumber = controller.getNextNumber();
    }
    */
}