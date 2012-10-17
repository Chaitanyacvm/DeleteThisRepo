trigger FM_UpdateLocations on FM_Asset__c (before Insert) {

    Set<Id> assetLocations = new Set<Id>();
    Set<Id> assetLocationLevels = new Set<Id>();
    Set<Id> assetLocationRooms = new Set<Id>();
    Set<Id> assetLocationAreas = new Set<Id>();
    
    for (FM_Asset__c thisAsset : trigger.new ) {
        assetLocations.add(thisAsset.Location__c);
        assetLocationLevels.add(thisAsset.Location_Level__c);
        assetLocationRooms.add(thisAsset.Location_Room__c);
        assetLocationAreas.add(thisAsset.Location_Area__c);
    }
    
    MAP<Id, FM_Location__c> locations = new MAP<Id, FM_Location__c>([SELECT Id FROM FM_Location__c WHERE Id IN :assetLocations]);
    MAP<Id, FM_Location_level__c> levels = new MAP<Id, FM_Location_level__c>([SELECT Id, Location__c FROM FM_Location_level__c WHERE Id IN :assetLocationLevels]);
    MAP<Id, FM_Location_Room__c> rooms = new MAP<Id, FM_Location_Room__c>([SELECT Id, Location_Level__r.Location__c, Location_Level__c FROM FM_Location_Room__c WHERE Id IN :assetLocationRooms]);
    MAP<Id, FM_Location_Area__c> areas = new MAP<Id, FM_Location_Area__c>([SELECT Id, Location_Room__r.Location_Level__r.Location__c, Location_Room__r.Location_Level__c, Location_Room__c FROM FM_Location_Area__c WHERE Id IN :assetLocationAreas]);
    
    for (FM_Asset__c thisAsset : trigger.new) {
        if (thisAsset.Location_Area__c != null){
            if (thisAsset.Location_Room__c != null && thisAsset.Location_Room__c != areas.get(thisAsset.Location_Area__c).Location_Room__c){
                thisAsset.Location_Room__c.adderror('The room is not valid for the area selected. Please update all location fields with correct values.');}
            else {
                thisAsset.Location_Room__c = areas.get(thisAsset.Location_Area__c).Location_Room__c;}
                if (thisAsset.Location_Level__c != null && thisAsset.Location_Level__c != rooms.get(thisAsset.Location_Room__c).Location_Level__c){
                    thisAsset.Location_Level__c.adderror('The level is not valid for the area selected. Please update all location fields with correct values.');}
                else {
                thisAsset.Location_Level__c = areas.get(thisAsset.Location_Area__c).Location_Room__r.Location_Level__c;
                    if (thisAsset.Location__c != null && thisAsset.Location__c != areas.get(thisAsset.Location_Level__c).Location_Room__r.Location_Level__r.Location__c){
                        thisAsset.Location__c.adderror('The location is not valid for the area selected. Please update all location fields with correct values.');}
                    else {
                    thisAsset.Location__c = areas.get(thisAsset.Location_Area__c).Location_Room__r.Location_Level__r.Location__c;                
               }
            }
        }
        else if (thisAsset.Location_Room__c != null){           
            if (thisAsset.Location_Level__c != null && thisAsset.Location_Level__c != rooms.get(thisAsset.Location_Room__c).Location_Level__c){
                thisAsset.Location_Level__c.adderror('The level is not valid for the room selected. Please update all location fields with correct values.');}
            else {
            thisAsset.Location_Level__c = rooms.get(thisAsset.Location_Room__c).Location_Level__c;
                if (thisAsset.Location__c != null && thisAsset.Location__c != rooms.get(thisAsset.Location_Level__c).Location_Level__r.Location__c){
                    thisAsset.Location__c.adderror('The location is not valid for the room selected. Please update all location fields with correct values.');}
                else {
                thisAsset.Location__c = rooms.get(thisAsset.Location_Room__c).Location_Level__r.Location__c;                
               }
            }
        }
        else if (thisAsset.Location_Level__c != null){
                if (thisAsset.Location__c != null && thisAsset.Location__c != levels.get(thisAsset.Location_Level__c).Location__c){
                    thisAsset.Location__c.adderror('The location is not valid for the room selected. Please update all location fields with correct values.');}
                else {
                thisAsset.Location__c = levels.get(thisAsset.Location_Level__c).Location__c;                
               }
            
        }
   }
    
   /*for (FM_Asset__c thisAsset : trigger.new) {
        if (thisAsset.Location__c != null && thisAsset.Location_Level__c != null){
            FM_Location_Level__c mylevel = levels.get(thisAsset.Location_Level__c);
            if (mylevel.Location__c == thisAsset.Location__c ){
                FM_Location_Room__c myroom = rooms.get(thisAsset.Location_Room__c);
                    if (myroom.Location_Level__c == thisAsset.Location_Level__c){
                        FM_Location_Area__c myarea = areas.get(thisAsset.Location_Area__c);
                            if (myarea.Location_Room__c == thisAsset.Location_Room__c){
                                
                            }
                    }    
            }
        }
    }*/
}