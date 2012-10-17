trigger setSLA on FM_Incident__c (before Insert, before Update) 
{
    Map<String, FM_Service_Level__c> ruleMap = new Map<String, FM_Service_Level__c> ();
    Id fmTeamSupplierId;
    try{
        fmTeamSupplierId = [Select Id 
                              From FM_Supplier__c 
                             Where Name = 'TNT' ].Id;
    } catch (QueryException qe){}
    Set<Id> locationsInIncidents = new Set<Id>();
    Set<String> scopeInIncidents = new Set<String>();
    Set<String> priorityInIncidents = new Set<String>();
    
    for(FM_Incident__c incident : trigger.new){
        locationsInIncidents.add(incident.Location__c);
        scopeInIncidents.add(incident.Sub_Type__c);
        priorityInIncidents.add(incident.Priority__c);
    }
                             
    for(FM_Service_Level__c rule : [Select f.In_Hours_Ack_SLA_Secs__c, f.Supplier__c, f.Scope__c, f.Priority_Level__c, f.Primary_Contact__c, f.PO_Required__c, f.Location__c, f.Id, f.In_Hours_On_Site_SLA_Secs__c, f.Out_Hours_Ack_SLA_Secs__c, f.Out_Hours_On_Site_SLA_Secs__c, f.Business_Hours_In__c, f.Business_Hours_Out__c
                                       From FM_Service_Level__c f 
                                      Where Location__c IN: locationsInIncidents
                                        And Priority_Level__c IN: priorityInIncidents
                                        And Scope__c IN: scopeInIncidents]){
        ruleMap.put( rule.Location__c + '|' + rule.Scope__c + '|' + rule.Priority_Level__c, rule );
    }
    
    for(FM_Incident__c incident : trigger.new){
        if(ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c ) != null){
            if(trigger.isInsert){ // insert
                // set fields on Incident
                incident.Supplier__c = ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c +  '|' + incident.Priority__c).Supplier__c;
                incident.PO_Number_Required__c = ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c +  '|' + incident.Priority__c).PO_required__c;
                incident.Supplier_Contact__c = ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c +  '|' + incident.Priority__c).Primary_Contact__c;
            } else if(trigger.isUpdate){ // update
                // set SLA fields on Incident        
                incident.Supplier_Ack_SLA__c = ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).In_Hours_Ack_SLA_Secs__c;
                incident.Supplier_In_Hours_OnSite_SLA__c = ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).In_Hours_On_Site_SLA_Secs__c;                
                incident.Supplier_Out_Hours_Ack_SLA__c = ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Out_Hours_Ack_SLA_Secs__c;
                incident.Supplier_Out_Hours_OnSite_SLA__c = ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Out_Hours_On_Site_SLA_Secs__c;              
                if(incident.Retrieved_Time__c !=null && incident.Ack_Deadline_In__c==null && incident.Ack_Deadline_Out__c==null){
                    incident.Ack_Deadline_In__c = BusinessHours.add(ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Business_Hours_In__c, incident.Retrieved_Time__c , (ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).In_Hours_Ack_SLA_Secs__c * 1000).longValue());
                    //incident.Ack_Deadline_Out__c = BusinessHours.add(ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Business_Hours_Out__c, incident.Retrieved_Time__c , (ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Out_Hours_Ack_SLA_Secs__c * 1000).longValue());
                }
                if(incident.Acknowledgement_Date_Time__c !=null){
                    incident.On_Site_Deadline_In__c = BusinessHours.add(ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Business_Hours_In__c, incident.Acknowledgement_Date_Time__c , (ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).In_Hours_On_Site_SLA_Secs__c * 1000).longValue());
                    //incident.On_Site_Deadline_Out__c = BusinessHours.add(ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Business_Hours_Out__c, incident.Acknowledgement_Date_Time__c , (ruleMap.get(incident.Location__c + '|' + incident.Sub_Type__c + '|' + incident.Priority__c).Out_Hours_On_Site_SLA_Secs__c * 1000).longValue());
                }
            } 
        } else{
            if(fmTeamSupplierId != null){
                incident.Supplier__c = fmTeamSupplierId;
            } else{
                incident.addError('Please contact your system administrator. - No default Supplier found.');
            }
        }
    }
}