/**
This controller is used for the PDF creation, for Claims email-templates.
**/

public with sharing class CS_Claims_Form_PDF_Controller {
    
    public CS_Claims__c claims {get; set;}
    
    public Id claimId {     
        get; 
        
        set{
                if(value != null){
                claims = getClaims(value);
                }
        }
    }
         
       public String emailId {
                get{
                        return CS_TNT_Claims__c.getInstance().Email_Id__c; 
                }
       } 
       public String address {
                get{
                        return CS_TNT_Claims__c.getInstance().Claims_postal_address__c; 
                }
       }
       public String header {
                get{
                        return CS_TNT_Claims__c.getInstance().Header__c;
                }
       }        
       
       public String Sender_section_title{
                get{
                        return CS_TNT_Claims__c.getInstance().Sender_section_title__c;
                }
       }
       public String Recipient_section_title{
                get{
                        return CS_TNT_Claims__c.getInstance().Recipient_Section_title__c;
                }
       }
       public String Claims_type_fieldset_label{
                get{
                        return CS_TNT_Claims__c.getInstance().Claims_type_fieldset_label__c;
                }
       }                                                 
       public String Claims_type_details_section_title{
                get{
                        return CS_TNT_Claims__c.getInstance().Claims_type_details_section_title__c;
                }
       }
       public String Claims_type_details_section_content{
                get{
                        return CS_TNT_Claims__c.getInstance().Claims_type_details_section_content__c;
                }
       }
       public String Claims_damaged_section_title{
                get{
                        return CS_TNT_Claims__c.getInstance().Claims_damaged_section_title__c;
                }
       }       
       public String damaged_items_inspection_label{
                get{
                        return CS_TNT_Claims__c.getInstance().damaged_items_inspection_label__c;
                }
       }
       public String payment_method_label{
                get{
                        return CS_TNT_Claims__c.getInstance().Method_of_payment_fieldset_label__c;
                }
       }
       
       public String Declaration_section_title{
                get{
                        return CS_TNT_Claims__c.getInstance().Declaration_section_title__c;
                }
       }
       public String Cost_value_of_consignment_label{
                get{
                                return CS_TNT_Claims__c.getInstance().Cost_value_of_consignment_label__c;
                }
       }
       public String Cost_value_of_items_label{
                get{
                        return CS_TNT_Claims__c.getInstance().Cost_value_of_items_label__c;
                }
       }
       
       public String check_list_opt_1{
                get{
                                return CS_TNT_Claims__c.getInstance().Check_list_opt_1__c;
                }
       }
       public String check_list_opt_2{
                get{
                                return CS_TNT_Claims__c.getInstance().Check_list_opt_2__c;
                }
       }
       public String check_list_opt_3{
                get{
                                return CS_TNT_Claims__c.getInstance().Check_list_opt_3__c;
                }
       }
       public String check_list_opt_4{
                get{
                                return CS_TNT_Claims__c.getInstance().Check_list_opt_4__c;
                }
       }
       public String replacement_consignement_no_label{
                get{
                        return CS_TNT_Claims__c.getInstance().Replacement_consignment_no_Label__c;
                }
       }    
    public CS_Claims_Form_PDF_Controller(){
     
     	claims = getClaims(Apexpages.currentPage().getParameters().get('cid'));
     	system.debug('==>CLAIMSPDF ' + claims);                                 
    }
    
      public CS_Claims__c getClaims(Id id){
                CS_Claims__c cl = new CS_Claims__c();
                try{
                cl = [SELECT
                        Name,
                        Copy_of_relevant_commercial_invoice__c, 
                        Copy_of_repair_estimate__c,
                        Sender_Address_1__c,
                        Recipient_Address_1__c,
                        Sender_Address_2__c,
                        Recipient_Address_2__c,
                        Sender_Address_3__c,
                        Recipient_Address_3__c,
                        All_requested_information__c,
                        cheque__c,
                        Claims_Stage__c,
                        Sender_company_name__c,
                        Consignment_no__c,
                        Sender_Contact_Name__c,
                        Recipient_Contact_Name__c,
                        Cost_of_consignment_exclcuding_VAT__c,
                        Cost_of_items_exclcuding_VAT__c,
                        Credit_your_TNT_account__c,
                        Sender_Email_Address__c,
                        Damaged__c,
                        Declarant_Date__c,
                        Date_of_dispatch__c,
                        Depot_no__c,
                        Detail_description_of_items__c,
                        Declarant_Full_Name_of__c,
                        damaged_packing_inspection__c,
                        Lost__c,
                        photographs_of_the_items__c,
                        Sender_Postcode__c,
                        Recipient_Postcode__c,
                        Reference_no__c,
                        Salvage_value__c,
                        Sender_Telephone_no__c,
                        Recipient_Telephone_no__c,
                        TNT_account_no__c,
                        Weight_of_items__c,
                        Repair_cost__c,
                        Replacement_Consignment_No__c                                                                                   
                        FROM CS_Claims__c 
                                WHERE 
                                id=: id
                        ];
                }catch(Exception e){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'If this error persists please contact TNT Customer care for further help. ERROR:' + e.getMessage()));
                }
                        
                        return cl;              
        }
    /***************************************
        Test Methods
    ****************************************/
    
    TestMethod static void test_pdf_controller(){
        try{
                CS_Claims__c testClaim = new CS_Claims__c(Depot_no__c='067', Reference_no__c='45678999', TNT_account_no__c='203456789', Sender_Email_Address__c='test@test.com',Claims_Stage__c = 'In Progress',Declarant_Full_Name_of__c='test',Declarant_Date__c= Date.today()); 
                insert testClaim;
                
                ApexPages.CurrentPage().getParameters().put('id',testClaim.Id);             
                Test.StartTest();
                CS_Claims_Form_PDF_Controller claimForm = new CS_Claims_Form_PDF_Controller();
                claimForm.getClaims(null);
                claimForm.getClaims(testClaim.Id);                                              
                system.debug(claimForm.address);                
                system.debug(claimForm.check_list_opt_1);
                system.debug(claimForm.check_list_opt_2);
                system.debug(claimForm.check_list_opt_3);
                system.debug(claimForm.check_list_opt_4);
                system.debug(claimForm.Claims_damaged_section_title);
                system.debug(claimForm.Claims_type_details_section_content);
                system.debug(claimForm.Claims_type_details_section_title);
                system.debug(claimForm.Claims_type_fieldset_label);
                system.debug(claimForm.Cost_value_of_consignment_label);
                system.debug(claimForm.Cost_value_of_items_label);
                system.debug(claimForm.Declaration_section_title);
                system.debug(claimForm.damaged_items_inspection_label);
                system.debug(claimForm.emailId);      
                system.debug(claimForm.header);
                system.debug(claimForm.payment_method_label);
                system.debug(claimForm.Recipient_section_title);
                system.debug(claimForm.replacement_consignement_no_label);
                system.debug(claimForm.Sender_section_title);               
                Test.stopTest(); 
        	}catch(Exception ex){
        		system.debug(ex);
        	}        		                           
    }
}