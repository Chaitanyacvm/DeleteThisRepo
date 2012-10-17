public with sharing class PUD_RoundOverview_Controller {

    public Boolean getRoute { get; set; } 
    public List<PUD_Consignment__c> table { get; set; }
    public List<String> timePostCodes { get; set;}
    public List<String> allInfos{ get; set;}
    
    public Integer numberStops { get; set; }

    public Boolean showStops { get; set; }

    public List<selectOption> soRounds { get; set; }
    public String selectedRound { get; set; }

    public List<selectOption> soColDate { get; set; }

    public String selectedColDate { get; set; }
    
    public String address { get; set; }
    
    private List<Depot__c> depots = new List<Depot__c>();
    public String DepotAddress { get; set; } 
    public MAP<Id, String> depotMap = new MAP<Id, String>();
    public List<selectOption> soDepots { get; set; }
    public String selectedDepot { get; set; }
    
    public List<SObject> rounds = new List<PUD_Round__c>();
    public List<SObject> stops = new List<PUD_Stop__c>();
    
    public String viewState { get; set; }

    public PUD_RoundOverview_Controller(){
        depots = new List<Depot__c>([Select d.Id, d.Street__c, d.Post_Code__c, d.Name, d.Depot_Code__c, d.City__c, d.old_Depot_Code__c, d.Type__c
                                       From Depot__c d
                                      Where d.Type__c = 'Depot'
                                   Order by d.Name]);
        
        // build select option for depots
        soDepots = new List<selectOption>();
        soDepots.add(new SelectOption('0', '--None--'));
        for (Depot__c d : depots){
            depotMap.put(d.Id, d.Depot_Code__c);
            soDepots.add(new SelectOption(d.Id, d.Name));
        }
        
        // build select option Date
        soColDate  = new List<selectOption>();
        soColDate.add(new SelectOption('0', '--None--'));
        
        // set select options rounds
        soRounds = new List<selectOption>();
        soRounds.add(new SelectOption('0', '----'));
        
        // set variables
        //showRounds = false;
        showStops = false;
        numberStops = 0;
        table = new List<PUD_Consignment__c>();
        address = '';
        
        // Google Route
        getRoute = false;
    }
    
    public void getDepots() {
        // set Depot Address
        if(selectedDepot != '0'){
            for (Depot__c d : depots){
                if ( d.Depot_Code__c == depotMap.get(selectedDepot) ){
                    DepotAddress = d.Post_Code__c;
                }
            }
            rounds = new List<PUD_Round__c>([Select p.Round_9__c, p.Round_8__c, p.Round_7__c, p.Round_6__c, p.Round_5__c, p.Round_4__c, p.Round_3__c, p.Round_2__c, p.Round_1__c, p.Round_10__c, p.Part__c, p.Id, p.Depot_Code__c, p.Date__c 
                                               From PUD_Round__c p
                                              Where p.Depot_Code__c =: depotMap.get(selectedDepot)
                                           Order By p.Date__c DESC,
                                                    p.Part__c]);
            // create Date Select Option
            soColDate  = new List<selectOption>();
            soColDate.add(new SelectOption('0', '--None--'));
            Map<Date, Date> dateMap = new Map<Date, Date>();
            for(SObject round : rounds){
        		dateMap.put((Date)round.get('Date__c'), (Date)round.get('Date__c'));
            }
            List<Date> dateList = dateMap.Values();
            dateList.Sort();
            if (dateList.Size() > 0){
                for(Date d : dateList){
                    soColDate.add(new SelectOption(String.ValueOf(d), String.ValueOf(d)));
                }
            } else{
                // set variables
                //showRounds = false;
                showStops = false;
                table.Clear();
                numberStops = 0;
                address = '';
                // error handling
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'There are no rounds available for this depot.'));
            }
        } else{
            // create Date Select Option
            soColDate  = new List<selectOption>();
            soColDate.add(new SelectOption('0', '--None--'));
        }
        selectedColDate = '0';
        // set select options rounds
        soRounds = new List<selectOption>();
        soRounds.add(new SelectOption('0', '----'));
        
        // set variables
        //showRounds = false;
        showStops = false;
        table.Clear();
        numberStops = 0;
        address = '';
    }
    
    public void getRounds() {        
        // create Round Number Select Option
        soRounds = new List<selectOption>();
        soRounds.add(new SelectOption('0', '----'));
        List<String> availableRounds = new List<String>();
        if(rounds.Size() > 0){
            for(SObject round : rounds){
                if(String.ValueOf((Date)round.get('Date__c')) == selectedColDate){
	                for(Integer roundCounter = 1; roundCounter < 11; roundCounter++){
	                    if(round.get('Round_' + roundCounter + '__c') != null){
	                        availableRounds.add(String.ValueOf(round.get('Round_' + roundCounter + '__c')));
	                    }
	                }
            	}
            }
        } else{
            // error handling
        }
        for(String availableRound : availableRounds){
            soRounds.add(new SelectOption(availableRound, availableRound));
        }
        selectedRound = '0';
        showStops = false;
        // set variables
        //showRounds = false;
        showStops = false;
        table.Clear();
        numberStops = 0;
        address = '';
    }
        
    public void getStops() {
        if((selectedRound != null && selectedRound != '0') && selectedDepot != null && (selectedColDate != null && selectedColDate != '0')){
            Date d = Date.ValueOf(selectedColDate);
            stops = new List<PUD_Stop__c>([Select p.Round__c, p.Part__c, p.Info_9__c, p.Info_8__c, p.Info_7__c, p.Info_6__c, p.Info_5__c, p.Info_4__c, p.Info_3__c, p.Info_2__c, p.Info_1__c, p.Info_10__c, p.Id, p.Depot_Code__c, p.Date__c 
                                             From PUD_Stop__c p
                                            Where Round__c =: selectedRound
                                              And Depot_Code__c =: depotMap.get(selectedDepot)
                                              And Date__c =: d
                                         Order By Part__c]);
        }
        table = new List<PUD_Consignment__c>();
        timePostCodes = new List<String>();
        Integer stopNumber = 0;
        if( stops.Size() > 0){
            for(SObject stop : stops){
                for(Integer infoCounter = 1; infoCounter < 11; infoCounter++){
                    if(stop.get('Info_' + infoCounter + '__c') != null){
                        timePostCodes.add(String.ValueOf(stop.get('Info_' + infoCounter + '__c')));
                    }
                }
            } 
            timePostCodes.Sort();
            Integer counter = 0;
            for(String timePostcode : timePostCodes){
                String postcode = timePostcode.SubString(6, timePostcode.indexOf(',', 6));
                viewstate = postcode;
                if(counter + 1 < timePostcodes.Size()){
                    System.Debug('===> counter: ' + counter);
                    System.Debug('===> postcode: ' + postcode);
                    System.Debug('===> timePostcode: ' + timePostcode);
                    if(postcode == timePostCodes.get(counter + 1).SubString(6, timePostCodes.get(counter + 1).indexOf(',', 6))){
                        System.Debug('===> continue');
                        counter++;
                        continue;
                    } else{
                        List<String> splitInfo = timePostcode.Split(',', 3);
                        if(splitInfo.Size() >= 3){
                            PUD_Consignment__c row = new PUD_Consignment__c();
                            row.Stop_No_RO__c = String.ValueOf(stopNumber + 1);
                            row.Time_Text__c = splitInfo.get(0);
                            row.Post_Code__c = formatPostcode(splitInfo.get(1));
                            row.Company__c = splitInfo.get(2);
                            table.add(row);
                            stopNumber++;
                        } 
                    }
                }else{
                    List<String> splitInfo = timePostcode.Split(',', 3);
                    viewState = viewState + ' ' + splitInfo.Size();
                    if(splitInfo.Size() >= 3){
                        PUD_Consignment__c row = new PUD_Consignment__c();
                        row.Stop_No_RO__c = String.ValueOf(stopNumber + 1);
                        row.Time_Text__c = splitInfo.get(0);
                        row.Post_Code__c = formatPostcode(splitInfo.get(1));
                        row.Company__c = splitInfo.get(2);
                        table.add(row);
                        stopNumber++;
                    }
                }
                counter++;
            }
            numberStops = stopNumber;
            showStops = true;
            getRoute = true;
            address = '';
            Integer rowCount = 0;
            Set<Integer> intToDelete = new Set<Integer>();
            for(PUD_Consignment__c row : table){
                if(row.Post_Code__c != null){
                    address = address + row.Post_Code__c + '--';
                } else{
                    intToDelete.add(rowCount);
                }
                rowCount++;
            }
            for(Integer i : intToDelete){
                table.remove(i);
            }
        } else{
            // set variables
            //showRounds = false;
            showStops = false;
            table.Clear();
            numberStops = 0;
            address = '';
            // error handling
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'There are no stops for this Round on this date.'));
        }
    }
    public String formatPostcode(String thePostcode){
        thePostcode = thePostcode.ReplaceAll(' ', '').toUpperCase();
        if (thePostcode.Length() == 5){
            thePostcode = thePostcode.substring(0, 2) + ' ' + thePostcode.substring(2, 5);
        }
        else if (thePostcode.Length() == 6){
            thePostcode = thePostcode.substring(0, 3) + ' ' + thePostcode.substring(3, 6);
        } 
        else if (thePostcode.Length() == 7){
            thePostcode = thePostcode.substring(0, 4) + ' ' + thePostcode.substring(4, 7);
        } else{
            return null;
        }
        //viewstate = viewstate + thePostcode;
        return thePostcode;
    }
    // tests
    TestMethod static void test_controllerRoundOverview() {
        // create depot
        Depot__c depot = new Depot__c();
        try{
        	depot = [Select Id From Depot__c Where Depot_Code__c = 'ABZ'];
        } catch (Exception e){
        	depot = new Depot__c();
        	depot.Depot_Code__c = 'ABZ';
            depot.Name = 'TEST';
            depot.Type__c = 'Depot';
            insert depot;
        }
        // create stops
        List<PUD_Stop__c> stops = new List<PUD_Stop__c>();
        for(Integer i = 0; i < 5; i++){
            PUD_Stop__C stop = new PUD_Stop__c();
            stop.Date__c = System.Today();
            stop.Depot_Code__c = 'ABZ';
            stop.Round__c = '111';
            stop.Part__c = i;
            stop.Info_1__c = '11:30,N' + String.ValueOf(Math.mod(i,3)) + 'ABZ,TESTCOMPANY';
            stop.Info_2__c = '11:30,N' + String.ValueOf(Math.mod(i,3)) + 'A3Z,TESTCOMPANY';
            stops.add(stop);
        }
        insert stops;
        Test.StartTest();
        PUD_RoundOverview_Controller cont = new PUD_RoundOverview_Controller();
        cont.selectedDepot = depot.Id;
        cont.getDepots();
        cont.selectedColDate = String.ValueOf(System.Today());
        cont.getRounds();
        cont.selectedRound = '111';
        cont.getStops();
        Test.StopTest();
    }
}