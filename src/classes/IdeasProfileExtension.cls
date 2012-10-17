public class IdeasProfileExtension {
    
    
    public IdeasProfileExtension(ApexPages.StandardSetController controller) {

    }

    
    private final ApexPages.IdeaStandardSetController ideaSetController;
    
    public IdeasProfileExtension(ApexPages.IdeaStandardSetController controller) {
        ideaSetController = (ApexPages.IdeaStandardSetController)controller;
        
        u = [SELECT Id, Idea_Location__c FROM User WHERE Id = :UserInfo.getUserId()];
         
    }
    
    public List<idea> getModifiedIdeas() {
    
        
        Idea[] ideas = ideaSetController.getIdeaList();
        
        return ideas;
    
    }
    
    public String userType = ((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')) ? 'apex':'ukideas';
    
    //******************** Get Submited Ideas *************************
    public List<ideaActivity> iedaActNew{ get{ 
        
        Date last30Days = (system.today() - 30);
        
        List<ideaActivity> ideaActNew = new List<ideaActivity>();
        
        String communityID = '';
        
        if(LocalNav){
            communityID = ' Idea.Move_Idea_To__c  = ' + '\'' +  'Local' + '\'' + ' AND Idea.CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else if(NationalNav){
            communityID = ' Idea.Move_Idea_To__c  = ' + '\'' +  'National' + '\'' + ' AND Idea.CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else if(CampaignNav){
            communityID = ' Idea.CommunityId  = ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else{
            communityID = ' Idea.Move_Idea_To__c  = ' + '\'' +  'Local' + '\'' + '  AND Idea.CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
            LocalNav = true;
        }
        
        
        //Idea[] ideas = ideaSetController.getIdeaList();
        
        Idea[] ideas = database.query('SELECT Id, Createdby.Id, CreatedDate, title FROM Idea WHERE Inappropriate_Flag_By_SC__c != ' + '\'' + 'Yes' + '\'' + ' AND ' + communityID );
        
        
        for(Idea i : ideas){
                
                
                if(i.Createdby.Id == UserInfo.getUserId() && i.CreatedDate > (system.today() - 30)){
                        
                        ideaActivity idA = new ideaActivity();
                        idA.typeOfActivity = '<img src="/img/ideas/icons/posted16.gif" /> You Submitted <a href="/' + userType +'/ideas_detail_v2?id=' + i.Id + '">' + i.title + '</a>';
                        ideaActNew.add(idA);
                        
                }
                
        }
        
        return ideaActNew;} set; }
        
    //******************** Get Commented Ideas ************************
    public List<ideaActivity> iedaActCom{ get{ 
        
        Date last30Days = (system.today() - 30);
        
        List<ideaActivity> ideaActCom = new List<ideaActivity>();
        
        
        String userID = UserInfo.getUserId();
        
        String communityID = '';
        
        if(LocalNav){
            communityID = ' Idea.Move_Idea_To__c  = ' + '\'' +  'Local' + '\'' + ' AND Idea.CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else if(NationalNav){
            communityID = ' Idea.Move_Idea_To__c  = ' + '\'' +  'National' + '\'' + ' AND Idea.CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else if(CampaignNav){
            communityID = ' Idea.CommunityId  = ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else{
            communityID = ' Idea.Move_Idea_To__c  = ' + '\'' +  'Local' + '\'' + '  AND Idea.CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
            LocalNav = true;
        }
        
        
       
        IdeaComment[] ideaCom =  database.query('SELECT IdeaId, Id, CreatedDate, CreatedById, CreatedBy.Name, CommentBody, Idea.CreatedById, Idea.Id, Idea.Title FROM IdeaComment WHERE CreatedDate > :last30Days AND Idea.Inappropriate_Flag_By_SC__c != ' + '\'' + 'Yes' + '\'' + ' AND ' + communityID );
        
        
        for(IdeaComment iCom : ideaCom){
                
                
                if(iCom.Idea.CreatedbyId == UserInfo.getUserId() && iCom.CreatedDate > (system.today() - 30) && iCom.CreatedById != UserInfo.getUserId()){
                        
                        ideaActivity idA = new ideaActivity();
                        idA.typeOfActivity = '<img src="/img/ideas/icons/ideasCommented16.gif" /> <b>' + iCom.CreatedBy.Name + '</b> Commented on your Idea <a href="/' + userType +'/ideas_detail_v2?id=' + iCom.Idea.Id + '">' + iCom.Idea.title + '</a> <br/> <img src="/img/ideas/icons/openquotes16.gif" /> ' + iCom.CommentBody + ' <img src="/img/ideas/icons/closequotes16.gif" />';
                        ideaActCom.add(idA);
                        
                        
                        
                //Coments on Other Ideas By Me in the last 30 Days
                }else if(iCom.Idea.CreatedbyId != UserInfo.getUserId() && iCom.CreatedDate > (system.today() - 30) && iCom.CreatedById == UserInfo.getUserId()){
                        
                        ideaActivity idA = new ideaActivity();
                        idA.typeOfActivity = '<img src="/img/ideas/icons/ideasCommented16.gif" /> You Commented on <a href="/' + userType +'/ideas_detail_v2?id=' + iCom.Idea.Id + '">' + iCom.Idea.title + '</a> <br/> <img src="/img/ideas/icons/openquotes16.gif" /> ' + iCom.CommentBody + ' <img src="/img/ideas/icons/closequotes16.gif" />';
                        ideaActCom.add(idA);
                        
    
                }
        }
        
        return ideaActCom;} set; }
        
    //******************** Get Voted Ideas ****************************
    public List<ideaActivity> iedaActVote{ get{ 
        
        Date last30Days = (system.today() - 30);
        
        List<ideaActivity> ideaActVote = new List<ideaActivity>();
        
        String userID = UserInfo.getUserId();
        
        String communityID = '';
        
        if(LocalNav){
            communityID = ' Move_Idea_To__c  = ' + '\'' +  'Local' + '\'' + ' AND CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else if(NationalNav){
            communityID = ' Move_Idea_To__c  = ' + '\'' +  'National' + '\'' + ' AND CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else if(CampaignNav){
            communityID = ' CommunityId  = ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
        }else{
            communityID = ' Move_Idea_To__c  = ' + '\'' +  'Local' + '\'' + '  AND CommunityId != ' + '\'' +  '09a200000000gmx' + '\'' + ' ';
            LocalNav = true;
        }
        
        
        Idea[] ideaVotes = database.query('SELECT  CreatedDate, CreatedById, Id, Title, (SELECT CreatedDate, Type, CreatedById, CreatedBy.Name FROM Votes WHERE CreatedDate > :last30Days AND CreatedById = ' + '\'' + userId + '\'' + ') FROM Idea Where Inappropriate_Flag_By_SC__c != ' + '\'' + 'Yes' + '\'' + ' AND ' + communityID );
        
        for(Idea i : ideaVotes){
        
                for(Vote v : i.Votes){
                        
                        //Votes UP On My Ideas in the Last 30 Days
                        if(i.CreatedById == UserInfo.getUserId() && v.CreatedDate > (system.today() - 30) && v.CreatedById != UserInfo.getUserId() && v.Type == 'Up'){
                                
                                ideaActivity idA = new ideaActivity();
                                idA.typeOfActivity = '<img src="/img/ideas/icons/voted16.gif" /> <b>' + v.CreatedBy.Name + '</b> Promoted your Idea <a href="/' + userType +'/ideas_detail_v2?id=' + i.Id + '">' + i.title + '</a>';
                                ideaActVote.add(idA);
                                
                        //VMy UP votes on other ideas in the Last 30 Day
                        }else if(i.CreatedById != UserInfo.getUserId() && v.CreatedDate > (system.today() - 30) && v.CreatedById == UserInfo.getUserId() && v.Type == 'Up'){
                                
                                ideaActivity idA = new ideaActivity();
                                idA.typeOfActivity = '<img src="/img/ideas/icons/voted16.gif" /> You Promoted <a href="/' + userType +'/ideas_detail_v2?id=' + i.Id + '">' + i.title + '</a>';
                                ideaActVote.add(idA);
                                
                        }//Votes DOWN On My Ideas in the Last 30 Days
                        else if(i.CreatedById == UserInfo.getUserId() && v.CreatedDate > (system.today() - 30) && v.CreatedById != UserInfo.getUserId() && v.Type == 'Down'){
                                
                                ideaActivity idA = new ideaActivity();
                                idA.typeOfActivity = '<img src="/img/ideas/icons/voted16.gif" /> <b>' + v.CreatedBy.Name + '</b> Demoted your Idea <a href="/' + userType +'/ideas_detail_v2?id=' + i.Id + '">' + i.title + '</a>';
                                ideaActVote.add(idA);
                                
                        //VMy DOWN votes on other ideas in the Last 30 Day
                        }else if(i.CreatedById != UserInfo.getUserId() && v.CreatedDate > (system.today() - 30) && v.CreatedById == UserInfo.getUserId() && v.Type == 'Down'){
                                
                                ideaActivity idA = new ideaActivity();
                                idA.typeOfActivity = '<img src="/img/ideas/icons/voted16.gif" /> You Demoted <a href="/' + userType +'/ideas_detail_v2?id=' + i.Id + '">' + i.title + '</a>';
                                ideaActVote.add(idA);
                                
                        }
                }
        }
        
        return ideaActVote;} set; }
    
    
    public class ideaActivity{
        
        public String typeOfActivity {get; set;}
        public String title {get; set;}
        public String body {get; set;}
        public String comment {get; set;}
        public ID id {get; set;}
        public String nick {get; set;}
        public Date dateOfActivity {get; set;}
    
    
    }
    
    // Change Location **************
    
    Boolean locEdit = false;
    
    
    public PageReference showEdit(){
        
        
        
        return null;
    }
    
    public Boolean getEditLocalShow(){
        return locEdit;
    }  
    
    
   
    
    public user u {get; set;}
    
    public String locationValue {get; set;}
    public String locationValueChange {get; set;}
    
    public List<SelectOption> locationsForUpdate {get{
        
        List<SelectOption> locationsForUpdate = new List<SelectOption>();
        
        
        
        locationsForUpdate.add(new SelectOption('--Select--','--Select--'));
        
        Idea_Location__c[] loc = [SELECT Id, Location__c FROM Idea_Location__c ORDER BY Location__c ASC];
        
        for(Idea_Location__c l : loc){
            locationsForUpdate.add(new SelectOption(l.location__c,l.location__c));
        }
        
        
        return locationsForUpdate;
    
    } set;}
    
    public PageReference changeLocation() {
        
        if(locEdit){
                u.Idea_Location__c = locationValueChange;
                
                update u;
        }
        
        if(locEdit){
                locEdit = false;
        }else if(!locEdit){
                locEdit = true;
        }
        
        
        return null;
    }
    
    
    
    
    // *****************************************
    // *********** Ideas In Action *************
    // *****************************************
    
    public Idea[] ideasInAction {get{
    
        return [SELECT Id, title, body, status, NumComments, VoteTotal FROM Idea Where status = 'In Action' Limit 5];
    
    } set;}
        
    // *****************************************
    // *********** Location Controller *********
    // *****************************************
        
    public String location {get; set;}
    
    
    // *****************************************
    // ************** Navigation ***************
    // *****************************************
    
    
    Public Boolean LocalNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09a200000000gmn') ? true : false;
        return nav;
    } set;}
    Public Boolean NationalNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09a200000000gms') ? true : false;
        return nav;
    } set;}
    Public Boolean CampaignNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09a200000000gmx') ? true : false;
        return nav;
    } set;}
    
    Public Boolean RecentNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('sort') == 'recent') ? true : false;
        return nav;
    } set;}
    Public Boolean TopNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('sort') == 'top') ? true : false;
        return nav;
    } set;}
    Public Boolean PopularNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('sort') == 'popular') ? true : false;
        return nav;
    } set;}
    Public Boolean CommentsNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('sort') == 'comments') ? true : false;
        return nav;
    } set;}
    
    
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
        
        IdeasProfileExtension.test4321 = '1';
        
        IdeasProfileExtension.test1234();
        
        Test.stopTest();   
    }
}