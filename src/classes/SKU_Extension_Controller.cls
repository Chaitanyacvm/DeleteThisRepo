public class SKU_Extension_Controller 
{
    public SKU__c sku {get; set;}
    private Boolean portal = false;
    public String customerCompanyName { get; set; }
    
    public Account customer_company
    {
        get
        {
            if ( sku.Customer_Company__c != null )
            {
                try
                {
                    customer_company = [SELECT  a.Style_Suffix_Enterable__c, a.Size_Dimension_Enterable__c, 
                                                a.Name, a.Id, a.Default_Packaging_Type__c, a.Customer_Company_Name__c, 
                                                a.Colour_Suffix_Enterable__c, a.Colour_No_Enterable__c, a.UPC_Barcode_enterable__c
                                                FROM Account a
                                                WHERE Id=:sku.Customer_Company__c limit 1];
                } catch (Exception ex) {
                    customer_company = new Account();
                    if (!ApexPages.hasMessages())
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please create SKUs through the customer company.'));
                }  
                return customer_company;
            }
        /*
            if(ApexPages.currentPage().getParameters().get('CF00NT00000016yZ4_lkid') != null)
            {
                String customer_companyId = ApexPages.currentPage().getParameters().get('CF00NT00000016yZ4_lkid');
                customer_company = [SELECT 
                                        a.Style_Suffix_Enterable__c, a.Size_Dimension_Enterable__c, 
                                        a.Name, a.Id, a.Default_Packaging_Type__c, a.Customer_Company_Name__c, 
                                        a.Colour_Suffix_Enterable__c, a.Colour_No_Enterable__c 
                                        FROM Account a
                                        WHERE Id=:customer_companyId limit 1];
            }
            else if (ApexPages.currentPage().getParameters().get('id') != null)
            {
                String customer_companyId = sku.Customer_Company__c;
                customer_company = [SELECT 
                                        a.Style_Suffix_Enterable__c, a.Size_Dimension_Enterable__c, 
                                        a.Name, a.Id, a.Default_Packaging_Type__c, a.Customer_Company_Name__c, 
                                        a.Colour_Suffix_Enterable__c, a.Colour_No_Enterable__c 
                                        FROM Account a
                                        WHERE Id=:customer_companyId limit 1];
            }
            */
            else
            {
                try {
                    portal = true;
                    User user = [SELECT Contact.AccountId FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
                    
                    customer_company = [SELECT 
                                            a.Style_Suffix_Enterable__c, a.Size_Dimension_Enterable__c, 
                                            a.Name, a.Id, a.Default_Packaging_Type__c, a.Customer_Company_Name__c, 
                                            a.Colour_Suffix_Enterable__c, a.Colour_No_Enterable__c, UPC_Barcode_enterable__c
                                            FROM Account a
                                            WHERE Id=:user.contact.AccountId limit 1];
                    this.sku.Customer_Company__c = user.contact.AccountId;
                    if(GeneralException.testException)
                        throw new GeneralException('TEST');
                } catch (Exception ex) {
                    customer_company = new Account();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please create SKUs through the customer company.'));
                }
            }            
            return customer_company;       
        }
        set;
    }
    
    public SKU_Extension_Controller(ApexPages.StandardController stdController) 
    {
        this.sku = (SKU__c)stdController.getRecord();
        if(stdController.getRecord().Id != null)
            this.sku = [SELECT s.batch__c, s.UPC_Barcode__c, s.Style__c, s.Style_Suffix__c, s.Style_Number__c, s.Style_Description__c, s.Size_Dimension__c, 
                               s.Packaging_Type__c, s.Name, s.Id, s.Customer_Company__c, s.Colour_Suffix__c, s.Colour_Description__c 
                          FROM SKU__c s 
                         WHERE Id =: stdController.getRecord().Id limit 1];
        if (ApexPages.currentPage().getParameters().get('Id') == null)
        {
            this.sku.Customer_Company__c = customer_company.Id;
        }
        try
        {
            customerCompanyName = [ Select a.Customer_Company_Name__c
                                      From Account a
                                     Where Id =: sku.Customer_Company__c ].Customer_Company_Name__c;
        } catch ( Exception e )
        {
        }
        this.sku.Packaging_Type__c = customer_company.Default_Packaging_Type__c;
    }
    
    public PageReference save() 
    {
        try
        {
            upsert sku;
            if ( portal )
                return new ApexPages.StandardController(sku).view().setRedirect(true);
            else
                return new ApexPages.StandardController(customer_company).view().setRedirect(true);
        }
        catch(Exception e)
        {
            return null;
        }        
        
    }
    
    public PageReference saveAndNew() 
    {
        try
        {
            upsert sku;
            SKU__c tempSku = new SKU__c();
            tempSku.Customer_Company__c = sku.Customer_Company__c;
            tempSku.Style_Number__c = sku.Style_Number__c;
            tempSku.Colour_Description__c = sku.Colour_Description__c;
            tempSku.Style__c = sku.Style__c;
            tempSku.Colour_Suffix__c = sku.Colour_Suffix__c;
            tempSku.Packaging_Type__c = sku.Packaging_Type__c;
            tempSku.Size_Dimension__c = sku.Size_Dimension__c;
            tempSku.Style_Description__c = sku.Style_Description__c;
            tempSku.Style_Suffix__c = sku.Style_Suffix__c;
            tempSku.UPC_Barcode__c = sku.UPC_Barcode__c;
            
            sku = new SKU__c();
            sku.Customer_Company__c = tempSku.Customer_Company__c;
            sku.Style_Number__c = tempSku.Style_Number__c;
            sku.Colour_Description__c = tempSku.Colour_Description__c;
            sku.Style__c = tempSku.Style__c;
            sku.Colour_Suffix__c = tempSku.Colour_Suffix__c;
            sku.Packaging_Type__c = tempSku.Packaging_Type__c;
            sku.Size_Dimension__c = tempSku.Size_Dimension__c;
            sku.Style_Description__c = tempSku.Style_Description__c;
            sku.Style_Suffix__c = tempSku.Style_Suffix__c;
            sku.UPC_Barcode__c = tempSku.UPC_Barcode__c;
            if (!ApexPages.hasMessages())
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'SKU created.'));
            return null;
        }
        catch(Exception e)
        {
            return null;
        }        
        
    }
    /*
    public void getCustomerCompany()
    {
        customer_company = [SELECT 
                                a.Style_Suffix_Enterable__c, a.Size_Dimension_Enterable__c, 
                                a.Name, a.Id, a.Default_Packaging_Type__c, a.Customer_Company_Name__c, 
                                a.Colour_Suffix_Enterable__c, a.Colour_No_Enterable__c 
                                FROM Account a
                                WHERE Id=:sku.Customer_Company__c limit 1];
        sku.Packaging_Type__c = customer_company.Default_Packaging_Type__c;
    }
    */

    /*    
    // Tests   
    public static testMethod void testThis() 
    {
        PageReference pageRef = Page.Create_SKU;
        Test.setCurrentPage(pageRef);
        SKU_Extension_Controller controller = new SKU_Extension_Controller();
        
        PageReference test = controller.save();
    }
    */
    
    // Tests    
    public static testMethod void testThis()
    {
        // create objects
        Account CustomerCompany = new Account(Name = 'cc', 
                                      Default_Packaging_Type__c = 'Blank');
        insert CustomerCompany;
        SKU__c sku = new SKU__c(Customer_Company__c = CustomerCompany.Id,
                                Style_Number__c = '12',
                                Packaging_Type__c = 'Blank');
        insert sku;
        
        Order__c order = new Order__c(  Customer_Company__c = CustomerCompany.Id, 
                                        Name = '123',
                                        Start_Ship_Date__c = System.today());
        insert order;
        
        // initialise page & controller
        PageReference pageRef = Page.Order_Done;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController stdController = new ApexPages.StandardController(sku);
        ApexPages.currentPage().getParameters().put('id', CustomerCompany.Id);
        SKU_Extension_Controller controller = new SKU_Extension_Controller(stdController);
        
        // execute methods
        PageReference save = controller.save();
        CustomerCompany = controller.customer_company;
        ApexPages.currentPage().getParameters().put('CF00NA0000003kqpj_lkid', CustomerCompany.Id);
        CustomerCompany = controller.customer_company;
        
        // execute methods
        GeneralException.testException = true;
        ApexPages.currentPage().getParameters().put('CF00NA0000003kqpj_lkid', null);
        ApexPages.currentPage().getParameters().put('id', null);
        CustomerCompany = controller.customer_company;
    }    
}