public class ideas_new {
    
    // *****************************************
    // ************** Attachment ***************
    // *****************************************
   
    public string fileName 
    {    get;set;    }
    
    public Blob fileBody 
    {    get;set;    }
    
   
    // *****************************************
    // ************** Variables ****************
    // *****************************************
    
    
    public Idea IdeaNew {get; set;}
    
    public Idea IdeaDetail {get; set;}
    
    public user u {get{ return [SELECT Id, FirstName, Idea_Location__c, Email, Idea_Admin_Role__c FROM User WHERE Id = :UserInfo.getUserId()];} set;}
    
    // *****************************************
    // ************** Save Idea ****************
    // *****************************************
  
  
    
    public PageReference saveIdea(){
        
        User u = [SELECT Id, Idea_Location__c, FirstName, Email, Idea_Community__c FROM User WHERE Id = : UserInfo.getUserId()];
        
        if(u.Idea_Location__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Update Your Location in the Profile Page</span>');
            ApexPages.addMessage(msg);
            return null;
        }
        
        if(ideaNew.Title == ''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Idea Title Cannot be Empty</span>');
            ApexPages.addMessage(msg);
            return null;
        }
        if(ideaNew.Body == ''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Idea Description Cannot be Empty</span>');
            ApexPages.addMessage(msg);
            return null;
        }
        
        
        
        Idea_Location__c i_location = [SELECT Id, RCIM_Queue__r.Id FROM Idea_Location__c WHERE Location__c = :u.Idea_Location__c LIMIT 1];
        
        ID ideaCampaign;
        
        ideaNew.Status__c = 'New';
        ideaNew.Inappropriate_Flag_By_SC__c = 'No';
        ideaNew.Idea_Campaign__c = (ApexPages.currentPage().getParameters().get('camp') != null) ? ApexPages.currentPage().getParameters().get('camp') : null; 
        ideaNew.CommunityId = (ApexPages.currentPage().getParameters().get('camp') != null) ? '09a200000000gmx' : '09a200000000gmn';
        ideaNew.Title = IdeaNew.Title;
        ideaNew.Contact_Number__c =  ideaNew.Contact_Number__c.trim().replaceAll('^0+(?!$)', '');
        ideaNew.Location__c = u.Idea_Location__c;
        ideaNew.Move_Idea_To__c = (ApexPages.currentPage().getParameters().get('camp') != null) ? 'National' : 'Local';
        ideaNew.Workflow_Status__c = (ApexPages.currentPage().getParameters().get('camp') != null) ? 'Sensibility Check Queue' : 'RCIM Queue';
        ideaNew.SLA_Date__c = system.today() + 10;
        ideaNew.Idea_Location__c = i_location.Id;
        ideaNew.Assigned_Admin__c = i_location.RCIM_Queue__r.Id;
        
        Idea_Attachment__c ideaAttach;
        
        if(fileBody != null && fileName != null){
            
            ideaAttach = new Idea_Attachment__c(Name = IdeaNew.Title);
            
            Insert ideaAttach;
            
            ideaNew.Idea_Attachment__c = ideaAttach.Id;
             
        }
        
        //catch errors
        
        try{
            insert ideaNew;
        }catch(System.DmlException e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;"></span>');
            ApexPages.addMessage(msg);
            return null;
        }
        
        Idea_Admin__c i_admin = new Idea_Admin__c(Name = ideaNew.Title, Evaluation__c = 'Local',Idea__c = ideaNew.Id, Idea_Location__c = i_location.Id, Workflow_Status__c = 'RCIM Queue');
        
        insert i_admin;
        
        //aaron: added 2 lines below
        ideaNew.Idea_Admin__c = i_admin.Id;
        update ideaNew;
        
        if(fileBody != null && fileName != null){
        
            Attachment myAttachment  = new Attachment();
            myAttachment.Body = fileBody;
            myAttachment.Name = fileName;
            myAttachment.ParentId = ideaAttach.Id;
            
            try {
              Insert myAttachment;
            } catch (DMLException e) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
              return null;
            } finally {
              myAttachment.body = null; // clears the viewstate
              myAttachment = new Attachment();
            }
            
        }
        
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {u.Email};
        message.setToAddresses(toAddresses);
        message.setReplyTo('TNT.UK.Ideas@tnt.co.uk');
        message.setSenderDisplayName('TNT Idea');
        //message.setTargetObjectId(i_admin.CreatedById);
        //message.setSaveAsActivity(false);
        //message.setWhatId(i_admin.Id);
        message.setSubject('TNT I’dea');
        //message.setHtmlBody('Thanks for submitting your I’dea. It will now be stored and reviewed along with the suggestions of your fellow TNT colleagues. We will be in touch if we need to discuss your I’dea further.');
        //message.setTemplateId('00X20000001G61U');
        
