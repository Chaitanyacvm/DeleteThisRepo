trigger idea_update_location_name on Idea_Location__c (before update, before insert) {
    
    for(Idea_Location__c loc : Trigger.new){
        loc.Location__c = loc.Location_Name__c;
    }
    
}