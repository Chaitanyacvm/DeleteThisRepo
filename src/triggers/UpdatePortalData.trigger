trigger UpdatePortalData on Feedback__c (before insert, before update) {
 
public String id;
public User Mybo;

    for (Feedback__c a: trigger.new) 
    {
        if (a.Business_Owner__c != null) 
        {
            id = a.Business_Owner__c;
        }
    }
    
    List <User> temp;
    
    temp = [SELECT  ProfileId, PortalRole, Name, LastName, IsPortalEnabled, 
        Id, FirstName, ContactId FROM User WHERE contactid =:id Limit 1];
    
    if (temp.size() > 0)
     {
        MyBo = temp[0];
     }
     else
     {
         MyBo = null;
     }  
     
 
    for (Feedback__c fb : trigger.new) 
     {    
        if (Mybo != null && MyBo.contactid !=null && MyBO.contactid == fb.Business_Owner__c) 
        {
            fb.Portal_Business_Owner__c = true;  
        }
        else
        {
           fb.Portal_Business_Owner__c = false;   
        }
     }
       
}