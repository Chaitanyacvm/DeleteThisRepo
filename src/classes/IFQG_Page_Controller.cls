public class IFQG_Page_Controller {
    public Inspection_Form_Question_Group__c IFQGroup {get; set;}
    public Boolean isEdit {get; set;}
    public Boolean createNewForm {get; set;}
    public String newFormName {get; set;}
    
    public IFQG_Page_Controller(ApexPages.StandardController stdController) {
        if (stdController.getRecord().Id != null){
            IFQGroup = [Select i.Name, i.Id, i.Group_Number__c, i.Group_Name__c, i.Form__c From Inspection_Form_Question_Group__c i Where Id =: stdController.getRecord().Id];
        } else{
            IFQGroup = (Inspection_Form_Question_Group__c)stdController.getRecord();
        }
        createNewForm = false;
        newFormName = '';
    }
    
    public LIST<SelectOption> getFormTypes() {
        return formMethods.getFormTypes();
    }
    
    public PageReference newForm() {
        createNewForm = true;
        
        return null;
    }
    
    public PageReference saveForm() {
        if (newFormName == null || newFormName.length() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must specify a Form Name'));
        } else {
            try {
                PUD_Form_Type__c formType = new PUD_Form_Type__c();
                formType.Name = newFormName;
                insert formType;
                
                createNewForm = false;
            } catch (Exception ex) {
                if (!ApexPages.hasMessages()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
                }
            }
        }
        
        return null;
    }
    
    public PageReference save() {
        try {
            upsert IFQGroup;
            
            return new ApexPages.StandardController(IFQGroup).view();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            
            return null;
        }
    }
    
    TestMethod static void test_IFQG_Page_Controller() {
        Inspection_Form_Question_Group__c testIFQG = new Inspection_Form_Question_Group__c();
        testIFQG.Form__c = 'Enviromental';
        testIFQG.Group_Number__c = 1;
        testIFQG.Group_Name__c = 'TEST';
        insert testIFQG;
        
        Test.StartTest();
        IFQG_Page_Controller cont = new IFQG_Page_Controller(new ApexPages.StandardController(testIFQG));
        cont.getFormTypes();
        cont.save();
        Test.StopTest();
    }
}