@isTest
private class DMD_test_Trigger {
    TestMethod static void TestTrigger_DMD_beforeFormQuestion(){
        Inspection_Form_Question_Group__c IFQG = new Inspection_Form_Question_Group__c();
        
        IFQG.Form__c = 'Depot Weather Report';
        IFQG.Group_Name__c = 'Weather';
        IFQG.Group_Number__c = 1;
        
        insert IFQG;
        Test.startTest();
        Inspection_Form_Question__c IFQ = new Inspection_Form_Question__c();
        
        IFQ.Answer_Type__c = 'Picklist';
        IFQ.Data_Type__c = '';
        IFQ.Picklist_Score__c = '2\n1\n0';
        IFQ.Picklist_Builder__c = 'High\nMedium\nLow';
        IFQ.Question__c = 'How hard the snow fall is?';
        IFQ.Inspection_Form_Question_Group__c = IFQG.Id;
        insert IFQ;
        
        try{
        IFQ.Answer_Type__c = 'Picklist';
        IFQ.Picklist_Score__c = '2\n0';
        IFQ.Picklist_Builder__c = 'High\nMedium\nLow';
        IFQ.Question__c = 'How hard the snow fall is?';
        update IFQ;        
        }catch(Exception ex){
        
        }
        
        try{
        IFQ.Answer_Type__c = 'Picklist';
        IFQ.Picklist_Score__c = '2\n1\n0';
        IFQ.Picklist_Builder__c = 'High\n \nLow';
        IFQ.Question__c = 'How hard the snow fall is?';
        update IFQ;        
        }catch(Exception ex){
        
        }
        
        try{
        IFQ.Answer_Type__c = 'Picklist';
        IFQ.Picklist_Score__c = null;
        IFQ.Picklist_Builder__c = 'High\nMedium\nLow';
        IFQ.Question__c = 'How hard the snow fall is?';
        update IFQ;        
        }catch(Exception ex){
        
        }
        
        try{
        IFQ.Answer_Type__c = 'Picklist';
        IFQ.Picklist_Score__c = '2\n1\n0';
        IFQ.Picklist_Builder__c = null;
        IFQ.Question__c = 'How hard the snow fall is?';
        update IFQ;        
        }catch(Exception ex){
        
        }
        Test.stopTest();
    }
}