trigger IR_Customer_after_withdrawn on IR_Customer__c (after update) {        
if(Trigger.isAfter){
        Boolean valid = false;
        LIST<Id> custIds = new LIST<Id>();
        LIST<Note> notesList = new LIST<Note>();                   
        
        for (IR_Customer__c customer : Trigger.New) {
            if(!customer.Send_Sales_Email__c && customer.Registration_Status__c == 'Customer Withdrawn'){
                valid = true;           
                custIds.add(customer.Id);
            }
        }
            if(valid){
                LIST<IR_Customer__c> customers = new LIST<IR_Customer__c>();
                
                MAP<Id, IR_Customer__c> customerMap = new MAP<Id, IR_Customer__c>([SELECT Id, Registration_Status__c, Send_Sales_Email__c,Comments__c FROM IR_Customer__c WHERE Id IN :custIds]);        
                User uCom = [SELECT Communication_Email__c, Communication_Label__c FROM User WHERE userName = 'itr@tntemea.force.com' LIMIT 1];        
                
                for(IR_Customer__c cs : Trigger.New){

                    if(!customerMap.get(cs.Id).Send_Sales_Email__c && customerMap.get(cs.Id).Registration_Status__c == 'Customer Withdrawn'){ 
                        
                        Note notes = new Note();
                        notes.Title = 'Customer Experience Comments';
                        notes.Body = 'Customer did not complete registration';
                        notes.ParentId = cs.Id;                                                       
                        notesList.add(notes);                              
                        customerMap.get(cs.Id).Send_Sales_Email__c = true;                                                
                        customers.add(customerMap.get(cs.Id));
                        
                        try{
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                                
                            mail.setReplyTo(uCom.Communication_Email__c);
                            mail.setSenderDisplayName(uCom.Communication_Label__c);
                            
                            EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Sales_Team_Email_Int2'];
                            mail.setSaveAsActivity(false);                            

                            Group g = [Select g.Name, g.Id, (Select Id, GroupId, UserOrGroupId From GroupMembers) From Group g where g.Name = 'IR Sales Team'];
                            List<Id> usIds = new List<Id>();                            
                            for(GroupMember gm : g.GroupMembers){
                                usIds.add(gm.UserOrGroupId);
                            }
                            Integer i = 0;
                            Id firstUserId = usIds[0];
                            if(usIds.size()> 1){
                                usIds.remove(0);
                            }
                            String[] toAddresses = new String[usIds.size()+1];
                            for(User us :[Select u.Email From User u where Id IN :usIds]){
                                toAddresses[i] = us.Email;
                                i++;
                            }                             
                            toAddresses[i] = 'ukindoorsalescentralreports@tnt.co.uk';
                            mail.setToAddresses(toAddresses);
                            mail.setWhatId(cs.Id);
                            mail.setTargetObjectId(firstUserId);
                            mail.setTemplateId(et.Id);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                        }catch(Exception e){
                            valid = false;
                            system.debug('==>emialTrigger' + e);
                        }                        
                    }
                }
                try{              
                    if(notesList.size() > 0){
                        insert notesList;
                        update customers;   
                    }                                     
                }catch (Exception e){
                    System.debug('IR_CUSTOMER_AFTER_WITHDRAWN_TRIGG: ' +e);
                }      
          }
     }                     
}