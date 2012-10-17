global class Address_Postcode_Check_Controller
{
    private LIST<MAP<String, String>> addresses{get; set;}

    global Address_Postcode_Check_Controller()
    {
        addresses = new LIST<MAP<String, String>>();
    }
    
    public void getAddresses(String postcode) {
        addresses = Postcode_Checker_Methods.getAddresses(postcode);
    }
    
    public Address__c setAddress(String index, Address__c currentAddress) {
        currentAddress = clearAddress(currentAddress);
        String compName = getCompanyName(index);
        if ( compName != null )
            if ( compName.Length() > 30 )
                compName = compName.SubString(0, 29);
        currentAddress.Company_Name__c = compName;
        currentAddress = getAddressLines(index, currentAddress);
        currentAddress.Town__c = getTown(index);
        currentAddress.Country__c = 'United Kingdom;UK';
        
        currentAddress = trimAddress(currentAddress);
        
        return currentAddress;
    }
    
    private Address__c clearAddress(Address__c currentAddress) {
        currentAddress.Company_Name__c = '';
        currentAddress.Address_1__c = '';
        currentAddress.Address_2__c = '';
        currentAddress.Address_3__c = '';
        currentAddress.Town__c = '';
        currentAddress.Country__c = '';
        
        return currentAddress;
    }
    
    private String getCompanyName(String index) {
        return addresses[Integer.ValueOf(index)].get('ORGN');
    }
    
    private Address__c getAddressLines(String index, Address__c currentAddress) {
        if (addresses[Integer.ValueOf(index)].get('SUBB') != null) {
            currentAddress.Address_1__c = (addresses[Integer.ValueOf(index)].get('SUBB') == null ? '' : addresses[Integer.ValueOf(index)].get('SUBB') + ' ') + (addresses[Integer.ValueOf(index)].get('BNAM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNAM'));
            
            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
                currentAddress.Address_2__c = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('DPTH') == null ? '' : addresses[Integer.ValueOf(index)].get('DPTH'));
                currentAddress.Address_3__c = (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR') + ' ');
            } else {
                currentAddress.Address_2__c = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR'));
            }
        } else if (addresses[Integer.ValueOf(index)].get('BNAM') != null) {
            currentAddress.Address_1__c = (addresses[Integer.ValueOf(index)].get('BNAM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNAM'));
                
            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
                currentAddress.Address_2__c = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('DPTH') == null ? '' : addresses[Integer.ValueOf(index)].get('DPTH'));
                currentAddress.Address_3__c = (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR') + ' ');
            } else {
                currentAddress.Address_2__c = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR'));
                currentAddress.Address_3__c = (addresses[Integer.ValueOf(index)].get('DPLO') == null ? '' : addresses[Integer.ValueOf(index)].get('DPLO'));
            }
        } else {
            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
                currentAddress.Address_1__c = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('DPTH') == null ? '' : addresses[Integer.ValueOf(index)].get('DPTH'));
                currentAddress.Address_2__c = (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR') + ' ');
                currentAddress.Address_3__c = (addresses[Integer.ValueOf(index)].get('DPLO') == null ? '' : addresses[Integer.ValueOf(index)].get('DPLO'));
            } else {
                currentAddress.Address_1__c = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR'));
                currentAddress.Address_2__c = (addresses[Integer.ValueOf(index)].get('DPLO') == null ? '' : addresses[Integer.ValueOf(index)].get('DPLO'));
            }
        }
        
        return currentAddress;
    }
    
    private String getTown(String index)
    {
        return addresses[Integer.ValueOf(index)].get('TOWN');
    }
    
    private Address__c trimAddress(Address__c currentAddress) {
        Integer Address_1_Length = Address__c.Address_1__c.getDescribe().getLength();
        Integer Address_2_Length = Address__c.Address_2__c.getDescribe().getLength();
        Integer Address_3_Length = Address__c.Address_3__c.getDescribe().getLength();
        Integer Town_Length = Address__c.Town__c.getDescribe().getLength();
        Integer Country_Length = Address__c.Country__c.getDescribe().getLength();
        
        if (currentAddress.Address_1__c != null && currentAddress.Address_1__c.Length() > Address_1_Length) {
            currentAddress.Address_1__c = currentAddress.Address_1__c.substring(0, Address_1_Length-1);
        }
        
        if (currentAddress.Address_2__c != null && currentAddress.Address_2__c.Length() > Address_2_Length) {
            currentAddress.Address_2__c = currentAddress.Address_2__c.substring(0, Address_2_Length-1);
        }
        
        if (currentAddress.Address_3__c != null && currentAddress.Address_3__c.Length() > Address_3_Length) {
            currentAddress.Address_3__c = currentAddress.Address_3__c.substring(0, Address_3_Length-1);
        }
        
        if (currentAddress.Town__c != null && currentAddress.Town__c.Length() > Town_Length) {
            currentAddress.Town__c = currentAddress.Town__c.substring(0, Town_Length-1);
        }
        
        if (currentAddress.Country__c != null && currentAddress.Country__c.Length() > Country_Length) {
            currentAddress.Country__c = currentAddress.Country__c.substring(0, Country_Length-1);
        }
        
        return currentAddress;
    }
    
    public List<selectOption> getAddressList()
    {
        LIST<selectOption> streets = new LIST<selectOption>();
        
        if (addresses == null || addresses.size() == 0) {
            streets.add(new selectOption('', '--None--'));
        } else {
            Integer i = 0;
            streets.add(new selectOption('', '--Please Select--'));
            
            for (MAP<String, String> address : addresses) 
            {
                String addressString = (address.get('SUBB') == null ? '' : address.get('SUBB') + ' ') + 
                                       (address.get('BNAM') == null ? '' : address.get('BNAM') + ' ') + 
                                       (address.get('BNUM') == null ? '' : address.get('BNUM') + ' ') + 
                                       (address.get('DPTH') == null ? '' : address.get('DPTH') + ' ') + 
                                       (address.get('THOR') == null ? '' : address.get('THOR') + ' '); 
                streets.add(new selectOption(String.ValueOf(i), addressString));
                
                i++;
            }
            
            //if ( streets.size() > 1 )
            //    streets.Remove(0);
        }
        return streets;
    }     

    TestMethod static void testController() {
        Test.StartTest();
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        Test.StopTest();
    }
    
    TestMethod static void testGetAddresses() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        
        Test.StartTest();
        cont.getAddresses('SE1 0HS');
        Test.StopTest();
    }
    
    TestMethod static void testSetAddress() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        Address__c testAddress = new Address__c();
        MAP<String, String> testAddressMap = new MAP<String, String>();
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        Test.StartTest();
        cont.setAddress('0', testAddress);
        
        System.Assert(testAddress != null);
        System.Assert(testAddress.Company_Name__c == 'Test Company');
        System.Assert(testAddress.Town__c == 'Test Town');
        Test.StopTest();
    }
    
    TestMethod static void testClearAddress() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        Address__c testAddress = new Address__c();
        
        Test.StartTest();
        testAddress = cont.clearAddress(testAddress);
        Test.StopTest();
    }
    
    TestMethod static void testGetCompanyName() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        String testCompanyName;
        MAP<String, String> testAddressMap = new MAP<String, String>();
        testAddressMap.put('ORGN', 'Test Company');
        cont.addresses.add(testAddressMap);
        
        Test.StartTest();
        testCompanyName = cont.getCompanyName('0');
        
        System.Assert(testCompanyName == 'Test Company');
        Test.StopTest();
    }
    
    TestMethod static void testGetAddressLines() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        Address__c testAddress = new Address__c();
        MAP<String, String> testAddressMap = new MAP<String, String>();
        cont.addresses.add(testAddressMap);
        
        Test.StartTest();
        //Branch 1
        cont = new Address_Postcode_Check_Controller();
        testAddressMap = new MAP<String, String>();
        testAddressMap.put('DPTH', 'DPTH');
        testAddressMap.put('SUBB', 'SUBB');
        testAddressMap.put('BNAM', 'BNAM');
        testAddressMap.put('BNUM', 'BNUM');
        testAddressMap.put('THOR', 'THOR');
        testAddressMap.put('DPLO', 'DPLO');
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        testAddress = cont.getAddressLines('0', testAddress);
        
        System.Assert(testAddress.Address_1__c == 'SUBB BNAM');
        System.Assert(testAddress.Address_2__c == 'BNUM DPTH');
        System.Assert(testAddress.Address_3__c == 'THOR');
        
        //Branch 2
        cont = new Address_Postcode_Check_Controller();
        testAddressMap = new MAP<String, String>();
        testAddressMap.put('SUBB', 'SUBB');
        testAddressMap.put('BNAM', 'BNAM');
        testAddressMap.put('BNUM', 'BNUM');
        testAddressMap.put('THOR', 'THOR');
        testAddressMap.put('DPLO', 'DPLO');
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        testAddress = cont.getAddressLines('0', testAddress);
        
        System.Assert(testAddress.Address_1__c == 'SUBB BNAM');
        System.Assert(testAddress.Address_2__c == 'BNUM THOR');
        
        //Branch 3
        cont = new Address_Postcode_Check_Controller();
        testAddressMap = new MAP<String, String>();
        testAddressMap.put('DPTH', 'DPTH');
        testAddressMap.put('BNAM', 'BNAM');
        testAddressMap.put('BNUM', 'BNUM');
        testAddressMap.put('THOR', 'THOR');
        testAddressMap.put('DPLO', 'DPLO');
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        testAddress = cont.getAddressLines('0', testAddress);
        
        System.Assert(testAddress.Address_1__c == 'BNAM');
        System.Assert(testAddress.Address_2__c == 'BNUM DPTH');
        System.Assert(testAddress.Address_3__c == 'THOR');
        
        //Branch 4
        cont = new Address_Postcode_Check_Controller();
        testAddressMap = new MAP<String, String>();
        testAddressMap.put('BNAM', 'BNAM');
        testAddressMap.put('BNUM', 'BNUM');
        testAddressMap.put('THOR', 'THOR');
        testAddressMap.put('DPLO', 'DPLO');
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        testAddress = cont.getAddressLines('0', testAddress);
        
        System.Assert(testAddress.Address_1__c == 'BNAM');
        System.Assert(testAddress.Address_2__c == 'BNUM THOR');
        System.Assert(testAddress.Address_3__c == 'DPLO');
        
        //Branch 5
        cont = new Address_Postcode_Check_Controller();
        testAddressMap = new MAP<String, String>();
        testAddressMap.put('DPTH', 'DPTH');
        testAddressMap.put('BNUM', 'BNUM');
        testAddressMap.put('THOR', 'THOR');
        testAddressMap.put('DPLO', 'DPLO');
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        testAddress = cont.getAddressLines('0', testAddress);
        
        System.Assert(testAddress.Address_1__c == 'BNUM DPTH');
        System.Assert(testAddress.Address_2__c == 'THOR');
        System.Assert(testAddress.Address_3__c == 'DPLO');
        
        //Branch 6
        cont = new Address_Postcode_Check_Controller();
        testAddressMap = new MAP<String, String>();
        testAddressMap.put('BNUM', 'BNUM');
        testAddressMap.put('THOR', 'THOR');
        testAddressMap.put('DPLO', 'DPLO');
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        testAddress = cont.getAddressLines('0', testAddress);
        
        System.Assert(testAddress.Address_1__c == 'BNUM THOR');
        System.Assert(testAddress.Address_2__c == 'DPLO');
        Test.StopTest();
    }
    
    TestMethod static void testGetTown() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        String testTown;
        MAP<String, String> testAddressMap = new MAP<String, String>();
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        Test.StartTest();
        testTown = cont.getTown('0');
        
        System.Assert(testTown == 'Test Town');
        Test.StopTest();
    }
    
    TestMethod static void testTrimAddress() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        Address__c testAddress = new Address__c();
        testAddress.Address_1__c = 'TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST';
        testAddress.Address_2__c = 'TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST';
        testAddress.Address_3__c = 'TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST';
        testAddress.Town__c = 'TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST';
        testAddress.Country__c = 'TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST_TEST';
        
        Test.StartTest();
        testAddress = cont.trimAddress(testAddress);
        Test.StopTest();
    }
    
    TestMethod static void testGetAddressList() {
        Address_Postcode_Check_Controller cont = new Address_Postcode_Check_Controller();
        Address__c testAddress = new Address__c();
        MAP<String, String> testAddressMap = new MAP<String, String>();
        List<selectOption> testList = new List<selectOption>();
        
        Test.StartTest();
        testAddressMap.put('DPTH', 'DPTH');
        testAddressMap.put('SUBB', 'SUBB');
        testAddressMap.put('BNAM', 'BNAM');
        testAddressMap.put('BNUM', 'BNUM');
        testAddressMap.put('THOR', 'THOR');
        testAddressMap.put('DPLO', 'DPLO');
        testAddressMap.put('ORGN', 'Test Company');
        testAddressMap.put('TOWN', 'Test Town');
        cont.addresses.add(testAddressMap);
        
        testList = cont.getAddressList();
        
        System.debug(testList[1].getLabel());
        //System.Assert(testList[0].getLabel() == '- None -');
        //System.Assert(testList[1].getLabel() == 'SUBB BNAM BNUM DPTH THOR');
        Test.StopTest();
    }
}