        PageReference pageRef;
        
        if((UserInfo.getUserType() == 'Standard' || UserInfo.getUserType() == 'PowerCustomerSuccess' || UserInfo.getUserType() == 'CSPLitePortal')){
                pageRef = new PageReference('/apex/ideas_test_v2?c=' + ideaNew.CommunityId +'&sort=recent');
          		message.setHtmlBody('<p>Dear ' + u.FirstName + ',</p><p>Thanks for submitting your I’dea:</p><p><a href="https://c.eu0.visual.force.com/apex/ideas_detail_v2?id=' + ideaNew.Id + '">' + ideaNew.Title + '</a></p><p>Your I’dea will now be stored and reviewed along with the suggestions of your fellow TNT colleagues. You will be notified of progress over the coming weeks and we will be in touch if we need to discuss your I’dea further.</p><p>Yours sincerely,</p><p>I’dea Administration Team</p>');    
        }else{
                
                pageRef = new PageReference('/ukideas/ideas_test_v2?c=' + ideaNew.CommunityId +'&sort=recent');
                message.setHtmlBody('<p>Dear ' + u.FirstName + ',</p><p>Thanks for submitting your I’dea:</p><p><a href="https://tntemea.secure.force.com/ukideas/ideas_detail_v2?id=' + ideaNew.Id + '">' + ideaNew.Title + '</a></p><p>Your I’dea will now be stored and reviewed along with the suggestions of your fellow TNT colleagues. You will be notified of progress over the coming weeks and we will be in touch if we need to discuss your I’dea further.</p><p>Yours sincerely,</p><p>I’dea Administration Team</p>');
        }
        
        try{
        	if(ideaNew.Contact_Number__c != null){
        		IdeaSMS.sendSMS('Thanks for your I’dea ' + ideaNew.Title + '.You will be notified of progress or if we need to discuss your I’dea further.', ideaNew.Contact_Number__c);
        	}
        }catch(exception e){}
        
        if(u.Email != null){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        }
        
        return pageRef;
    
    }
    

    public ideas_new(ApexPages.StandardController controller) {
        
        IdeaNew = new Idea();
        
    }
    
    // *****************************************
    // ************Find Similar*****************
    // *****************************************
    
    public List<Idea> dupIdeas;
    
    public List<Idea> getDupIdeas(){
        
        return dupIdeas;
    
    }
    
    public PageReference getDups(){
        
        dupIdeas = new List<Idea>();
        
        Idea ideaX = new Idea();
        
        ideaX.Title = IdeaNew.Title;
        
            system.debug(IdeaNew.Title);
      
        Community community = [ SELECT Id FROM Community WHERE Name = 'Local' ];
        
        ideaX.CommunityId = community.Id;
        
        ID[] results = Ideas.findSimilar(ideaX);
        
            system.debug(results);
        
        dupIdeas = [SELECT Id, title, body, status, NumComments, VoteTotal
                    FROM Idea
                    WHERE Id IN :results 
                    ORDER BY VoteScore DESC
                    LIMIT 5];
        
        return null;
    }

    // *****************************************
    // ************** Voting *******************
    // *****************************************
   
    
    public PageReference voteUp(){
        
        Vote v = new Vote();
        
        v.ParentId = System.currentPageReference().getParameters().get('ideaIdForVoatUp');

        v.Type = 'Up';
        insert v;
        
        return null;
    }
    
    public PageReference voteDown(){
        
        Vote v = new Vote();
        
        v.ParentId = System.currentPageReference().getParameters().get('ideaIdForVoatDown');

        v.Type = 'Down';
        
        insert v;
        
        return null;
    }
    
    
    // *****************************************
    // *************** Sort Location ************
    // ******************************************
    
    public String locationValue {get; set;}
    
    public List<SelectOption> locationsForUpdate {get{
        
        List<SelectOption> locationsForUpdate = new List<SelectOption>();
        
        Schema.DescribeFieldResult F = Idea_Location__c.Location__c.getDescribe();
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
        Boolean nav; 
        
        if(ApexPages.currentPage().getParameters().get('c') == '09a200000000gmn'){
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
        Boolean nav = (ApexPages.currentPage().getParameters().get('c') == '09a200000000gmx') ? true : false;
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
        
        ideas_new controller = new ideas_new(new ApexPages.StandardController(i));
        
        Test.startTest();
        
        controller.test4321 = '1';
        
        controller.test1234();
        
        Test.stopTest();   
    }
    
    
    
    
    
    
}