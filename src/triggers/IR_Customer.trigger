trigger IR_Customer on IR_Customer__c (after insert, after update, before insert, before update) {
    if (trigger.isBefore) {
        LIST<Id> custIds = new LIST<Id>();
        for (IR_Customer__c customer : Trigger.New) {
            custIds.add(customer.Id);
        }
        
        MAP<Id, Boolean> hasOrdersMap = new MAP<Id, Boolean>();
        for (IR_Order__c order : [SELECT Id, Customer__c FROM IR_Order__c WHERE Customer__c IN :custIds]) {
            hasOrdersMap.put(order.Customer__c, true);
        }
        
        for (IR_Customer__c customer : Trigger.New) {
            customer.Country_Code__c = IR_Global_Class.getCountryCode(customer.Country__c);
            
            if (customer.Customer_Password__c == null) {
                customer.Customer_Password__c = IR_Global_Class.generatePassword();
            }
            
            if (hasOrdersMap.get(customer.Id) != null) {
                customer.Has_Consignments__c = hasOrdersMap.get(customer.Id);
            }
            
            //Set metrics
            if (customer.Registration_Status__c == 'Quote' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Quoted__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Awaiting Email Verification' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Verification_Email_Sent__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'In Sales Admin Queue' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Order_Placed__c = System.now();
                customer.Time_Entered_SA_Queue__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Accepted by Sales Admin' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Accepted_By_SA__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'In Customer Experience Queue' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Entered_CE_Queue__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Accepted by Customer Experience' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Accepted_By_CE__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'In Rates and Contacts Queue' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Entered_RC_Queue__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Booking Failed' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Booking_Completed__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Accepted by Rates and Contacts' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Accepted_By_RC__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Complete' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Booking_Completed__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'EInvoicing Registration Failed' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Booking_Completed__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Rejected' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Booking_Completed__c = System.now();
            }
            
            if (customer.Registration_Status__c == 'Customer to Re-Submit' && (trigger.isInsert || trigger.oldMap.get(customer.Id).Registration_Status__c != customer.Registration_Status__c)) {
                customer.Time_Booking_Completed__c = System.now();
            }
            
            if ((customer.Registration_Status__c != 'In Sales Admin Queue' && customer.Registration_Status__c != 'Accepted by Sales Admin') && (trigger.isUpdate && (trigger.oldMap.get(customer.Id).Registration_Status__c == 'In Sales Admin Queue' || trigger.oldMap.get(customer.Id).Registration_Status__c == 'Accepted by Sales Admin'))) {
            	customer.Time_Exited_SA_Stage__c = System.now();
            }
            
            if ((customer.Registration_Status__c != 'In Customer Experience Queue' && customer.Registration_Status__c != 'Accepted by Customer Experience') && (trigger.isUpdate && (trigger.oldMap.get(customer.Id).Registration_Status__c == 'In Customer Experience Queue' || trigger.oldMap.get(customer.Id).Registration_Status__c == 'Accepted by Customer Experience'))) {
            	customer.Time_Exited_CE_Stage__c = System.now();
            }
            
            if ((customer.Registration_Status__c != 'In Rates and Contacts Queue' && customer.Registration_Status__c != 'Accepted by Rates and Contacts') && (trigger.isUpdate && (trigger.oldMap.get(customer.Id).Registration_Status__c == 'In Rates and Contacts Queue' || trigger.oldMap.get(customer.Id).Registration_Status__c == 'Accepted by Rates and Contacts'))) {
            	customer.Time_Exited_RC_Stage__c = System.now();
            }
        }
        
    } else if (trigger.isAfter) {
        LIST<Id> custIds = new LIST<Id>();
        for (IR_Customer__c customer : Trigger.New) {
            custIds.add(customer.Id);
        }
        
        MAP<Id, IR_Order__c> ordersMap = new MAP<Id, IR_Order__c>([SELECT Id, Customer__r.Extended_Transit_Liability_Setting__c FROM IR_Order__c WHERE Customer__c IN :custIds]);
        
        LIST<IR_Consignment__c> consignments = new LIST<IR_Consignment__c>();
        for (IR_Consignment__c consignment : [SELECT Id, Order_IR__c FROM IR_Consignment__c WHERE Order_IR__c IN :ordersMap.keySet()]) {
            if (ordersMap.get(consignment.Order_IR__c) != null) {
                consignment.Account_ETL_Setting__c = ordersMap.get(consignment.Order_IR__c).Customer__r.Extended_Transit_Liability_Setting__c;
                System.debug('consignment.Account_ETL_Setting__c=' + consignment.Account_ETL_Setting__c);
                consignments.add(consignment);
            }
        }
        
        try {
            update consignments;
        } catch (Exception e) {
            System.debug(e);
        }
    }
}