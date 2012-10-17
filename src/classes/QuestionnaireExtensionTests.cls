@istest
private class QuestionnaireExtensionTests
    {    
        static testMethod void testExtension ()
    {    
    // Creates a new Questionnaire and populates the fields with data. 
    Questionnaire__c a = new Questionnaire__c
    (
        Private__c = 'true',
        On_behalf__c         = 'An Employee',
        Completed_by__c      = 'test',
        Question1__c         = '1',
        Question1Comment__c  = 'test',
        Question2Benefits__c = 'test',
        Question2BonusandCommision__c = 'test',
        Question2HolidayEntitlement__c = 'test',
        Question2JobContent__c = 'test',
        Question2WorkingHours__c = 'test',
        Question2Comment__c  = 'test',
        Question3__c         = '1',
        Question3Comment__c  = 'test',
        Question4__c         = '1',
        Question4Comment__c  = 'test',
        Question5__c         = '1',
        Question5Comment__c  = 'test',
        Question6__c         = '1',
        Question6Comment__c  = 'test',
        Question7__c         = '1',
        Question7Comment__c  = 'test',
        Question8__c         = '1',
        Question8Comment__c  = 'test',
        Question9Comment__c  = 'test',
        Question10__c         = '1',
        Question10Comment__c  = 'test',
        Question11__c         = '1',
        Question11Comment__c  = 'test',
        Question12__c         = '1',
        Question12Comment__c  = 'test',
        Question13__c         = '1',
        Question13Comment__c  = 'test',
        Question14__c         = '1',
        Question14Comment__c  = 'test',
        Question15Comment__c  = 'test',
        Question16__c         = '1',
        Question16Comment__c  = 'test',
        Question17Comment__c  = 'test',
        Question18Comment__c  = 'test',
        Question19Comment__c  = 'test',
        Question20__c         = '1',
        Question20Comment__c  = 'test',
        Question21__c         = '1',
        Question22__c         = '1',
        Question22Comment__c  = 'test',
        Question23Comment__c  = 'test',
        Question24__c         = '1',
        Question24Comment__c  = 'test',
        Question25__c         = '1',
        GeneralComment__c  = 'test'                                             
    );
         
        insert a;
        ApexPages.StandardController cont = new ApexPages.StandardController(a);
        QuestionnaireExtension ext = new QuestionnaireExtension(cont);
        ext.save();
        ext.savepage1to2();             
        ext.savePage2();             
        ext.savePage3();             
        ext.savePage4();             
        ext.savePage5();             
        ext.savePage6();  
        ext.savePage7();
        ext.savePage8();
        ext.savePage9();
        ext.Previous_on_page1to2();  
        ext.Previous_on_page2();   
        ext.Previous_on_page3();   
        ext.Previous_on_page4();   
        ext.Previous_on_page5();   
        ext.Previous_on_page6();   
        ext.Previous_on_page7();   
        ext.Previous_on_page8();   
        ext.Previous_on_page9();   
        ext.Previous_on_page10();          
     }
}