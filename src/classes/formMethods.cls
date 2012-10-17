public class formMethods {
    public static Date nextReportDate(Id depotId, String formName) {
        Date lastFormDate;
        Date nextFormDate;
        //Id formRecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get(formName).getRecordTypeId();
        Form_Schedule__c schedule;
        
        try {
        	
        	//@Dinesh Acharya - Added due days to the select query to fetch the details
            schedule = [SELECT Start_Date__c, Form__c, Name, Id, Due_September__c, Due_October__c, Due_November__c, Due_May__c, Due_March__c, 
            Due_June__c, Due_July__c, Due_January__c, Due_February__c, Due_December__c, Due_August__c, Due_April__c, Due_Sunday__c, Due_Monday__c, 
            Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Depot__c, Schedule_Type__c 
            FROM Form_Schedule__c 
            WHERE Depot__c = :depotId AND Form__c = :formName ORDER BY Start_Date__c DESC LIMIT 1];
        } catch (Exception ex) {
            return null;
        }
        
        try {
            lastFormDate = [SELECT Date__c FROM Form__c WHERE Form_Name__c = :formName AND Depot__c = :depotId ORDER BY Date__c DESC LIMIT 1].Date__c;
        } catch (Exception ex) {
            System.debug(schedule.Start_Date__c);
            if (schedule.Start_Date__c <= System.Today()) {
                return schedule.Start_Date__c;
            } else {
                return null;
            }
        }
        
        Date currentSearchDate;
        string currentDay;
        //@Dinesh Acharya replying a new next report date based on selection.
        if(schedule.Schedule_Type__c == 'Daily')
        {
        	currentSearchDate = lastFormDate.addDays(1);
        	while(TRUE) {
        		if (currentSearchDate <= System.Today()) {
        			currentDay = calculateDayOfDate(currentSearchDate);
	                if (currentDay == 'Sunday' && schedule.Due_Sunday__c) {
	                    return currentSearchDate;
	                } else if (currentDay == 'Monday' && schedule.Due_Monday__c) {
	                    return currentSearchDate;
	                } else if (currentDay == 'Tuesday' && schedule.Due_Tuesday__c) {
	                    return currentSearchDate;
	                } else if (currentDay == 'Wednesday' && schedule.Due_Wednesday__c) {
	                    return currentSearchDate;
	                } else if (currentDay == 'Thursday' && schedule.Due_Thursday__c) {
	                    return currentSearchDate;
	                } else if (currentDay == 'Friday' && schedule.Due_Friday__c) {
	                    return currentSearchDate;
	                } else if (currentDay == 'Saturday' && schedule.Due_Saturday__c) {
	                    return currentSearchDate;
	                }   
	                currentSearchDate = currentSearchDate.addDays(1);
	            } else {
	                return null;
	            }
        	}
        }
        else if(schedule.Schedule_Type__c == 'Monthly')
        {
	        currentSearchDate = lastFormDate.addMonths(1);
	        while (TRUE) {
	            if (currentSearchDate <= System.Today()) {
	                if (currentSearchDate.Month() == 1 && schedule.Due_January__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 2 && schedule.Due_February__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 3 && schedule.Due_March__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 4 && schedule.Due_April__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 5 && schedule.Due_May__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 6 && schedule.Due_June__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 7 && schedule.Due_July__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 8 && schedule.Due_August__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 9 && schedule.Due_September__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 10 && schedule.Due_October__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 11 && schedule.Due_November__c) {
	                    return currentSearchDate;
	                } else if (currentSearchDate.Month() == 12 && schedule.Due_December__c) {
	                    return currentSearchDate;
	                }
	                
	                currentSearchDate = currentSearchDate.addMonths(1);
	            } else {
	                return null;
	            }
	        }
        }
        
        return null;
    }
    
    //@Dinesh Acharya
   	public static String calculateDayOfDate(Date SelectedDate)  
    {  
    	Date startDate = date.newInstance(0001, 1, 1);
        List<String> listDay = new List<String>{'Saturday' , 'Sunday' , 'Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday'};    
        Integer remainder = Math.mod(startDate.daysBetween(SelectedDate) , 7);  
        return(listDay.get(remainder));  
    }
    
    public static MAP<String, Date> nextFormDates(Id depotId, SET<String> formNames, LIST<Form_Schedule__c> formSchedules) {
        MAP<String, Date> nextFormDates = new  MAP<String, Date>();
        
        for (Form_Schedule__c schedule : formSchedules) {
            Boolean formExists = false;
            Date lastFormDate;
            //@Dinesh Acharya
            String scheduleType = schedule.Schedule_Type__c;
            
            try {
                lastFormDate = [SELECT Form_Name__c, Date__c FROM Form__c WHERE Form_Name__c = :schedule.Form__c AND Depot__c = :depotId ORDER BY Date__c DESC LIMIT 1].Date__c;
                
                formExists = true;
            } catch (Exception ex) {
                if (schedule.Start_Date__c <= System.Today()) {
                    nextFormDates.put(schedule.Form__c, schedule.Start_Date__c);
                } else {
                    nextFormDates.put(schedule.Form__c, null);
                }
            }
            
            
            if (formExists) {
            	//@Dinesh Acharya
            	Date currentSearchDate;
            	if(scheduleType == 'Daily')
            	{
            		currentSearchDate = lastFormDate.addDays(1);
            		string currentDay = calculateDayOfDate(currentSearchdate);
	                while (TRUE) {
	                    if (currentSearchDate <= System.Today()) {
	                        if (currentDay == 'Sunday' && schedule.Due_Sunday__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            break;
	                        } else if (currentDay == 'Monday' && schedule.Due_Monday__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            break;
	                        } else if (currentDay == 'Tuesday' && schedule.Due_Tuesday__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentDay == 'Wednesday' && schedule.Due_Wednesday__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentDay == 'Thursday' && schedule.Due_Thursday__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentDay == 'Friday' && schedule.Due_Friday__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentDay == 'Saturday' && schedule.Due_Saturday__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        }
	                        currentSearchDate = currentSearchDate.addDays(1);
	                    } else {
	                        nextFormDates.put(schedule.Form__c, Date.newInstance(currentSearchDate.Year(), currentSearchDate.Month(), currentSearchDate.day()));
	                        
	                        break;
	                    }
	                }
            	}
            	else
            	{
	                currentSearchDate = lastFormDate.addMonths(1);
	                while (TRUE) {
	                    if (currentSearchDate <= System.Today()) {
	                        if (currentSearchDate.Month() == 1 && schedule.Due_January__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 2 && schedule.Due_February__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 3 && schedule.Due_March__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 4 && schedule.Due_April__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 5 && schedule.Due_May__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 6 && schedule.Due_June__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 7 && schedule.Due_July__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 8 && schedule.Due_August__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 9 && schedule.Due_September__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 10 && schedule.Due_October__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 11 && schedule.Due_November__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        } else if (currentSearchDate.Month() == 12 && schedule.Due_December__c) {
	                            nextFormDates.put(schedule.Form__c, currentSearchDate);
	                            
	                            break;
	                        }
	                        
	                        currentSearchDate = currentSearchDate.addMonths(1);
	                    } else {
	                        nextFormDates.put(schedule.Form__c, Date.newInstance(currentSearchDate.Year(), currentSearchDate.Month(), schedule.Run_Day__c.IntValue()));
	                        
	                        break;
	                    }
                	}
                }
            }
        }
        
        return nextFormDates;
    }
    
    public static LIST<Task> createDepotTasks(Depot__c depot) {
        MAP<String, Schema.RecordTypeInfo> taskRecordTypes = Task.SObjectType.getDescribe().getRecordTypeInfosByName();
        Id formTaskRecordTypeId = taskRecordTypes.get('Form Task').getRecordTypeId();
        LIST<Task> depotTasks = new LIST<Task>();
        MAP<String, Boolean> openTasksMap = getExistingTasks(depot.OwnerId, formTaskRecordTypeId);
        
        SET<String> scheduledFormTypes = new SET<String>();
        for(Form_Schedule__c schedule : depot.Form_Schedules__r) {
            scheduledFormTypes.add(schedule.Form__c);
        }
        
        MAP<String, Date> nextFormDates = nextFormDates(depot.Id, scheduledFormTypes, depot.Form_Schedules__r);
        
        for(Form_Schedule__c schedule : depot.Form_Schedules__r) {
            Date currentDate;
            System.debug('Dinesh-Acharya: ' + schedule + '  Schedule-type: ' + schedule.Schedule_Type__c);
            String ScheduleType = schedule.Schedule_Type__c;
            if (nextFormDates.get(schedule.Form__c) == null) {
            	//@Dinesh Acharya
            	if(ScheduleType == 'Daily')
            	{
            		Date currentStartDate = schedule.Start_Date__c;
            		currentDate = Date.newInstance(currentStartDate.year(),currentStartDate.Month(), currentStartDate.day()); //Date.newInstance(System.Today().year(),System.Today().Month(), System.today().day());
            	}
            	else
            	{
                	currentDate = Date.newInstance(System.Today().Year(), System.Today().Month(), schedule.Run_Day__c.IntValue());
            	}
            } else {
                currentDate = nextFormDates.get(schedule.Form__c);
            }
			Date endDate;
			//@Dinesh Acharya
			if(ScheduleType == 'Daily')
            {
            	//endDate = System.Today().addMonths(1);
            	endDate = System.Today().addYears(1);
            	System.Debug('Dinesh-Acharya endDate: ' + endDate);
            }
            else
            {
            	endDate = System.Today().addYears(1);
            }
            
            Integer IteratingMonth = currentDate.month();
            Boolean IsAddaMonthTocurrentNEndDate = false;
            While (currentDate < endDate) {
                if (openTasksMap.get(schedule.Form__c + '|' + currentDate.Day() + currentDate.Month() + currentDate.Year()) == null) {
                	//@Dinesh Acharya
                	if(ScheduleType == 'Daily')
                	{
                		if(IsAddaMonthTocurrentNEndDate == false)
                		{
					    	String currentDay = calculateDayOfDate(currentDate);
							if (currentDay == 'Sunday' && schedule.Due_Sunday__c) {
					            depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
					        } else if (currentDay == 'Monday' && schedule.Due_Monday__c) {
					            depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
					        } else if (currentDay == 'Tuesday' && schedule.Due_Tuesday__c) {
					            depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
					        } else if (currentDay == 'Wednesday' && schedule.Due_Wednesday__c) {
					            depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
					        } else if (currentDay == 'Thursday' && schedule.Due_Thursday__c) {
					            depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
					        } else if (currentDay == 'Friday' && schedule.Due_Friday__c) {
					            depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
					        } else if (currentDay == 'Saturday' && schedule.Due_Saturday__c) {
					            depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
					        }
                		}
                	}
                	else
                	{
	                    if (currentDate.Month() == 1 && schedule.Due_January__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 2 && schedule.Due_February__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 3 && schedule.Due_March__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 4 && schedule.Due_April__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 5 && schedule.Due_May__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 6 && schedule.Due_June__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 7 && schedule.Due_July__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 8 && schedule.Due_August__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 9 && schedule.Due_September__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 10 && schedule.Due_October__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 11 && schedule.Due_November__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    } else if (currentDate.Month() == 12 && schedule.Due_December__c) {
	                        depotTasks.add(createDepotTask(currentDate, schedule, formTaskRecordTypeId));
	                    }
                	}
                }
                if(ScheduleType == 'Daily')
                {
                	currentDate = currentDate.addDays(1);
                	System.Debug('Dinesh-Acharya currentDate: ' + currentDate);
                	if(IteratingMonth  != currentDate.month())
                	{
	                	IsAddaMonthTocurrentNEndDate = checkMonthSelection(currentDate, schedule);
	                	if(IsAddaMonthTocurrentNEndDate == true)
	                	{
	                		currentDate = currentDate.addMonths(1);
	                		//endDate = endDate.addMonths(1);
	                		System.Debug('Dinesh-Acharya IteratingMonth: ' + IteratingMonth);
	                	}else{
	                		IteratingMonth = currentDate.month();
	                	}
                	}
                }
                else
                {
                	currentDate = currentDate.addMonths(1);
                }
            }
        }
        return depotTasks;
    }
    
    //@Dinesh-Acharya 
    private static Boolean checkMonthSelection(Date currentDate, Form_Schedule__c schedule)
    {
    	Integer currentMonth = currentDate.month();
    	if(currentMonth == 1 && schedule.Due_January__c == false){
    		return true;}
    	else if(currentMonth == 2 && schedule.Due_February__c == false){
    		return true;}
    	else if(currentMonth == 3 && schedule.Due_March__c == false){
    		return true;}
    	else if(currentMonth == 4 && schedule.Due_April__c == false){
    		return true;}
    	else if(currentMonth == 5 && schedule.Due_May__c == false){
    		return true;}
    	else if(currentMonth == 6 && schedule.Due_June__c == false){
    		return true;}
    	else if(currentMonth == 7 && schedule.Due_July__c == false){
    		return true;}
    	else if(currentMonth == 8 && schedule.Due_August__c == false){
    		return true;}
    	else if(currentMonth == 9 && schedule.Due_September__c == false){
    		return true;}
    	else if(currentMonth == 10 && schedule.Due_October__c == false){
    		return true;}
    	else if(currentMonth == 12 && schedule.Due_November__c == false){
    		return true;}
    	else if(currentMonth == 12 && schedule.Due_December__c == false){
    		return true;}
    	return false;
    }
    
    private static MAP<String, Boolean> getExistingTasks(Id ownerId, Id formTaskRecordTypeId) {
        MAP<String, Boolean> openTasksMap = new MAP<String, Boolean>();
        
        LIST<Task> openTasks = [SELECT Task_Related_Form__c, ActivityDate FROM Task WHERE RecordTypeId = :formTaskRecordTypeId AND IsClosed = FALSE AND OwnerId = :ownerId];
        
        for (Task openTask : openTasks) {
            openTasksMap.put(openTask.Task_Related_Form__c + '|' + openTask.ActivityDate.Day() + openTask.ActivityDate.Month() + openTask.ActivityDate.Year(), TRUE);
        }
        
        return openTasksMap;
    }
    
    private static Task createDepotTask(Date taskDate, Form_Schedule__c schedule, Id formTaskRecordTypeId) {
        Task depotTask = new Task();
        depotTask.OwnerId = schedule.Depot__r.OwnerId;
        depotTask.Subject = 'Create ' + schedule.Form__c + ' Form';
        depotTask.Task_Related_Form__c = schedule.Form__c;
        depotTask.ActivityDate = taskDate;
        depotTask.ReminderDateTime = DateTime.newInstance(taskDate, Time.newInstance(0, 0, 0, 0));
        depotTask.RecordTypeId = formTaskRecordTypeId;
        depotTask.WhatId = schedule.Depot__c;
        
        return depotTask;
    }
    
    public static LIST<SelectOption> getFormTypes_create() {
        /*
        LIST<Schema.RecordTypeInfo> formTypes = Form__c.SObjectType.getDescribe().getRecordTypeInfos();
        LIST<SelectOption> formTypeOptions = new LIST<SelectOption>();
        
        for (Schema.RecordTypeInfo formType : formTypes) {
            if (!formType.getName().equals('Master')) {
                formTypeOptions.add(new SelectOption(formType.getName(), formType.getName()));
            }
        }
        */
        LIST<SelectOption> formTypeOptions = new LIST<SelectOption>();
        for (PUD_Form_Type__c formType : [SELECT Id, Name FROM PUD_Form_Type__c LIMIT 1000]) {
            formTypeOptions.add(new SelectOption(formType.Name, formType.Name));
        }
        
        return formTypeOptions;
    }
    
    public static LIST<SelectOption> getFormTypes() {
        /*
        LIST<Schema.RecordTypeInfo> formTypes = Form__c.SObjectType.getDescribe().getRecordTypeInfos();
        LIST<SelectOption> formTypeOptions = new LIST<SelectOption>();
        
        for (Schema.RecordTypeInfo formType : formTypes) {
            if (!formType.getName().equals('Master')) {
                formTypeOptions.add(new SelectOption(formType.getName(), formType.getName()));
            }
        }
        */
        LIST<SelectOption> formTypeOptions = new LIST<SelectOption>();
        for (PUD_Form_Type__c formType : [SELECT Id, Name FROM PUD_Form_Type__c LIMIT 1000]) {
            formTypeOptions.add(new SelectOption(formType.Name, formType.Name));
        }
        
        formTypeOptions.add(new SelectOption('Emergency Lighting', 'Emergency Lighting'));
        formTypeOptions.add(new SelectOption('Fire Extinguishers', 'Fire Extinguishers'));
        
        return formTypeOptions;
    }
    
    public static LIST<SelectOption> getScheduleType() {
    	LIST<SelectOption> scheduleTypeOption = new LIST<SelectOption>();
    	List<String> scheduleType = new List<String>();
    	scheduleTypeOption.add(new SelectOption('Monthly', 'Monthly'));
    	scheduleTypeOption.add(new SelectOption('Daily', 'Daily'));
    	
    	return scheduleTypeOption;
    }
    
    TestMethod static void test_formMethods_1() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-1);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_2() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-2);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_3() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-3);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_4() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-4);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_5() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-5);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_6() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-6);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_7() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-7);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_8() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-8);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_9() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-9);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_10() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-10);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_11() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-11);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_12() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-12);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_13() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-13);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = false;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = true;
        testFS.Due_Monday__c = true;
        testFS.Due_Tuesday__c = true;
        testFS.Due_Wednesday__c = true;
        testFS.Due_Thursday__c = true;
        testFS.Due_Friday__c = true;
        testFS.Due_Saturday__c = true;
        testFS.Schedule_Type__c = 'Daily';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_14() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-1);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_15() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-2);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_16() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-3);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_17() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-4);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_18() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-5);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_19() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-6);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_20() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-7);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_21() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-8);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_22() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-9);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_23() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-10);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_24() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-11);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_25() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-12);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
    
    TestMethod static void test_formMethods_26() {
        Depot__c testDepot = new Depot__c();
        testDepot.Name = 'TEST';
        testDepot.Depot_Code__c = 'TES';
        insert testDepot;
        
        Form__c testForm = new Form__c();
        testForm.RecordTypeId = Form__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Fire Extinguishers').getRecordTypeId();
        testForm.Location__c = 'TEST';
        testForm.Date__c = System.Today().addMonths(-13);
        testForm.Depot__c = testDepot.Id;
        
        Form_Schedule__c testFS = new Form_Schedule__c();
        testFS.Start_Date__c = System.Today();
        testFS.Form__c = 'Fire Extinguishers';
        testFS.Depot__c = testDepot.Id;
        testFS.Due_January__c = true;
        testFS.Due_February__c = true;
        testFS.Due_March__c = true;
        testFS.Due_April__c = true;
        testFS.Due_May__c = true;
        testFS.Due_June__c = true;
        testFS.Due_July__c = true;
        testFS.Due_August__c = true;
        testFS.Due_September__c = true;
        testFS.Due_October__c = true;
        testFS.Due_November__c = true;
        testFS.Due_December__c = true;
        //@Dinesh Acharya
        testFS.Due_Sunday__c = false;
        testFS.Due_Monday__c = false;
        testFS.Due_Tuesday__c = false;
        testFS.Due_Wednesday__c = false;
        testFS.Due_Thursday__c = false;
        testFS.Due_Friday__c = false;
        testFS.Due_Saturday__c = false;
        testFS.Schedule_Type__c = 'Monthly';
        insert testFS;
        
        testDepot = [SELECT OwnerId, Id, (SELECT Due_Sunday__c, Due_Monday__c,Due_Tuesday__c, Due_Wednesday__c, Due_Thursday__c, Due_Friday__c, Due_Saturday__c, Schedule_Type__c, Depot__c, Due_January__c, Due_April__c, Due_August__c, Due_December__c, Due_February__c, Due_July__c, Due_June__c, Due_March__c, Due_May__c, Due_November__c, Due_October__c, Due_September__c, Start_Date__c, Form__c, Run_Day__c, Form_Schedule__c.Depot__r.OwnerId FROM Form_Schedules__r), (SELECT Date__c FROM Forms__r ORDER BY Date__c DESC LIMIT 200) FROM Depot__c WHERE Id = :testDepot.Id];
        
        String formName = Form__c.SObjectType.getDescribe().getRecordTypeInfosByID().get(testForm.RecordTypeId).getName();
        
        Test.StartTest();
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        
        insert testForm;
        
        formMethods.nextReportDate(testDepot.Id, formName);
        formMethods.createDepotTasks(testDepot);
        formMethods.getFormTypes();
        Test.StopTest();
    }
}