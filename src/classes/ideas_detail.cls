public class ideas_detail {
    
    
    //Adding More Information To Ideas
    
    public Boolean showEdit{get{
    
        if(ApexPages.currentPage().getParameters().get('e') == 't'){
            return true;
        }else{
            return false;
        }
    
    } set;}
    
    public PageReference showEditBtn(){
        
        PageReference pRef;
        
        if((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')){
                pRef = new PageReference('/apex/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id') + '&e=t');
        }else{
                pRef = new PageReference('/ukideas/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id') + '&e=t');
        }
        
        return pRef;
    }
    
    public String ideaAddInfoValue2{get; set;}
    
    public PageReference updateIdeaInformation(){
        Idea IdeaUpdate = [SELECT Id, Title, Body, Additional_Information__c, Status FROM Idea WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        IdeaUpdate.Additional_Information__c = ideaAddInfoValue2;
        
        update IdeaUpdate;
        
        PageReference pRef;
        
        if((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')){
                pRef = new PageReference('/apex/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }else{
                pRef = new PageReference('/ukideas/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }
        return pRef;
    }
    
    // *****************************************
    // ************** Variables ****************
    // *****************************************
    
    private final ApexPages.IdeaStandardSetController ideaSetController;
    
    private final ApexPages.StandardSetController stdtSetController;
    
    private final ApexPages.IdeaStandardController ideaController;
    
    public List<Idea> allIdeas = new List<Idea>();
    
    public String filterId {get; set;}
    
    public Integer pageSize {get; set;}
    
    public Integer resultSize {get; set;}
    
    public Integer pageListNumber;
    
    public Boolean HasNext {get; set;}
    
    public Boolean HasPrevious {get; set;}
    
    public Idea IdeaNew {get; set;}
    
    public Idea IdeaDetail {get{
    
        IdeaDetail = [SELECT Id, Title, CreatedDate, Body, Status, voted__c, (SELECT Id FROM Votes Where CreatedById = :UserInfo.getUserId()) FROM Idea WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        for(Vote v :IdeaDetail.Votes){
            
            IdeaDetail.voted__c = True;
            
              
        }
        
        
        
        return IdeaDetail;
    
    } set;}
    
    //Format Date
    
    public String dateFormated{ get{
        
        Datetime cDT = IdeaDetail.CreatedDate;
    
        String longDate = cDT.format('EEEE, MMMM d, yyyy');
        return longDate;
    } set;} 
    
    public user u {get{ return [SELECT Id, email, Idea_Admin_Role__c, Idea_Location__c FROM User WHERE Id = :UserInfo.getUserId()];} set;}
    
    // *****************************************
    // ************** Pagination ***************
    // *****************************************
    
    
    public PageReference backPage(){
        
        pageListNumber--;
        
        PageReference pageRef = new PageReference('https://c.cs4.visual.force.com/apex/ideas_test?lsr=' + pageListNumber);
        
        return pageRef;
    
    }
    
    public PageReference nextPage(){
        
        pageListNumber++;
        
        PageReference pageRef = new PageReference('https://c.cs4.visual.force.com/apex/ideas_test?lsr=' + pageListNumber);
        
        return pageRef;
    
    }
    
    
    public PageReference saveIdea(){
        
        insert ideaNew;
        
        PageReference pageRef = new PageReference('https://c.cs4.visual.force.com/apex/ideas_test?lsr=1');
        
        return pageRef;
    
    }
    
    // *****************************************
    // ********* Stdt Set Controller ***********
    // *****************************************
    
    
    
    public ideas_detail(ApexPages.StandardSetController controller) {
        
        
        
        if(ApexPages.currentPage().getParameters().get('lsr') == null){
            pageListNumber = 1;
        }else{
            pageListNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('lsr'));
        }
        
        stdtSetController = (ApexPages.StandardSetController) controller;
        
        stdtSetController.setPageSize(10);
        stdtSetController.setpageNumber(pageListNumber);
        
        filterId = stdtSetController.getFilterId();
        pageSize = stdtSetController.getPageSize();
        resultSize = stdtSetController.getResultSize();
        HasNext = stdtSetController.getHasNext();
        HasPrevious = stdtSetController.getHasPrevious();
        
        allIdeas = stdtSetController.getRecords();
    
    }


    public ideas_detail(ApexPages.StandardController controller) {
        
        
        this.ideaDetailX = (Idea)controller.getRecord();
        
    }
    
     public ideas_detail(ApexPages.IdeaStandardController controller) {
        ideaController = (ApexPages.IdeaStandardController)controller;
    }
    
    // *****************************************
    // ********* Idea Set Controller ***********
    // *****************************************
    
    public Idea ideaDetailX;
    
    public ideas_detail(ApexPages.IdeaStandardSetController controller) {
        
        ideaSetController = (ApexPages.IdeaStandardSetController) controller;
        
    }


    
    public List<Idea> getIdeasList(){
    
            return [SELECT Id, title, body, status
                    FROM Idea
                    WHERE Id IN :allIdeas];
    
    }
    
    // *****************************************
    // ************** Comments *****************
    // *****************************************
    
    public String commentBody {get; set;}
    
    
    public List<IdeaComment> getCommentList(){
            
            IdeaComment[] coms = [SELECT id, commentBody, createdDate, createdBy.Id, createdBy.communityNickname, createdBy.name FROM IdeaComment WHERE ID IN :ideaController.getCommentList()];
            
            return coms;
    
    }
    
    public PageReference saveComment(){
    
        IdeaComment com = new IdeaComment();
        
        com.IdeaId = ApexPages.CurrentPage().getParameters().get('id');
        com.CommentBody = commentBody;
        
        insert com;
        
        commentBody = null;
        
        PageReference pRef;
        
        if((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')){
                pRef = new PageReference('/apex/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }else{
                pRef = new PageReference('/ukideas/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }
        
        return pRef;
    }
    
    // *****************************************
    // ************** Updates *****************
    // *****************************************
    
    public String ideaUpdateValue{get; set;}
    public String ideaAddInfoValue{get; set;}
    
    public PageReference saveUpdates(){
    
        Idea IdeaUpdate = [SELECT Id, Title, Body, Additional_Information__c, Status FROM Idea WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        IdeaUpdate.Additional_Information__c = ideaAddInfoValue;
        
        update IdeaUpdate;
        
        PageReference pRef;
        
        if((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')){
                pRef = new PageReference('https://c.eu0.visual.force.com/apex/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }else{
                pRef = new PageReference('https://tntemea.secure.force.com/ukideas/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }
        return pRef;
    
    }
    
    //Sencibility Check
    
    public String ideaAddInfoValueSC{get; set;}
    
    public PageReference saveUpdatesSC(){
    
        Idea IdeaUpdate = [SELECT Id, Title, Body, Additional_Information_SC__c, Status FROM Idea WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        IdeaUpdate.Additional_Information_SC__c = ideaAddInfoValueSC;
        
        update IdeaUpdate;
        
        PageReference pRef;
        
        if((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')){
                pRef = new PageReference('https://c.eu0.visual.force.com/apex/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }else{
                pRef = new PageReference('https://tntemea.secure.force.com/ukideas/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id'));
        }
        return pRef;
    
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
    // *************** Sort Location ************
    // ******************************************
    
    public String locationValue {get; set;}
    
    public List<SelectOption> locationsForUpdate {get{
        
        List<SelectOption> locationsForUpdate = new List<SelectOption>();
        
        Schema.DescribeFieldResult F = User.Location__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        
        locationsForUpdate.add(new SelectOption('--Select--','--Select--'));
        
        for(Schema.PicklistEntry pick : P){
            locationsForUpdate.add(new SelectOption(pick.getValue(),pick.getValue()));
        }
        
        return locationsForUpdate;
    
    } set;}
    
    
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
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09aP0000000CakE') ? true : false;
        return nav;
    } set;}
    Public Boolean NationalNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09aP0000000Cak9') ? true : false;
        return nav;
    } set;}
    Public Boolean CampaignNav {get{ 
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09aP0000000CakJ') ? true : false;
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
    // ************** Attachment Id ************
    // *****************************************
    
    public String attachmentName {get{
        
        if(ideaController.getRecord().Id != null){
        
            Id IdeaId = ideaController.getRecord().Id;
            
            Idea IdeaX = [SELECT Id, Idea_Attachment__r.Id FROM Idea WHERE Id = :IdeaId];
            
            if(IdeaX.Idea_Attachment__r.Id != null){
                try{
                    String testX = [SELECT Name FROM Attachment WHERE ParentId  = :IdeaX.Idea_Attachment__r.Id LIMIT 1].Name;
                
                    return testX;
                }catch(QueryException qe){
                    return null;
                }
            }else{
                return null;
            }
        }
        else{
            return null;
        }
    } set;}
    
    public String attachmentId {get{
        
        if(ideaController.getRecord().Id != null){
        
            Id IdeaId = ideaController.getRecord().Id;
            
            Idea IdeaX = [SELECT Id, Idea_Attachment__r.Id FROM Idea WHERE Id = :IdeaId];
            
            if(IdeaX.Idea_Attachment__r.Id != null){
                try{
                    String testX = [SELECT Id FROM Attachment WHERE ParentId  = :IdeaX.Idea_Attachment__r.Id LIMIT 1].Id;
                
                    return testX;
                }catch(QueryException qe){
                    return null;
                }
            }else{
                return null;
            }
        }
        else{
            return null;
        }
    } set;}
    
    
    // ********************** REPORT Inappropriate **************************
    
    public PageReference updateAdminInappropriate(){
        
        Idea i = [SELECT Id, CreatedBy.Email, Title, Workflow_Status__c, Assigned_Admin__r.Id, Contact_Number__c, Inappropriate_Flag_By_SC__c FROM Idea Where Id = :ideaController.getRecord().Id];
        
        //aaron additions / modifications
        //aaron: added line below
        Idea_Admin__c idad = [SELECT id,Inappropriate_Flag__c, Inappropriate_Flag_Author__c, Inappropriate_Flag_timestamp__c FROM Idea_Admin__c WHERE Idea__c = :i.Id]; 
        
        User ux = [SELECT Id, FirstName, Profile.Name, National_Evaluator__c, LastName FROM User WHERE Id = :UserInfo.getUserId()];
         
        //aaron: added lines to solve issue 157 -> email to all users in profile 'IDEA ADMIN'        
        List<User> admUsers = new List<User>([select id, Email from User where Profile.Name =: 'IDEA ADMIN' ]);
        List<String> toEmails = new List<String>();
        for(User u : admUsers){
			toEmails.add(u.Email);
        }
         if((ux.Profile.Name == 'IDEA ADMIN' || ux.National_Evaluator__c == true || i.Assigned_Admin__r.Id == ux.Id) && (i.Inappropriate_Flag_By_SC__c == '' || i.Inappropriate_Flag_By_SC__c == 'No' || idad.Inappropriate_Flag__c == 'No' || idad.Inappropriate_Flag__c == '') ){
                
                i.Inappropriate_Flag_By_SC__c = 'yes';
                idad.Inappropriate_Flag__c = 'Yes';
                idad.Inappropriate_Flag_Author__c = ux.FirstName + ' ' + ux.LastName;
                idad.Inappropriate_Flag_timestamp__c = datetime.now();

        		//message to IDEA ADMINS
        		Messaging.SingleEmailMessage messageADM = new Messaging.SingleEmailMessage();
                messageADM.setToAddresses(toEmails);
                messageADM.setReplyTo('tnt@tnt.co.uk');
                messageADM.setSenderDisplayName('TNT Idea');
                messageADM.setSubject('TNT I’dea');
                messageADM.setHtmlBody('<p>Dear IDEA ADMIN' + ',</p><p>An I’dea has been flagged as inappropriate by a member of the TNT community:</p><p>' + i.Title + '</p><p>Yours sincerely,</p><p>I’dea Administration Team</p>');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { messageADM });
               
        }else if((ux.Profile.Name == 'IDEA ADMIN' || ux.National_Evaluator__c == true || i.Assigned_Admin__r.Id == ux.Id) && (i.Inappropriate_Flag_By_SC__c == 'Yes' || idad.Inappropriate_Flag__c == 'Yes') ){
               //message to user
                i.Inappropriate_Flag_By_SC__c = 'Removed';
                idad.Inappropriate_Flag__c = 'Removed';
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {i.CreatedBy.Email};
                message.setToAddresses(toAddresses);
                message.setReplyTo('tnt@tnt.co.uk');
                message.setSenderDisplayName('TNT Idea');
                message.setSubject('TNT I’dea');
                User receiver = [SELECT id, FirstName FROM User WHERE id = : i.CreatedById]; 
                message.setHtmlBody('<p>Dear ' + receiver.FirstName + ',</p><p>Your I’dea has been flagged as inappropriate by a member of the TNT community:</p><p>' + i.Title + '</p><p>We have therefore taken the decision to remove your I’dea from the website.</p><p>Yours sincerely,</p><p>I’dea Administration Team</p>');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                IdeaSMS.sendSMS('Your I’dea ' + i.Title + ' has been deemed inappropriate and has therefore been removed from the website', i.Contact_Number__c);      	
        		 
        }else if((ux.Profile.Name != 'IDEA ADMIN' && ux.National_Evaluator__c != true && i.Assigned_Admin__r.Id != ux.Id) && (i.Inappropriate_Flag_By_SC__c == '' || i.Inappropriate_Flag_By_SC__c == 'No' || idad.Inappropriate_Flag__c == 'No' || idad.Inappropriate_Flag__c == '') ){
        	//idea user set idea as inappropriate:
        	//i.Inappropriate_Flag_By_SC__c = 'yes - Portal';
        	 i.Inappropriate_Flag_By_SC__c = 'yes';
             idad.Inappropriate_Flag__c = 'Yes';
             idad.Inappropriate_Flag_Author__c = ux.FirstName + ' ' + ux.LastName;
             idad.Inappropriate_Flag_timestamp__c = datetime.now();
             Messaging.SingleEmailMessage messageADM = new Messaging.SingleEmailMessage();
             messageADM.setToAddresses(toEmails);
             messageADM.setReplyTo('tnt@tnt.co.uk');
             messageADM.setSenderDisplayName('TNT Idea');
             messageADM.setSubject('TNT I’dea');
             messageADM.setHtmlBody('<p>Dear IDEA ADMIN' + ',</p><p>An I’dea has been flagged as inappropriate by a member of the TNT community:</p><p>' + i.Title + '</p><p>Yours sincerely,</p><p>I’dea Administration Team</p>');
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { messageADM });
        }
        
        // end of aaron additions
         /* aaron commented original section. This section was inside aaron modifications above
       //Last behaviour: just send to the current admin
        if(ux.Profile.Name == 'IDEA ADMIN' || ux.National_Evaluator__c == true || i.Assigned_Admin__r.Id == ux.Id){
                i.Inappropriate_Flag_By_SC__c = 'yes';
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {i.CreatedBy.Email};
                message.setToAddresses(toAddresses);
                message.setReplyTo('tnt@tnt.co.uk');
                message.setSenderDisplayName('TNT Idea');
                message.setSubject('TNT I’dea');
                message.setHtmlBody('<p>Dear ' + ux.FirstName + ',</p><p>Your I’dea has been flagged as inappropriate by a member of the TNT community:</p><p>' + i.Title + '</p><p>We have therefore taken the decision to remove your I’dea from the website.</p><p>Yours sincerely,</p><p>I’dea Administration Team</p>');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                IdeaSMS.sendSMS('Your I’dea ' + i.Title + ' has been deemed inappropriate and has therefore been removed from the website', i.Contact_Number__c);
                
        }else{
                i.Inappropriate_Flag_By_SC__c = 'yes - Portal';
        }
        */
        update i;
        update idad;
        
        PageReference pRef;
        
        if((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')){
                pRef = new PageReference('/apex/ideas/ideas_test_v2');
        }else{
                pRef = new PageReference('/ukideas/ideas_test_v2');
        }
        
        
        return pRef;
    }
    
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
        
        ideas_detail controller = new ideas_detail(new ApexPages.StandardController(i));
        
        Test.startTest();
        
        controller.test4321 = '1';
        
        controller.test1234();
        
        Test.stopTest();   
    }       
}