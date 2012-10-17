/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Ideas_Admin_Tigger_Test_Suite {
    //& Test Case for the trigger Idea_Admin
    static testMethod void testAdminTriggerAfterUpdate() {
        Idea i = getIdea();
        Idea_Admin__c idAd = getIdeaAdmin();
        try{                            
            insert i;
            idAd.Idea__c = i.Id;
            insert idAd;
            i.Title = 'chnagedTitle';
            update i;
            
        }catch(Exception ws){
            system.debug('TestCaseIdeaAdminTrigger: ' + ws);
        }                 
    }
    static Idea_Admin__c getIdeaAdmin(){
        //& Function to create a new Idea Admin record
        Idea_Admin__c idAd = new Idea_Admin__c();
        idAd.Name = 'testAdmin';
        idAd.Workflow_Status__c = 'RCIM Queue1';
        return idAd;        
    }
    static Idea getIdea(){
        //& fucntion for inserting the Ideas test record.
        Community c =  [Select Id From Community WHERE name = 'Local' LIMIT 1];
        Idea i = new Idea();        
        i.Title = 'test';
        i.body = 'test';
        i.Status = 'New';
        i.Workflow_Status__c = 'RCIM Queue';
        i.Location__c = 'Depo';
        i.Status__c = 'New';
        i.CommunityId = c.id;
        return i;       
    }
    
    static testMethod void testAdminTriggerAfterUpdate2() {
        Community c =  [Select Id From Community WHERE name = 'Local' LIMIT 1];
        Idea i = new Idea();        
        i.Title = 'test';
        i.body = 'test';
        i.Status = 'New';
        i.Workflow_Status__c = 'RCIM Queue';
        i.Location__c = 'Depo';
        i.Status__c = 'New';
        i.CommunityId = c.id;
        insert i;    
        
        Idea_Admin__c idAd = new Idea_Admin__c();
        idAd.Name = 'testAdmin';
        idAd.Workflow_Status__c = 'RCIM Queue';
        idAd.Idea__c = i.Id;
        insert idAd;
        
        idAd.Workflow_Status__c = 'RCIM Queue1';
        update idAd;
        idAd.Workflow_Status__c = 'RCIM Queue';
        update idAd;   
        idAd.Workflow_Status__c = 'Sensibility Check Queue';
        update idAd;
        idAd.Workflow_Status__c = 'Local Evaluator Queue';
        update idAd;
    }
    
    static testMethod void testAdminTriggerAfterUpdate3() {
        Idea_Location__c loc = new Idea_Location__c();
        loc.Name = 'test';
        loc.Location_Name__c = 'test';
        insert loc;
    }
}