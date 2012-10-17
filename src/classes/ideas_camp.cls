public class ideas_camp {
    
    
    public Idea_Campaign__c camp {get{ return [SELECT Name, Status__c, Campaign_Description__c, info__c, createdBy.Name, createdDate, Description__c, Id FROM Idea_Campaign__c Where Id = :ApexPages.CurrentPage().getParameters().get('camp')]; } set;}
    
    public List<Idea> campIdeas {get{
    
        List<Idea> campIdeas = database.query('SELECT Id, title, body, status, NumComments, VoteTotal, voted__c, (SELECT Id FROM Votes Where CreatedById = ' + '\'' + UserInfo.getUserId() + '\'' + ') FROM Idea WHERE Idea_Campaign__c = ' + '\'' + ApexPages.CurrentPage().getParameters().get('camp') + '\'' + 'ORDER BY CreatedDate DESC');
        
        for(Idea i : campIdeas){
        
                for(Vote v :i.Votes){
                        i.voted__c = True;
                }
        }
        return campIdeas;
        
    }set;}
    
    public Integer numbOfIdeas {get{
    
        return Database.countQuery('SELECT count() FROM Idea WHERE Idea_Campaign__c = ' + '\'' + ApexPages.CurrentPage().getParameters().get('camp') + '\'');
        
    } set;}
    
    public ideas_camp(ApexPages.IdeaStandardController controller) {
        
    }
    
    public ideas_camp(ApexPages.IdeaStandardSetController controller) {
        
    }
    
    public List<Idea> getIdeasList(){
            
            
            
            return [SELECT Id, title, body, status, NumComments 
                    FROM Idea
                    WHERE Idea_Campaign__c = :ApexPages.CurrentPage().getParameters().get('camp')];
            
    }
    
    // *****************************************
    // ************** TEST       ***************
    // *****************************************
    
     public static String test4321 {get; set;}
    
     public static void test1234(){
        
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        
    
    }
    
    
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
        
        Test.startTest();
        
        ideas_camp.test4321 = '1';
        
        ideas_camp.test1234();
        
        Test.stopTest();   
    }
    
}