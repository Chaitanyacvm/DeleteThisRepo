public with sharing class FM_CalendarViewContentController{
    public List<Job> jobsToShow {get; set;}
    public Label label {get; set;}
    
    public String selectedLocation {get; set;}
    public String selectedTimeFrame {get; set;}

    public String selectedYear {get; set;}
    
    public Boolean showCalendar{
        get{
            if(selectedLocation != null && selectedTimeFrame != null){
                if(selectedLocation != '0'){
                    selectedYear = getSelectedYear();
                    createAssetRecords(getAssetJobs(), getSystemJobs());
                    return true;
                }
            }
            return false;
        }
        set;
    }
    
    public FM_CalendarViewContentController(){
        // create Labels for datatable
        label = new Label();
    }

    private String getSelectedYear(){
      if(selectedTimeFrame == 'this_year'){
                return String.ValueOf(System.today().Year());
        } else if(selectedTimeFrame == 'last_year'){
                return String.ValueOf(System.today().Year() - 1);
        } else if(selectedTimeFrame == 'next_year'){
                return String.ValueOf(System.today().Year() + 1);
        }
        return null;
    }

    // get all assets for the selected location in the selected timeframe
    private List<FM_Asset__c> getAssetJobs(){
        if(selectedTimeFrame == 'this_year'){
                return [SELECT f.Name, f.Id, f.Location__r.Name, f.Location_Room__r.Name, 
                               (SELECT Status__c, Week__c, Deadline__c, Job_Type__r.Frequency_Number__c, Job_Type__r.Calendar_Frequency__c,
                                       Job_Type__r.Frequency_Period__c, Job_Type__r.Name, Job_Type__r.Specs_Number__c
                                  FROM Job_Instances__r 
                                 WHERE Deadline__c = this_year 
                                   AND Job_Type__c != '' 
                              ORDER BY Job_Type__r.Frequency_Period__c) 
                          FROM FM_Asset__c f 
                         WHERE Location__c =: selectedLocation 
                      ORDER BY f.Name];
        } else if(selectedTimeFrame == 'last_year'){
                return [SELECT f.Name, f.Id, f.Location__r.Name, f.Location_Room__r.Name, 
                               (SELECT Status__c, Week__c, Deadline__c, Job_Type__r.Frequency_Number__c, Job_Type__r.Calendar_Frequency__c,
                                       Job_Type__r.Frequency_Period__c, Job_Type__r.Name, Job_Type__r.Specs_Number__c
                                  FROM Job_Instances__r 
                                 WHERE Deadline__c = last_year 
                                   AND Job_Type__c != '' 
                              ORDER BY Job_Type__r.Frequency_Period__c) 
                          FROM FM_Asset__c f 
                         WHERE Location__c =: selectedLocation 
                      ORDER BY f.Name];
        } else if(selectedTimeFrame == 'next_year'){
                return [SELECT f.Name, f.Id, f.Location__r.Name, f.Location_Room__r.Name, 
                               (SELECT Status__c, Week__c, Deadline__c, Job_Type__r.Frequency_Number__c, Job_Type__r.Calendar_Frequency__c,
                                       Job_Type__r.Frequency_Period__c, Job_Type__r.Name, Job_Type__r.Specs_Number__c
                                  FROM Job_Instances__r 
                                 WHERE Deadline__c = next_year 
                                   AND Job_Type__c != '' 
                              ORDER BY Job_Type__r.Frequency_Period__c) 
                          FROM FM_Asset__c f 
                         WHERE Location__c =: selectedLocation 
                      ORDER BY f.Name];
        }
        return null;
    }
    
    // get all systems for the selected location in the selected timeframe
    private List<FM_System__c> getSystemJobs(){
        if(selectedTimeFrame == 'this_year'){
                return [SELECT f.Name, f.Id, f.Location__r.Name, 
                               (SELECT Status__c, Week__c, Deadline__c, Job_Type__r.Frequency_Number__c, Job_Type__r.Calendar_Frequency__c,
                                       Job_Type__r.Frequency_Period__c, Job_Type__r.Name, Job_Type__r.Specs_Number__c 
                                  FROM Job_Instances__r 
                                 WHERE Deadline__c = this_year 
                                   AND Job_Type__c != '' 
                              ORDER BY Job_Type__r.Frequency_Period__c) 
                          FROM FM_System__c f 
                         WHERE Location__c =: selectedLocation 
                      ORDER BY f.Name];
        } else if(selectedTimeFrame == 'last_year'){
                return [SELECT f.Name, f.Id, f.Location__r.Name, 
                               (SELECT Status__c, Week__c, Deadline__c, Job_Type__r.Frequency_Number__c, Job_Type__r.Calendar_Frequency__c,
                                       Job_Type__r.Frequency_Period__c, Job_Type__r.Name, Job_Type__r.Specs_Number__c 
                                  FROM Job_Instances__r 
                                 WHERE Deadline__c = last_year 
                                   AND Job_Type__c != '' 
                              ORDER BY Job_Type__r.Frequency_Period__c) 
                          FROM FM_System__c f 
                         WHERE Location__c =: selectedLocation 
                      ORDER BY f.Name];
        } else if(selectedTimeFrame == 'next_year'){
                return [SELECT f.Name, f.Id, f.Location__r.Name, 
                               (SELECT Status__c, Week__c, Deadline__c, Job_Type__r.Frequency_Number__c, Job_Type__r.Calendar_Frequency__c,
                                       Job_Type__r.Frequency_Period__c, Job_Type__r.Name, Job_Type__r.Specs_Number__c 
                                  FROM Job_Instances__r 
                                 WHERE Deadline__c = next_year 
                                   AND Job_Type__c != '' 
                              ORDER BY Job_Type__r.Frequency_Period__c) 
                          FROM FM_System__c f 
                         WHERE Location__c =: selectedLocation 
                      ORDER BY f.Name];
        }
        return null;
    }
    
    // create datatable for all selected assets
    private void createAssetRecords(List<FM_Asset__c> assets, List<FM_System__c> systems){
        jobsToShow = new List<Job>();
        for(FM_Asset__c asset : assets){
            Job jobToShow = new Job();
            jobToShow.Location = asset.Location__r.Name;
            jobToShow.Room = asset.Location_Room__r.Name;
            jobToShow.Asset = asset.Name;
            for(FM_Job_Instance__c job : asset.Job_Instances__r){
                jobToShow.JobType = job.Job_Type__r.Name;
                jobToShow.Spec = job.Job_Type__r.Specs_Number__c;
                if(job.week__c == 1){
                    jobToShow.week_1 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_1 = job.Status__c;
                } else if(job.week__c == 2){
                    jobToShow.week_2 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_2 = job.Status__c;
                } else if(job.week__c == 3){
                    jobToShow.week_3 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_3 = job.Status__c;
                } else if(job.week__c == 4){
                    jobToShow.week_4 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_4 = job.Status__c;
                } else if(job.week__c == 5){
                    jobToShow.week_5 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_5 = job.Status__c;
                } else if(job.week__c == 6){
                    jobToShow.week_6 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_6 = job.Status__c;
                } else if(job.week__c == 7){
                    jobToShow.week_7 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_7 = job.Status__c;
                } else if(job.week__c == 8){
                    jobToShow.week_8 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_8 = job.Status__c;
                } else if(job.week__c == 9){
                    jobToShow.week_9 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_9 = job.Status__c;
                } else if(job.week__c == 10){
                    jobToShow.week_10 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_10 = job.Status__c;
                } else if(job.week__c == 11){
                    jobToShow.week_11 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_11 = job.Status__c;
                } else if(job.week__c == 12){
                    jobToShow.week_12 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_12 = job.Status__c;
                } else if(job.week__c == 13){
                    jobToShow.week_13 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_13 = job.Status__c;
                } else if(job.week__c == 14){
                    jobToShow.week_14 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_14 = job.Status__c;
                } else if(job.week__c == 15){
                    jobToShow.week_15 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_15 = job.Status__c;
                } else if(job.week__c == 16){
                    jobToShow.week_16 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_16 = job.Status__c;
                } else if(job.week__c == 17){
                    jobToShow.week_17 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_17 = job.Status__c;
                } else if(job.week__c == 18){
                    jobToShow.week_18 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_18 = job.Status__c;
                } else if(job.week__c == 19){
                    jobToShow.week_19 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_19 = job.Status__c;
                } else if(job.week__c == 20){
                    jobToShow.week_20 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_20 = job.Status__c;
                } else if(job.week__c == 21){
                    jobToShow.week_21 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_21 = job.Status__c;
                } else if(job.week__c == 22){
                    jobToShow.week_22 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_22 = job.Status__c;
                } else if(job.week__c == 23){
                    jobToShow.week_23 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_23 = job.Status__c;
                } else if(job.week__c == 24){
                    jobToShow.week_24 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_24 = job.Status__c;
                } else if(job.week__c == 25){
                    jobToShow.week_25 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_25 = job.Status__c;
                } else if(job.week__c == 26){
                    jobToShow.week_26 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_26 = job.Status__c;
                } else if(job.week__c == 27){
                    jobToShow.week_27 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_27 = job.Status__c;
                } else if(job.week__c == 28){
                    jobToShow.week_28 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_28 = job.Status__c;
                } else if(job.week__c == 29){
                    jobToShow.week_29 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_29 = job.Status__c;
                } else if(job.week__c == 30){
                    jobToShow.week_30 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_30 = job.Status__c;
                } else if(job.week__c == 31){
                    jobToShow.week_31 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_31 = job.Status__c;
                } else if(job.week__c == 32){
                    jobToShow.week_32 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_32 = job.Status__c;
                } else if(job.week__c == 33){
                    jobToShow.week_33 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_33 = job.Status__c;
                } else if(job.week__c == 34){
                    jobToShow.week_34 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_34 = job.Status__c;
                } else if(job.week__c == 35){
                    jobToShow.week_35 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_35 = job.Status__c;
                } else if(job.week__c == 36){
                    jobToShow.week_36 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_36 = job.Status__c;
                } else if(job.week__c == 37){
                    jobToShow.week_37 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_37 = job.Status__c;
                } else if(job.week__c == 38){
                    jobToShow.week_38 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_38 = job.Status__c;
                } else if(job.week__c == 39){
                    jobToShow.week_39 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_39 = job.Status__c;
                } else if(job.week__c == 40){
                    jobToShow.week_40 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_40 = job.Status__c;
                } else if(job.week__c == 41){
                    jobToShow.week_41 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_41 = job.Status__c;
                } else if(job.week__c == 42){
                    jobToShow.week_42 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_42 = job.Status__c;
                } else if(job.week__c == 43){
                    jobToShow.week_43 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_43 = job.Status__c;
                } else if(job.week__c == 44){
                    jobToShow.week_44 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_44 = job.Status__c;
                } else if(job.week__c == 45){
                    jobToShow.week_45 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_45 = job.Status__c;
                } else if(job.week__c == 46){
                    jobToShow.week_46 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_46 = job.Status__c;
                } else if(job.week__c == 47){
                    jobToShow.week_47 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_47 = job.Status__c;
                } else if(job.week__c == 48){
                    jobToShow.week_48 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_48 = job.Status__c;
                } else if(job.week__c == 49){
                    jobToShow.week_49 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_49 = job.Status__c;
                } else if(job.week__c == 50){
                    jobToShow.week_50 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_50 = job.Status__c;
                } else if(job.week__c == 51){
                    jobToShow.week_51 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_51 = job.Status__c;
                } else if(job.week__c == 52){
                    jobToShow.week_52 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_52 = job.Status__c;
                }   
            }
            if(asset.Job_Instances__r.Size() > 0){
                jobsToShow.add(jobToShow);
            }
        }
        for(FM_System__c sys : systems){
            Job jobToShow = new Job();
            jobToShow.Location = sys.Location__r.Name;
            jobToShow.Asset = sys.Name;
            for(FM_Job_Instance__c job : sys.Job_Instances__r){
                jobToShow.JobType = job.Job_Type__r.Name;
                jobToShow.Spec = job.Job_Type__r.Specs_Number__c;
                if(job.week__c == 1){
                    jobToShow.week_1 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_1 = job.Status__c;
                } else if(job.week__c == 2){
                    jobToShow.week_2 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_2 = job.Status__c;
                } else if(job.week__c == 3){
                    jobToShow.week_3 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_3 = job.Status__c;
                } else if(job.week__c == 4){
                    jobToShow.week_4 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_4 = job.Status__c;
                } else if(job.week__c == 5){
                    jobToShow.week_5 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_5 = job.Status__c;
                } else if(job.week__c == 6){
                    jobToShow.week_6 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_6 = job.Status__c;
                } else if(job.week__c == 7){
                    jobToShow.week_7 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_7 = job.Status__c;
                } else if(job.week__c == 8){
                    jobToShow.week_8 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_8 = job.Status__c;
                } else if(job.week__c == 9){
                    jobToShow.week_9 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_9 = job.Status__c;
                } else if(job.week__c == 10){
                    jobToShow.week_10 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_10 = job.Status__c;
                } else if(job.week__c == 11){
                    jobToShow.week_11 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_11 = job.Status__c;
                } else if(job.week__c == 12){
                    jobToShow.week_12 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_12 = job.Status__c;
                } else if(job.week__c == 13){
                    jobToShow.week_13 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_13 = job.Status__c;
                } else if(job.week__c == 14){
                    jobToShow.week_14 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_14 = job.Status__c;
                } else if(job.week__c == 15){
                    jobToShow.week_15 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_15 = job.Status__c;
                } else if(job.week__c == 16){
                    jobToShow.week_16 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_16 = job.Status__c;
                } else if(job.week__c == 17){
                    jobToShow.week_17 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_17 = job.Status__c;
                } else if(job.week__c == 18){
                    jobToShow.week_18 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_18 = job.Status__c;
                } else if(job.week__c == 19){
                    jobToShow.week_19 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_19 = job.Status__c;
                } else if(job.week__c == 20){
                    jobToShow.week_20 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_20 = job.Status__c;
                } else if(job.week__c == 21){
                    jobToShow.week_21 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_21 = job.Status__c;
                } else if(job.week__c == 22){
                    jobToShow.week_22 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_22 = job.Status__c;
                } else if(job.week__c == 23){
                    jobToShow.week_23 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_23 = job.Status__c;
                } else if(job.week__c == 24){
                    jobToShow.week_24 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_24 = job.Status__c;
                } else if(job.week__c == 25){
                    jobToShow.week_25 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_25 = job.Status__c;
                } else if(job.week__c == 26){
                    jobToShow.week_26 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_26 = job.Status__c;
                } else if(job.week__c == 27){
                    jobToShow.week_27 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_27 = job.Status__c;
                } else if(job.week__c == 28){
                    jobToShow.week_28 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_28 = job.Status__c;
                } else if(job.week__c == 29){
                    jobToShow.week_29 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_29 = job.Status__c;
                } else if(job.week__c == 30){
                    jobToShow.week_30 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_30 = job.Status__c;
                } else if(job.week__c == 31){
                    jobToShow.week_31 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_31 = job.Status__c;
                } else if(job.week__c == 32){
                    jobToShow.week_32 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_32 = job.Status__c;
                } else if(job.week__c == 33){
                    jobToShow.week_33 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_33 = job.Status__c;
                } else if(job.week__c == 34){
                    jobToShow.week_34 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_34 = job.Status__c;
                } else if(job.week__c == 35){
                    jobToShow.week_35 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_35 = job.Status__c;
                } else if(job.week__c == 36){
                    jobToShow.week_36 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_36 = job.Status__c;
                } else if(job.week__c == 37){
                    jobToShow.week_37 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_37 = job.Status__c;
                } else if(job.week__c == 38){
                    jobToShow.week_38 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_38 = job.Status__c;
                } else if(job.week__c == 39){
                    jobToShow.week_39 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_39 = job.Status__c;
                } else if(job.week__c == 40){
                    jobToShow.week_40 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_40 = job.Status__c;
                } else if(job.week__c == 41){
                    jobToShow.week_41 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_41 = job.Status__c;
                } else if(job.week__c == 42){
                    jobToShow.week_42 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_42 = job.Status__c;
                } else if(job.week__c == 43){
                    jobToShow.week_43 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_43 = job.Status__c;
                } else if(job.week__c == 44){
                    jobToShow.week_44 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_44 = job.Status__c;
                } else if(job.week__c == 45){
                    jobToShow.week_45 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_45 = job.Status__c;
                } else if(job.week__c == 46){
                    jobToShow.week_46 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_46 = job.Status__c;
                } else if(job.week__c == 47){
                    jobToShow.week_47 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_47 = job.Status__c;
                } else if(job.week__c == 48){
                    jobToShow.week_48 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_48 = job.Status__c;
                } else if(job.week__c == 49){
                    jobToShow.week_49 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_49 = job.Status__c;
                } else if(job.week__c == 50){
                    jobToShow.week_50 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_50 = job.Status__c;
                } else if(job.week__c == 51){
                    jobToShow.week_51 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_51 = job.Status__c;
                } else if(job.week__c == 52){
                    jobToShow.week_52 = job.Job_Type__r.Calendar_Frequency__c;
                    jobToShow.status_52 = job.Status__c;
                }   
            }
            if(sys.Job_Instances__r.Size() > 0){
                jobsToShow.add(jobToShow);
            }
        }
    }
    
    // class for datatable    
    public class Job{
        public String Location {get; set;}
        public String Room {get; set;}
        public String Asset {get; set;}
        public String JobType {get; set;}
        public String Spec {get; set;}
        public String week_1 {get; set;}
        public String week_2 {get; set;}
        public String week_3 {get; set;}
        public String week_4 {get; set;}
        public String week_5 {get; set;}
        public String week_6 {get; set;}
        public String week_7 {get; set;}
        public String week_8 {get; set;}
        public String week_9 {get; set;}
        public String week_10 {get; set;}
        public String week_11 {get; set;}
        public String week_12 {get; set;}
        public String week_13 {get; set;}
        public String week_14 {get; set;}
        public String week_15 {get; set;}
        public String week_16 {get; set;}
        public String week_17 {get; set;}
        public String week_18 {get; set;}
        public String week_19 {get; set;}
        public String week_20 {get; set;}
        public String week_21 {get; set;}
        public String week_22 {get; set;}
        public String week_23 {get; set;}
        public String week_24 {get; set;}
        public String week_25 {get; set;}
        public String week_26 {get; set;}
        public String week_27 {get; set;}
        public String week_28 {get; set;}
        public String week_29 {get; set;}
        public String week_30 {get; set;}
        public String week_31 {get; set;}
        public String week_32 {get; set;}
        public String week_33 {get; set;}
        public String week_34 {get; set;}
        public String week_35 {get; set;}
        public String week_36 {get; set;}
        public String week_37 {get; set;}
        public String week_38 {get; set;}
        public String week_39 {get; set;}
        public String week_40 {get; set;}
        public String week_41 {get; set;}
        public String week_42 {get; set;}
        public String week_43 {get; set;}
        public String week_44 {get; set;}
        public String week_45 {get; set;}
        public String week_46 {get; set;}
        public String week_47 {get; set;}
        public String week_48 {get; set;}
        public String week_49 {get; set;}
        public String week_50 {get; set;}
        public String week_51 {get; set;}
        public String week_52 {get; set;}
        public String status_1 {get; set;}
        public String status_2 {get; set;}
        public String status_3 {get; set;}
        public String status_4 {get; set;}
        public String status_5 {get; set;}
        public String status_6 {get; set;}
        public String status_7 {get; set;}
        public String status_8 {get; set;}
        public String status_9 {get; set;}
        public String status_10 {get; set;}
        public String status_11 {get; set;}
        public String status_12 {get; set;}
        public String status_13 {get; set;}
        public String status_14 {get; set;}
        public String status_15 {get; set;}
        public String status_16 {get; set;}
        public String status_17 {get; set;}
        public String status_18 {get; set;}
        public String status_19 {get; set;}
        public String status_20 {get; set;}
        public String status_21 {get; set;}
        public String status_22 {get; set;}
        public String status_23 {get; set;}
        public String status_24 {get; set;}
        public String status_25 {get; set;}
        public String status_26 {get; set;}
        public String status_27 {get; set;}
        public String status_28 {get; set;}
        public String status_29 {get; set;}
        public String status_30 {get; set;}
        public String status_31 {get; set;}
        public String status_32 {get; set;}
        public String status_33 {get; set;}
        public String status_34 {get; set;}
        public String status_35 {get; set;}
        public String status_36 {get; set;}
        public String status_37 {get; set;}
        public String status_38 {get; set;}
        public String status_39 {get; set;}
        public String status_40 {get; set;}
        public String status_41 {get; set;}
        public String status_42 {get; set;}
        public String status_43 {get; set;}
        public String status_44 {get; set;}
        public String status_45 {get; set;}
        public String status_46 {get; set;}
        public String status_47 {get; set;}
        public String status_48 {get; set;}
        public String status_49 {get; set;}
        public String status_50 {get; set;}
        public String status_51 {get; set;}
        public String status_52 {get; set;}
    }
    
    // class for labels/headers in datatable
    public class Label{
        public String Location {get; set;}
        public String Room {get; set;}
        public String Asset {get; set;}
        public String JobType {get; set;}
        public String Spec {get; set;}
        public String week_1 {get; set;}
        public String week_2 {get; set;}
        public String week_3 {get; set;}
        public String week_4 {get; set;}
        public String week_5 {get; set;}
        public String week_6 {get; set;}
        public String week_7 {get; set;}
        public String week_8 {get; set;}
        public String week_9 {get; set;}
        public String week_10 {get; set;}
        public String week_11 {get; set;}
        public String week_12 {get; set;}
        public String week_13 {get; set;}
        public String week_14 {get; set;}
        public String week_15 {get; set;}
        public String week_16 {get; set;}
        public String week_17 {get; set;}
        public String week_18 {get; set;}
        public String week_19 {get; set;}
        public String week_20 {get; set;}
        public String week_21 {get; set;}
        public String week_22 {get; set;}
        public String week_23 {get; set;}
        public String week_24 {get; set;}
        public String week_25 {get; set;}
        public String week_26 {get; set;}
        public String week_27 {get; set;}
        public String week_28 {get; set;}
        public String week_29 {get; set;}
        public String week_30 {get; set;}
        public String week_31 {get; set;}
        public String week_32 {get; set;}
        public String week_33 {get; set;}
        public String week_34 {get; set;}
        public String week_35 {get; set;}
        public String week_36 {get; set;}
        public String week_37 {get; set;}
        public String week_38 {get; set;}
        public String week_39 {get; set;}
        public String week_40 {get; set;}
        public String week_41 {get; set;}
        public String week_42 {get; set;}
        public String week_43 {get; set;}
        public String week_44 {get; set;}
        public String week_45 {get; set;}
        public String week_46 {get; set;}
        public String week_47 {get; set;}
        public String week_48 {get; set;}
        public String week_49 {get; set;}
        public String week_50 {get; set;}
        public String week_51 {get; set;}
        public String week_52 {get; set;}
        public String Trade {get; set;}
        
        // constructor
        public Label(){
            this.setLabels();
        }
        
        // set all week numbers
        private void setLabels(){
            this.Location = 'Location';
            this.Room = 'Room';
            this.Asset = 'System / Assets';
            this.JobType = 'Job Type';
            this.Spec = 'Spec';
            this.week_1 = '1';
            this.week_2 = '2';
            this.week_3 = '3';
            this.week_4 = '4';
            this.week_5 = '5';
            this.week_6 = '6';
            this.week_7 = '7';
            this.week_8 = '8';
            this.week_9 = '9';
            this.week_10 = '10';
            this.week_11 = '11';
            this.week_12 = '12';
            this.week_13 = '13';
            this.week_14 = '14';
            this.week_15 = '15';
            this.week_16 = '16';
            this.week_17 = '17';
            this.week_18 = '18';
            this.week_19 = '19';
            this.week_20 = '20';
            this.week_21 = '21';
            this.week_22 = '22';
            this.week_23 = '23';
            this.week_24 = '24';
            this.week_25 = '25';
            this.week_26 = '26';
            this.week_27 = '27';
            this.week_28 = '28';
            this.week_29 = '29';
            this.week_30 = '30';
            this.week_31 = '31';
            this.week_32 = '32';
            this.week_33 = '33';
            this.week_34 = '34';
            this.week_35 = '35';
            this.week_36 = '36';
            this.week_37 = '37';
            this.week_38 = '38';
            this.week_39 = '39';
            this.week_40 = '40';
            this.week_41 = '41';
            this.week_42 = '42';
            this.week_43 = '43';
            this.week_44 = '44';
            this.week_45 = '45';
            this.week_46 = '46';
            this.week_47 = '47';
            this.week_48 = '48';
            this.week_49 = '49';
            this.week_50 = '50';
            this.week_51 = '51';
            this.week_52 = '52';
            this.Trade = 'Trade';
        }
    }
    
    static testMethod void test_CalendarViewContent() {
        //create business hours
        BusinessHours bH = [select id from businesshours where IsDefault=true];
      
        // create supplier
        FM_Supplier__c supplier = new FM_Supplier__c ();
        supplier.Name = 'TestSupplier';
        insert supplier;
        
        // create location
        FM_Location__c location = new FM_Location__c ();
        location.Name = 'TestLocation';
        location.Midlands_Cluster__c = true;
        insert location;
        
        // create rule
        FM_Service_Level__c rule = new FM_Service_Level__c ();
        rule.Location__c = location.Id;
        rule.Business_Hours_In__c = bH.Id;
        rule.Business_Hours_Out__c = bH.Id;
        rule.Scope__c = 'Cleaning';
        rule.Supplier__c = supplier.Id;
        rule.In_Hours_Acknowledgement_SLA__c = 2.5;
        rule.Out_Hours_Acknowledgement_SLA__c = 5;
        rule.Start_In_Hours__c = 9;
        rule.End_In_Hours__c = 17;
        rule.Priority_Level__c = 'P4';
        insert rule;
        
        // create incident for test
        FM_Incident__c incident = new FM_Incident__c ();
        incident.Location__c = location.Id;
        incident.Subject__c = 'IncidentTitle';
        incident.Description__c = 'IncidentDescription';
        incident.Status__c = 'Supplier Progress';
        incident.Service__c = 'Cleaning';
        incident.Type__c = 'Cleaning';
        incident.Sub_Type__c = 'Cleaning';
        incident.Any_Risk_Applicable__c ='No';
        incident.Raised_By__c = 'TestName';
        incident.Phone__c = '12345';
        incident.Email__c = 'test@test.com';
        incident.Any_Risk_Applicable__c = 'No';
        insert incident;
        
        FM_Job_Type__c jobType = new FM_Job_Type__c();
        jobType.Name = 'TestJobType';
        jobType.Frequency_Number__c = 1;
        jobType.Frequency_Period__c = 'week';
        jobType.Specs_Number__c = '6.16W';
        insert jobType;
        
        FM_Asset__c asset = new FM_Asset__c();
        asset.Location__c = location.Id;
        asset.Name = 'TestAssedCode';
        insert asset;
        
        FM_System__c sys = new FM_System__c();
        sys.Location__c = location.Id;
        sys.Name = 'TestSysCode';
        insert sys;
        
        List<FM_Job_Instance__c> jobInstanceList = new List<FM_Job_Instance__c>();
        for(Integer i = 0; i < 55; i++){
          FM_Job_Instance__c jobInstance = new FM_Job_Instance__c();
          jobInstance.Job_Type__c = jobType.Id;
          jobInstance.Deadline__c = Date.newInstance(System.today().year(), 1, 1) + i*7;
          jobInstance.Status__c = 'Planned';
          jobInstance.Asset__c = asset.Id;
          jobInstanceList.add(jobInstance);
        }
        
        for(Integer i = 0; i < 55; i++){
          FM_Job_Instance__c jobInstance = new FM_Job_Instance__c();
          jobInstance.Job_Type__c = jobType.Id;
          jobInstance.Deadline__c = Date.newInstance(System.today().year(), 1, 1) + i*7;
          jobInstance.Status__c = 'Planned';
          jobInstance.System__c = sys.Id;
          jobInstanceList.add(jobInstance);
        }
        insert jobInstanceList; 
        
        Test.startTest();
          FM_CalendarViewContentController controller = new FM_CalendarViewContentController();
          controller.selectedTimeFrame = 'last_year';
          controller.selectedLocation = location.Id;
          Boolean case1 = controller.showCalendar;
          
          controller.selectedTimeFrame = 'this_year';
          controller.selectedLocation = location.Id;
          Boolean case2 = controller.showCalendar;
          
          controller.selectedTimeFrame = 'next_year';
          controller.selectedLocation = location.Id;
          Boolean case3 = controller.showCalendar;
        Test.stopTest();
    }
}