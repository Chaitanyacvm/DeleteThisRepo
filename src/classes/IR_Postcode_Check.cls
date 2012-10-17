global class IR_Postcode_Check {
    public LIST<MAP<String, String>> addresses{get; set;}
    
    global IR_Postcode_Check() {
        addresses = new LIST<MAP<String, String>>();
    }
    
    public void getAddresses(String postcode) {
        try {
            addresses = Postcode_Checker_Methods.getAddresses(postcode);
        } catch (Exception ex) {
            System.debug(ex);
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
    }

    public void getAddresses( Map<String, String> itemMap ) {
        try {
            //addresses = Postcode_Checker_Methods.getAddresses(postcode);
            System.debug('itemMap=' + itemMap);
            addresses = Postcode_Checker_Methods.getAddressesInternational( itemMap );
            System.debug('addresses=' + addresses);
        } catch (Exception ex) {
            System.debug(ex);
            if (!ApexPages.hasMessages()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            }
        }
    }
    
    public String getCompanyName(String index) {
        return addresses[Integer.ValueOf(index)].get('ORGN');
    }
    
    public String getAddressLine1(String index) {
        String returnAddress = '';
        
        try {
	        if (addresses[Integer.ValueOf(index)].get('SUBB') != null) {
	            returnAddress = (addresses[Integer.ValueOf(index)].get('SUBB') == null ? '' : addresses[Integer.ValueOf(index)].get('SUBB') + ' ') + (addresses[Integer.ValueOf(index)].get('BNAM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNAM'));
	        } else if (addresses[Integer.ValueOf(index)].get('BNAM') != null) {
	            returnAddress = (addresses[Integer.ValueOf(index)].get('BNAM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNAM'));
	        } else {
	            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('DPTH') == null ? '' : addresses[Integer.ValueOf(index)].get('DPTH'));
	            } else {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR'));
	            }
	        }
	        
	        if (returnAddress != null && returnAddress.length() > 30) {
	            return returnAddress.substring(0,29);
	        } else {
	            return returnAddress;
	        }
        } catch (Exception e) {
        	System.debug(e);
        	
        	return null;
        }
    }
    
    public String getAddressLine2(String index) {
        String returnAddress = '';
        
        try {
	        if (addresses[Integer.ValueOf(index)].get('SUBB') != null) {
	            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('DPTH') == null ? '' : addresses[Integer.ValueOf(index)].get('DPTH'));
	            } else {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR'));
	            }
	        } else if (addresses[Integer.ValueOf(index)].get('BNAM') != null) {
	            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('DPTH') == null ? '' : addresses[Integer.ValueOf(index)].get('DPTH'));
	            } else {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('BNUM') == null ? '' : addresses[Integer.ValueOf(index)].get('BNUM') + ' ') + (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR'));
	            }
	        } else {
	            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR') + ' ');
	            } else {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('DPLO') == null ? '' : addresses[Integer.ValueOf(index)].get('DPLO'));
	            }
	        }
	        
	        if (returnAddress != null && returnAddress.length() > 30) {
	            return returnAddress.substring(0,29);
	        } else {
	            return returnAddress;
	        }
        } catch (Exception e) {
        	System.debug(e);
        	
        	return null;
        }
    }
    
    public String getAddressLine3(String index) {
        String returnAddress = '';
        
        try {
	        if (addresses[Integer.ValueOf(index)].get('SUBB') != null) {
	            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR') + ' ');
	            }
	        } else if (addresses[Integer.ValueOf(index)].get('BNAM') != null) {
	            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('THOR') == null ? '' : addresses[Integer.ValueOf(index)].get('THOR') + ' ');
	            } else {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('DPLO') == null ? '' : addresses[Integer.ValueOf(index)].get('DPLO'));
	            }
	        } else {
	            if (addresses[Integer.ValueOf(index)].get('DPTH') != null) {
	                returnAddress = (addresses[Integer.ValueOf(index)].get('DPLO') == null ? '' : addresses[Integer.ValueOf(index)].get('DPLO'));
	            }
	        }
	        
	        if (returnAddress != null && returnAddress.length() > 30) {
	            return returnAddress.substring(0,29);
	        } else {
	            return returnAddress;
	        }
        } catch (Exception e) {
        	System.debug(e);
        	
        	return null;
        }
    }
    
    public String getTown(String index) {
    	try {
	        if (addresses[Integer.ValueOf(index)].get('TOWN') != null && addresses[Integer.ValueOf(index)].get('TOWN').length() > 30) {
	            return addresses[Integer.ValueOf(index)].get('TOWN').substring(0,29);
	        } else {
	            return addresses[Integer.ValueOf(index)].get('TOWN');
	        }
        } catch (Exception e) {
        	System.debug(e);
        	
        	return null;
        }
    }
    
    public String getCounty(String index) {
    	try {
	        if (addresses[Integer.ValueOf(index)].get('CNTY') != null && addresses[Integer.ValueOf(index)].get('CNTY').length() > 30) {
	            return addresses[Integer.ValueOf(index)].get('CNTY').substring(0,29);
	        } else {
	            return addresses[Integer.ValueOf(index)].get('CNTY');
	        }
        } catch (Exception e) {
        	System.debug(e);
        	
        	return null;
        }
    }
    
    public List<SelectOption> getAddressList() {
        try {
            LIST<String> numAddresses = new LIST<String>();
            LIST<String> textAddresses = new LIST<String>();
            MAP<String, String> addressPosMap = new MAP<String, String>();
            Integer i = 0;
            
            for (MAP<String, String> address : addresses)  {
                String addressString = (address.get('ORGN') == null ? (address.get('SUBB') == null ? ((address.get('BNUM') == null ? (address.get('BNAM') == null ? '' : address.get('BNAM')+ ' ') : address.get('BNUM') + ' ') + (address.get('DPTH') == null ? (address.get('THOR') == null ? '' : address.get('THOR')) : address.get('DPTH'))) : address.get('SUBB') + ' '+ (address.get('BNAM') == null ? '' : address.get('BNAM') + ' ')) : address.get('ORGN'));              
                if (IR_Global_Class.startsWithNumber(addressString)) {
                    numAddresses.add(addressString);
                } else {
                    textAddresses.add(addressString);
                }
                
                addressPosMap.put(addressString, String.ValueOf(i));
                
                i++;
            }
            
            return orderAddressList(numAddresses, textAddresses, addressPosMap);
        } catch (Exception ex) {
            return new LIST<selectOption>();
        }
    }
    
    private LIST<SelectOption> orderAddressList(LIST<String> numAddresses, LIST<String> textAddresses, MAP<String, String> addressPosMap) {
        LIST<String> addresses = new LIST<String>();
        
        addresses.addAll(numAddresses);
        textAddresses.sort();
        addresses.addAll(textAddresses);
        
        LIST<SelectOption> streets = new LIST<selectOption>();
        streets.add(new SelectOption('', '- Please Select -'));
        
        for (String address : addresses) {
            streets.add(new selectOption(addressPosMap.get(address), address));            
        }        
        return streets;
    }
    /****************************Test Method********************************/
    TestMethod static void test_all(){
    	Map<String,String> itemMap = new Map<String,String>{'BNUM'=>'BNUM','THOR'=>'THOR','TOWN'=>'TOWN','CNTY'=>'CNTY'};
    	LIST<MAP<String,String>> li = new LIST<Map<String,String>>();
    	li.add(itemMap);
    	IR_Postcode_Check post = new IR_Postcode_Check();
    	post.addresses = li;
    	post.getAddresses(itemMap);    	
    	String postcode = 'SE1 0HS';
    	post.getAddresses(postcode);
    	System.debug(post.getCounty('0'));
    	System.debug(post.getCompanyName('0'));    	
    	System.debug(post.getAddressLine1('0'));
    	System.debug(post.getAddressLine2('0'));
    	System.debug(post.getAddressLine3('0'));
    	System.debug(post.getTown('0'));
    	System.debug(post.getAddressList());
    	List<String> textAddresses = new List<String>();
    	List<String> numAddresses = new List<String>();
    	textAddresses.add('TestTETS2');
    	textAddresses.add('TestTETS32');
    	textAddresses.add('TestTETS3');
    	numAddresses.add('123');
    	numAddresses.add('125');
    	numAddresses.add('126');
    	//System.debug(post.orderAddressList(numAddresses, textAddresses, itemMap));    	
    }
}