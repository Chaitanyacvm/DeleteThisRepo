global class FM_batchSchedulePPMJobs implements Database.Batchable<sObject> {
    global FM_batchSchedulePPMJobs(){
    }

    // select stuff
    global Database.QueryLocator start( Database.BatchableContext BC ){
        return Database.getQueryLocator( 'Select f.Trade__c, f.SystemModstamp, f.Specs_Number__c, f.OwnerId, f.Name, f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, f.Frequency_Period__c, f.Frequency_Number__c, f.Execution_In_Days__c, f.Description__c, f.CreatedDate, f.CreatedById, (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Deadline__c, Asset__c, System__c, Status__c, Job_Type__c, Assigned_To__c, Comments__c, Asset_Managed_By__c, Stage__c, Calendar_View__c, Engineer_Name__c, Job_Specs__c From Job_Instances__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Asset__c, Job_Type__c, Job_Type_Description__c, Job_Type_Specs__c, System__c, Asset_Reference_Date__c, System_Reference_Date__c, Asset_Last_Maintenance_Date__c, System_Last_Maintenance_Date__c, Last_Executed_Date__c, Next_Execution_Date__c From Asset_Job_Types__r) From FM_Job_Type__c f Order by Frequency_Period__c Desc' );
    }

    // execute stuff - need to check the frequency
    global void execute( Database.BatchableContext BC, List<FM_Job_Type__c> jobs ) {
        // add recordtypes to map
        Map<String, Id> jobRecordTypes = new Map<String, Id>();
        for (RecordType recordType : [SELECT Id, DeveloperName
                                            FROM RecordType
                                           WHERE DeveloperName = 'Asset_Job_Instance'
                                              OR DeveloperName = 'System_Job_Instance']) {
            jobRecordTypes.put(recordType.DeveloperName, recordType.Id);
        }

        MAP<String, FM_Job_Instance__c> jobsToCreate = new MAP<String, FM_Job_Instance__c>();
        MAP<Id, FM_Asset_Job_Type__c> assetJobsToUpdate = new MAP<Id, FM_Asset_Job_Type__c>();
        for ( FM_Job_Type__c job : jobs ){
            for ( FM_Job_Instance__c jobInstance : job.Job_Instances__r ){
                // put all existin job instances into map
                jobsToCreate.put( jobInstance.Job_Type__c + ',' + jobInstance.Asset__c + ',' + jobInstance.System__c + ',' + jobInstance.Deadline__c, jobInstance );
            }

            for ( FM_Asset_Job_Type__c assetJob : job.Asset_Job_Types__r ){
                // check for existing job instances
                if ( jobsToCreate.get( assetJob.Job_Type__c + ',' + assetJob.Asset__c + ',' + assetJob.System__c + ',' + assetJob.Next_Execution_Date__c ) != null )
                    continue;

                List<Date> d = new List<Date>();
                if ( job.Frequency_Period__c == 'Years' ){
                    Integer i = 365 * Integer.ValueOf( String.ValueOf( job.Frequency_Number__c ) );
                    while ( i > 0 ){
                        System.Debug( '===> Years: ' + i );
                        if ( assetJob.Last_Executed_Date__c != null )
                            if ( assetJob.Last_Executed_Date__c + i >= System.Today() + 365 )
                                i = -1;
                            else{
                                d.add( assetJob.Last_Executed_Date__c + i );
                                i = i + 365 * Integer.ValueOf( String.ValueOf( job.Frequency_Number__c ) );
                            }
                        else
                            if ( assetJob.Asset_Reference_Date__c != null )
                                assetJob.Last_Executed_Date__c = assetJob.Asset_Reference_Date__c;
                            else if ( assetJob.System_Reference_Date__c != null )
                                assetJob.Last_Executed_Date__c = assetJob.System_Reference_Date__c;
                            else
                                i = -1;
                    }
                }
                else if ( job.Frequency_Period__c == 'Months' ){
                System.Debug( '===> Months: ' );
                    Integer i = 30 * Integer.ValueOf( String.ValueOf( job.Frequency_Number__c ) );
                    while ( i > 0 )
                    {
                        System.Debug( '===> Months: ' + i );
                        if ( assetJob.Last_Executed_Date__c != null )
                            if ( assetJob.Last_Executed_Date__c + i >= System.Today() + 365 )
                                i = -1;
                            else{
                                d.add( assetJob.Last_Executed_Date__c + i );
                                i = i + 30 * Integer.ValueOf( String.ValueOf( job.Frequency_Number__c ) );
                            }
                        else
                            if ( assetJob.Asset_Reference_Date__c != null )
                                assetJob.Last_Executed_Date__c = assetJob.Asset_Reference_Date__c;
                            else if ( assetJob.System_Reference_Date__c != null )
                                assetJob.Last_Executed_Date__c = assetJob.System_Reference_Date__c;
                            else
                                i = -1;
                    }
                }
                else if ( job.Frequency_Period__c == 'Weeks' ){
                System.Debug( '===> Weeks: ');
                    Integer i = 7 * Integer.ValueOf( String.ValueOf( job.Frequency_Number__c ) );
                    while ( i > 0 ){
                        System.Debug( '===> Weeks: ' + i );
                        if ( assetJob.Last_Executed_Date__c != null )
                            if ( assetJob.Last_Executed_Date__c + i >= System.Today() + 365 )
                                i = -1;
                            else
                            {
                                d.add( assetJob.Last_Executed_Date__c + i );
                                i = i + 7 * Integer.ValueOf( String.ValueOf( job.Frequency_Number__c ) );
                            }
                        else
                            if ( assetJob.Asset_Reference_Date__c != null )
                                assetJob.Last_Executed_Date__c = assetJob.Asset_Reference_Date__c;
                            else if ( assetJob.System_Reference_Date__c != null )
                                assetJob.Last_Executed_Date__c = assetJob.System_Reference_Date__c;
                            else
                                i = -1;
                    }
                }
                System.Debug( '===> Date: ' + d );
                for ( Date dat : d ){
                    if ( dat < System.Today() )
                        continue;
                    FM_Job_Instance__c jobToCreate = new FM_Job_Instance__c();
                    jobToCreate.Job_Type__c = assetJob.Job_Type__c;

                    system.debug('date : '+ dat + ' belongs to jobInstance : ' + jobToCreate.Id);
                    if ( assetJob.Asset__c != null ){
                        jobToCreate.Asset__c = assetJob.Asset__c;
                        jobToCreate.RecordTypeId = jobRecordTypes.get('Asset_Job_Instance');
                    }
                    if ( assetJob.System__c != null ){
                        jobToCreate.System__c = assetJob.System__c;
                        jobToCreate.RecordTypeId = jobRecordTypes.get('System_Job_Instance');
                    }
                    jobToCreate.Status__c = 'Planned';
                    jobToCreate.Deadline__c = dat;

                    System.Debug( '===> Job: ' + jobToCreate );
                    jobsToCreate.put( assetJob.Job_Type__c + ',' + assetJob.Asset__c + ',' + assetJob.System__c + ',' + dat, jobToCreate );

                    assetJob.Last_Executed_Date__c = dat;
                    assetJobsToUpdate.put( assetJob.Id, assetJob );
                }
            }
        }

        upsert jobsToCreate.Values();

        update assetJobsToUpdate.Values();

        // check if there are several jobs for one week
        Map<String, FM_Job_Instance__c> jobsToKeep = new Map<String, FM_Job_Instance__c>();
        List<FM_Job_Instance__c> jobsToDelete = new List<FM_Job_Instance__c>();
        Set<Id> jobIdsToKeep = new Set<Id>();
        for(FM_Job_Instance__c jobInstance : [SELECT Asset__c, System__c, Status__c, Week__c, Deadline__c, Job_Type__r.Specs_Number__c,
                                                     Job_Type__r.Frequency_Number__c, Job_Type__r.Frequency_Period__c, Job_Type__r.Name
                                                FROM FM_Job_Instance__c
                                               WHERE CreatedDate = today
                                            ORDER BY Job_Type__r.Frequency_Period__c
                                                 ASC]){
            if(jobsToKeep.get(jobInstance.Week__c + ',' + jobInstance.Job_Type__r.Specs_Number__c + ',' + jobInstance.Asset__c + ',' + jobInstance.System__c) != null){
                jobsToDelete.add(jobsToKeep.get(jobInstance.Week__c + ',' + jobInstance.Job_Type__r.Specs_Number__c + ',' + jobInstance.Asset__c + ',' + jobInstance.System__c));
            }
            jobsToKeep.put(jobInstance.Week__c + ',' + jobInstance.Job_Type__r.Specs_Number__c + ',' + jobInstance.Asset__c + ',' + jobInstance.System__c, jobInstance);
            jobIdsToKeep.add(jobInstance.Id);
        }

        delete jobsToDelete;

        // get all inserted systemAssetJobs
        Map<String, FM_System_Asset_Job_Instances__c> existingSystemAssetJobs = new Map<String, FM_System_Asset_Job_Instances__c>();
        for(FM_System_Asset_Job_Instances__c existingSystemAssetJob : [SELECT Id, Name, Job_Instance__c, Asset__c, Status__c
                                                                         FROM FM_System_Asset_Job_Instances__c
                                                                        WHERE Status__c = 'Planned'
                                                                          AND Job_Instance__c IN: jobIdsToKeep]){
            existingSystemAssetJobs.put(existingSystemAssetJob.Job_Instance__c + ',' + existingSystemAssetJob.Asset__c + ',' + existingSystemAssetJob.Status__c, existingSystemAssetJob);
        }

        Map<Id, Set<Id>> systemIds = new Map<Id, Set<Id>>();
        for(FM_Job_Instance__c systemJobs : jobsToKeep.Values()){
            if(systemJobs.System__c != null){
                if(systemIds.get(systemJobs.System__c) == null){
                    Set<Id> jobIds = new Set<Id>();
                    jobIds.add(systemJobs.Id);
                    systemIds.put(systemJobs.System__c, jobIds);
                } else{
                    Set<Id> jobIds = systemIds.get(systemJobs.System__c);
                    jobIds.add(systemJobs.Id);
                    systemIds.put(systemJobs.System__c, jobIds);
                }
            }
        }

        Set<FM_System_Asset_Job_Instances__c> systemAssetsToInsert = new Set<FM_System_Asset_Job_Instances__c>();
        for(FM_System__c sys : [SELECT Id, (SELECT Id, Name, Asset__c FROM System_Assets__r) FROM FM_System__c WHERE Id IN: systemIds.KeySet()]){
            if(sys.System_Assets__r != null){
                for(System_Asset__c systemAsset : sys.System_Assets__r){
                    for(Id jobId : systemIds.get(sys.Id)){
                        FM_System_Asset_Job_Instances__c systemAssetJob = new FM_System_Asset_Job_Instances__c();
                        systemAssetJob.Job_Instance__c = jobId;
                        systemAssetJob.Status__c = 'Planned';
                        systemAssetJob.Asset__c = systemAsset.Asset__c;
                        if(existingSystemAssetJobs.get(systemAssetJob.Job_Instance__c + ',' + systemAssetJob.Asset__c + ',' + systemAssetJob.Status__c) == null){
                            systemAssetsToInsert.add(systemAssetJob);
                            existingSystemAssetJobs.put(systemAssetJob.Job_Instance__c + ',' + systemAssetJob.Asset__c + ',' + systemAssetJob.Status__c, systemAssetJob);
                        }
                    }
                }
            }
        }
        List<FM_System_Asset_Job_Instances__c> systemAssetsToInsert2 = new List<FM_System_Asset_Job_Instances__c>();
        systemAssetsToInsert2.addAll(systemAssetsToInsert);
        insert systemAssetsToInsert2;

        Integer numberOfJobs = jobsToCreate.Values().Size() - jobsToDelete.Size();
        System.Debug( '===> Inserted: ' + numberOfJobs + ' Records: ' + jobsToCreate );
        System.Debug( '===> Updated: ' + assetJobsToUpdate.Size() + ' Records: ' + assetJobsToUpdate );
    }

    // finish
    global void finish(Database.BatchableContext BC) {
    }

    // test
    TestMethod static void test_FM_batchSchedulePPMJobs() {
        BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];

        // create supplier
        FM_Supplier__c supplier = new FM_Supplier__c();
        supplier.Name = 'TestSupplier';
        insert supplier;

        // create location
        FM_Location__c location = new FM_Location__c ();
        location.Name = 'TestLocation';
        insert location;

        //create location level
        FM_Location_Level__c level = new FM_Location_Level__c ();
        level.Name = 'TestLocationLevel';
        level.Location__c= location.Id;
        insert level;

        //create location room
        FM_Location_Room__c room = new FM_Location_Room__c ();
        room.Name = 'TestLocationRoom';
        room.Location_Level__c= level.Id;
        insert room;

        //create location area
        FM_Location_Area__c area = new FM_Location_Area__c ();
        area.Name = 'TestLocationRoom';
        area.Location_Room__c= room.Id;
        insert area;

        // create rule
        FM_Service_Level__c rule = new FM_Service_Level__c ();
        rule.Location__c = location.Id;
        rule.Scope__c = 'Cleaning';
        rule.Supplier__c = supplier.Id;
        rule.In_Hours_Acknowledgement_SLA__c = 2.5;
        rule.Out_Hours_Acknowledgement_SLA__c = 5;
        rule.Start_In_Hours__c = 9;
        rule.End_In_Hours__c = 17;
        rule.Business_Hours_In__c = stdBusinessHours.Id;
        rule.Business_Hours_Out__c = stdBusinessHours.Id;
        rule.Priority_Level__c = 'P4';
        insert rule;

        // create incident for test
        FM_Incident__c incident = new FM_Incident__c ();
        incident.Location__c = location.Id;
        incident.Subject__c = 'IncidentTitle';
        incident.Description__c = 'IncidentDescription';
        incident.Status__c = 'With Supplier';
        incident.Service__c = 'Cleaning';
        incident.Type__c = 'Cleaning';
        incident.Sub_Type__c = 'Cleaning';
        //incident.Syb_Type__c = '';
        incident.Raised_By__c = 'TestName';
        incident.Phone__c = '12345';
        incident.Email__c = 'test@test.com';
        Incident.Any_Risk_Applicable__c = 'No';
        incident.PO_Number__c = '123';
        insert incident;

        // create asset for location
        FM_Asset__c locationasset = new FM_Asset__c();
        locationAsset.Name = 'LOC Asset';
        locationAsset.Location__c= location.id;
        insert locationasset;

        // insert weekly job
        FM_Job_Type__c weeklyJob = new FM_Job_Type__c();
        weeklyJob.Frequency_Number__c = 1;
        weeklyJob.Specs_Number__c = '9.99W';
        weeklyJob.Name = 'WEEKLY';
        weeklyJob.Frequency_Period__c = 'Weeks';
        insert weeklyJob;

        // insert monthly job
        FM_Job_Type__c monthlyJob = new FM_Job_Type__c();
        monthlyJob.Frequency_Number__c = 1;
        monthlyJob.Specs_Number__c = '9.99M';
        monthlyJob.Name = 'MONTHLY';
        monthlyJob.Frequency_Period__c = 'Months';
        insert monthlyJob;

        // insert yearly job
        FM_Job_Type__c yearlyJob = new FM_Job_Type__c();
        yearlyJob.Frequency_Number__c = 1;
        yearlyJob.Specs_Number__c = '9.99Y';
        yearlyJob.Name = 'YEARLY';
        yearlyJob.Frequency_Period__c = 'Years';
        insert yearlyJob;

        // asset job type weekly
        FM_Asset_Job_Type__c assetJobTypeWeekly = new FM_Asset_Job_Type__c();
        assetJobTypeWeekly.Asset__c = locationAsset.Id;
        assetJobTypeWeekly.Job_Type__c = weeklyJob.Id;
        assetJobTypeWeekly.Last_Executed_Date__c = System.Today() - 1;
        insert assetJobTypeWeekly;

        // asset job type monthly
        FM_Asset_Job_Type__c assetJobTypeMonthly = new FM_Asset_Job_Type__c();
        assetJobTypeMonthly.Asset__c = locationAsset.Id;
        assetJobTypeMonthly.Job_Type__c = monthlyJob.Id;
        assetJobTypeMonthly.Last_Executed_Date__c = System.Today() - 1;
        insert assetJobTypeMonthly;

        // asset job type yearly
        FM_Asset_Job_Type__c assetJobTypeYearly = new FM_Asset_Job_Type__c();
        assetJobTypeYearly.Asset__c = locationAsset.Id;
        assetJobTypeYearly.Job_Type__c = yearlyJob.Id;
        assetJobTypeYearly.Last_Executed_Date__c = System.Today() - 1;
        insert assetJobTypeYearly;

        Test.StartTest();
            FM_batchSchedulePPMJobs scheduleJobs = new FM_batchSchedulePPMJobs();
            ID batchprocessid = Database.executeBatch( scheduleJobs );
        Test.StopTest();
    }
}