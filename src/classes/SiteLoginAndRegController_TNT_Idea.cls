global class SiteLoginAndRegController_TNT_Idea {
    
    //TnC Agree
    
    public Boolean tNcAgree {get; set;}
    public String tNcAgree2  {get; set;}
    
    // Show Join Now Step 2
    
    public Boolean jNow = false;
    
    public Boolean getJoinNowShow(){
    
        return jNow;
    
    }
    
    
    
    
    public Boolean renderMsg {get{
        
        Boolean getB = (ApexPages.CurrentPage().getParameters().get('cid') == null) ? true : false;
        
        return getB;
    
    } set;}
    
        
    //Login Part
    
    global String userNameL {get; set;}
    global String passWordL {get; set;}
    
    global PageReference login() {
            
            String startURL;
            
            if(ApexPages.currentPage().getParameters().get('id') != null){
                startURL = '/ukideas/ideas_detail_v2?id=' + ApexPages.currentPage().getParameters().get('id');
            }else if(ApexPages.currentPage().getParameters().get('r') != null){
                startURL = '/ukideas/ideas_report';
            }else{
                startURL = '/ukideas/ideas_test_v2?c=09a200000000gmn&sort=recent';
            }
            
            
            
            return site.login(userNameL, passWordL, startURL);
    }
    
    global SiteLoginAndRegController_TNT_Idea() {
    
        if(ApexPages.CurrentPage().getParameters().get('forgot') == 'yes'){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<div id="InfoMsg"><span style="color:red;">Please check your TNT email and follow the instructions to complete your registration</span></div> <br/>');
            ApexPages.addMessage(msg);
        }
        
        
    }
    
    
    //Registration Part
    
    private static Id PORTAL_ACCOUNT_ID = '0012000000mfGWy';
    
    public String username {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String location {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
     
    private boolean isValidPassword() {
        
        return password == confirmPassword;
    }
    private boolean isValidPasswordStrenght() {
        
        boolean pas = (password.length() >= 8 && ( password.contains('0') || password.contains('1') || password.contains('2') || password.contains('3') || password.contains('4') || password.contains('5') || password.contains('6') || password.contains('7') || password.contains('8') || password.contains('9') )) ? true :false;
        
        return pas;
    }
    
    private boolean isValidEmail() {
        
        
        Boolean valid = (email.contains('@tnt') || email.contains('@tNt') || email.contains('@tNT') || email.contains('@TNT') ||  email.contains('@TnT') ||  email.contains('@tNT')) ? true : false;
        
        return valid;
        
        
    }
    
    // Step 1 in Registration Process
    
    // Get Location
    public List<SelectOption> locationsForUpdate {get{
        
        List<SelectOption> locationsForUpdate = new List<SelectOption>();
        
        locationsForUpdate.add(new SelectOption('--Select--','--Select--'));
        
        Idea_Location__c[] loc = [SELECT Id, Location__c FROM Idea_Location__c ORDER BY Location__c ASC];
        
        for(Idea_Location__c l : loc){
            locationsForUpdate.add(new SelectOption(l.location__c,l.location__c));
        }
        
        
        return locationsForUpdate;
    
    } set;}
    
    public PageReference registerUser() {
        
        String testEmail = email; 
        
        User[] uCheck = [SELECT username, Id FROM User WHERE username = : testEmail];
        
        // it's okay if password is null - we'll send the user a random password in that case. Email Address Will be validated at this pint as well
        if(firstName == '' || lastName == '' || email == '') {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Enter Valid Personal Details</span>  <br/>');
                ApexPages.addMessage(msg);
                return null;
        }else if(!isValidPasswordStrenght()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">The password has to be at least 8 characters long and include at least one number.</span>  <br/>');
            ApexPages.addMessage(msg);
            return null;
        }else if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Passwords Don\'t Match</span>  <br/>');
            ApexPages.addMessage(msg);
            return null;
        }else if(!isValidEmail()) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Enter a Valid TNT Email Address</span>  <br/>');
                ApexPages.addMessage(msg);
                return null;
        }else if(uCheck.size() > 0){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Email Already In Use</span>  <br/>');
                ApexPages.addMessage(msg);
                return null;
        
        }else if(tNcAgree == false || tNcAgree == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:red;">Please agree to Terms and Condition before proceeding</span>  <br/>');
            ApexPages.addMessage(msg);
            return null;
        }
        
        
        Contact c = new Contact();
        
        c.FirstName = firstName;
        c.LastName = lastName;
        c.UserName__c = email;
        c.Reg_Password__c = password;
        c.Email = email;
        c.Location__c = location;
        insert c;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {email};
        message.setToAddresses(toAddresses);
        message.setReplyTo('TNT.UK.Ideas@tnt.co.uk');
        message.setSenderDisplayName('TNT Idea Registration');
        message.setSubject('Welcome to TNT I’dea!');
        message.setHtmlBody('<p>Dear ' + firstName +',</p><p>Welcome to TNT I’dea!</p><p>Thanks for registering to be a part of I’dea. Before you can log in, please click the link below to confirm your registration:</p><p><a href="https://tntemea.secure.force.com/ukideas/ideas_reg_confirm?cid=' + c.Id + '">Click here to confirm your registration</a></p><p>You will now be able to log in using your email and provided password, submit your own I’deas and collaborate with your colleagues from across the business.</p><p>Yours sincerely,</p><p>I’dea Administration Team</p>');
        //message.setHtmlBody('Thanks for registering to be a part of I’dea. Click ' + '<a href="https://tntemea.secure.force.com/ukideas/ideas_reg_confirm?cid=' + c.Id + '">here</a> to confirm your registration and proceed to submit your I’dea.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        
        
        jNow = true;
        
        
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, '<div id="InfoMsg"><span style="color:red;">Check your inbox to complete the registration process</span></div> <br/>');
        ApexPages.addMessage(msg);
        
        return null;
    }
    
    // Step 2 in Registration Process
    
    public PageReference registerUserComplete() {
        // it's okay if password is null - we'll send the user a random password in that case
        if(ApexPages.CurrentPage().getParameters().get('cid') != null){
            Contact c = [SELECT Id, FirstName, LastName, UserName__c, Reg_Password__c, Email, Location__c FROM Contact WHERE Id = : ApexPages.CurrentPage().getParameters().get('cid')];
            
            User u = new User();
            u.FirstName = c.FirstName;
            u.LastName = c.LastName;
            u.Username = c.UserName__c;
            u.Email = c.Email;
            u.Idea_Location__c = c.Location__c;
            u.CommunityNickname = c.FirstName + ' ' + c.LastName + ' ' + math.random();
            
            String accountId = PORTAL_ACCOUNT_ID;
    
            // lastName is a required field on user, but if it isn't specified, we'll default it to the username
            String userId = Site.createPortalUser(u, accountId, c.Reg_Password__c);
            system.debug('************ SITE USER');
            /*
            if (userId != null) { 
                if (c.Reg_Password__c != null && c.Reg_Password__c.length() > 1) {
                    String startURL = '/IdeasPortal/apex/ideas_login';
                    return Site.login(username, password, null);
                }
                else {
                    PageReference page = System.Page.SiteRegisterConfirm;
                    page.setRedirect(true);
                    return page;
                }
            }
            */
            PageReference pRef = new PageReference('/ukideas/ideas_login');
            
            return pRef;
            
        }
        
        return null;
    }
    
   global static testmethod void testSiteLoginController_TNT_Idea() {
            
            SiteLoginAndRegController_TNT_Idea tntLogin = new SiteLoginAndRegController_TNT_Idea();
            tntLogin.userNameL = 'test@tnt.com';
            tntLogin.passWordL = '123456789';
            
            system.assertEquals(tntLogin.login(),null);
            
    } 
    
    // Test method to bring this class's test coverage over the required 75%
    static testMethod void testRegistration() {
        SiteLoginAndRegController_TNT_Idea controller = new SiteLoginAndRegController_TNT_Idea();
        controller.username = 'test@tnt.com';
        controller.email = 'test@tnt.com';
        controller.firstName = 'test';
        controller.lastName = 'test';
        controller.location = 'test';
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd1234';
        controller.tNcAgree = true;
        controller.registerUser();
        
        controller.renderMsg = true;
        controller.locationsForUpdate = new List<SelectOption>();
        
        // error1
        controller.email = '';
        controller.firstName = '';
        controller.lastName = '';
        controller.registerUser();
        
        // error2
        controller.email = 'test.test@tnt.com';
        controller.firstName = 'test';
        controller.lastName = 'test';
        controller.password = 'abcd';
        controller.registerUser();
        
        // error3
        controller.email = 'test.test@tnt.com';
        controller.firstName = 'test';
        controller.lastName = 'test';
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd12345';
        controller.registerUser();
        
        // error4
        controller.email = 'test.test@tnt2.com';
        controller.firstName = 'test';
        controller.lastName = 'test';
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd1234';
        controller.registerUser();
        
        // error4
        controller.email = 'test.test@tnt.com';
        controller.firstName = 'test';
        controller.lastName = 'test';
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd1234';
        controller.tNcAgree = false;
        controller.registerUser();
        
        
        // registerUser will always return null when the page isn't accessed as a guest user
        
        Contact c = new Contact(FirstName = 'test', LastName = 'test', email = 'test@tnt.com', Location__c = 'test', Reg_Password__c = 'abcd1234',  userName__c = 'test@tnt.com');
        
        insert c;
        
        ApexPages.CurrentPage().getParameters().put('cid', c.id);
        
        controller.registerUserComplete();
        
        
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        
    }
}