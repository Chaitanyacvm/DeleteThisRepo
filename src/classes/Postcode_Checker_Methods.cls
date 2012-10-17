public class Postcode_Checker_Methods 
{
    public static GBMailer_Service.GBPortalWSSoap wsCall = new GBMailer_Service.GBPortalWSSoap();
    public static GBMailer_Service.AcceleratorSearchReturn results;
    public static String sessionId;
    public Enum itemMapKeys { SID, ISOC, PCOD, TOWN, BNUM, THOR }
    
    public static LIST<MAP<String, String>> getAddresses(String postcode) 
    {
        GBMailer_Service.AcceleratorAddress searchAddress = new GBMailer_Service.AcceleratorAddress();
        searchAddress.text = postcode;
        LIST<MAP<String, String>> addresses = new LIST<MAP<String, String>>();
        
        sessionId = createSession();
        results = callGBMailerService(sessionId, postcode);
        System.debug('===> results = ' + results);
        addresses = splitAddress(results);
        
        return addresses;
    }

    public static LIST<MAP<String, String>> getAddressesInternational( Map<String, String> itemMap ) 
    {
        //GBMailer_Service.AcceleratorAddress searchAddress = new GBMailer_Service.AcceleratorAddress();
        //searchAddress.text = postcode;
        LIST<MAP<String, String>> addresses = new LIST<MAP<String, String>>();
        
        itemMap.put( itemMapKeys.SID.Name(), createSession() );
        
        if ( itemMap.get( itemMapKeys.ISOC.Name() ) == 'GBR' )
            results = callGBMailerService( itemMap.get( itemMapKeys.SID.Name() ), itemMap.get( itemMapKeys.PCOD.Name() ) );
        else
            results = callGBMailerServiceFind( itemMap );
        System.debug('===> results = ' + results);
        addresses = splitAddress(results);
        
        return addresses;
    }
        
    public static String createSession()
    {
        return wsCall.CreateSession();
    }
    
    public static GBMailer_Service.AcceleratorSearchReturn callGBMailerService(String sId, String pc)
    {
        return wsCall.Pinpoint('WS-AcceleratorNames', sId, 'EHissett@tnt.com', 'TNTpkms12!', pc, '', 'Three address lines, town, county and postcode', '', 0, 1000);
    }

/*
    public static LIST<MAP<String, String>> getAddressesInternational(String postcode) 
    {
        GBMailer_Service.AcceleratorAddress searchAddress = new GBMailer_Service.AcceleratorAddress();
        searchAddress.text = postcode;
        LIST<MAP<String, String>> addresses = new LIST<MAP<String, String>>();
        
        sessionId = createSession();
        results = callGBMailerServiceFind(sessionId, postcode);
        System.debug('===> results = ' + results);
        addresses = splitAddress(results);
        
        return addresses;
    }
    
    public static GBMailer_Service.AcceleratorSearchReturn callGBMailerServiceFind( String sId, String pc )
    {
        GBMailer_Service.AcceleratorAddress structSearchCriteria = new GBMailer_Service.AcceleratorAddress();        
        structSearchCriteria.Items = new GBMailer_Service.ArrayOfAcceleratorItem();
        structSearchCriteria.Items.AcceleratorItem = new GBMailer_Service.AcceleratorItem[3];
        structSearchCriteria.Items.AcceleratorItem[0] = new GBMailer_Service.AcceleratorItem();
        structSearchCriteria.Items.AcceleratorItem[0].Key = 'ISOC';
        structSearchCriteria.Items.AcceleratorItem[0].Value = 'DEU';
        
        structSearchCriteria.Text = '53804 Much, Strunkhausen';
        
        structSearchCriteria.Items.AcceleratorItem[1] = new GBMailer_Service.AcceleratorItem();
        structSearchCriteria.Items.AcceleratorItem[1].Key = 'TOWN';
        structSearchCriteria.Items.AcceleratorItem[1].Value = 'Much';
        
        structSearchCriteria.Items.AcceleratorItem[2] = new GBMailer_Service.AcceleratorItem();
        structSearchCriteria.Items.AcceleratorItem[2].Key = 'PCOD';
        structSearchCriteria.Items.AcceleratorItem[2].Value = '53804';

        return wsCall.Find('WS-AcceleratorInternationalB', sId, 'NDavis@tnteval.com', 'TNTpkms12!', structSearchCriteria, 'Three address lines, town, county and postcode', '', '', 0, 100);
    }
*/
    
    public static GBMailer_Service.AcceleratorSearchReturn callGBMailerServiceFind( Map<String, String> itemMap )
    /************************************************************************************************************
    * CHANGES
    * 2011/01/11 - Makepositive - Technical Architect - Florian Hoehn - +44 (0)20 7928 1497
    *************************************************************************************************************
    * PARAMETER
    * itemMap
    *                 KEY       |         VALUE/DESCRIPTION
    *           ------------------------------------------------
    *               SID         |       Session Id
    *               ISOC        |       Countrycode
    *               PCOD        |       Postcode
    *               TOWN        |       Town
    *               BNUM        |       Building Number
    *               THOR        |       Street Name
    *               ...
    *************************************************************************************************************
    * DESCRIPTION
    *       this method returns a list of addresses for the given search criteria ( itemMap ). 
    *       Depending on the country there have to be different packages that have to be used.
    *
    * PACKAGES
    *         WS-AcceleratorNames            - UK postcode checker
    *         WS-AcceleratorInternationalB   - International address & postcode validation
    *
    * COUNTRY CODES
    *         http://en.wikipedia.org/wiki/ISO_3166-1 - ( 3-digit codes )
    ************************************************************************************************************/ 
    {
        // initialisation
        GBMailer_Service.AcceleratorAddress structSearchCriteria = new GBMailer_Service.AcceleratorAddress();        
        structSearchCriteria.Items = new GBMailer_Service.ArrayOfAcceleratorItem();
        structSearchCriteria.Items.AcceleratorItem = new GBMailer_Service.AcceleratorItem[ itemMap.size() ];
        Integer i = 0;
        
        // loop over search criteria map ( itemMap )
        for ( String key : itemMap.KeySet() )
        {
            structSearchCriteria.Items.AcceleratorItem[i] = new GBMailer_Service.AcceleratorItem();
            structSearchCriteria.Items.AcceleratorItem[i].Key = key;
            structSearchCriteria.Items.AcceleratorItem[i].Value = itemMap.get( key );
            i++;
        }
        
        // debugging
        System.Debug( '===> ' + itemMap );
        System.Debug( '===> ' + structSearchCriteria );
        
        // call & return the webservice response
        return wsCall.Find('WS-AcceleratorInternationalB', itemMap.get( itemMapKeys.SID.Name() ), 'NDavis@tnteval.com', 'TNTpkms12!', structSearchCriteria, 'Three address lines, town, county and postcode', '', '', 0, 100);
    }
    
    public static LIST<MAP<String, String>> splitAddress(GBMailer_Service.AcceleratorSearchReturn sreturn)
    {
        try {
            LIST<MAP<String, String>> addresses = new LIST<MAP<String, String>>();
            MAP<String, Boolean> existingNumbers = new MAP<String, Boolean>();
            
            for (GBMailer_Service.AcceleratorAddress address : sreturn.Addresses.AcceleratorAddress) 
            {
                GBMailer_Service.ArrayOfAcceleratorItem items = address.Items;
                MAP<String, String> addressItems = new MAP<String, String>();
                
                if (existingNumbers.get(address.Text) == null){
                    for (GBMailer_Service.AcceleratorItem item : items.AcceleratorItem) {
                        addressItems.put(item.Key, item.Value);
                    }
                    
                    existingNumbers.put(address.Text, TRUE);
                    system.debug('==> addressItems ' + addressItems);
                    addresses.add(addressItems);
                } 
            }
            
            return addresses;
        } catch (Exception ex) {
            return null;
        }
    }
    
    // Tests   
    static testMethod void testThis() 
    {
        LIST<MAP<String, String>> AdressesList = new LIST<MAP<String, String>>();
        GBMailer_Service.AcceleratorSearchReturn res = new GBMailer_Service.AcceleratorSearchReturn();
        GBMailer_Service.ArrayOfAcceleratorAddress Addresses = new GBMailer_Service.ArrayOfAcceleratorAddress();
        List<GBMailer_Service.AcceleratorAddress> addressList = new List<GBMailer_Service.AcceleratorAddress>();
        GBMailer_Service.AcceleratorAddress Address = new GBMailer_Service.AcceleratorAddress();
        GBMailer_Service.ArrayOfAcceleratorItem items = new GBMailer_Service.ArrayOfAcceleratorItem();
        List<GBMailer_Service.AcceleratorItem> itemList = new List<GBMailer_Service.AcceleratorItem>();
        GBMailer_Service.AcceleratorItem item = new GBMailer_Service.AcceleratorItem();
        item.Key = 'ORGN';
        item.Value = 'ACCLAIM EVENTS LTD';
        itemList.add(item);
        item.Key = 'BNUM';
        item.Value = '16';
        itemList.add(item);
        item.Key = 'THOR';
        item.Value = 'GREAT GUILDFORD STREET';
        itemList.add(item);
        item.Key = 'TOWN';
        item.Value = 'LONDON';
        itemList.add(item);        
        item.Key = 'PCOD';
        item.Value = 'SE1 0HS';
        itemList.add(item);        
        item.Key = 'DPTS';
        item.Value = '6BM';
        itemList.add(item);        
        
        items.AcceleratorItem = itemList;
        
        Address.Text = 'Acclaim Events Ltd 16 Great Guildford Street  LONDON  SE1 0HS';
        Address.Items = items;
        AddressList.add(Address);
        
        Addresses.AcceleratorAddress = AddressList;
        
        res.Status = 'Success';
        res.Remarks = 'remarks';
        res.Addresses = Addresses;
        
        Postcode_Checker_Methods.splitAddress(res);
        Postcode_Checker_Methods.results = res;
        Postcode_Checker_Methods.sessionId = '1';
        AdressesList = Postcode_Checker_Methods.getAddresses('SE1 0HS');
        System.assertNotEquals(null, AdressesList);
    }
}