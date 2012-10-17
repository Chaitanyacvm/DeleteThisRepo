public class Create_Form_Page_Controller {
    public final integer ROWS = 10;
    public final integer ROWS_TO_ADD = 10;
    public Form__c form {get; set;}
    public LIST<InspectionAnswerGroup> inspectionAnswerGroups {get; set;}
    public LIST<Extinguisher_Form_Item__c> extinguisherAnswers {get; set;}
    public LIST<Emergency_Lighting_Form_Item__c> emergLightAnswers {get; set;}
    public String formType {get; set;}
    public String formName {get; set;}
    public Boolean renderSelection {get; set;}
    public Boolean reportDue {get; set;}
    public Boolean inspectionForm {get; set;}
    public Boolean extinguisherForm {get; set;}
    public Boolean emergLightForm {get; set;}
    
    public Create_Form_Page_Controller(ApexPages.StandardController stdController) {
        inspectionAnswerGroups = new LIST<InspectionAnswerGroup>();
        extinguisherAnswers = new LIST<Extinguisher_Form_Item__c>();
        emergLightAnswers = new LIST<Emergency_Lighting_Form_Item__c>();
        inspectionForm = false;
        extinguisherForm = false;
        emergLightForm = false;
        renderSelection = false;
        form = (Form__c)stdController.getRecord();
        
        if (form.Depot__c == null && ApexPages.CurrentPage().getParameters().get('depotId') != null) {
            form.Depot__c = ApexPages.CurrentPage().getParameters().get('depotId');
        }
        
        MAP<Id, Schema.RecordTypeInfo> formTypesMap = Form__c.SObjectType.getDescribe().getRecordTypeInfosById();
        formType = formTypesMap.get(form.RecordTypeId).getName();
        
        if (formType == 'Fire Extinguishers') {
            formName = formType;
            form.Form_Name__c = formName;
            extinguisherForm = true;
            renderSelection = false;
            
            if (checkFormDue(formType)) {
                for (Integer i=0; i<ROWS; i++) {
                    extinguisherAnswers.add(new Extinguisher_Form_Item__c(Extinguisher_Number__c = (i+1)));
                }
                
                reportDue = true;
            }
        } else if (formType == 'Emergency Lighting') {
            formName = formType;
            form.Form_Name__c = formName;
            emergLightForm = true;
            renderSelection = false;
            
            if (checkFormDue(formType)) {
                for (Integer i=0; i<ROWS; i++) {
                    emergLightAnswers.add(new Emergency_Lighting_Form_Item__c(Unit_Light_Number__c = (i+1)));
                }
                
                reportDue = true;
            }
        } else {
            renderSelection = true;
            inspectionForm = true;
        }
    }
    
    public String getRecordTypeName(Id recordTypeId) {
        return Form__c.SObjectType.getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
    }
    
    public LIST<SelectOption> formTypes {
        get {
            LIST<SelectOption> formTypeOptions = new LIST<SelectOption>();
            for (SelectOption formTypeOption : formMethods.getFormTypes_create()) {
                if (!(formTypeOption.getLabel() == 'Fire Extinguishers' || formTypeOption.getLabel() == 'Emergency Lighting')) {
                    formTypeOptions.add(formTypeOption);
                }
            }
            
            return formTypeOptions;
        }
    }
    
    public PageReference selectFormType() {
        System.debug('formName=' + formName);
        if (checkFormDue(formName)) {
            form.Form_Name__c = formName;
            reportDue = true;
            renderSelection = false;
            inspectionForm = true;
            System.debug('SELECT Group_Number__c, Group_Name__c, Form__c, (SELECT Question__c FROM Inspection_Form_Questions__r) FROM Inspection_Form_Question_Group__c WHERE Form__c = ' + formName + ' ORDER BY Group_Number__c');
            for (Inspection_Form_Question_Group__c questionGroup : [SELECT Group_Number__c, Group_Name__c, Form__c, (SELECT Question__c, Answer_Type__c, Data_Type__c, Picklist_Builder__c, Picklist_Score__c, Id FROM Inspection_Form_Questions__r Order By Name) FROM Inspection_Form_Question_Group__c WHERE Form__c = :formName ORDER BY Group_Number__c]) {
                inspectionAnswerGroups.add(new InspectionAnswerGroup(questionGroup));
            }
        }
        
        return null;
    }
    
    public Boolean checkFormDue(String thisFormType) {
        form.Date__c = formMethods.nextReportDate(form.Depot__c, thisFormType);
        
        if (form.Date__c == null || form.Date__c > System.Today()) {
            reportDue = false;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'The ' + thisFormType + ' Form is not yet due'));
            
            
            return false;
        } else {
            return true;
        }
    }
    
    public void addRows() {
        Integer currentSize = 0;
        Integer nextNumber;
        
        if (extinguisherForm) {
            currentSize = extinguisherAnswers.Size();
        } else if (emergLightForm) {
            currentSize = emergLightAnswers.Size();
        }
        
        if ((currentSize + ROWS_TO_ADD) < 1000) {
            for (Integer i=0; i<ROWS_TO_ADD; i++) {
                nextNumber = (i+1)+currentSize;
                
                if (extinguisherForm) {
                    extinguisherAnswers.add(new Extinguisher_Form_Item__c(Extinguisher_Number__c = nextNumber));
                } else if (emergLightForm) {
                    emergLightAnswers.add(new Emergency_Lighting_Form_Item__c(Unit_Light_Number__c = nextNumber));
                }
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You cannot have more than 1000 rows per form'));
        }
    }
    
    public PageReference Save() {
        try {
            form.Form_Name__c = formName;
            upsert form;
            
            if (extinguisherForm) {
                LIST<Extinguisher_Form_Item__c> extinguisherAnswersToAdd = new LIST<Extinguisher_Form_Item__c>();
                for (Extinguisher_Form_Item__c anAnswer : extinguisherAnswers) {
                    Extinguisher_Form_Item__c theAnswer = anAnswer;
                    
                    if (theAnswer.Extinguisher_Type__c != null) {
                        theAnswer.Form__c = form.Id;
                        
                        extinguisherAnswersToAdd.add(theAnswer);
                    }
                }
                
                upsert extinguisherAnswersToAdd;
            } else if (emergLightForm) {
                LIST<Emergency_Lighting_Form_Item__c> emergLightAnswersToAdd = new LIST<Emergency_Lighting_Form_Item__c>();
                for (Emergency_Lighting_Form_Item__c anAnswer : emergLightAnswers) {
                    Emergency_Lighting_Form_Item__c theAnswer = anAnswer;
                    
                    if (theAnswer.Unit_Location__c != null) {
                        theAnswer.Form__c = form.Id;
                        
                        emergLightAnswersToAdd.add(theAnswer);
                    }
                }
                
                upsert emergLightAnswersToAdd;
            } else if (inspectionForm) {
                LIST<Inspection_Form_Item__c> inspectionAnswersToAdd = new LIST<Inspection_Form_Item__c>();
                for (InspectionAnswerGroup answerGroup : inspectionAnswerGroups) {
                    for (InspectionAnswer anAnswer : answerGroup.Answers) {
                        Inspection_Form_Item__c theAnswer = anAnswer.thisAnswer;
                        theAnswer.Form__c = form.Id;
                        theAnswer.Answer__c = anAnswer.AnswerVal;
                        if(theAnswer.Answer_Type__c.trim().equalsIgnoreCase('Free form text')){
                            if(theAnswer.Data_Type__c.trim().equalsIgnoreCase('number')){
                                Boolean check = pattern.matches('[a-zA-Z]+',anAnswer.AnswerVal);
                                if (check == true) {
                                    anAnswer.AnswerVal = '';
                                    theAnswer.Answer__c = anAnswer.AnswerVal;
                                    form.addError('Free form Text Answer has to be numbers');
                                    return null;
                                }
                            }
                            theAnswer.InspectionScore__c = 1.0;
                        }else{
                            theAnswer.Answer__c = anAnswer.AnswerPickListVal;
                            theAnswer.InspectionScore__c = anAnswer.SelectOptions.get(anAnswer.AnswerPickListVal);
                        }
                        inspectionAnswersToAdd.add(theAnswer);
                    }
                }
                
                upsert inspectionAnswersToAdd;
            }
            
            try {
                Task t = [SELECT Id, IsClosed FROM Task WHERE Task_Related_Form__c = :formName AND WhatId = :form.Depot__c AND ActivityDate = :form.Date__c AND IsClosed = false LIMIT 1];
                t.Status = 'Completed';
                update t;
            } catch (Exception ex) {
                System.debug('There was a problem updating the Task (most likely the Task doesn\'t exist): ' + ex.getMessage());
            }
            
            return new ApexPages.StandardController(form).view();
        } catch (Exception ex) {
            return null;
        }
    }
    
    public integer getRowsToAdd() {
        return ROWS_TO_ADD;
    }
    
    public class InspectionAnswerGroup {
        public Decimal groupNumber{get; set;}
        public String groupName{get; set;}
        public LIST<InspectionAnswer> answers{get; set;}
        
        public inspectionAnswerGroup(Inspection_Form_Question_Group__c questionGroup) {
            answers = new LIST<InspectionAnswer>();
            groupNumber = questionGroup.Group_Number__c;
            groupName = questionGroup.Group_Name__c;
            
            for (Inspection_Form_Question__c question : questionGroup.Inspection_Form_Questions__r) {
                answers.add(new InspectionAnswer(questionGroup, question.Question__c, question.Answer_Type__c, question.Data_Type__c, question.Picklist_Builder__c, question.Picklist_Score__c));
            }
        }
    }
    
    public class InspectionAnswer {
        public Inspection_Form_Item__c thisAnswer{get; set;}
        public String AnswerVal{get;set;}
        public List<Selectoption> AnswerValueList{get;set;}
        public Map<String, Decimal> SelectOptions{get;set;}
        public String PicklistAnswerTypePanel{get;set;}
        public String FreeFormTextAnswerTypePanel{get;set;}
        public String AnswerPickListVal {get;set;}
        
        public void setAnswerPickListVal(String value){
            this.AnswerPickListVal = value;
        }
        
        public String getAnswerPickListVal(){
            return this.AnswerPickListVal;
        }
        
        public void setPicklistAnswerTypePanel(String value){
            this.PicklistAnswerTypePanel = value;
        }
        
        public void setFreeFormTextAnswerTypePanel(String value){
            this.FreeFormTextAnswerTypePanel = value;
        }
        
        public void setSelectOptions(Map<String, Decimal> value){
            this.SelectOptions = value;
        }
        
        public void setAnswerval(String value){
            this.AnswerVal = value;
        }
        
        public String getAnswerVal(){
            return this.AnswerVal;
        }
        
        
        public inspectionAnswer(Inspection_Form_Question_Group__c questionGroup, String question, String AnswerType, String DataType, String PicklistBuilder, String PicklistScore) {
            SelectOptions = new Map<String, Decimal>();
            thisAnswer = new Inspection_Form_Item__c();
            //Maximum_Score__c
            thisAnswer.Group_Number__c = questionGroup.Group_Number__c;
            thisAnswer.Group_Name__c = questionGroup.Group_Name__c;
            thisAnswer.Question__c = question;
            thisAnswer.Answer_Type__c = AnswerType.trim();
            if(AnswerType.trim().equalsIgnoreCase('Picklist')){
                PicklistAnswerTypePanel = 'block';
                FreeFormTextAnswerTypePanel = 'none';
            }else{
                PicklistAnswerTypePanel = 'none';
                FreeFormTextAnswerTypePanel = 'block';
                thisAnswer.Maximum_Score__c = 1.0;
            }
            thisAnswer.Data_Type__c = DataType;
            thisAnswer.Picklist_Builder__c = PicklistBuilder;
            thisAnswer.Picklist_Score__c = PicklistScore;
            if(PicklistBuilder != null){
                String[] splitList = PicklistBuilder.split('\n');
                String[] splitScore = PicklistScore.split('\n');
                AnswerValueList = new List<Selectoption>();
                Integer index = 0;
                Decimal Max = 0.0;
                for(String s: splitList){
                    String tempData = splitScore[index].trim();
                    if(tempData.contains('.') == false){
                        tempData = tempData + '.0';
                    }
                    Decimal temp = decimal.valueOf(tempData);
                    if(Max < temp){
                        Max = temp;
                    }
                    SelectOptions.put(s.trim(), temp);
                    AnswerValueList.add(new Selectoption(s.trim(),s.trim()));
                    index = index + 1;
                }
                thisAnswer.Maximum_Score__c = Max;
            }
        }
    }
    
    TestMethod static void test_Create_Form_Page_Controller() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today();
        //testForm.Depot__c = testDepot.Id;
        //insert testForm;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        insert testFS;
        
        Form_Schedule__c testFS2 = new Form_Schedule__c();
        testFS2.Start_Date__c = System.Today();
        testFS2.Form__c = 'Emergency Lighting';
        testFS2.Depot__c = testDepot.Id;
        testFS2.Due_January__c = true;
        testFS2.Due_February__c = true;
        testFS2.Due_March__c = true;
        testFS2.Due_April__c = true;
        testFS2.Due_May__c = true;
        testFS2.Due_June__c = true;
        testFS2.Due_July__c = true;
        testFS2.Due_August__c = true;
        testFS2.Due_September__c = true;
        testFS2.Due_October__c = true;
        testFS2.Due_November__c = true;
        testFS2.Due_December__c = true;
        insert testFS2;
        
        Form_Schedule__c testFS3 = new Form_Schedule__c();
        testFS3.Start_Date__c = System.Today();
        testFS3.Form__c = 'Enviromental';
        testFS3.Depot__c = testDepot.Id;
        testFS3.Due_January__c = true;
        testFS3.Due_February__c = true;
        testFS3.Due_March__c = true;
        testFS3.Due_April__c = true;
        testFS3.Due_May__c = true;
        testFS3.Due_June__c = true;
        testFS3.Due_July__c = true;
        testFS3.Due_August__c = true;
        testFS3.Due_September__c = true;
        testFS3.Due_October__c = true;
        testFS3.Due_November__c = true;
        testFS3.Due_December__c = true;
        insert testFS3;
        
        ApexPages.CurrentPage().getParameters().put('depotId', testDepot.Id);
        
        Test.StartTest();
        Create_Form_Page_Controller cont = new Create_Form_Page_Controller(new ApexPages.StandardController(testForm));
        cont.addRows();
        cont.Save();
        
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Emergency Lighting').getRecordTypeId();
        cont = new Create_Form_Page_Controller(new ApexPages.StandardController(testForm));
        cont.addRows();
        cont.Save();
        
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Enviromental').getRecordTypeId();
        cont = new Create_Form_Page_Controller(new ApexPages.StandardController(testForm));
        cont.addRows();
        cont.Save();
        
        cont = new Create_Form_Page_Controller(new ApexPages.StandardController(testForm));
        Test.StopTest();
    }
}