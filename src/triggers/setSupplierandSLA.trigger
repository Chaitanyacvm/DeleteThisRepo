trigger setSupplierandSLA on FM_Incident__c (before Insert) 
{
    Map<String, FM_Service_Level__c> ruleMap = new Map<String, FM_Service_Level__c> ();
    Id fmTeamSupplierId = [ Select Id 
                              From FM_Supplier__c 
                             Where Name = 'TNT' ].Id;
    for ( FM_Service_Level__c rule : [ Select f.SystemModstamp, f.Supplier__c, f.Business_Hours_In__c,f.Business_Hours_Out__c, f.Start_In_Hours__c, f.Scope__c, f.Priority_Level__c, f.Primary_Contact__c, f.PO_Required__c, f.OwnerId, f.Out_Hours_On_Site_SLA__c, f.Out_Hours_On_Site_SLA_Secs__c, f.Out_Hours_Acknowledgement_SLA__c, f.Out_Hours_Ack_SLA_Secs__c, f.Name, f.Location__c, f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.In_Hours_On_Site_SLA__c, f.In_Hours_On_Site_SLA_Secs__c, f.In_Hours_Acknowledgement_SLA__c, f.In_Hours_Ack_SLA_Secs__c, f.Id, f.End_In_Hours__c, f.CreatedDate, f.CreatedById, f.Contact_Number__c, f.Contact_Name__c 
                                         From FM_Service_Level__c f ] )
    {
        ruleMap.put( rule.Location__c + '|' + rule.Scope__c, rule );
    }
    
    for ( FM_Incident__c incident : trigger.new )
    {
        if ( ruleMap.get( incident.Location__c + '|' + incident.Type__c ) != null )
        {
            // create DateTime fields
            //Time startInHoursTime = Time.newInstance( ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Start_In_Hours__c.IntValue(), 0, 0, 0);
            //Time endInHoursTime = Time.newInstance( ruleMap.get( incident.Location__c + '|' + incident.Type__c ).End_In_Hours__c.IntValue(), 0, 0, 0);
            //DateTime startInHoursDateTime = DateTime.newInstance( System.Today(), startInHoursTime );
            //DateTime endInHoursDateTime = DateTime.newInstance( System.Today(), endInHoursTime );
            
            // set fields on Incident
            incident.Supplier__c = ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Supplier__c;
            incident.PO_Number_Required__c = ruleMap.get( incident.Location__c + '|' + incident.Type__c ).PO_required__c;
            incident.Supplier_Contact__c = ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Primary_Contact__c;
            
            /* set SLA fields on Incident
            // in hours
            incident.Supplier_Ack_SLA__c = ruleMap.get( incident.Location__c + '|' + incident.Type__c ).In_Hours_Ack_SLA_Secs__c;
            incident.Supplier_In_Hours_OnSite_SLA__c = ruleMap.get( incident.Location__c + '|' + incident.Type__c ).In_Hours_On_Site_SLA_Secs__c;
            // out of hours
            incident.Supplier_Out_Hours_Ack_SLA__c = ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Out_Hours_Ack_SLA_Secs__c;
            incident.Supplier_Out_Hours_OnSite_SLA__c = ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Out_Hours_On_Site_SLA_Secs__c;
            // times
            //incident.Supplier_Start_Time__c = startInHoursDateTime;
            //incident.Supplier_End_Time__c = endInHoursDateTime;
            
            //if (incident.Submitted_Time__c within BHin{
            incident.Ack_Deadline_In__c = BusinessHours.add(ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Business_Hours_In__c, incident.Submitted_Time__c , (ruleMap.get( incident.Location__c + '|' + incident.Type__c ).In_Hours_Ack_SLA_Secs__c * 1000).longValue());
            incident.Ack_Deadline_Out__c = BusinessHours.add(ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Business_Hours_Out__c, incident.Submitted_Time__c , (ruleMap.get( incident.Location__c + '|' + incident.Type__c ).Out_Hours_Ack_SLA_Secs__c * 1000).longValue());
            //}else{
            
            //}
            
            
            //System.Debug( startInHoursDateTime + '<' + System.Now() + '<' + endInHoursDateTime );
            //if ( System.Now() > startInHoursDateTime && System.Now() < endInHoursDateTime )
            //{
                // in hours
                incident.Supplier_Out_Hours__c = false;
            //}
            //else
            //{
                // out hours
                incident.Supplier_Out_Hours__c = true;
            //}*/
        }
        else
        {
            incident.Supplier__c = fmTeamSupplierId;
            //incident.addError('No rule found for this location and type.');
        }
    }
}