trigger IR_Order on IR_Order__c (after insert, after update, before insert, before update) {
    if (trigger.isBefore) {
        SET<Id> custIds = new SET<Id>();
        for (IR_Order__c thisOrder : trigger.new) {
            custIds.add(thisOrder.Customer__c);
        }
        
        MAP<Id, IR_Customer__c> customersMap = new MAP<Id, IR_Customer__c>([SELECT Id, Name, Email__c, Register_Only__c, Total_Cost__c FROM IR_Customer__c WHERE Id IN :custIds]);
        
        for (IR_Order__c thisOrder : trigger.new) {
            IR_Customer__c customer = customersMap.get(thisOrder.Customer__c);
            
            if (customer != null) {
                thisOrder.Customer_Email__c = customer.Email__c;
                customer.Register_Only__c = false;
                
                if (customer.Total_Cost__c == null) {
                    customer.Total_Cost__c = 0;
                }
                
                if (thisOrder.Total_Cost__c != null) {
                    customer.Total_Cost__c += thisOrder.Total_Cost__c;
                }
                
                if (trigger.isUpdate) {
                    IR_Order__c oldOrder = trigger.oldMap.get(thisOrder.Id);
                    
                    if (oldOrder != null && oldOrder.Total_Cost__c != null) {
                        customer.Total_Cost__c += oldOrder.Total_Cost__c;
                    }
                }
                
                customersMap.put(customer.Id, customer);
            }
            
            if (trigger.isUpdate) {
                if (thisOrder.All_Consignments_Booked__c == 'Yes') {
                    thisOrder.Order_Status__c = 'Complete';
                }
            }
        }
        
        update customersMap.values();
    } else if (trigger.isAfter) {
        SET<Id> orderIds = new SET<Id>();
        for (IR_Order__c thisOrder : trigger.new) {
            orderIds.add(thisOrder.Id);
        }
        
        LIST<IR_Consignment__c> consignments = [SELECT Id, Customer__c, Order_IR__c FROM IR_Consignment__c WHERE Order_IR__c IN :orderIds];
        for (IR_Consignment__c consignment : consignments) {
            consignment.Customer__c = trigger.newMap.get(consignment.Order_IR__c).Customer__c;
        }
        
        update consignments;
    }
}