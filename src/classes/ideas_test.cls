public virtual class ideas_test {
    
    
    // *****************************************
    // ************** Navigation ***************
    // *****************************************
    
    
    Public Boolean LocalNav {get{ 
        Boolean nav;
        
        if(ApexPages.currentPage().getParameters().get('c') == '09a200000000gmn' || ApexPages.currentPage().getParameters().get('c') == '09a200000000gmnAAA'){
            nav = true;
        }else if(ApexPages.currentPage().getParameters().get('c') == null){
            nav = true;
        }else{
            nav = false;
        }
        
        return nav;
    } set;}
    Public Boolean NationalNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09a200000000gms') ? true : false;
        return nav;
    } set;}
    Public Boolean CampaignNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09a200000000gmx' || ApexPages.currentPage().getParameters().get('c') == '09a200000000gmxAAA') ? true : false;
        return nav;
    } set;}
    
    Public Boolean RecentNav {get{ 
        Boolean nav; 
        
        if(ApexPages.currentPage().getParameters().get('sort') == 'recent'){
            nav = true;
        }else if(ApexPages.currentPage().getParameters().get('sort') == null){
            nav = true;
        }else{
            nav = false;
        }
        
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
    // ************** Controllers **************
    // *****************************************
    
    private final ApexPages.IdeaStandardSetController ideaSetController;
    
    public List<pagginationNav> newPageNav;
    
    // get Navigation Pages
    
    public List<pagginationNav> getNewPageNav(){
        
        filterId = stdtSetController.getFilterId();
        pageSize = stdtSetController.getPageSize();
        resultSize = stdtSetController.getResultSize();
        HasNext = stdtSetController.getHasNext();
        HasPrevious = stdtSetController.getHasPrevious();
        
        
        Decimal nrOfPages = Decimal.valueOf(stdtSetController.getResultSize()) / Decimal.valueOf(stdtSetController.getPageSize());
        
        newPageNav = new List<pagginationNav>();
        
        nrOfPages = nrOfPages.round();
        
        system.debug('nrOfPages ' + nrOfPages);
        system.debug('pageSize ' + pageSize );
        system.debug('resultSize ' + resultSize );
        
        for(integer i = 0; i <= nrOfPages; i++){
                
                Integer iX = i + 1;
                
                Boolean selectedNav = (pageListNumber == iX) ? true : false;
                
                String paramC = (ApexPages.currentPage().getParameters().get('c') == null) ? '09a200000000gmn' : ApexPages.currentPage().getParameters().get('c');
                String paramSort = (ApexPages.currentPage().getParameters().get('sort') == null) ? 'recent' : ApexPages.currentPage().getParameters().get('sort');
                
                String navURL;
                
                String location_value = ApexPages.CurrentPage().getParameters().get('loc');
                
                if(location_value == '' || location_value == null || location_value == 'null'){
                
                   
                    if(UserInfo.getUserType() == 'Standard'){
                        navURL = '/apex/ideas_test_v2?c=' + paramC + '&sort=' + paramSort + '&lsr=' + iX;
                    }else{
                        navURL = '/ukideas/ideas_test_v2?c=' + paramC + '&sort=' + paramSort + '&lsr=' + iX;
                    }
                }     
                else{
                    
                    if(UserInfo.getUserType() == 'Standard'){
                        navURL = '/apex/ideas_test_v2?c=' + paramC + '&loc=' + location_value + '&sort=' + paramSort + '&lsr=' + iX;
                    }else{
                        navURL = '/ukideas/ideas_test_v2?c=' + paramC + '&loc=' + location_value + '&sort=' + paramSort + '&lsr=' + iX;
                    }
                
                }
                
                pagginationNav p = new pagginationNav();
                
                p.pageNR = iX;
                p.selectedURL = navURL;
                p.selected = selectedNav;
                
                newPageNav.add(p);
                
        }
        
        system.debug('newPageNav.size() ' + newPageNav.size());
        
        if(newPageNav.size() > 1){
            return newPageNav;    
        }else{
            return null;
        }
        
        
        
    }
    
    // get Ideas to be displayed with navigation
    
    private ApexPages.StandardSetController stdtSetController {get{
    
        if(stdtSetController == null){
        
        String userID = UserInfo.getUserId();
        
        User u = [SELECT Id, Idea_Location__c FROM User WHERE Id = : UserInfo.getUserId()];
        
        String orderField;
        String sortOrder;
        String commentsFilter = '';
        String communityID = '';
        String locationFilter = '';
        String searchFilter = '';
        
        Integer pageListNumber;
        
        if(RecentNav){
            orderField = 'CreatedDate';
            sortOrder = 'DESC';
        }else if(TopNav){
            orderField = 'VoteTotal';
            sortOrder ='DESC';
        }else if(PopularNav){
            orderField = 'VoteScore';
            sortOrder = 'DESC';
        }else if(CommentsNav){
            orderField = 'LastCommentDate';
            sortOrder = 'DESC';
            commentsFilter = ' AND NumComments > 0 ';
        }else{
            orderField = 'CreatedDate';
            sortOrder = 'DESC';
            RecentNav = true;
        }
        
        
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
        
        
        
        
        //Sort By Location
        
        String loc_for_idea = ApexPages.currentPage().getParameters().get('loc');
        
        try{
        
                if((loc_for_idea == null || loc_for_idea == '--Select--') && LocalNav && u.Idea_Location__c != null){
                        
                        Idea_Location__c i_Loc = [SELECT Id, Location__c, Group__c FROM Idea_Location__c WHERE Location__c = :u.Idea_Location__c LIMIT 1];
                        
                        locationFilter = ' AND Idea_Location__r.Group__c = ' + '\'' + i_Loc.Group__c + '\'';
                        
                }else if(LocalNav){
                        
                        Idea_Location__c i_Loc = [SELECT Id, Location__c, Group__c FROM Idea_Location__c WHERE Location__c = :loc_for_idea LIMIT 1];
                        
                        locationFilter = ' AND Idea_Location__r.Group__c = ' + '\'' + i_Loc.Group__c + '\'';
                }
        }catch(exception e){
                
                locationFilter = '';
                
        }
        
        //Search By Name
        
        if(searchIdeas == null || searchIdeas == 'Search ideas'){
                searchFilter = '';
        }else if(searchIdeas != null && searchIdeas != 'Search ideas'){
                searchFilter = ' AND title LIKE ' + '\'' + '%' + searchIdeas + '%' + '\'';
        }
        
        
        List<Idea> voteIds = database.query('SELECT Id, title, body, status, NumComments, VoteTotal, voted__c, (SELECT Id FROM Votes Where CreatedById = ' + '\'' + userId + '\'' + ') FROM Idea Where Inappropriate_Flag_By_SC__c != ' + '\'' + 'Yes' + '\'' + ' AND ' + communityID + commentsFilter + locationFilter + searchFilter + ' ORDER BY ' + OrderField + ' ' + sortOrder);
        
        
        
        ApexPages.StandardSetController ret = new ApexPages.StandardSetController(voteIds);
        
        if(ApexPages.currentPage().getParameters().get('lsr') == null){
            pageListNumber = 1;
        }else{
            pageListNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('lsr'));
        }
        
        
        ret.setPageSize(10);
        ret.setpageNumber(pageListNumber);
        
        
        HasNext = ret.getHasNext();
        HasPrevious = ret.getHasPrevious();
        

        return ret;
        
        }else{
            return null;
        }
        
    } set;}
    
    
    
    // *****************************************
    // ************** Variables ****************
    // *****************************************
    
    
    
    public List<Idea> allIdeas = new List<Idea>();
    
    public String filterId {get; set;}
    
    public Integer pageSize {get; set;}
    
    public Integer resultSize {get; set;}
    
    public Integer pageListNumber;
    
    public Boolean HasNext {get; set;}
    
    public Boolean HasPrevious {get; set;}
    
    public user u {get{ return [SELECT Id, Idea_Location__c, Idea_Admin_Role__c FROM User WHERE Id = :UserInfo.getUserId()];} set;}
    
    
    // *****************************************
    // ************** Pagination ***************
    // *****************************************
    
    public String userType = (UserInfo.getUserType() == 'Standard') ? 'apex':'ukideas';
    
    public PageReference backPage(){
        
        pageListNumber = (ApexPages.currentPage().getParameters().get('lsr') != null) ? Integer.valueOf(ApexPages.currentPage().getParameters().get('lsr')) : 1;
        
        pageListNumber--;
        
        String i_community = (ApexPages.currentPage().getParameters().get('c') != null) ? 'c=' + ApexPages.currentPage().getParameters().get('c') : '';   
        
        String i_sort = (ApexPages.currentPage().getParameters().get('sort') != null) ? '&sort=' + ApexPages.currentPage().getParameters().get('sort') : '';
        
        PageReference pageRef = new PageReference('/' + userType + '/ideas_test_v2?' + i_community + i_sort + '&lsr=' + pageListNumber);
        //PageReference pageRef = new PageReference('/' + userType + '/ideas_test_v2?c=' + ApexPages.currentPage().getParameters().get('c') + '&sort=' + ApexPages.currentPage().getParameters().get('sort') + '&lsr=' + pageListNumber);
        
        return pageRef;
    
    }
    
    public PageReference nextPage(){
        
        pageListNumber = (ApexPages.currentPage().getParameters().get('lsr') != null) ? Integer.valueOf(ApexPages.currentPage().getParameters().get('lsr')) : 1;
        
        pageListNumber++;
        
        String i_community = (ApexPages.currentPage().getParameters().get('c') != null) ? 'c=' + ApexPages.currentPage().getParameters().get('c') : '';   
        
        String i_sort = (ApexPages.currentPage().getParameters().get('sort') != null) ? '&sort=' + ApexPages.currentPage().getParameters().get('sort') : '';
        
        PageReference pageRef = new PageReference('/' + userType + '/ideas_test_v2?' + i_community + i_sort + '&lsr=' + pageListNumber);
        //PageReference pageRef = new PageReference('/' + userType + '/ideas_test_v2?c=' + ApexPages.currentPage().getParameters().get('c') + '&sort=' + ApexPages.currentPage().getParameters().get('sort') + '&lsr=2');
        
        return pageRef;
    
    }
    
    
    
    public class pagginationNav{
        
        public Integer pageNR {get; set;} 
        public String selectedURL {get; set;}
        public Boolean selected {get; set;}
        
    }
    
    
    


    public ideas_test(ApexPages.StandardController controller) {
        
        
        
    }
    
   
    
    // *****************************************
    // ********* Idea Set Controller ***********
    // *****************************************
    
    public ideas_test(ApexPages.IdeaStandardSetController controller) {
        
        ideaSetController = (ApexPages.IdeaStandardSetController) controller;
        
        
        if(ApexPages.currentPage().getParameters().get('lsr') == null){
            pageListNumber = 1;
        }else{
            pageListNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('lsr'));
        }
        
        filterId = ideaSetController.getFilterId();
        pageSize = ideaSetController.getPageSize();
        resultSize = ideaSetController.getResultSize();
       
    }
    
    // *****************************************
    // ********* Stdt Set Controller ***********
    // *****************************************
    
    public ideas_test(ApexPages.StandardSetController controller) {
        
        if(ApexPages.currentPage().getParameters().get('lsr') == null){
            pageListNumber = 1;
        }else{
            pageListNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('lsr'));
        }
        
        
    }
    
    
    
    public List<Idea> getIdeasList(){
            
            
            
            Integer pageListNumber;
            
            if(ApexPages.currentPage().getParameters().get('lsr') == null){
                pageListNumber = 1;
            }else{
                pageListNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('lsr'));
            }
            
            
            stdtSetController.setpageNumber(pageListNumber);
            
           
            
            return updatedIdeasList(stdtSetController.getRecords());
            
            
    }
    
    public List<Idea> updatedIdeasList(List<Idea> ideasForUpdate){
        
        
        
        
        String userID = UserInfo.getUserId();
        
        String orderField;
        String sortOrder;
        
        if(RecentNav){
            orderField = 'CreatedDate';
            sortOrder = 'DESC';
        }else if(TopNav){
            orderField = 'VoteTotal';
            sortOrder ='DESC';
        }else if(PopularNav){
            orderField = 'VoteScore';
            sortOrder = 'DESC';
        }else if(CommentsNav){
            orderField = 'LastCommentDate';
            sortOrder = 'DESC';
        }else{
            orderField = 'CreatedDate';
            sortOrder = 'DESC';
        }
        
        
        List<Idea> voteIds = database.query('SELECT Id, title, Status__c, body, status, NumComments, VoteTotal, voted__c, (SELECT Id FROM Votes Where CreatedById = ' + '\'' + userId + '\'' + ') FROM Idea Where Id in :ideasForUpdate ORDER BY ' + OrderField + ' ' + sortOrder);
        
        Set<ID> vID;
        
        for(Idea i : voteIds){
            
            for(Vote v :i.Votes){
            
                i.voted__c = True;
                
            }
        }
        
          
        return voteIds;
    }
    
    // *****************************************
    // ************** Voting *******************
    // *****************************************
   
    
    public PageReference voteUp(){
        
        Vote v = new Vote();
        
        v.ParentId = System.currentPageReference().getParameters().get('ideaIdForVoatUp');

        v.Type = 'Up';
        
        try{
            insert v;
        }catch(System.DmlException e){
            
        }
       
        return null;
    }
    
    public PageReference voteDown(){
        
        Vote v = new Vote();
        
        v.ParentId = System.currentPageReference().getParameters().get('ideaIdForVoatDown');

        v.Type = 'Down';
        
        try{
            insert v;
        }catch(System.DmlException e){
            
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
    // *************** Repply Badge ************
    // *****************************************
    
    public String unreadReplies {get{
        
        Id[] comOneIdeas = Ideas.getUnreadRecentReplies(UserInfo.getUserId(),'09a200000000gmn');
        Id[] comTwoIdeas = Ideas.getUnreadRecentReplies(UserInfo.getUserId(),'09a200000000gms');
        Id[] comThreeIdeas = Ideas.getUnreadRecentReplies(UserInfo.getUserId(),'09a200000000gmx');
        
        return String.valueOf((comOneIdeas.size() + comTwoIdeas.size() + comThreeIdeas.size()));
    
    } set; }
    
     // *****************************************
    // *************** Sort Location ************
    // ******************************************
    
    
    public PageReference location_sort_recent(){
        
        String userTypeForGoBtn = (UserInfo.getUserType() == 'Standard') ? 'https://c.cs2.visual.force.com/apex':'/ukideas';
        
        PageReference pageRef;
        
        String location_value = ApexPages.CurrentPage().getParameters().get('loc');
       
        if(location_value == '' || location_value == null || location_value == 'null'){
            pageRef = new PageReference(userTypeForGoBtn + '/ideas_test_v2' + '?&sort=' + ApexPages.CurrentPage().getParameters().get('sort_idea'));
        }else{
            pageRef = new PageReference(userTypeForGoBtn + '/ideas_test_v2' + '?&loc=' + location_value + '&sort=' + ApexPages.CurrentPage().getParameters().get('sort_idea') + '&x=1');
        }
        
        
        return pageRef;
    }
    
    
    public String locationValue {get; set;}
    
    public PageReference updateLocationView(){
        
        system.debug('********' + locationValue);
        
        String userTypeForGoBtn = (UserInfo.getUserType() == 'Standard') ? 'https://c.cs2.visual.force.com/apex':'/ukideas';
        
        PageReference pageRef = new PageReference(userTypeForGoBtn + '/ideas_test_v2' + '?&loc=' + locationValue + '&x=1');
        return pageRef; 
     
    }
    
    public List<SelectOption> locationsForUpdate {get{
        
        List<SelectOption> locationsForUpdate = new List<SelectOption>();
        
        
        if(ApexPages.currentPage().getParameters().get('loc') == null || ApexPages.currentPage().getParameters().get('loc') == '--Select--'){
                locationsForUpdate.add(new SelectOption('--Select--','--Select--'));
        }else{
                 locationsForUpdate.add(new SelectOption(ApexPages.currentPage().getParameters().get('loc'),ApexPages.currentPage().getParameters().get('loc')));
        }
        
        
        locationsForUpdate.add(new SelectOption('View All','View All'));
        Idea_Location__c[] loc = [SELECT Id, Location__c FROM Idea_Location__c ORDER BY Location__c ASC];
        
        for(Idea_Location__c l : loc){
            try{
            locationsForUpdate.add(new SelectOption(l.location__c,l.location__c));
            }catch(exception e){}
        }
        
        
        
        return locationsForUpdate;
    
    } set;}
    
    // *****************************************
    // *************** Campaign ****************
    // ******************************************
    
    public List<Idea_Campaign__c> ideaCampaign {get{
        
        Idea_Campaign__c[] ideaCampaigns = [SELECT Id, Name, info__c, attachment_Id__c, Image_URL__c, (Select Id From Attachments) FROM Idea_Campaign__c WHERE Publish__c = true LIMIT 2];
        
        for(Idea_Campaign__c iCamp : ideaCampaigns){
                for(Attachment a : iCamp.Attachments){
                        iCamp.attachment_id__c = a.Id;
                }
                if(iCamp.attachment_id__c == null){
                        iCamp.attachment_id__c = '00P2000000BF67w';
                }
        }
        
        return ideaCampaigns;
    
    } set;}
    
    // *****************************************
    // ************** Search Ideas *************
    // *****************************************
    
    public String searchIdeas {get; set;}
    
    
    // *****************************************
    // ************** TEST       ***************
    // *****************************************
    
    public String test4321 {get; set;}
    
    public PageReference test1234(){
        
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
        return null;
        
    
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(i);
        
        ideas_test controller = new ideas_test(sc);
        
        Test.startTest();
        
        controller.test4321 = '1';
        
        controller.test1234();
        
        Test.stopTest();   
    }
 
}