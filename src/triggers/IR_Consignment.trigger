trigger IR_Consignment on IR_Consignment__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        LIST<Id> orderIds = new LIST<Id>();
        for (IR_Consignment__c consignment : Trigger.New) {
            orderIds.add(consignment.Order_IR__c);
        }
        
        MAP<Id, IR_Order__c> ordersMap = new MAP<Id, IR_Order__c>([SELECT Id, Customer__c FROM IR_Order__c WHERE Id IN :orderIds]);
        
        SET<Id> customerIds = new SET<Id>();
        for (IR_Order__c thisOrder : ordersMap.values()) {
            if (thisOrder.Customer__c != null) {
                customerIds.add(thisOrder.Customer__c);
            }
        }
        
        MAP<Id, IR_Customer__c> customersMap = new MAP<Id, IR_Customer__c>([SELECT Id, Ship_To_Country__c, Description_of_Goods__c, Service__c, Extended_Transit_Liability_Setting__c FROM IR_Customer__c WHERE Id IN :customerIds]);
        
        LIST<IR_Customer__c> updatedCustomers = new LIST<IR_Customer__c>();
        for (IR_Consignment__c consignment : Trigger.New) {
            consignment.From_Country_Code__c = IR_Global_Class.getCountryCode(consignment.From_Country__c);
            consignment.To_Country_Code__c = IR_Global_Class.getCountryCode(consignment.To_Country__c);
            
            if (IR_Global_Class.inEU(consignment.From_Country_Code__c)) {
                consignment.From_EU__c = true;
            } else {
                consignment.From_EU__c = false;
            }
            
            if (IR_Global_Class.inEU(consignment.To_Country_Code__c)) {
                consignment.To_EU__c = true;
            } else {
                consignment.To_EU__c = false;
            }
            
            IR_Order__c thisOrder = ordersMap.get(consignment.Order_IR__c);
            if (thisOrder != null) {
                if (thisOrder.Customer__c != null) {
                    IR_Customer__c thisCustomer = customersMap.get(thisOrder.Customer__c);
                    
                    if (thisCustomer != null) {
                        consignment.Account_ETL_Setting__c = thisCustomer.Extended_Transit_Liability_Setting__c;
                        consignment.Customer__c = thisCustomer.Id;
                        
                        thisCustomer.Ship_To_Country__c = consignment.To_Country__c;
                        thisCustomer.Description_of_Goods__c = consignment.Description_of_Goods__c;
                        thisCustomer.Service__c = consignment.Service__c;
                        thisCustomer.In_EU__c = (consignment.To_EU__c && consignment.From_EU__c);
                        updatedCustomers.add(thisCustomer);
                    }
                }
            }
        }
        
        update updatedCustomers;
    } else if (Trigger.isAfter) {/*
        LIST<Id> conIds = new LIST<Id>();
        LIST<IR_Package__c> packages = new LIST<IR_Package__c>();
        
        for (IR_Consignment__c consignment : trigger.new) {
            conIds.add(consignment.Id);
        }
        
        for (IR_Package__c aPackage : [SELECT Id, Name, Consignment_IR__c, Cube_Weight_Multiplier__c FROM IR_Package__c WHERE Consignment_IR__c IN :conIds LIMIT 1000]) {
            IR_Consignment__c consignment = Trigger.newMap.get(aPackage.Consignment_IR__c);
            
            if ((consignment.From_EU__c && consignment.To_EU__c) || consignment.Economy_Service__c == 'No') {
                aPackage.Cube_Weight_Multiplier__c = 250;
            } else {
                aPackage.Cube_Weight_Multiplier__c = 200;
            }
            
            packages.add(aPackage);
        }
        
        update packages;*/
    }
}