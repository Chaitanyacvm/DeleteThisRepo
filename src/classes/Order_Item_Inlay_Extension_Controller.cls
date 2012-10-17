public class Order_Item_Inlay_Extension_Controller
{
    private final Order__c order;
    public Order_Item__c order_item
    {
        get
        {
            if (order_item == null)
                order_item = new Order_Item__c();
            return order_item;
        }
        set;
    }
    public SKU__c sku
    {
        get
        {
            if (sku == null)
                sku = new SKU__c();
            return sku;
        }
        set;
    }
    
    public String StyleNumber {get; set;}
    public String StyleSuffix {get; set;}
    public String ColourNumber {get; set;}
    public String ColourSuffix {get; set;}
    public String SizeDimension {get; set;}
    //public String UPCBarcode{get; set;}
    
    public Order_Item_Inlay_Extension_Controller(ApexPages.StandardController stdController) 
    {
        this.order = (Order__c)stdController.getRecord(); 
        Datetime now = Datetime.Now();
        now = now.addSeconds(-5);
        try{
            Order_Item__c tempOrderItem = [SELECT o.SKU__c
                                             FROM Order_Item__c o
                                            WHERE o.CreatedDate >=: now
                                              AND o.Order__c =: this.order.Id
                                         ORDER BY o.CreatedDate DESC
                                            LIMIT 1];
            SKU__c tempSku = [SELECT s.batch__c, s.UPC_Barcode__c, s.Style__c, s.Style_Suffix__c, s.Style_Number__c, 
                                     s.Style_Description__c, s.Size_Dimension__c, s.Packaging_Type__c, s.Name, s.Id, 
                                     s.Customer_Company__c, s.Colour_Suffix__c, s.Colour_Description__c 
                                FROM SKU__c s
                               WHERE Id =: tempOrderItem.SKU__c
                               LIMIT 1];
            if(tempSku != null){
                StyleNumber = tempSku.Style_Number__c;
                ColourNumber  = tempSku.Style__c;
                ColourSuffix = tempSku.Colour_Suffix__c;
                SizeDimension  = tempSku.Size_Dimension__c;
                StyleSuffix = tempSku.Style_Suffix__c;
            }
        } catch (Exception e){}
    }
    
    public void addSKUtoOrderItem()
    {
        try
        {
            String Style_Suffix;
            if(Order.Customer_Company__r.Style_Suffix_Enterable__c)
                Style_Suffix = StyleSuffix;//sku.Style_Suffix__c;
            
            String Colour_Number;
            if(Order.Customer_Company__r.Colour_No_Enterable__c)
                Colour_Number = ColourNumber;//sku.Style__c;           
            
            String Colour_Suffix;
            if(Order.Customer_Company__r.Colour_Suffix_Enterable__c)
                Colour_Suffix = ColourSuffix;//sku.Colour_Suffix__c; 
            
            String Size_Dimension;
            if(Order.Customer_Company__r.Size_Dimension_Enterable__c)
                Size_Dimension = SizeDimension;//sku.Size_Dimension__c;
                
            //String UPC_Barcode;
            //if(Order.Customer_Company__r.UPC_Barcode_Enterable__c)
            //    UPC_Barcode = UPCBarcode;//sku.UPC_Barcode__c;
            
            //System.debug('SELECT Id, Style_Number__c,Style_Suffix__c, Style__c, Colour_Suffix__c, Size_Dimension__cFROM SKU__c WHERE Style_Number__c = ' + sku.Style_Number__c + ' AND Style_Suffix__c = ' + Style_Suffix + ' AND Style__c = ' + Colour_Number + ' AND Colour_Suffix__c = ' + Colour_Suffix + ' AND Size_Dimension__c = ' + Size_Dimension + ' AND Customer_Company__c = ' + order.Customer_Company__c + ' LIMIT 1');
            
            sku = [SELECT Id, Style_Number__c,Style_Suffix__c, 
                    Style__c, Colour_Suffix__c, Size_Dimension__c
                    FROM SKU__c 
                    WHERE Style_Number__c =: StyleNumber//sku.Style_Number__c
                    AND Style_Suffix__c =: Style_Suffix
                    AND Style__c =: Colour_Number
                    AND Colour_Suffix__c =: Colour_Suffix
                    AND Size_Dimension__c =: Size_Dimension
                    //AND UPC_Barcode__c =: UPC_Barcode
                    AND Customer_Company__c =: order.Customer_Company__c limit 1];
                    
            order_item.SKU__c = sku.Id;
            order_item.Order__c = order.Id;
            order_item.Order_Item_Number__c = getNextNumber();
            
            upsert order_item;
            
            reloadNeeded = true;
            if(GeneralException.testException)
                throw new GeneralException('TEST');
        }
        catch (Exception e) 
        {
            if(!ApexPages.hasMessages()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No SKU found.'));
            }
        }
    }
    
    public void addAndNewSKUtoOrderItem()
    {
        try
        {
            String Style_Suffix;
            if(Order.Customer_Company__r.Style_Suffix_Enterable__c)
                Style_Suffix = StyleSuffix;//sku.Style_Suffix__c;
            
            String Colour_Number;
            if(Order.Customer_Company__r.Colour_No_Enterable__c)
                Colour_Number = ColourNumber;//sku.Style__c;           
            
            String Colour_Suffix;
            if(Order.Customer_Company__r.Colour_Suffix_Enterable__c)
                Colour_Suffix = ColourSuffix;//sku.Colour_Suffix__c; 
            
            String Size_Dimension;
            if(Order.Customer_Company__r.Size_Dimension_Enterable__c)
                Size_Dimension = SizeDimension;//sku.Size_Dimension__c;
                
            //String UPC_Barcode;
            //if(Order.Customer_Company__r.UPC_Barcode_Enterable__c)
            //    UPC_Barcode = UPCBarcode;//sku.UPC_Barcode__c;
            
            //System.debug('SELECT Id, Style_Number__c,Style_Suffix__c, Style__c, Colour_Suffix__c, Size_Dimension__cFROM SKU__c WHERE Style_Number__c = ' + sku.Style_Number__c + ' AND Style_Suffix__c = ' + Style_Suffix + ' AND Style__c = ' + Colour_Number + ' AND Colour_Suffix__c = ' + Colour_Suffix + ' AND Size_Dimension__c = ' + Size_Dimension + ' AND Customer_Company__c = ' + order.Customer_Company__c + ' LIMIT 1');
            
            sku = [SELECT Id, Style_Number__c,Style_Suffix__c, 
                    Style__c, Colour_Suffix__c, Size_Dimension__c
                    FROM SKU__c 
                    WHERE Style_Number__c =: StyleNumber//sku.Style_Number__c
                    AND Style_Suffix__c =: Style_Suffix
                    AND Style__c =: Colour_Number
                    AND Colour_Suffix__c =: Colour_Suffix
                    AND Size_Dimension__c =: Size_Dimension
                    //AND UPC_Barcode__c =: UPC_Barcode
                    AND Customer_Company__c =: order.Customer_Company__c limit 1];
                    
            order_item.SKU__c = sku.Id;
            order_item.Order__c = order.Id;
            order_item.Order_Item_Number__c = getNextNumber();
            
            upsert order_item;
            
            reloadNeeded = false;
            if(GeneralException.testException)
                throw new GeneralException('TEST');
        }
        catch (Exception e) 
        {
            if(!ApexPages.hasMessages()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No SKU found.'));
            }
        }
    }
    
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
                                        Name = '123',
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
}