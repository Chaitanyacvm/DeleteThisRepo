public class IR_Display_Document_Controller {
    public String docType {get; set;}
    private IR_Consignment__c consignment{get; set;}
    
    public IR_Display_Document_Controller() {
        try {
            docType = ApexPages.currentPage().getParameters().get('docType');
            //consignment = [SELECT Id, Name, Manifest_XML__c, Label_XML__c, Invoice_XML__c, Con_Note_XML__c FROM IR_Consignment__c WHERE Id = :ApexPages.currentPage().getParameters().get('cid')];
            consignment = IR_Global_Class.getConsignment(ApexPages.currentPage().getParameters().get('cid'));
        } catch (Exception ex) {
            System.debug(ex);
            
            consignment = null;
        }
    }
    
    public String XML_Header {
        get {
            return '<?xml version="1.0" encoding="ISO_8859-1" standalone="yes"?>';
        }
    }
    
    public String XSL_Header_Start {
        get {
            return '<?xml-stylesheet href="';
        }
    }
    
    public String XSL_Header_End {
        get {
            return '" type="text/xsl"?>';
        }
    }
    
    public String XML_Body {
        get {
            String xml = '';
            
            if (consignment == null || !consignment.Booking_Complete__c) {
                return xml;
            } else {
                if (docType.toLowerCase().equals('manifest')) {
                    //return  consignment.Manifest_XML__c;
                    xml = IR_Global_Class.urlEncodeXML(IR_ExpressConnect.getDocumentXML(IR_ExpressConnect.DocType.MANIFEST, consignment.Booking_Result__c));
                    
                    //xml = IR_Global_Class.urlEncodeXML('<CONSIGNMENTBATCH>  <CONSIGNMENT>    <HEADER last=\'true\'>      <SHIPMENTDATE>09/12/2010</SHIPMENTDATE>      <SENDER>        <COMPANYNAME>BUREAU VERITAS</COMPANYNAME>        <STREETADDRESS1>UNIT 109-120 GREAT GUILDFORD B</STREETADDRESS1>        <STREETADDRESS2>30 GREAT GUILDFORD STREET</STREETADDRESS2>        <STREETADDRESS3></STREETADDRESS3>        <CITY>LONDON</CITY>        <PROVINCE></PROVINCE>        <POSTCODE>SE10HS</POSTCODE>        <COUNTRY>United Kingdom</COUNTRY>        <CONTACTNAME>James Tildesley</CONTACTNAME>        <CONTACTDIALCODE>(01827)</CONTACTDIALCODE>        <CONTACTTELEPHONE>56328</CONTACTTELEPHONE>        <ACCOUNT>240512979</ACCOUNT>        <VAT></VAT>      </SENDER>      <COLLECTION>        <COMPANYNAME>BUREAU VERITAS</COMPANYNAME>        <STREETADDRESS1>        UNIT 109-120 GREAT GUILDFORD BUSIN</STREETADDRESS1>        <STREETADDRESS2>30 GREAT GUILDFORD STREET</STREETADDRESS2>        <STREETADDRESS3></STREETADDRESS3>        <CITY>LONDON</CITY>        <PROVINCE></PROVINCE>        <POSTCODE>SE10HS</POSTCODE>        <COUNTRY>United Kingdom</COUNTRY>        <CONTACTNAME>James Tildesley</CONTACTNAME>        <CONTACTDIALCODE>(01827)</CONTACTDIALCODE>        <CONTACTTELEPHONE>56328</CONTACTTELEPHONE>        <ACCOUNT></ACCOUNT>        <VAT></VAT>      </COLLECTION>      <CARRIAGEFORWARD>Y</CARRIAGEFORWARD>    </HEADER>    <RECEIVER>      <COMPANYNAME>test</COMPANYNAME>      <STREETADDRESS1>test</STREETADDRESS1>      <STREETADDRESS2></STREETADDRESS2>      <STREETADDRESS3></STREETADDRESS3>      <CITY>test</CITY>      <PROVINCE></PROVINCE>      <POSTCODE>SW182EW</POSTCODE>      <COUNTRY>United Kingdom</COUNTRY>      <CONTACTNAME>James Tildesley</CONTACTNAME>      <CONTACTDIALCODE>(01827)</CONTACTDIALCODE>      <CONTACTTELEPHONE>56328</CONTACTTELEPHONE>      <ACCOUNT></ACCOUNT>      <VAT></VAT>    </RECEIVER>    <DELIVERY>      <COMPANYNAME>test</COMPANYNAME>      <STREETADDRESS1>test</STREETADDRESS1>      <STREETADDRESS2></STREETADDRESS2>      <STREETADDRESS3></STREETADDRESS3>      <CITY>test</CITY>      <PROVINCE></PROVINCE>      <POSTCODE>SW182EW</POSTCODE>      <COUNTRY>United Kingdom</COUNTRY>      <CONTACTNAME>James Tildesley</CONTACTNAME>      <CONTACTDIALCODE>(01827)</CONTACTDIALCODE>      <CONTACTTELEPHONE>56328</CONTACTTELEPHONE>      <ACCOUNT></ACCOUNT>      <VAT></VAT>    </DELIVERY>    <TOTALVOLUME units="m3">0</TOTALVOLUME>    <TOTALWEIGHT units="kg">0.91</TOTALWEIGHT>    <CUSTOMERREF></CUSTOMERREF>    <CONSIGNMENTTYPE>N</CONSIGNMENTTYPE>    <CONNUMBER>GE117100796GB</CONNUMBER>    <SERVICE>BT Before 10:30 Next Working Day</SERVICE>    <INSURANCEVALUE>0</INSURANCEVALUE>    <GOODSDESC1>NotProvided</GOODSDESC1>    <GOODSDESC2></GOODSDESC2>    <GOODSDESC3></GOODSDESC3>    <TOTALITEMS>1</TOTALITEMS>    <GOODSVALUE>0</GOODSVALUE>    <DELIVERYINST>NotProvided</DELIVERYINST>    <OPTION1></OPTION1>    <OPTION2></OPTION2>    <OPTION3></OPTION3>    <OPTION4></OPTION4>    <OPTION5></OPTION5>    <DANGEROUSGOODS>N</DANGEROUSGOODS>    <CURRENCY>GBP</CURRENCY>    <INSURANCECURRENCY></INSURANCECURRENCY>    <PAYMENTIND>S</PAYMENTIND>    <CONREF>conref1</CONREF>    <PACKAGE>      <LENGTH units="cm">0.1</LENGTH>      <HEIGHT units="cm">2</HEIGHT>      <WIDTH units="cm">5.1</WIDTH>      <WEIGHT units="Kg">0.91</WEIGHT>      <ITEMS>1</ITEMS>      <VOLUME units="m3">0</VOLUME>      <PACKAGEINDEX>1</PACKAGEINDEX>      <PACKAGEMAX>1</PACKAGEMAX>      <TTOTALITEMS>1</TTOTALITEMS>      <ARTICLE>        <PACKAGECODE>8906311</PACKAGECODE>        <INVOICEDESC>NotProvided</INVOICEDESC>        <INVOICEVALUE>1</INVOICEVALUE>        <ITEMS>1</ITEMS>        <DESCRIPTION>NotProvided</DESCRIPTION>        <WEIGHT units="kg">0.91</WEIGHT>        <HTS>~</HTS>        <ORIGINCOUNTRY>GB</ORIGINCOUNTRY>      </ARTICLE>    </PACKAGE>  </CONSIGNMENT></CONSIGNMENTBATCH>');
                } else if (docType.toLowerCase().equals('label')) {
                    //return  consignment.Label_XML__c;
                    xml = IR_Global_Class.urlEncodeXML(IR_ExpressConnect.getDocumentXML(IR_ExpressConnect.DocType.LABEL, consignment.Booking_Result__c));
                } else if (docType.toLowerCase().equals('invoice')) {
                    //return  consignment.Invoice_XML__c;
                    xml = IR_Global_Class.urlEncodeXML(IR_ExpressConnect.getDocumentXML(IR_ExpressConnect.DocType.INVOICE, consignment.Booking_Result__c));
                } else if (docType.toLowerCase().equals('connote')) {
                    //return  consignment.Con_Note_XML__c;
                    xml = IR_Global_Class.urlEncodeXML(IR_ExpressConnect.getDocumentXML(IR_ExpressConnect.DocType.CONNOTE, consignment.Booking_Result__c));
                }
            }
            System.debug(xml);
            return xml;
            //return EncodingUtil.urlEncode(xml, 'UTF-8');
        }
    }
    /*******************************TestMethod********************************/
    
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
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id, Order_Status__c='Complete');
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(        
        Order_IR__c=testOrder.Id,
        From_Postcode__c='SE10HS',
        To_Postcode__c='SE10HS',
        Type__c='Document',
        Pickup_Collection_Date__c=System.today(),
        Booking_Complete__c = true        
        );
        
        insert testCon;
          IR_Package__c pac = new IR_Package__c(
        Height__c = 10.00,
        Length__c = 10.00,
        Width__c = 10.00,
        Weight_Kg__c = 10.00,
        Consignment_IR__c = testCon.Id
        );  
        insert pac;
        
        testCust = IR_Global_Class.getCustomer(testCust.Id);        
        testOrder = IR_Global_Class.getOrder(testOrder.Id);
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        pac = IR_Global_Class.getPackage(pac.Id);
        
        IR_Display_Document_Controller disp;
        
        ApexPages.currentPage().getParameters().put('docType','manifest');
        ApexPages.currentPage().getParameters().put('cid',testCust.Id);
        disp = new IR_Display_Document_Controller();
        System.debug(disp.XML_Header);
        System.debug(disp.XML_Body);
        System.debug(disp.XSL_Header_End);
        System.debug(disp.XSL_Header_Start);
    	System.debug(disp.docType);
    	
    	
    	ApexPages.currentPage().getParameters().put('docType','label');
        ApexPages.currentPage().getParameters().put('cid',testCust.Id);
        disp = new IR_Display_Document_Controller();
        System.debug(disp.XML_Header);
        System.debug(disp.XML_Body);
        System.debug(disp.XSL_Header_End);
        System.debug(disp.XSL_Header_Start);
    	System.debug(disp.docType);
    	
    	ApexPages.currentPage().getParameters().put('docType','invoice');
        ApexPages.currentPage().getParameters().put('cid',testCust.Id);
        disp = new IR_Display_Document_Controller();
        System.debug(disp.XML_Header);
        System.debug(disp.XML_Body);
        System.debug(disp.XSL_Header_End);
        System.debug(disp.XSL_Header_Start);
    	System.debug(disp.docType);
    	
    	ApexPages.currentPage().getParameters().put('docType','connote');
        ApexPages.currentPage().getParameters().put('cid',testCust.Id);
        disp = new IR_Display_Document_Controller();
        System.debug(disp.XML_Header);
        System.debug(disp.XML_Body);
        System.debug(disp.XSL_Header_End);
        System.debug(disp.XSL_Header_Start);
    	System.debug(disp.docType);
    	
    }
}