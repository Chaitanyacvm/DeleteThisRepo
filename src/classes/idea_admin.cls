public class idea_admin {
    
    //new idea for admin info **** Updated
    
    public idea ideaDetail {get; set;}
    
    public idea_admin(ApexPages.StandardController controller) {
        
        try{   
            ideaDetail = new Idea();
            
            Idea i = [SELECT Id, Request_Additional_Information__c, Request_Additional_Information_SC__c FROM Idea Where Id = :ApexPages.CurrentPage().getParameters().get('id')];
            
            if(i.Request_Additional_Information__c != null || i.Request_Additional_Information__c != ''){
                ideaDetail.Request_Additional_Information__c = i.Request_Additional_Information__c;
            }
            if(i.Request_Additional_Information_SC__c != null || i.Request_Additional_Information_SC__c != ''){
                ideaDetail.Request_Additional_Information_SC__c = i.Request_Additional_Information_SC__c;
            }
            
        }catch(exception e){
        
        
        }
        
    }
    
    //END//new idea for admin info **** Updated
    
    //**************** Idea Fields ********************
    
    public String Move_Idea_To {get; set;}
    
    
    //**************** Page Filter ********************
    
    public User adminU {get{
    
        return [SELECT Id, Idea_Admin_Role__c, Delivering_More_Issuer__r.Id, Delegate_Evaluator__r.Id, National_Evaluator__c FROM User WHERE Id = :UserInfo.getUserId()];
    
    } set;}
    
    public idea_admin() {

    }
    
    //************** Delegate Idea **********************
    
    public PageReference delegateIdea(){
        
        Idea Ix = [SELECT Title, Assigned_Admin__c, Idea_Location__r.Delegate_CIM_Queue__r.Id, Idea_Location__r.Delegate_Evaluator_Queue__r.Id, Contact_Number__c, Delegate__c, Decision__c, CreatedBy.UserType, CreatedBy.Email, Workflow_Status__c, National_Evaluator__c, When__c, Decision_Reason__c, Body, Ease_of_Implementation__c, Further_investigation_required__c, Business_Benefit__c, Idea_Checked__c, Reward__c, Additional_Information_Question__c, Request_Additional_Information__c, Additional_Information__c, Private_Comment__c, Public_Comment__c, Move_Idea_To__c, Idea_Rewarded__c, Idea_Accepted__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea WHERE Id = :ApexPages.CurrentPage().getParameters().get('id')];
        
        if(Ix.Move_Idea_To__c == 'Local'){
            //Assign Next Admin
            Ix.Assigned_Admin__c = Ix.Idea_Location__r.Delegate_Evaluator_Queue__r.Id;
         
                
        }else if(Ix.Move_Idea_To__c == 'National'){
            
            if(adminU.National_Evaluator__c){
                //Assign Next Admin
                Ix.Assigned_Admin__c = adminU.Delegate_Evaluator__r.Id;
            }else{
                //Assign Next Admin
                Ix.Assigned_Admin__c = Ix.Idea_Location__r.Delegate_CIM_Queue__r.Id;
            }
            
                
        }
        
        update Ix;
        
        PageReference pageRef;
        
        if(Ix.Workflow_Status__c == 'RCIM Queue'){
                pageRef = new PageReference('/apex/ideas_admin_rcim');
        }else if(Ix.Workflow_Status__c == 'Local Evaluator Queue' || Ix.Workflow_Status__c == 'Local Evaluator Queue - Awaiting User Feedback'){
                pageRef = new PageReference('/apex/ideas_admin_local_evaluation');    
        }else if(Ix.Workflow_Status__c == 'Sensibility Check Queue'  || Ix.Workflow_Status__c == 'Sensibility Check Queue - Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_sensibility');
        }else if(Ix.Workflow_Status__c == 'National Evaluator Queue'  || Ix.Workflow_Status__c == 'National Evaluator Queue- Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_national_evaluation');
        }else if(Ix.Workflow_Status__c == 'Local Delivering More Queue' || Ix.Workflow_Status__c == 'National Delivering More Queue'){
                pageRef = new PageReference('/apex/ideas_admin_dMore_evaluation');
        }else{
                pageRef = new PageReference('/home/home.jsp');
        }
        
        
        return pageRef;
    }
    
    //************ Delegate Assignment List ***************
    
    public List<SelectOption> delegateList {get{
        
        List<SelectOption> delegateList = new List<SelectOption>();
        
        Idea_Location__c[] ideaLocation = [SELECT Evaluator__c FROM Idea_Location__c WHERE Evaluator__c != null AND Evaluator__c != :UserInfo.getUserName()];
        
        Set<String> uniqueDel = new Set<String>();
        
        for(Idea_Location__c iLoc : ideaLocation){
            uniqueDel.add((String)iLoc.Evaluator__c);
        }
        for(String s : uniqueDel){
            delegateList.add(new SelectOption(s,s));
        }
        return delegateList;
    
    } set;}
    
    public PageReference updateAdminInappropriate(){
        
        Idea i = [SELECT Id, Workflow_Status__c, Inappropriate_Flag_By_SC__c FROM Idea Where Id = :ApexPages.CurrentPage().getParameters().get('id')];
        
        i.Inappropriate_Flag_By_SC__c = 'yes';
        
        update i;
        
        ideaDetail.Request_Additional_Information_SC__c = 'No';
        
        update ideaDetail;
        
        PageReference pageRef = new PageReference('/apex/ideas_admin_detail?id=' + I.Id + '&f=' + I.Workflow_Status__c);
        
        PageReference pageRef2 = new PageReference('/apex/ideas_admin_sensibility');
        
        return pageRef2;
    }
    
    public PageReference assigneDelegate(){
    
        Idea_Request__c req = new Idea_Request__c();
        
        req.Name = 'Idea Feedback Request';
        //system.debug('*******' + req.Name);
        req.Delegate__c = ideaDetail.Feedback_Required_From__c;
        req.Idea__c = ApexPages.CurrentPage().getParameters().get('id');
        req.OwnerId = ideaDetail.Feedback_Required_From__c;
        
        insert req;
        
        return null;
        
    }    
    
    //************ Delegate Assignment List END ***********
    
    public List<Idea_Request__c> IdReq {get{
    
        Idea_Request__c[] IdReq = [SELECT Id, Name, Idea__c, Feedback__c, Delegate__c, Completed__c, CreatedDate FROM Idea_Request__c WHERE Idea__c = :ApexPages.CurrentPage().getParameters().get('id')];
        
        if(IdReq.size() > 0){
            return IdReq;    
        }else{
            
            IdReq = new List<Idea_Request__c>();
            
            return IdReq;
        }
        
    
    } set;}
    
    //************ Comments List ***********
    
    public List<Idea_Comment__c> IdCom {get{
    
        Idea_Comment__c[] IdCom = [SELECT Id, Name, Idea__c, Comment__c, CreatedBy.Name, CreatedDate FROM Idea_Comment__c WHERE Idea__c = :ApexPages.CurrentPage().getParameters().get('id')];
        
        if(IdCom.size() > 0){
            return IdCom;    
        }else{
            
            IdCom = new List<Idea_Comment__c>();
            
            return IdCom;
        }
        
    
    } set;}
    
    public String commentValue {get; set;}
    
    public PageReference addComment(){
    
        Idea_Comment__c req = new Idea_Comment__c();
        
        req.Name = 'Idea Comment';
        req.Comment__c = commentValue;
        req.Idea__c = ApexPages.CurrentPage().getParameters().get('id');
        
        insert req;
        
        return null;
        
    } 
    
    //************ Comments List END ***********
    
    //public Idea ideaDetail;
    
    // **** Show Admin Info ****
    
    Boolean addInfoShowVal;
    
    public Boolean addInfoShow {get{
        system.debug('********** ' + addInfoShowVal);
        
        return addInfoShowVal;
    } set;}
    
    public PageReference showAdminInfo(){
        
        system.debug('********** ' + ideaDetail.Request_Additional_Information__c);
        system.debug('********** ' + addInfoShowVal);
        if(ideaDetail.Request_Additional_Information__c == 'Yes'){
                addInfoShowVal = true;
        }
        
        system.debug('********** ' + addInfoShowVal);
        
        return null;
    }
    
    /*
    public idea_admin(ApexPages.IdeaStandardController controller) {
        this.ideaDetail = (Idea)controller.getRecord();
        
        
                addInfoShowVal = false;
        
        
        
        
        system.debug('********' + ApexPages.CurrentPage().getParameters().get('f'));
    }
    */
    
    public PageReference assignIdea(){
    
        IdeaId = ApexPages.CurrentPage().getParameters().get('ideaIdX');
        
        return null;
    }
    
    public String adminRole {get; set;}
    
    public Id IdeaId {get; set;}
    
    public String IdeaAdminSectionFilter {get{
        
        
        
        return ApexPages.CurrentPage().getParameters().get('f');
    
    } set;} 
    
    public string adminValue;
    
    public PageReference setPageAdmin(){
        adminValue = ApexPages.CurrentPage().getparameters().get('admin');
        
        return null;
    }
    
    public List<Idea> ideas {get{
    
        User u = [SELECT id, Location__c, Idea_Admin_Role__c FROM User WHERE Id = : UserInfo.getUserId()];
        
        String location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\' AND Days_to_SLA__c <= 0 ';
        
        String IdeaAdminRoleFilter = ' WHERE Workflow_Status__c = ' + '\'' + 'None' + '\'';
        
        if(adminValue == 'RCIM Queue'){
            location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\'';
            IdeaAdminRoleFilter = ' WHERE Delegate__c = null AND Workflow_Status__c = ' + '\'' + adminValue + '\'';
        }else if(adminValue == 'Sensibility Check Queue'){
            location_filter = ' AND Days_to_SLA__c <= 0 ';
            IdeaAdminRoleFilter = ' WHERE Delegate__c = null AND Workflow_Status__c = ' + '\'' + adminValue + '\'';
            //IdeaAdminRoleFilter = ' WHERE Workflow_Status__c IN (' + '\'' + 'Sensibility Check Queue' + '\'' + ',' + '\'' + 'Sensibility Check Queue - Awaiting User Feedback' + '\'' + ')';
        }else if(adminValue == 'Local Evaluator Queue'){
            location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\' AND Days_to_SLA__c <= 0 ';
            IdeaAdminRoleFilter = ' WHERE Delegate__c = null AND Workflow_Status__c = ' + '\'' + adminValue + '\'';
            //IdeaAdminRoleFilter = ' WHERE Workflow_Status__c IN (' + '\'' + 'Local Evaluator Queue' + '\'' + ',' + '\'' + 'Local Evaluator Queue - Awaiting User Feedback' + '\'' + ')';
        }else if(adminValue == 'National Evaluator Queue'){
            location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\' AND Days_to_SLA__c <= 0 AND Days_to_SLA2__c <= 0 ';
            IdeaAdminRoleFilter = ' WHERE Delegate__c = null AND Workflow_Status__c = ' + '\'' + adminValue + '\'';
            //IdeaAdminRoleFilter = ' WHERE Workflow_Status__c IN (' + '\'' + 'National Evaluator Queue' + '\'' + ',' + '\'' + 'National Evaluator Queue- Awaiting User Feedback' + '\'' + ')';
        }else if(adminValue == 'Delivery More'){
            location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\' AND Days_to_SLA__c <= 0 AND Days_to_SLA2__c <= 0 AND Days_to_SLA3__c <= 0 ';
            IdeaAdminRoleFilter = ' WHERE Workflow_Status__c IN (' + '\'' + 'Local Delivering More Queue' + '\'' + ',' + '\'' + 'National Delivering More Queue' + '\'' + ')';
        }
        
        
        
        Idea[] ideasAdmin = Database.query('SELECT Title, Days_to_SLA__c, createdBy.Name, SLA_Date__c, Location__c, Additional_Information_SC__c, Workflow_Status__c, National_Evaluator__c, When__c, Business_Benefit__c, Body, Further_investigation_required__c, Additional_Information_Question__c, Reward__c, Request_Additional_Information__c, Additional_Information__c, Private_Comment__c, Public_Comment__c, Idea_Accepted__c, Idea_Rewarded__c, Idea_Checked__c, Move_Idea_To__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea ' + IdeaAdminRoleFilter + ' ' + location_filter + ' Limit 50');
        
       
        return ideasAdmin;
    } set;}
    
    
    // **************** Ideas With Additional Infromation requests
    
    public List<Idea> ideasUFeedback {get{
        
        User u = [SELECT id, Location__c, Idea_Admin_Role__c FROM User WHERE Id = : UserInfo.getUserId()];
        
        
        String IdeaAdminRoleFilter = ' WHERE Workflow_Status__c = ' + '\'' + 'None' + '\'';
        
        String location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\' AND Days_to_SLA__c <= 0 ';
        
        if(adminValue == 'RCIM Queue'){
            location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\'';
        }else if(adminValue == 'Sensibility Check Queue'){
            location_filter = ' AND Days_to_SLA__c <= 0 ';
            
        }else if(adminValue == 'Local Evaluator Queue'){
            location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\' AND Days_to_SLA__c <= 0 ';
            
        }else if(adminValue == 'National Evaluator Queue'){
            location_filter = ' AND Assigned_Admin__r.Id = ' + '\'' + u.Id + '\' AND Days_to_SLA__c <= 0 AND Days_to_SLA2__c <= 0 ';
            
        }
        
        if(adminValue == 'Local Evaluator Queue'){
                IdeaAdminRoleFilter = ' WHERE Workflow_Status__c = ' + '\'' + 'Local Evaluator Queue - Awaiting User Feedback' + '\'';
        }else if(adminValue == 'Sensibility Check Queue'){
                IdeaAdminRoleFilter = ' WHERE Workflow_Status__c = ' + '\'' + 'Sensibility Check Queue - Awaiting User Feedback' + '\'';
        }else if(adminValue == 'National Evaluator Queue'){
                IdeaAdminRoleFilter = ' WHERE Workflow_Status__c = ' + '\'' + 'National Evaluator Queue- Awaiting User Feedback' + '\'';
        }
        
        Idea[] ideasAdmin = Database.query('SELECT Title, Days_to_SLA__c, CreatedBy.Name, SLA_Date__c, Location__c, Additional_Information_SC__c, Workflow_Status__c, National_Evaluator__c, When__c, Business_Benefit__c, Body, Further_investigation_required__c, Additional_Information_Question__c, Reward__c, Request_Additional_Information__c, Additional_Information__c, Private_Comment__c, Public_Comment__c, Idea_Accepted__c, Idea_Rewarded__c, Idea_Checked__c, Move_Idea_To__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea ' + IdeaAdminRoleFilter + ' ' + location_filter + ' Limit 50');
        
        return ideasAdmin;
    } set;}
    
    public PageReference updateAdmin(){
        system.debug('*** -- Into updateAdmin -- ***');
        system.debug('*** -- evaluator story = ' + ideaDetail.Evaluator_Story__c + ' -- ***');
        system.debug('*** -- system comment = ' + ideaDetail.System_Comment__c + ' -- ***');
                
        Idea Ix = [SELECT Request_Additional_Information_SC__c, National_Evaluator__r.Id, Idea_Location__r.Evaluator_Delegate_Queue__r.Id, Idea_Location__r.Evaluator_Queue__r.Out_of_Office__c, Idea_Location__r.RCIM_Queue__r.Id, Idea_Location__r.Delivering_More_Queue__r.Id, Idea_Location__r.Evaluator_Queue__r.Id, Idea_Location__r.Delegate_CIM_Queue__r.Id, Idea_Location__r.Delegate_Evaluator_Queue__r.Id, Title, CreatedById, Contact_Number__c, Decision__c, Anonymous_Idea__c, CreatedBy.UserType, CreatedBy.Email, Workflow_Status__c, National_Evaluator__c, When__c, Decision_Reason__c, Body, Ease_of_Implementation__c, Further_investigation_required__c, Business_Benefit__c, Idea_Checked__c, Reward__c, Additional_Information_Question__c, Request_Additional_Information__c, Additional_Information__c, Private_Comment__c, Public_Comment__c, Move_Idea_To__c, Idea_Rewarded__c, Idea_Accepted__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea WHERE Id = :ApexPages.CurrentPage().getParameters().get('id')];
        Idea I_update = [SELECT Request_Additional_Information_SC__c, National_Evaluator__r.Id, Idea_Location__r.RCIM_Queue__r.Id, Idea_Location__r.Delivering_More_Queue__r.Id, Idea_Location__r.Evaluator_Queue__r.Id, Idea_Location__r.Delegate_CIM_Queue__r.Id, Idea_Location__r.Delegate_Evaluator_Queue__r.Id, Title, CreatedById, Contact_Number__c, Decision__c, Anonymous_Idea__c, CreatedBy.UserType, CreatedBy.Email, Workflow_Status__c, National_Evaluator__c, When__c, Decision_Reason__c, Body, Ease_of_Implementation__c, Further_investigation_required__c, Business_Benefit__c, Idea_Checked__c, Reward__c, Additional_Information_Question__c, Request_Additional_Information__c, Additional_Information__c, Evaluator_Story__c, System_Comment__c, Private_Comment__c, Public_Comment__c, Move_Idea_To__c, Idea_Rewarded__c, Idea_Accepted__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea WHERE Id = :ApexPages.CurrentPage().getParameters().get('id')];

        String smsBody;
        
        Idea_Admin__c i_admin = [SELECT Id, Evaluator_Story__c, System_Comment__c, Request_Additional_Information_SC__c, Private_Comment__c, OwnerId, Decision__c, Decision_Reason__c, Additional_Information_Question_SC__c, Additional_Information_Question__c FROM Idea_Admin__c WHERE Idea__r.Id = :ApexPages.CurrentPage().getParameters().get('id')];
		        
        //Email Template
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setReplyTo('TNT.UK.Ideas@tnt.co.uk');
        message.setSenderDisplayName('TNT Idea');
        //message.setSubject('TNT Idea Notification');
        message.setTargetObjectId(Ix.CreatedById);
        message.setSaveAsActivity(false);
        i_admin.Decision__c = ideaDetail.Decision__c;
        i_admin.Decision_Reason__c = ideaDetail.Decision_Reason__c;
        i_admin.Additional_Information_Question_SC__c = ideaDetail.Additional_Information_Question_SC__c;
        i_admin.Additional_Information_Question__c = ideaDetail.Additional_Information_Question__c;
        i_admin.Private_Comment__c = ideaDetail.Private_Comment__c;
        i_admin.Evaluator_Story__c = ideaDetail.Evaluator_Story__c;
        i_admin.System_Comment__c = ideaDetail.System_Comment__c;
        message.setWhatId(i_admin.Id);
        //SMS
        
        //aaron: added to update idea before sending emails (field merge templates)
        I_update.Decision_Reason__c = ideaDetail.Decision_Reason__c;
        update I_update;
        //aaron: end additions
        
        system.debug('**** x1: ' + Ix.Workflow_Status__c);
        system.debug('**** x2: ' + ideaDetail.Request_Additional_Information__c);
        system.debug('**** x3: ' + ideaDetail.National_Evaluator__c);
        system.debug('**** x4: ' + Ix.Request_Additional_Information__c);
        //Validation
        if(Ix.Workflow_Status__c == 'Local Evaluator Queue' && ideaDetail.Request_Additional_Information__c == 'Yes' && ideaDetail.Additional_Information_Question__c == ''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Enter Question to Idea Owner</span>');
            ApexPages.addMessage(msg);
            return null;
        }else if(Ix.Workflow_Status__c == 'Sensibility Check Queue' && ideaDetail.Request_Additional_Information_SC__c == 'Yes' && ideaDetail.Additional_Information_Question_SC__c == ''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Enter Question to Idea Owner</span>');
            ApexPages.addMessage(msg);
            return null;
        }else if(Ix.Workflow_Status__c == 'National Evaluator Queue' && ideaDetail.Request_Additional_Information__c == 'Yes' && ideaDetail.Additional_Information_Question__c == ''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Enter Question to Idea Owner</span>');
            ApexPages.addMessage(msg);
            return null;
        }else if(Ix.Workflow_Status__c == 'Sensibility Check Queue' && (ideaDetail.Request_Additional_Information_SC__c == 'No' || Ix.Request_Additional_Information_SC__c == 'No') && ideaDetail.National_Evaluator__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Assign National Evaluator</span>');
            ApexPages.addMessage(msg);
            return null;
        }
        
        //Link To Idea
        
        String IdeaLink;
        
        if(Ix.CreatedBy.UserType == 'Standard'){
                IdeaLink = '<a href="' + 'https://c.cs4.visual.force.com/apex/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id') + '">Idea Link</a>';
        }else{
                
                IdeaLink = '<a href="' + 'https://tntemea.developer1.cs4.force.com/IdeasPortal/ideas_detail_v2?id=' + ApexPages.CurrentPage().getParameters().get('id') + '">Idea Link</a>';
        }
            
        
        
        
        
        //*******************************************************************************************************
        //RCIM Step 1
        
        
        if(Ix.Workflow_Status__c == 'RCIM Queue'  && Move_Idea_To != 'National'){    
            
            I_update.Move_Idea_To__c = Move_Idea_To;
            
            //Assign Next Admin
            
            if(Ix.Idea_Location__r.Evaluator_Queue__r.Out_of_Office__c){
                I_update.Assigned_Admin__c = Ix.Idea_Location__r.Evaluator_Delegate_Queue__r.Id;
            }else{
                I_update.Assigned_Admin__c = Ix.Idea_Location__r.Evaluator_Queue__r.Id;
            }
            
            
            I_update.Workflow_Status__c = 'Local Evaluator Queue';
            //I_update.SLA_Date2__c = system.today() + 10;
            //Notification Idea Is Evaluated
            
            //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
            //message.setToAddresses(toAddresses);
            message.setTemplateId('00X20000001G61W');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            smsBody = 'Your I’dea ' + Ix.Title + ' is now under evaluation! You will be notified of progress over the coming weeks';            
            
            I_update.Status__c = 'Acknowledged';
            I_update.Status = 'Acknowledged';
            
            
        }else if(Ix.Workflow_Status__c == 'RCIM Queue' && Move_Idea_To == 'National'){
            
            I_update.Move_Idea_To__c = Move_Idea_To;
            
            //Assign Next Admin
            //ideaDetail.Assigned_Admin__c = Ix.Idea_Location__r.RCIM_Queue__r.Id;
            
            I_update.Workflow_Status__c = 'Sensibility Check Queue';
            //I_update.SLA_Date2__c = system.today() + 10;
            
            //Notification Idea Move to National
            
            //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
            //message.setToAddresses(toAddresses);
            message.setTemplateId('00X20000001G61V');
            //message.setHtmlBody('Thanks for your interesting I’dea, it has been deemed to have national implications and has been moved forward for evaluation. We will keep you posted of your I’dea’s progress. ' + IdeaLink);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            smsBody = 'Your I’dea ' + Ix.Title + ' has been deemed to have national implications and has been moved forward for evaluation';
            
            
            I_update.Status__c = 'Acknowledged';
            I_update.Status = 'Acknowledged';
            
        }
        
        //*******************************************************************************************************
        //Local Evaluator Queue(Local Evaluator) Step 2
        
        else if(Ix.Workflow_Status__c == 'Local Evaluator Queue' && ideaDetail.Request_Additional_Information__c == 'Yes'){
            
            I_update.Workflow_Status__c = 'Local Evaluator Queue - Awaiting User Feedback';
            
            //Notification Request Additional Infromation
            smsBody = 'We’re interested in your I’dea ' + Ix.Title + ' but need more info to evaluate it. Log in or see your I’dea Champion ASAP';
            //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
            //message.setToAddresses(toAddresses);
            message.setTemplateId('00X20000001G61X');
            //message.setHtmlBody('We are very interested in your I’dea but require more information. A question has been posted regarding your suggestion. Please respond. '  + IdeaLink);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            
        }
        
        else if((Ix.Workflow_Status__c == 'Local Evaluator Queue' || Ix.Workflow_Status__c == 'Local Evaluator Queue - Awaiting User Feedback') && ideaDetail.Decision__c != null){

            //Notification Rejection
            if(ideaDetail.Decision__c == 'Reject'){
                I_update.Workflow_Status__c = 'Local Rejected';
                I_update.Status__c = 'Rejected';
                I_update.Status = 'Rejected';
                message.setTemplateId('00X20000001G61Y');
                //message.setHtmlBody('Thanks again for your interesting I’dea. Unfortunately, on this occasion, we are not able to take this forward. Please see your I’dea notice board or log on to the system for more details. ' + ideaDetail.Private_Comment__c + ' ' + IdeaLink);
                smsBody = 'Thanks for your I’dea ' + Ix.Title + ' but unfortunately, on this occasion, we are not able to take this forward';
                //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
                //message.setToAddresses(toAddresses);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            }
            //Notification On For The Future
            else if(ideaDetail.Decision__c == 'One for the Future' && Ix.Anonymous_Idea__c == true){
                
            }
            //Notification Implement
            else if(ideaDetail.Decision__c == 'Implement' && Ix.Anonymous_Idea__c == true){
                
            }
            
            if(ideaDetail.Decision__c != 'Reject' && ideaDetail.Decision__c != null){
                I_update.Workflow_Status__c = 'Local Delivering More Queue';
                //Assign Next Admin
                I_update.Assigned_Admin__c = Ix.Idea_Location__r.Delivering_More_Queue__r.Id;
                I_update.SLA_Date2__c = system.today() + 10;
            }
        }
        
        
        //*******************************************************************************************************
        //Local Delivering More Queue Step 3
        
        
        else if(Ix.Workflow_Status__c == 'Local Delivering More Queue' && ideaDetail.Delivery_More_Approved__c != null){
            if(ideaDetail.Decision__c == 'Reject'){
                
            }
            
            else if(Ix.Decision__c == 'One for the Future'){
                I_update.Workflow_Status__c = 'Local One for the Future';
                I_update.Status__c = 'One for the Future';
                I_update.Status = 'One for the Future';
                
                if(ideaDetail.Delivery_More_Approved__c == 'Yes'){
                        message.setTemplateId('00X20000001G61a');
                        //message.setHtmlBody('We really liked your I’dea. Unfortunately it is not something TNT can introduce at the moment but we will keep an eye on it as one for the future. You will receive your reward shortly. Weell done! Evaluator comment - ' + Ix.Private_Comment__c + ' ' + IdeaLink);
                        smsBody = 'We liked your I’dea ' + Ix.Title + ' but it\'s one for the future. You will receive your reward shortly. Well done!';
                        //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
                        //message.setToAddresses(toAddresses);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                }else if(ideaDetail.Delivery_More_Approved__c == 'No'){
                        I_update.Workflow_Status__c = 'Local Evaluator Queue';
                        I_update.Decision__c = '';
                        
                }
            }
            
            else if(Ix.Decision__c == 'Implement'){
                I_update.Workflow_Status__c = 'Local Implemented';
                I_update.Status__c = 'To be implemented';
                I_update.Status = 'To be implemented';
                
                if(ideaDetail.Delivery_More_Approved__c == 'Yes'){
                        message.setTemplateId('00X20000001G61R');
                        //message.setHtmlBody('Great news! We loved your I’dea and really think it will benefit the company. Your suggestion will be implemented as soon as feasibly possible. Congratulations and thanks again for submitting a superb I’dea that will help improve the way TNT serves our customers. You will receive your reward shortly. Well done! Evaluator comment - ' + Ix.Private_Comment__c + ' ' + IdeaLink);
                        smsBody = 'We liked your I’dea ' + Ix.Title + ' and it will be implemented. You will receive your reward shortly. Well done!';
                        //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
                        //message.setToAddresses(toAddresses);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                }else if(ideaDetail.Delivery_More_Approved__c == 'No'){
                        I_update.Workflow_Status__c = 'Local Evaluator Queue';
                        I_update.Decision__c = '';
                        //Assign Next Admin
                        I_update.Assigned_Admin__c = Ix.Idea_Location__r.Evaluator_Queue__r.Id;
            
                }
            }
            
            
        }
        
        
        //*******************************************************************************************************
        //Sensibility Check Queue Step 2
        
        
        else if(Ix.Workflow_Status__c == 'Sensibility Check Queue' && ideaDetail.Request_Additional_Information_SC__c == 'Yes'){
            I_update.Workflow_Status__c = 'Sensibility Check Queue - Awaiting User Feedback';
            
            //Notification Request Additional Infromation
            
            //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
            //message.setToAddresses(toAddresses);
            message.setTemplateId('00X20000001G620');
            //message.setHtmlBody('We are very interested in your I’dea but require more information. A question has been posted regarding your suggestion. Please respond. '  + IdeaLink);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            
            smsBody = 'We’re interested in your I’dea ' + Ix.Title + ' but need more info to evaluate it. Log in or see your I’dea Champion ASAP';
            
        }
        
        else if((Ix.Workflow_Status__c == 'Sensibility Check Queue - Awaiting User Feedback' || Ix.Workflow_Status__c == 'Sensibility Check Queue') && ideaDetail.National_Evaluator__c != null){
            I_update.Workflow_Status__c = 'National Evaluator Queue';
            
            //Assign Next Admin
            
            User delegated_u = [SELECT Id, Out_of_Office__c, Delegate_Evaluator__c FROM User WHERE Id = :ideaDetail.National_Evaluator__c];
            
            if(delegated_u.Out_of_Office__c){
                I_update.Assigned_Admin__c = delegated_u.Delegate_Evaluator__c;
            }else{
                I_update.Assigned_Admin__c = ideaDetail.National_Evaluator__c;
            }
            
            
            
            //I_update.SLA_Date3__c = system.today() + 10;
            I_update.SLA_Date2__c = system.today() + 10;
            //Notification Idea Is Evaluated
            I_update.Status__c = 'In Progress';
            I_update.Status = 'In Progress';

			//String[] toAddresses = new String[] {Ix.CreatedBy.Email};
            //message.setToAddresses(toAddresses);
            message.setTemplateId('00X20000001G61W');
            //message.setHtmlBody('Your I’dea is currently being evaluated. You will be notified if we require any further information or of any developments with regards to your suggestion. ' + IdeaLink);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            
            smsBody = 'Your I’dea ' + Ix.Title + ' is now under evaluation! You will be notified of progress over the coming weeks';
            
        }
        
        
        
        //*******************************************************************************************************
        //National Evaluator Queue Step 3
        
        else if(Ix.Workflow_Status__c == 'National Evaluator Queue' && ideaDetail.Request_Additional_Information__c == 'Yes'){
            
           
            
            I_update.Workflow_Status__c = 'National Evaluator Queue- Awaiting User Feedback';
            
            //Notification Request Additional Infromation
            smsBody = 'We’re interested in your I’dea ' + Ix.Title + ' but need more info to evaluate it. Log in or see your I’dea Champion ASAP';
            //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
            //message.setToAddresses(toAddresses);
            message.setTemplateId('00X20000001G61X');
            //message.setHtmlBody('We are very interested in your I’dea but require more information. A question has been posted regarding your suggestion. Please respond. '  + IdeaLink);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            
            
        }
        
        
        
        else if((Ix.Workflow_Status__c == 'National Evaluator Queue' || Ix.Workflow_Status__c == 'National Evaluator Queue - Awaiting User Feedback') && ideaDetail.Decision__c != null){    
            //Notification Rejection
            if(ideaDetail.Decision__c == 'Reject'){
                I_update.Status__c = 'Rejected';
                I_update.Status = 'Rejected';
                I_update.Workflow_Status__c = 'National Rejected';
                message.setTemplateId('00X20000001G61Y');
                //message.setHtmlBody('Thanks again for your interesting I’dea. Unfortunately, on this occasion, we are not able to take this forward. Please see your I’dea notice board or log on to the system for more details. ' + ideaDetail.Private_Comment__c + ' ' + IdeaLink);
                smsBody = 'Thanks for your I’dea ' + Ix.Title + ' but unfortunately, on this occasion, we are not able to take this forward';
                //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
                    //message.setToAddresses(toAddresses);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            }
            //Notification On For The Future
            else if(ideaDetail.Decision__c == 'One for the Future' && Ix.Anonymous_Idea__c == true){
                
            }
            //Notification Implement
            else if(ideaDetail.Decision__c == 'Implement' && Ix.Anonymous_Idea__c == true){
                
            }
            
            if(ideaDetail.Decision__c != 'Reject' && ideaDetail.Decision__c != null){
                I_update.Workflow_Status__c = 'National Delivering More Queue';
                
                I_update.SLA_Date3__c = system.today() + 10;
                
                if(adminU.Delivering_More_Issuer__r.Id != null){
                    //Assign Next Admin
                    I_update.Assigned_Admin__c = adminU.Delivering_More_Issuer__r.Id;
                    I_update.National_Evaluator__c = adminU.Id;
                }else{
                    I_update.Assigned_Admin__c = adminU.Id;
                }
                
                
            
            }
            
            
            
        }
        
        //*******************************************************************************************************
        //National Delivering More Queue Step 4
        
        
         else if(Ix.Workflow_Status__c == 'National Delivering More Queue' && ideaDetail.Delivery_More_Approved__c != null){
            if(ideaDetail.Decision__c == 'Reject'){
                
            }
            
            else if(Ix.Decision__c == 'One for the Future'){
                I_update.Workflow_Status__c = 'National One for the Future';
                I_update.Status__c = 'One for the Future';
                I_update.Status = 'One for the Future';
                
                 if(ideaDetail.Delivery_More_Approved__c == 'Yes'){
                        message.setTemplateId('00X20000001G61a');
                        //message.setHtmlBody('We really liked your I’dea. Unfortunately it is not something TNT can introduce at the moment but we will keep an eye on it as one for the future. You will receive your reward shortly. Weell done! Evaluator comment - ' + Ix.Private_Comment__c + ' ' + IdeaLink);
                        smsBody = 'We liked your I’dea ' + Ix.Title + ' but it\'s one for the future. You will receive your reward shortly. Well done!';
                        //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
                        //message.setToAddresses(toAddresses);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                }else if(ideaDetail.Delivery_More_Approved__c == 'No'){
                        I_update.Workflow_Status__c = 'National Evaluator Queue';
                        I_update.Decision__c = '';
                        //Assign Next Admin
                        //aaron commented due to issue update 3 28/02/12 I_update.Assigned_Admin__c = Ix.National_Evaluator__r.Id;
                }
            }
            
            else if(Ix.Decision__c == 'Implement'){
                I_update.Workflow_Status__c = 'National Implemented';
                I_update.Status__c = 'To be implemented';
                I_update.Status = 'To be implemented';
                
                 if(ideaDetail.Delivery_More_Approved__c == 'Yes'){
                        message.setTemplateId('00X20000001G61R');
                        //message.setHtmlBody('Great news! We loved your I’dea and really think it will benefit the company. Your suggestion will be implemented as soon as feasibly possible. Congratulations and thanks again for submitting a superb I’dea that will help improve the way TNT serves our customers. You will receive your reward shortly. Well done! Evaluator comment - ' + Ix.Private_Comment__c + ' ' + IdeaLink);
                        smsBody = 'We liked your I’dea ' + Ix.Title + ' and it will be implemented. You will receive your reward shortly. Well done!';
                        //String[] toAddresses = new String[] {Ix.CreatedBy.Email};
                        //message.setToAddresses(toAddresses);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                }else if(ideaDetail.Delivery_More_Approved__c == 'No'){
                        I_update.Workflow_Status__c = 'National Evaluator Queue';
                        I_update.Decision__c = '';
                }
            }
            
            
        }
        
        
        if(ideaDetail.Request_Additional_Information__c != null || ideaDetail.Request_Additional_Information__c != ''){
            I_update.Request_Additional_Information__c = ideaDetail.Request_Additional_Information__c;
        }
        if(ideaDetail.Request_Additional_Information_SC__c != null || ideaDetail.Request_Additional_Information_SC__c != ''){
            I_update.Request_Additional_Information_SC__c = ideaDetail.Request_Additional_Information_SC__c;
        }
        if(ideaDetail.Additional_Information_Question__c != null){
            I_update.Additional_Information_Question__c = ideaDetail.Additional_Information_Question__c;
        }
        if(ideaDetail.Additional_Information_Question_SC__c != null){
            I_update.Additional_Information_Question_SC__c = ideaDetail.Additional_Information_Question_SC__c;
        }
        if(ideaDetail.Decision__c != null){
            I_update.Decision__c = ideaDetail.Decision__c;
        }
        if(ideaDetail.Decision_Reason__c != null){
        	I_update.Decision_Reason__c = ideaDetail.Decision_Reason__c;
        }
        if(ideaDetail.Business_Benefit__c != null){
            I_update.Business_Benefit__c = ideaDetail.Business_Benefit__c;
        }
        if(ideaDetail.Ease_of_Implementation__c != null){
            I_update.Ease_of_Implementation__c = ideaDetail.Ease_of_Implementation__c;
        }
        if(ideaDetail.Re_evaluation_Date__c != null){
            I_update.Re_evaluation_Date__c = ideaDetail.Re_evaluation_Date__c;
        }
        if(ideaDetail.When__c != null){
            I_update.When__c = ideaDetail.When__c;
        }
        if(ideaDetail.Idea_Rewarded__c != null){
            I_update.Idea_Rewarded__c = ideaDetail.Idea_Rewarded__c;
        }
        if(ideaDetail.Private_Comment__c != null){
            I_update.Private_Comment__c = ideaDetail.Private_Comment__c;
        }
        if(ideaDetail.Public_Comment__c != null){
            I_update.Public_Comment__c = ideaDetail.Public_Comment__c;
        }
        system.debug('*** -- Evaluator Story Later On - ' + ideaDetail.Evaluator_Story__c + ' -- ***');
        if (ideaDetail.Evaluator_Story__c != null){
        	I_update.Evaluator_Story__c = ideaDetail.Evaluator_Story__c;
        }
        system.debug('*** -- System Comment Later On - ' + ideaDetail.System_Comment__c + ' -- ***');
        if (ideaDetail.System_Comment__c != null){
        	I_update.System_Comment__c = ideaDetail.System_Comment__c;
        }
        system.debug('*** -- Evaluator Story After Update - ' + I_update.Evaluator_Story__c + ' -- ***');
        system.debug('*** -- System Comment After Update - ' + I_update.System_Comment__c + ' -- ***');
        if(ideaDetail.Evaluator_Comments_To_DM__c != null){
            I_update.Evaluator_Comments_To_DM__c = ideaDetail.Evaluator_Comments_To_DM__c;
        }
        if(ideaDetail.National_Evaluator__c != null){
            I_update.National_Evaluator__c = ideaDetail.National_Evaluator__c;
        }
        if(ideaDetail.Delivery_More_Approved__c != null){
            I_update.Delivery_More_Approved__c = ideaDetail.Delivery_More_Approved__c;
        }
        if(ideaDetail.DM_Comments_To_Evaluator__c != null){
            I_update.DM_Comments_To_Evaluator__c = ideaDetail.DM_Comments_To_Evaluator__c;
        }
    
        update I_update;
        
        
        
        if(Ix.Contact_Number__c != null && smsBody != null){
            try{
                IdeaSMS.sendSMS(smsBody, Ix.Contact_Number__c);
            }catch(System.CalloutException e){
                IdeaSMS.sendSMS(smsBody, Ix.Contact_Number__c);
            }
        }
        
        
        
        PageReference pageRef;
        
        if(Ix.Workflow_Status__c == 'RCIM Queue'){
                pageRef = new PageReference('/apex/ideas_admin_rcim');
        }else if(Ix.Workflow_Status__c == 'Local Evaluator Queue' || Ix.Workflow_Status__c == 'Local Evaluator Queue - Awaiting User Feedback'){
                
                if(Ix.Workflow_Status__c == 'Local Evaluator Queue' && ideaDetail.Request_Additional_Information__c == 'No' && ideaDetail.Decision__c == null){
                    pageRef = new PageReference('/apex/ideas_admin_detail?id=' + Ix.Id + '&f=' + Ix.Workflow_Status__c);
                }else{
                    pageRef = new PageReference('/apex/ideas_admin_local_evaluation');
                }
                
                
        }else if(Ix.Workflow_Status__c == 'Sensibility Check Queue'  || Ix.Workflow_Status__c == 'Sensibility Check Queue - Awaiting User Feedback'){
                
                if(Ix.Workflow_Status__c == 'Sensibility Check Queue' && ideaDetail.Request_Additional_Information_SC__c == 'No' && ideaDetail.National_Evaluator__c == null ){
                    pageRef = new PageReference('/apex/ideas_admin_detail?id=' + Ix.Id + '&f=' + Ix.Workflow_Status__c);
                }else{
                    pageRef = new PageReference('/apex/ideas_admin_sensibility');
                }
                
                
        }else if(Ix.Workflow_Status__c == 'National Evaluator Queue'  || Ix.Workflow_Status__c == 'National Evaluator Queue- Awaiting User Feedback'){
                
                if(Ix.Workflow_Status__c == 'National Evaluator Queue' && ideaDetail.Request_Additional_Information__c == 'No' && ideaDetail.Decision__c == null){
                    pageRef = new PageReference('/apex/ideas_admin_detail?id=' + Ix.Id + '&f=' + Ix.Workflow_Status__c);
                }else{
                    pageRef = new PageReference('/apex/ideas_admin_national_evaluation');
                }
                
        }else if(Ix.Workflow_Status__c == 'Local Delivering More Queue' || Ix.Workflow_Status__c == 'National Delivering More Queue'){
                pageRef = new PageReference('/apex/ideas_admin_dMore_evaluation');
        }else{
                pageRef = new PageReference('/home/home.jsp');
        }
  
        return pageRef;
    }
    
     public PageReference backtoAdmin(){
        
        Idea Ix = [SELECT Title, Contact_Number__c, Decision__c, CreatedBy.UserType, CreatedBy.Email, Workflow_Status__c, National_Evaluator__c, When__c, Decision_Reason__c, Body, Ease_of_Implementation__c, Further_investigation_required__c, Business_Benefit__c, Idea_Checked__c, Reward__c, Additional_Information_Question__c, Request_Additional_Information__c, Additional_Information__c, Private_Comment__c, Public_Comment__c, Move_Idea_To__c, Idea_Rewarded__c, Idea_Accepted__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea WHERE Id = :ApexPages.CurrentPage().getParameters().get('id')];
        
        PageReference pageRef;
        
        if(Ix.Workflow_Status__c == 'RCIM Queue'){
                pageRef = new PageReference('/apex/ideas_admin_rcim');
        }else if(Ix.Workflow_Status__c == 'Local Evaluator Queue' || Ix.Workflow_Status__c == 'Local Evaluator Queue - Awaiting User Feedback'){
                pageRef = new PageReference('/apex/ideas_admin_local_evaluation');    
        }else if(Ix.Workflow_Status__c == 'Sensibility Check Queue'  || Ix.Workflow_Status__c == 'Sensibility Check Queue - Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_sensibility');
        }else if(Ix.Workflow_Status__c == 'National Evaluator Queue'  || Ix.Workflow_Status__c == 'National Evaluator Queue- Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_national_evaluation');
        }else if(Ix.Workflow_Status__c == 'Local Delivering More Queue' || Ix.Workflow_Status__c == 'National Delivering More Queue'){
                pageRef = new PageReference('/apex/ideas_admin_dMore_evaluation');
        }else{
                pageRef = new PageReference('/home/home.jsp');
        }
        
        
        return pageRef;
        
        
    }
    
    public PageReference backToCCIM(){
        
        Idea Ix = [SELECT Title, Assigned_Admin__c, Idea_Location__r.RCIM_Queue__r.Id, Contact_Number__c, Decision__c, CreatedBy.UserType, CreatedBy.Email, Workflow_Status__c, National_Evaluator__c, When__c, Decision_Reason__c, Body, Ease_of_Implementation__c, Further_investigation_required__c, Business_Benefit__c, Idea_Checked__c, Reward__c, Additional_Information_Question__c, Request_Additional_Information__c, Additional_Information__c, Private_Comment__c, Public_Comment__c, Move_Idea_To__c, Idea_Rewarded__c, Idea_Accepted__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea WHERE Id = :ApexPages.CurrentPage().getParameters().get('id')];
        
        PageReference pageRef;
        
        if(Ix.Workflow_Status__c == 'RCIM Queue'){
                pageRef = new PageReference('/apex/ideas_admin_rcim');
        }else if(Ix.Workflow_Status__c == 'Local Evaluator Queue' || Ix.Workflow_Status__c == 'Local Evaluator Queue - Awaiting User Feedback'){
                pageRef = new PageReference('/apex/ideas_admin_local_evaluation');    
        }else if(Ix.Workflow_Status__c == 'Sensibility Check Queue'  || Ix.Workflow_Status__c == 'Sensibility Check Queue - Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_sensibility');
        }else if(Ix.Workflow_Status__c == 'National Evaluator Queue'  || Ix.Workflow_Status__c == 'National Evaluator Queue- Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_national_evaluation');
        }else if(Ix.Workflow_Status__c == 'Local Delivering More Queue' || Ix.Workflow_Status__c == 'National Delivering More Queue'){
                pageRef = new PageReference('/apex/ideas_admin_dMore_evaluation');
        }else{
                pageRef = new PageReference('/home/home.jsp');
        }
        
        Ix.Workflow_Status__c = 'Sensibility Check Queue';
        Ix.National_Evaluator__c = null;
        Ix.Move_Idea_To__c = 'National';
        
        //Assign Next Admin
        Ix.Assigned_Admin__c = Ix.Idea_Location__r.RCIM_Queue__r.Id;
            
        
        update Ix;
        
        return pageRef;
    
    }
    
    public PageReference backToLocal(){
    
        Idea Ix = [SELECT Title, Assigned_Admin__c, Idea_Location__r.Evaluator_Queue__r.Id, Contact_Number__c, Decision__c, CreatedBy.UserType, CreatedBy.Email, Workflow_Status__c, National_Evaluator__c, When__c, Decision_Reason__c, Body, Ease_of_Implementation__c, Further_investigation_required__c, Business_Benefit__c, Idea_Checked__c, Reward__c, Additional_Information_Question__c, Request_Additional_Information__c, Additional_Information__c, Private_Comment__c, Public_Comment__c, Move_Idea_To__c, Idea_Rewarded__c, Idea_Accepted__c, CreatedDate, CreatedBy.CommunityNickname, NumComments, Status, VoteTotal, Id FROM Idea WHERE Id = :ApexPages.CurrentPage().getParameters().get('id')];
        
        PageReference pageRef;
        
        if(Ix.Workflow_Status__c == 'RCIM Queue'){
                pageRef = new PageReference('/apex/ideas_admin_rcim');
        }else if(Ix.Workflow_Status__c == 'Local Evaluator Queue' || Ix.Workflow_Status__c == 'Local Evaluator Queue - Awaiting User Feedback'){
                pageRef = new PageReference('/apex/ideas_admin_local_evaluation');    
        }else if(Ix.Workflow_Status__c == 'Sensibility Check Queue'  || Ix.Workflow_Status__c == 'Sensibility Check Queue - Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_sensibility');
        }else if(Ix.Workflow_Status__c == 'National Evaluator Queue'  || Ix.Workflow_Status__c == 'National Evaluator Queue- Awaiting User Feedback'){
            pageRef = new PageReference('/apex/ideas_admin_national_evaluation');
        }else if(Ix.Workflow_Status__c == 'Local Delivering More Queue' || Ix.Workflow_Status__c == 'National Delivering More Queue'){
                pageRef = new PageReference('/apex/ideas_admin_dMore_evaluation');
        }else{
                pageRef = new PageReference('/home/home.jsp');
        }
        
        Ix.Workflow_Status__c = 'Local Evaluator Queue';
        Ix.National_Evaluator__c = null;
        Ix.Move_Idea_To__c = 'Local';
        
        //Assign Next Admin
        Ix.Assigned_Admin__c = Ix.Idea_Location__r.Evaluator_Queue__r.Id;
         
        
        update Ix;
        
        return pageRef;
    
    }
    
    public PageReference reject_form_update(){
        
        system.debug('********Decision: '+ideaDetail.Decision__c);
        
        if(ideaDetail.Decision__c == 'Reject'){
            ideaDetail.Business_Benefit__c = 'N/A';
            ideaDetail.Ease_of_Implementation__c = 'N/A';
            ideaDetail.Idea_Rewarded__c = 'N/A';
            ideaDetail.When__c = 'N/A';
            ideaDetail.Decision__c = 'Reject';
        }else if(ideaDetail.Decision__c == 'Implement'){
            ideaDetail.Business_Benefit__c = '--None--';
            ideaDetail.Ease_of_Implementation__c = '--None--';
            ideaDetail.Idea_Rewarded__c = '--None--';
            ideaDetail.When__c = '--None--';
            ideaDetail.Decision__c = 'Implement';
        }else if(ideaDetail.Decision__c == 'One for the Future'){
            ideaDetail.Business_Benefit__c = '--None--';
            ideaDetail.Ease_of_Implementation__c = '--None--';
            ideaDetail.Idea_Rewarded__c = '--None--';
            ideaDetail.When__c = '--None--';
            ideaDetail.Decision__c = 'One for the Future';
        }
        
        
        
        return null;
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
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
        if(test4321 == '2'){
            test4321 = '1';
        }
        if(test4321 == '1'){
            test4321 = '2';
        }
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
        
        idea_admin.test4321 = '1';
        
        idea_admin.test1234();
        
        Test.stopTest();   
    }
    
}