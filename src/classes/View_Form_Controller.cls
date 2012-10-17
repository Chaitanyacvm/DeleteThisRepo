public class View_Form_Controller {
    public Form__c form{get; set;}
    public LIST<Inspection_Form_Item__c> inspectionAnswers{get; set;}
    public LIST<Extinguisher_Form_Item__c> extinguisherAnswers{get; set;}
    public LIST<Emergency_Lighting_Form_Item__c> emergLightAnswers{get; set;}
    public String formRecordTypeName{get; set;}
    public Boolean inspectionForm{get; set;}
    public Boolean extinguisherForm{get; set;}
    public Boolean emergLightForm{get; set;}

    public View_Form_Controller(ApexPages.StandardController stdController) {
        inspectionAnswers = new LIST<Inspection_Form_Item__c>();
        extinguisherAnswers = new LIST<Extinguisher_Form_Item__c>();
        emergLightAnswers = new LIST<Emergency_Lighting_Form_Item__c>();
        form = [SELECT Id, Name, Form_Name__c, RecordType.Name, RecordTypeId, Location__c, Date__c, Score__c, Maximum_Score__c, Depot__c, (SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Form__c, Question__c, Group_Number__c, Group_Name__c, InspectionScore__c, Answer__c, Action_Required__c, By_Whom__c, Date_Completed__c, Score__c FROM Inspection_Form_Items__r ORDER BY Group_Number__c), (SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Form__c, Extinguisher_Number__c, Extinguisher_Type__c, Extinguisher_Location__c, Extinguisher_free_from_Defect__c, Action_Required__c, By_Whom__c, Date_Completed__c, Score__c FROM Extinguisher_Form_Items__r ORDER BY Extinguisher_Number__c), (SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Unit_Light_Number__c, Unit_Location__c, Light_free_from_Defect__c, Action_Required__c, By_Whom__c, Date_Completed__c, Form__c, Score__c FROM Emergency_Lighting_Form_Items__r ORDER BY Unit_Light_Number__c) FROM Form__c WHERE Id = :((Form__c)stdController.getRecord()).Id LIMIT 1];
        
        formRecordTypeName = getRecordTypeName(form.RecordTypeId);
        
        if (formRecordTypeName == 'Fire Extinguishers') {
                extinguisherForm = true;
                
                for (Extinguisher_Form_Item__c formItem : form.Extinguisher_Form_Items__r) {
                    extinguisherAnswers.add(formItem);
                }
            } else if (formRecordTypeName == 'Emergency Lighting') {
                emergLightForm = true;
                
                for (Emergency_Lighting_Form_Item__c formItem : form.Emergency_Lighting_Form_Items__r) {
                    emergLightAnswers.add(formItem);
                }
            } else {
                inspectionForm = true;
                
                for (Inspection_Form_Item__c formItem : form.Inspection_Form_Items__r) {
                    inspectionAnswers.add(formItem);
                }
            }
    }
    
    public String getRecordTypeName(Id recordTypeId) {
        return Form__c.SObjectType.getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
    }
    
    public Integer totalScore {
        get {
            return form.Score__c.IntValue();
        }
    }
    
    public Integer maximumTotalScore {
        get {
            return form.Maximum_Score__c.IntValue();
        }
    }
    
    public String formDate {
        get {
            return form.Date__c.Day() + '/' + form.Date__c.Month() + '/' + form.Date__c.Year();
        }
    }
    
    TestMethod static void test_View_Form_Controller() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-1);
        testForm.Depot__c = testDepot.Id;
        insert testForm;
        
        Form__c testForm1 = new Form__c();
        testForm1.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Emergency Lighting').getRecordTypeId();
        testForm1.Location__c = 'TEST';
        testForm1.Date__c = System.Today().addMonths(-1);
        testForm1.Depot__c = testDepot.Id;
        insert testForm1;
        /*
        Form__c testForm2 = new Form__c();
        testForm2.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Enviromental').getRecordTypeId();
        testForm2.Location__c = 'TEST';
        testForm2.Date__c = System.Today().addMonths(-1);
        testForm2.Depot__c = testDepot.Id;
        insert testForm2;
        */
        Test.StartTest();
        View_Form_Controller cont = new View_Form_Controller(new ApexPages.StandardController(testForm));
        System.debug(cont.totalScore);
        System.debug(cont.maximumTotalScore);
        System.debug(cont.formDate);
        
        cont = new View_Form_Controller(new ApexPages.StandardController(testForm1));
        System.debug(cont.totalScore);
        System.debug(cont.maximumTotalScore);
        System.debug(cont.formDate);
        
        /*
        cont = new View_Form_Controller(new ApexPages.StandardController(testForm2));
        System.debug(cont.totalScore);
        System.debug(cont.maximumTotalScore);
        System.debug(cont.formDate);
        */
        Test.StopTest();
    }
}