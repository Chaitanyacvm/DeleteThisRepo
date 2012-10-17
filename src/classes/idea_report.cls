public class idea_report {

    public User u {get{
        
        return [SELECT Id, FirstName, LastName, Idea_Location__c FROM User WHERE Id = :UserInfo.getUserId()];
    
    } set;}
    
    public List<Idea> ideas_for_report { get{
        
        Idea[] report_ideas;
        
        try{
            report_ideas = [SELECT Id, Anonymous_Idea__c, On_Behalf__c, Request_Additional_Information__c, Additional_Information__c, Additional_Information_SC__c, Request_Additional_Information_SC__c, Title, NumComments, CreatedBy.Name, status__c, CreatedDate, voteTotal, Move_Idea_to__c FROM Idea WHERE Location__c = :u.Idea_Location__c];
        }catch(exception e){}
        
        if(report_ideas.size() > 0){
            return report_ideas;
        }else{
            return null;
        }
    
    } set; }
    
    public List<Idea> ideas_for_national_report { get{
        
        Idea[] report_ideas;
        
        try{
            report_ideas = [SELECT Id, Anonymous_Idea__c, On_Behalf__c, Request_Additional_Information__c, Additional_Information__c, Additional_Information_SC__c, Request_Additional_Information_SC__c, Title, NumComments, CreatedBy.Name, status__c, CreatedDate, voteTotal, Move_Idea_to__c FROM Idea];
        }catch(exception e){}
        
        if(report_ideas.size() > 0){
            return report_ideas;
        }else{
            return null;
        }
    
    } set; }
    
    static testMethod void testRegistration() {
        
        idea i = new idea();
        
        Community c =  [Select Id From Community WHERE name = 'Local' LIMIT 1];
        
        i.Title = 'test';
        i.body = 'test';
        i.Status = 'New';
        i.Workflow_Status__c = 'RCIM Queue';
        i.Location__c = 'Depo';
        i.Status__c = 'New';
        i.CommunityId = c.id;
        i.Move_Idea_To__c = 'Local';
        insert i;
        
        idea_report i_rep = new idea_report();
        
        
        Test.startTest();
        
        //i_rep.getideas_for_report();
        //i_rep.u;
        
        Test.stopTest();   
    }
    
}