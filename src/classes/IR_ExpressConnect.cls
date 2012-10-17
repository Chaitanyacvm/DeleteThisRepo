public class IR_ExpressConnect {
    public static IR_Global_Class.RateCheckResult rateCheck(IR_Global_Class.RateCheckRequest request, Boolean dom) {
        String requestXML = rateCheck_generateRequest(request, dom);
        System.debug('requestXML=' + requestXML);
        
        HttpResponse res;
        String responseXML;
        IR_Global_Class.RateCheckResult result;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://iConnection.tnt.com/Pricegate.asp');
        //req.setEndpoint('https://164.39.122.230/Pricegate.asp');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('xml_in=' + requestXML);
        try{        	        	
        	res = http.send(req);        
        	responseXML = res.getBody();        	
        }catch(Exception e){
        	IR_Global_Class.logIRError('IR_HHTP_ERR', e.getMessage());        		
        }
        //responseXML = '<?xml version="1.0" standalone="yes"?><document><DATASETS><COUNTRY>NEW</COUNTRY><CURRENCY>NEW</CURRENCY><POSTCODEMASK>NEW</POSTCODEMASK><TOWNGROUP>NEW</TOWNGROUP><SERVICE>NEW</SERVICE><OPTION>NEW</OPTION></DATASETS><ERROR><CODE>P7</CODE><DESCRIPTION>RATEID: RATE - PRICE CHECK INTERGATE FAILURE : NO RATES RETURNED</DESCRIPTION></ERROR></document>';
        //dom = false;
        System.debug('requestXML=' + requestXML);
        System.debug('responseXML=' + responseXML);
        
        result = new IR_Global_Class.RateCheckResult();
        if (dom) {
            result = rateCheck_parseDomResponse(responseXML);
        } else {
            result = rateCheck_parseIntResponse(responseXML);
        }
        
        //Created logs if rates have or haven't been returned
        if (result.orderedCombinedRates.size() == 0) {
            IR_Global_Class.logIRError('IR_ERR_NO_RATES', 'requestXML=' + requestXML + '\n\nresponseXML=' + responseXML);
        } else {
            IR_Global_Class.logIRError('IR_HAS_RATES', 'requestXML=' + requestXML + '\n\nresponseXML=' + responseXML);
            result.success = true;
        }
        System.debug('result.errors=' + result.errors);
        
        
        return result;
    }
    
    private static String rateCheck_generateRequest(IR_Global_Class.RateCheckRequest request, Boolean dom) {
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        
        w.writeStartElement(null, 'PRICEREQUEST', null);
            w.writeStartElement(null, 'LOGIN', null);
                w.writeStartElement(null, 'COMPANY', null);
                    w.writeCharacters('TNTCLOUD');
                w.writeEndElement();
                w.writeStartElement(null, 'PASSWORD', null);
                    w.writeCharacters('TNTcl0UD');
                w.writeEndElement();
                w.writeStartElement(null, 'APPID', null);
                    w.writeCharacters('PC');
                w.writeEndElement();
            w.writeEndElement();
            
            w.writeStartElement(null, 'DATASETS', null);
                w.writeStartElement(null, 'COUNTRY', null);
                    w.writeCharacters('1.0');
                w.writeEndElement();
                w.writeStartElement(null, 'CURRENCY', null);
                    w.writeCharacters('1.0');
                w.writeEndElement();
                w.writeStartElement(null, 'POSTCODEMASK', null);
                    w.writeCharacters('1.0');
                w.writeEndElement();
                w.writeStartElement(null, 'TOWNGROUP', null);
                    w.writeCharacters('1.0');
                w.writeEndElement();
                w.writeStartElement(null, 'SERVICE', null);
                    w.writeCharacters('1.0');
                w.writeEndElement();
                w.writeStartElement(null, 'OPTION', null);
                    w.writeCharacters('1.0');
                w.writeEndElement();
            w.writeEndElement();
            
            w.writeStartElement(null, 'PRICECHECK', null);
                w.writeStartElement(null, 'RATEID', null);
                    w.writeCharacters(request.rateId);
                w.writeEndElement();
                w.writeStartElement(null, 'ORIGINCOUNTRY', null);
                    w.writeCharacters(request.origin_country);
                w.writeEndElement();
                w.writeStartElement(null, 'ORIGINTOWNNAME', null);
                    w.writeCharacters(request.origin_townName);
                w.writeEndElement();
                w.writeStartElement(null, 'ORIGINPOSTCODE', null);
                    w.writeCharacters(request.origin_postcode);
                w.writeEndElement();
                w.writeStartElement(null, 'ORIGINTOWNGROUP', null);
                    w.writeCharacters(request.origin_townGroup);
                w.writeEndElement();
                w.writeStartElement(null, 'DESTCOUNTRY', null);
                    w.writeCharacters(request.dest_country);
                w.writeEndElement();
                w.writeStartElement(null, 'DESTTOWNNAME', null);
                    w.writeCharacters(request.dest_townName);
                w.writeEndElement();
                w.writeStartElement(null, 'DESTPOSTCODE', null);
                    w.writeCharacters(request.dest_postcode);
                w.writeEndElement();
                w.writeStartElement(null, 'DESTTOWNGROUP', null);
                    w.writeCharacters(request.dest_townGroup);
                w.writeEndElement();
                w.writeStartElement(null, 'CONTYPE', null);
                    w.writeCharacters(request.conType);
                w.writeEndElement();
                w.writeStartElement(null, 'CURRENCY', null);
                    w.writeCharacters(request.rateCurrency);
                w.writeEndElement();
                w.writeStartElement(null, 'WEIGHT', null);
                    if (dom) {
                        w.writeCharacters(String.valueOf(request.weight.round(System.RoundingMode.UP).intValue()));
                    } else {
                        w.writeCharacters(IR_Global_Class.roundHalfUp(request.actual_weight));
                    	//w.writeCharacters(String.valueOf(request.actual_weight.round(System.RoundingMode.UP).intValue()));
					}
                w.writeEndElement();
                w.writeStartElement(null, 'VOLUME', null);
                    w.writeCharacters(String.valueOf(request.volume));
                w.writeEndElement();
                w.writeStartElement(null, 'ACCOUNT', null);
                    w.writeCharacters(request.rateAccount);
                w.writeEndElement();
                w.writeStartElement(null, 'ITEMS', null);
                    w.writeCharacters(String.valueOf(request.items));
                w.writeEndElement();
                if(dom){
                	w.writeStartElement(null, 'UKDOMESTIC', null);
                		w.writeStartElement(null, 'SHIPDATE', null);                		                	
                			w.writeCharacters(request.pickup_collection_date);
                		w.writeEndElement();
                		
                		for(IR_Package__c pac: request.packages){
                			w.writeStartElement(null, 'CONLINE', null);
                				w.writeStartElement(null, 'LINEITEMS', null);
                					w.writeCharacters('1');
                				w.writeEndElement();
                				w.writeStartElement(null, 'LINEWEIGHT', null);
                					w.writeCharacters(IR_Global_Class.roundHalfUp(pac.Weight_kg__c));
                					//w.writeCharacters(String.valueOf(pac.Weight_kg__c.round(System.RoundingMode.UP).intValue()));
                				w.writeEndElement();
                			w.writeEndElement();
                		}
                	w.writeEndElement();	
                }
                if (request.serviceCode != null) {
                    w.writeStartElement(null, 'SERVICE', null);
                        w.writeCharacters(request.serviceCode);
                    w.writeEndElement();
                }
            w.writeEndElement();
        w.writeEndElement();
        
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        System.debug('RequestXML=' + xmlOutput);
        w.close();
        
        return xmlOutput;
    }
    
    private static IR_Global_Class.RateCheckResult rateCheck_parseDomResponse(String responseXML) {
        IR_Global_Class.RateCheckResult results = new IR_Global_Class.RateCheckResult();
        try{
        XmlStreamReader reader = new XmlStreamReader(responseXML);
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('ratedService' == reader.getLocalName()) {
                    IR_Global_Class.RateCheckRate rate = rateCheck_parseDomResponse_parsePrice(reader);
                    
                    if (rate.rate > 0) {
                        results.addRate(rate);
                    }
                } else if ('error' == reader.getLocalName()) {
                    IR_Global_Class.RateCheckError error = new IR_Global_Class.RateCheckError();
                    error.code = reader.getAttributeValue(null, 'code');
                    error.message = getElementText(reader);                    		
                    results.addError(error);
                    
                } else if ('errorDescription' == reader.getLocalName()) {
                    String errorMessage = getElementText(reader);
                    
                    if (errorMessage != null) {
                        IR_Global_Class.RateCheckError error = new IR_Global_Class.RateCheckError();
                        
                        if (errorMessage == 'Invalid Delivery Postcode') {
                            error.code = 'IR_ERR_INV_DEL_PC';
                            error.message = errorMessage;
                        } else if (errorMessage == 'Invalid Collection Postcode') {
                            error.code = 'IR_ERR_INV_COL_PC';
                            error.message = errorMessage;
                        } else {
                            error.code = 'IR_ERR_NO_RATES';
                            error.message = errorMessage;
                        }                        
                        results.addError(error);
                    }
                }
            }
            
            reader.next();
        }
        system.debug('EXP_ERR_Debug' + results);
        return results;
        }catch(Exception e){
        	IR_Global_Class.logIRError('IR_ERR', e.getMessage());
        	IR_Global_Class.RateCheckError error = new IR_Global_Class.RateCheckError();
        	error.code = 'IR_ERR';
        	error.message = e.getMessage();
        	results.addError(error);        	
        	return results;
        }
    }
    
    private static IR_Global_Class.RateCheckRate rateCheck_parseDomResponse_parsePrice(XmlStreamReader reader) {
        IR_Global_Class.RateCheckRate rate = new IR_Global_Class.RateCheckRate();
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('code' == reader.getLocalName()) {
                    rate.rateId = getElementText(reader);
                    rate.serviceCode = rate.rateId;
                } else if ('description' == reader.getLocalName()) {
                    rate.serviceDesc = getElementText(reader);
                } else if ('surcharges' == reader.getLocalName()) {
                    rateCheck_parseDomResponse_parseSurcharge(reader);
                } else if ('charge' == reader.getLocalName()) {
                    try {
                        rate.rate = Decimal.valueOf(getElementText(reader).trim());
                    } catch (Exception ex) {
                        rate.rate = 0.0;
                    }
                } else {
                    getElementText(reader);
                }
            } else if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            
            reader.next();
        }
        
        return rate;
    }
    
    private static void rateCheck_parseDomResponse_parseSurcharge(XmlStreamReader reader) {
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (true) {
                    getElementText(reader);
                }
            } else if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            
            reader.next();
        }
    }
    
    public static IR_Global_Class.RateCheckResult rateCheck_parseIntResponse(String responseXML) {
        IR_Global_Class.RateCheckResult results = new IR_Global_Class.RateCheckResult();
        try{
        XmlStreamReader reader = new XmlStreamReader(responseXML);        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('PRICE' == reader.getLocalName()) {
                    IR_Global_Class.RateCheckRate rate = rateCheck_parseIntResponse_parsePrice(reader);
                    
                    if (rate.rate > 0) {
                        results.addRate(rate);
                    }
                } else if ('ERROR' == reader.getLocalName()) {
                    IR_Global_Class.RateCheckError error = rateCheck_parseIntResponse_parseError(reader);                                        
                    results.addError(error);
                }
            }
            
            reader.next();
        }        
        return results;
        }catch(Exception e){
        	IR_Global_Class.logIRError('IR_ERR', e.getMessage());
        	return results;          	
       	}
    }
    
    private static IR_Global_Class.RateCheckError rateCheck_parseIntResponse_parseError(XmlStreamReader reader) {
        IR_Global_Class.RateCheckError error = new IR_Global_Class.RateCheckError();
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('reader.getLocalName()=' + reader.getLocalName());
                if ('CODE' == reader.getLocalName()) {
                    error.code = getElementText(reader);
                } else if ('DESCRIPTION' == reader.getLocalName()) {
                    error.message = getElementText(reader);                    
                }
            } else if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            
            reader.next();
        }
        
        return error;
    }
    
    private static IR_Global_Class.RateCheckRate rateCheck_parseIntResponse_parsePrice(XmlStreamReader reader) {
        IR_Global_Class.RateCheckRate rate = new IR_Global_Class.RateCheckRate();
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('reader.getLocalName()=' + reader.getLocalName());
                if ('RATEID' == reader.getLocalName()) {
                    rate.rateId = getElementText(reader);
                } else if ('SERVICE' == reader.getLocalName()) {
                    rate.serviceCode = getElementText(reader);
                } else if ('SERVICEDESC' == reader.getLocalName()) {
                    rate.serviceDesc = getElementText(reader);
                } else if ('OPTION' == reader.getLocalName()) {
                    rate.optionCode = getElementText(reader);
                } else if ('OPTIONDESC' == reader.getLocalName()) {
                    rate.optionDesc = getElementText(reader);
                } else if ('CURRENCY' == reader.getLocalName()) {
                    rate.rateCurrency = getElementText(reader);
                } else if ('RATE' == reader.getLocalName()) {
                    try {
                        rate.rate = Decimal.valueOf(getElementText(reader).trim());
                    } catch (Exception ex) {
                        System.debug('ex=' + ex.getMessage());
                        rate.rate = 0.0;
                    }
                }
            } else if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            
            reader.next();
        }
        
        return rate;
    }
    
    public static void setDatasets() {
        //setDatasets_postcodeMask();
        //setDatasets_country();
        //setDatasets_currency();
        //setDatasets_towngroup();
        setDatasets_service();
        //setDatasets_option();
    }
    
    private static void setDatasets_postcodeMask() {
        System.debug(setDatasets_callService(setDatasets_generateRequest('PostcodeMask')));
    }
    
    private static void setDatasets_country() {
        System.debug(setDatasets_callService(setDatasets_generateRequest('Country')));
    }
    
    private static void setDatasets_currency() {
        System.debug(setDatasets_callService(setDatasets_generateRequest('Currency')));
    }
    
    private static void setDatasets_towngroup() {
        System.debug(setDatasets_callService(setDatasets_generateRequest('Towngroup')));
    }
    
    private static void setDatasets_service() {
        System.debug(setDatasets_callService(setDatasets_generateRequest('Service')));
    }
    
    private static void setDatasets_option() {
        System.debug(setDatasets_callService(setDatasets_generateRequest('Option')));
    }
    
    private static String setDatasets_callService(String requestXML) {
        System.debug(requestXML);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://iConnection.tnt.com:443/Pricegate.asp');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');          
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('xml_in=' + requestXML);
        HttpResponse res = http.send(req);
        
        return res.getBody();
    }
    
    private static String setDatasets_generateRequest(String datasets) {
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        
        w.writeStartElement(null, 'SETREQUEST', null);
            w.writeStartElement(null, 'LOGIN', null);
                w.writeStartElement(null, 'COMPANY', null);
                    w.writeCharacters('TNTCLOUD');
                w.writeEndElement();
                w.writeStartElement(null, 'PASSWORD', null);
                    w.writeCharacters('TNTcl0UD');
                w.writeEndElement();
                w.writeStartElement(null, 'APPID', null);
                    w.writeCharacters('PC');
                w.writeEndElement();
            w.writeEndElement();
            
            w.writeStartElement(null, 'REQUEST', null);
                w.writeStartElement(null, 'DATASET', null);
                    w.writeCharacters(datasets);
                w.writeEndElement();
            w.writeEndElement();
        w.writeEndElement();
        
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();
        
        return xmlOutput;
    }
    
    public static IR_Global_Class.BookResult book(IR_Customer__c customer, IR_Order__c order, IR_Consignment__c consignment) {
        String requestXML = book_generateRequest(customer, order, consignment);
        System.debug('requestXML=' + requestXML);
        String responseXML;
        IR_Global_Class.BookResult result;
        HttpResponse res;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://iConnection.tnt.com/shippergate2.asp');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');          
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('xml_in=' + requestXML);
        
        try{
        res = http.send(req);
        responseXML = res.getBody();        
        IR_Global_Class.logIRError('ExpressConnect', responseXml);
        result =  book_parseResponse(responseXML);
        }catch(Exception e){
        	System.debug(e);
        	result = new IR_Global_Class.BookResult();
        	result.errorResponse =e.getMessage(); 
        }
                      
        System.debug('requestXML=' + requestXML);
        System.debug('responseXML=' + responseXML);
        
        if (result.success) {
            String resultString = getDocumentXML(IR_ExpressConnect.DocType.RESULT, result.confirmationCode);
            
            if (resultString != 'Y') {
                result.success = false;
                result.errorResponse = result.confirmationCode + ' | ' + resultString;
            }
        }
        
        System.debug('result=' + result);
        
        return result;
    }
    
    public static String book_generateRequest(IR_Customer__c customer, IR_Order__c order, IR_Consignment__c consignment) {
        Boolean dom = (consignment.From_Country_Code__c == 'GB' && consignment.To_Country_Code__c == 'GB');
        String conref = 'conref1';
        String transitVal = '';
        
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        
        w.writeStartElement(null, 'ESHIPPER', null);
            w.writeStartElement(null, 'LOGIN', null);
                w.writeStartElement(null, 'COMPANY', null);
                    w.writeCharacters('TNTCLOUD');
                w.writeEndElement();
                w.writeStartElement(null, 'PASSWORD', null);
                    w.writeCharacters('TNTcl0UD');
                w.writeEndElement();
                w.writeStartElement(null, 'APPID', null);
                    w.writeCharacters('EC');	//changed from 'IN' to 'EC'.
                w.writeEndElement();
                w.writeStartElement(null, 'APPVERSION', null);
                    w.writeCharacters('2.2');
                w.writeEndElement();
            w.writeEndElement();
            
            w.writeStartElement(null, 'CONSIGNMENTBATCH', null);
                w.writeStartElement(null, 'SENDER', null);
                	if (dom) {
                		//If this is domestic then use the Collection (From) Address
                        w.writeStartElement(null, 'COMPANYNAME', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Company__c == null ? '' : consignment.From_Company__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'STREETADDRESS1', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Address_1__c == null ? '' : consignment.From_Address_1__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'STREETADDRESS2', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Address_2__c == null ? '' : consignment.From_Address_2__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'STREETADDRESS3', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Address_3__c == null ? '' : consignment.From_Address_3__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'CITY', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Town_City__c == null ? '' : consignment.From_Town_City__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'PROVINCE', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_County__c == null ? '' : consignment.From_County__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'POSTCODE', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Postcode__c == null ? '' : consignment.From_Postcode__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'COUNTRY', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Country_Code__c == null ? '' : consignment.From_Country_Code__c)));
                        w.writeEndElement();
                	} else {
                		//If this is international then use the Customer Address
	                    w.writeStartElement(null, 'COMPANYNAME', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Company__c == null ? '' : customer.Company__c)));
	                    w.writeEndElement();
	                    w.writeStartElement(null, 'STREETADDRESS1', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Address_1__c == null ? '' : customer.Address_1__c)));
	                    w.writeEndElement();
	                    w.writeStartElement(null, 'STREETADDRESS2', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Address_2__c == null ? '' : customer.Address_2__c)));
	                    w.writeEndElement();
	                    w.writeStartElement(null, 'STREETADDRESS3', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Address_3__c == null ? '' : customer.Address_3__c)));
	                    w.writeEndElement();
	                    w.writeStartElement(null, 'CITY', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Town_City__c == null ? '' : customer.Town_City__c)));
	                    w.writeEndElement();
	                    w.writeStartElement(null, 'PROVINCE', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.County__c == null ? '' : customer.County__c)));
	                    w.writeEndElement();
	                    w.writeStartElement(null, 'POSTCODE', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Postcode__c == null ? '' : customer.Postcode__c)));
	                    w.writeEndElement();
	                    w.writeStartElement(null, 'COUNTRY', null);
	                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Country_Code__c == null ? '' : customer.Country_Code__c)));
	                    w.writeEndElement();
                	}
                	
                    w.writeStartElement(null, 'ACCOUNT', null);
                        w.writeCharacters(consignment.Account_Number__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'VAT', null);
                        w.writeCharacters(IR_Global_Class.encodeXML((customer.VAT_Registration_Number__c == null ? '' : customer.VAT_Registration_Number__c)));
                    w.writeEndElement();
                    w.writeStartElement(null, 'CONTACTNAME', null);
                        w.writeCharacters(IR_Global_Class.encodeXML((customer.First_Name__c == null ? '' : customer.First_Name__c) + ' ' + (customer.Surname__c == null ? '' : customer.Surname__c)));
                    w.writeEndElement();
                    w.writeStartElement(null, 'CONTACTDIALCODE', null);
                        if (customer.Telephone__c.split(' ').size() >= 2) {
                            w.writeCharacters(IR_Global_Class.encodeXML(customer.Telephone__c.split(' ')[1].length() > 7 ? customer.Telephone__c.split(' ')[1].substring(0,7) : customer.Telephone__c.split(' ')[1]));
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'CONTACTTELEPHONE', null);
                        if (customer.Telephone__c.split(' ').size() >= 3) {
                            w.writeCharacters(IR_Global_Class.encodeXML(customer.Telephone__c.split(' ')[2].length() > 9 ? customer.Telephone__c.split(' ')[2].substring(0,9) : customer.Telephone__c.split(' ')[2]));
                        }
                    w.writeEndElement();
                   /* w.writeStartElement(null, 'CONTACTEMAIL', null);
                        w.writeCharacters(IR_Global_Class.encodeXML((customer.Email__c == null ? '' : customer.Email__c)));
                    w.writeEndElement();*/
                    
                    w.writeStartElement(null, 'COLLECTION', null);
                    	//If this is an international delivery then send the COLLECTION ADDRESS NODE
                    	if (!dom) {
	                        w.writeStartElement(null, 'COLLECTIONADDRESS', null);
	                            w.writeStartElement(null, 'COMPANYNAME', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Company__c == null ? '' : consignment.From_Company__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'STREETADDRESS1', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Address_1__c == null ? '' : consignment.From_Address_1__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'STREETADDRESS2', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Address_2__c == null ? '' : consignment.From_Address_2__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'STREETADDRESS3', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Address_3__c == null ? '' : consignment.From_Address_3__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'CITY', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Town_City__c == null ? '' : consignment.From_Town_City__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'PROVINCE', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_County__c == null ? '' : consignment.From_County__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'POSTCODE', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Postcode__c == null ? '' : consignment.From_Postcode__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'COUNTRY', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Country_Code__c == null ? '' : consignment.From_Country_Code__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'VAT', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((customer.VAT_Registration_Number__c == null ? '' : customer.VAT_Registration_Number__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'CONTACTNAME', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.From_Contact_Name__c == null ? '' : consignment.From_Contact_Name__c)));
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'CONTACTDIALCODE', null);
	                                if (consignment.From_Contact_Number__c.split(' ').size() >= 2) {
	                                    w.writeCharacters(IR_Global_Class.encodeXML(consignment.From_Contact_Number__c.split(' ')[1].length() > 7 ? consignment.From_Contact_Number__c.split(' ')[1].substring(0,7) : consignment.From_Contact_Number__c.split(' ')[1]));
	                                }
	                            w.writeEndElement();
	                            w.writeStartElement(null, 'CONTACTTELEPHONE', null);
	                                if (consignment.From_Contact_Number__c.split(' ').size() >= 3) {
	                                    w.writeCharacters(IR_Global_Class.encodeXML(consignment.From_Contact_Number__c.split(' ')[2].length() > 9 ? consignment.From_Contact_Number__c.split(' ')[2].substring(0,9) : consignment.From_Contact_Number__c.split(' ')[2]));
	                                }
	                            w.writeEndElement();
	                            /*w.writeStartElement(null, 'CONTACTEMAIL', null);
	                                w.writeCharacters(IR_Global_Class.encodeXML((customer.Email__c == null ? '' : customer.Email__c)));
	                            w.writeEndElement();*/
	                        w.writeEndElement();
                    	}
                        
                        w.writeStartElement(null, 'SHIPDATE', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.Pickup_Collection_Date__c == null ? '' : DateTime.newInstance(consignment.Pickup_Collection_Date__c, Time.newInstance(0,0,0,0)).format('dd/MM/yyyy'))));
                        w.writeEndElement();
                        
                        w.writeStartElement(null, 'PREFCOLLECTTIME', null);
                            w.writeStartElement(null, 'FROM', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.Pickup_Collection_Time_from__c == null ? '' : consignment.Pickup_Collection_Time_from__c).replaceAll(':', '')));
                            w.writeEndElement();
                            w.writeStartElement(null, 'TO', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.Pickup_Collection_Time_to__c == null ? '' : consignment.Pickup_Collection_Time_to__c).replaceAll(':', '')));
                            w.writeEndElement();
                        w.writeEndElement();
                        
                        w.writeStartElement(null, 'ALTCOLLECTTIME', null);
                            w.writeStartElement(null, 'FROM', null);
                                w.writeCharacters(IR_Global_Class.encodeXML(''));
                            w.writeEndElement();
                            w.writeStartElement(null, 'TO', null);
                                w.writeCharacters(IR_Global_Class.encodeXML(''));
                            w.writeEndElement();
                        w.writeEndElement();
                        
                        w.writeStartElement(null, 'COLLINSTRUCTIONS', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.Instructions__c == null ? 'Not Provided' : consignment.Instructions__c)));
                        w.writeEndElement();
                    w.writeEndElement();
                w.writeEndElement();
                
                w.writeStartElement(null, 'CONSIGNMENT', null);
                    w.writeStartElement(null, 'CONREF', null);
                        w.writeCharacters(conref);
                    w.writeEndElement();
                    
                    w.writeStartElement(null, 'DETAILS', null);
                        w.writeStartElement(null, 'RECEIVER', null);
                            w.writeStartElement(null, 'COMPANYNAME', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Company__c == null ? '' : consignment.To_Company__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'STREETADDRESS1', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Address_1__c == null ? '' : consignment.To_Address_1__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'STREETADDRESS2', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Address_2__c == null ? '' : consignment.To_Address_2__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'STREETADDRESS3', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Address_3__c == null ? '' : consignment.To_Address_3__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'CITY', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Town_City__c == null ? '' : consignment.To_Town_City__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'PROVINCE', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_County__c == null ? '' : consignment.To_County__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'POSTCODE', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Postcode__c == null ? '' : consignment.To_Postcode__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'COUNTRY', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Country_Code__c == null ? '' : consignment.To_Country_Code__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'VAT', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((customer.VAT_Registration_Number__c == null ? '' : customer.VAT_Registration_Number__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'CONTACTNAME', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Contact_Name__c == null ? '' : consignment.To_Contact_Name__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'CONTACTDIALCODE', null);
                                if (consignment.To_Contact_Number__c.split(' ').size() >= 2) {
                                    w.writeCharacters(IR_Global_Class.encodeXML(consignment.To_Contact_Number__c.split(' ')[1].length() > 7 ? consignment.To_Contact_Number__c.split(' ')[1].substring(0,7) : consignment.To_Contact_Number__c.split(' ')[1]));
                                }
                            w.writeEndElement();
                            w.writeStartElement(null, 'CONTACTTELEPHONE', null);
                                if (consignment.To_Contact_Number__c.split(' ').size() >= 3) {
                                    w.writeCharacters(IR_Global_Class.encodeXML(consignment.To_Contact_Number__c.split(' ')[2].length() > 9 ? consignment.To_Contact_Number__c.split(' ')[2].substring(0,9) : consignment.To_Contact_Number__c.split(' ')[2]));
                                }
                            w.writeEndElement();
                           /* w.writeStartElement(null, 'CONTACTEMAIL', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((customer.Email__c == null ? '' : customer.Email__c)));
                            w.writeEndElement();*/
                        w.writeEndElement();
                        
                        w.writeStartElement(null, 'DELIVERY', null);
                            w.writeStartElement(null, 'COMPANYNAME', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Company__c == null ? '' : consignment.To_Company__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'STREETADDRESS1', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Address_1__c == null ? '' : consignment.To_Address_1__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'STREETADDRESS2', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Address_2__c == null ? '' : consignment.To_Address_2__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'STREETADDRESS3', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Address_3__c == null ? '' : consignment.To_Address_3__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'CITY', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Town_City__c == null ? '' : consignment.To_Town_City__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'PROVINCE', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_County__c == null ? '' : consignment.To_County__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'POSTCODE', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Postcode__c == null ? '' : consignment.To_Postcode__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'COUNTRY', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Country_Code__c == null ? '' : consignment.To_Country_Code__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'VAT', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((customer.VAT_Registration_Number__c == null ? '' : customer.VAT_Registration_Number__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'CONTACTNAME', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Contact_Name__c == null ? '' : consignment.To_Contact_Name__c)));
                            w.writeEndElement();
                            w.writeStartElement(null, 'CONTACTDIALCODE', null);
                                if (consignment.From_Contact_Number__c.split(' ').size() >= 2) {
                                    w.writeCharacters(IR_Global_Class.encodeXML(consignment.To_Contact_Number__c.split(' ')[1].length() > 7 ? consignment.To_Contact_Number__c.split(' ')[1].substring(0,7) : consignment.To_Contact_Number__c.split(' ')[1]));
                                }
                            w.writeEndElement();
                            w.writeStartElement(null, 'CONTACTTELEPHONE', null);
                                if (consignment.From_Contact_Number__c.split(' ').size() >= 3) {
                                    w.writeCharacters(IR_Global_Class.encodeXML(consignment.To_Contact_Number__c.split(' ')[2].length() > 9 ? consignment.To_Contact_Number__c.split(' ')[2].substring(0,9) : consignment.To_Contact_Number__c.split(' ')[2]));
                                }
                            w.writeEndElement();
                            /*w.writeStartElement(null, 'CONTACTEMAIL', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((customer.Email__c == null ? '' : customer.Email__c)));
                            w.writeEndElement();*/
                        w.writeEndElement();
                        
                        w.writeStartElement(null, 'CUSTOMERREF', null);
                            w.writeCharacters(IR_Global_Class.encodeXML(customer.Sender_Reference__c == null ? '' : (String.valueOf(customer.Sender_Reference__c))));
                        w.writeEndElement();
                        w.writeStartElement(null, 'CONTYPE', null);
                            w.writeCharacters(IR_Global_Class.encodeXML(consignment.Type_Identifier__c));
                        w.writeEndElement();
                        w.writeStartElement(null, 'PAYMENTIND', null);
                            w.writeCharacters(IR_Global_Class.encodeXML(''));
                        w.writeEndElement();
                        w.writeStartElement(null, 'ITEMS', null);
                            w.writeCharacters(IR_Global_Class.encodeXML(consignment.Number_Of_Packages__c == null ? '0' : (String.valueOf(consignment.Number_Of_Packages__c))));
                        w.writeEndElement();
                        
                        w.writeStartElement(null, 'TOTALWEIGHT', null);
	                        if (dom) {
	                            w.writeCharacters(IR_Global_Class.encodeXML(consignment.Total_Chargeable_Weight__c == null ? '0' : String.valueOf(consignment.Total_Chargeable_Weight__c)));
	                        } else {
	                            w.writeCharacters(IR_Global_Class.encodeXML(consignment.Total_Actual_Weight__c == null ? '0' : String.valueOf(consignment.Total_Actual_Weight__c)));
	                        }
                        w.writeEndElement();
                        
                        w.writeStartElement(null, 'TOTALVOLUME', null);
                            w.writeCharacters(IR_Global_Class.encodeXML(consignment.Total_Volume__c == null ? '0' : String.valueOf(consignment.Total_Volume__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'CURRENCY', null);
                            w.writeCharacters('GBP');
                        w.writeEndElement();
                        //changes done to the logic according to fixlog no 236.
                        if(consignment.Transit_Liability__c){
                        	if(consignment.National_International__c == 'International'){
                        		transitVal = String.valueOf(consignment.Estimated_Value__c); 	
                        	}else{
                        		//transitVal = String.valueOf(IR_Global_Class.getETLValue(customer.Extended_Transit_Liability_Setting__c));
                        		transitVal = String.valueOf('0.01');
                        	}
                        	  
                        }
                        
                        w.writeStartElement(null, 'GOODSVALUE', null);                        
                            //w.writeCharacters(IR_Global_Class.encodeXML((consignment.Estimated_Value__c == null || consignment.Estimated_Value__c == 0 ? '' : String.valueOf(consignment.Estimated_Value__c))));
                            w.writeCharacters(IR_Global_Class.encodeXML(transitVal));
                        w.writeEndElement();
                        
                        if (consignment.Transit_Liability__c && customer.Extended_Transit_Liability_Setting__c != null) {
                            w.writeStartElement(null, 'INSURANCEVALUE', null);
                                //w.writeCharacters(IR_Global_Class.encodeXML(String.valueOf(IR_Global_Class.getETLValue(customer.Extended_Transit_Liability_Setting__c))));
                                w.writeCharacters(IR_Global_Class.encodeXML(transitVal));
                            w.writeEndElement();
                            w.writeStartElement(null, 'INSURANCECURRENCY', null);
                                w.writeCharacters('GBP');
                            w.writeEndElement();
                        }
                        
                        w.writeStartElement(null, 'SERVICE', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.Service_Code__c == null ? '' : consignment.Service_Code__c)));
                        w.writeEndElement();
                        
                        if (consignment.Option_Code__c != null && (!consignment.From_EU__c || !consignment.From_EU__c)) {
                            w.writeStartElement(null, 'OPTION', null);
                                w.writeCharacters(IR_Global_Class.encodeXML((consignment.Option_Code__c == null ? '' : consignment.Option_Code__c)));
                            w.writeEndElement();
                        }
                        
                        w.writeStartElement(null, 'DESCRIPTION', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.Description_Of_Goods__c == null || consignment.Description_Of_Goods__c.length() == 0 ? 'Not Provided' : consignment.Description_Of_Goods__c)));
                        w.writeEndElement();
                        w.writeStartElement(null, 'DELIVERYINST', null);
                            w.writeCharacters(IR_Global_Class.encodeXML((consignment.Instructions__c == null ? 'Not Provided' : consignment.Instructions__c)));
                        w.writeEndElement();
                        
                        for (IR_Package__c thisPackage : consignment.Packages__r) {
                            w.writeStartElement(null, 'PACKAGE', null);
                                w.writeStartElement(null, 'ITEMS', null);
                                    w.writeCharacters('1');
                                w.writeEndElement();
                                w.writeStartElement(null, 'DESCRIPTION', null);
                                    w.writeCharacters(IR_Global_Class.encodeXML((consignment.Description_Of_Goods__c == null || consignment.Description_Of_Goods__c.length() == 0 ? 'Not Provided' : consignment.Description_Of_Goods__c)));
                                w.writeEndElement();
                                w.writeStartElement(null, 'LENGTH', null);
                                    w.writeCharacters(IR_Global_Class.encodeXML(String.valueOf(thisPackage.Length__c / 100)));
                                w.writeEndElement();
                                w.writeStartElement(null, 'HEIGHT', null);
                                    w.writeCharacters(IR_Global_Class.encodeXML(String.valueOf(thisPackage.Height__c / 100)));
                                w.writeEndElement();
                                w.writeStartElement(null, 'WIDTH', null);
                                    w.writeCharacters(IR_Global_Class.encodeXML(String.valueOf(thisPackage.Width__c / 100)));
                                w.writeEndElement();
                                w.writeStartElement(null, 'WEIGHT', null);
                                    w.writeCharacters(IR_Global_Class.encodeXML(String.valueOf(thisPackage.Weight_Kg__c)));
                                w.writeEndElement();
                                
                                w.writeStartElement(null, 'ARTICLE', null);
                                    w.writeStartElement(null, 'ITEMS', null);
                                        w.writeCharacters('1');
                                    w.writeEndElement();
                                    w.writeStartElement(null, 'DESCRIPTION', null);
                                        w.writeCharacters(IR_Global_Class.encodeXML((consignment.Description_Of_Goods__c == null || consignment.Description_Of_Goods__c.length() == 0 ? 'Not Provided' : consignment.Description_Of_Goods__c)));
                                    w.writeEndElement();
                                    w.writeStartElement(null, 'WEIGHT', null);
                                        w.writeCharacters(IR_Global_Class.encodeXML(String.valueOf(thisPackage.Weight_Kg__c)));
                                    w.writeEndElement();
                                    w.writeStartElement(null, 'INVOICEVALUE', null);
                                        w.writeCharacters('1');
                                    w.writeEndElement();
                                    w.writeStartElement(null, 'INVOICEDESC', null);
                                        w.writeCharacters(IR_Global_Class.encodeXML((consignment.Description_Of_Goods__c == null || consignment.Description_Of_Goods__c.length() == 0 ? 'Not Provided' : consignment.Description_Of_Goods__c)));
                                    w.writeEndElement();
                                    w.writeStartElement(null, 'HTS', null);
                                        w.writeCharacters('');
                                    w.writeEndElement();
                                    w.writeStartElement(null, 'COUNTRY', null);
                                        w.writeCharacters(IR_Global_Class.encodeXML((consignment.To_Country_Code__c == null ? '' : consignment.To_Country_Code__c)));
                                    w.writeEndElement();
                                w.writeEndElement();
                            w.writeEndElement();
                        }
                    w.writeEndElement();
                w.writeEndElement();
            w.writeEndElement();
            
            w.writeStartElement(null, 'ACTIVITY', null);
                w.writeStartElement(null, 'BOOK', null);
                	//w.writeAttribute(null, null, 'ShowBookingRef', 'N');
                    w.writeStartElement(null, 'CONREF', null);
                        w.writeCharacters(conref);
                    w.writeEndElement();
                w.writeEndElement();
                
                w.writeStartElement(null, 'SHIP', null);
                    w.writeStartElement(null, 'CONREF', null);
                        w.writeCharacters(conref);
                    w.writeEndElement();
                w.writeEndElement();
                                               
                w.writeStartElement(null, 'PRINT', null);
                    w.writeStartElement(null, 'CONNOTE', null);
                        w.writeStartElement(null, 'CONREF', null);
                            w.writeCharacters(conref);
                        w.writeEndElement();
                        
                        /*w.writeStartElement(null, 'CONNUMBER', null);
                            w.writeCharacters();
                        w.writeEndElement();*/
                    w.writeEndElement();
                    
                    w.writeStartElement(null, 'LABEL', null);
                        w.writeStartElement(null, 'CONREF', null);
                            w.writeCharacters(conref);
                        w.writeEndElement();
                    w.writeEndElement();
                    
                    w.writeStartElement(null, 'MANIFEST', null);
                        w.writeStartElement(null, 'CONREF', null);
                            w.writeCharacters(conref);
                        w.writeEndElement();
                    w.writeEndElement();
                    
                    w.writeStartElement(null, 'INVOICE', null);
                        w.writeStartElement(null, 'CONREF', null);
                            w.writeCharacters(conref);
                        w.writeEndElement();
                    w.writeEndElement();
                w.writeEndElement();
            w.writeEndElement();
        w.writeEndElement();
        
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();
        
        return xmlOutput;
    }
    
    public static IR_Global_Class.BookResult book_parseResponse(String responseXML) {
        IR_Global_Class.BookResult bookResult = new IR_Global_Class.BookResult();
        
        try {
            bookResult.confirmationCode = responseXML.split(':')[1];
            
            bookResult.success = true;
        } catch (Exception ex) {
            bookResult.errorResponse = responseXML;
            
            bookResult.success = false;
        }
        
        return bookResult;
    }
    
    public static String getDocumentXML(IR_ExpressConnect.DocType dType, String confCode) {
        String requestXML = getDocumentXML_generateRequest(dType, confCode);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://iConnection.tnt.com/shippergate2.asp');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');          
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('xml_in=' + requestXML);
        HttpResponse res = http.send(req);
        
        String responseXML = res.getBody();
        
        System.debug('getDocumentXML_requestXML=' + requestXML);
        System.debug('getDocumentXML_responseXML=' + responseXML);
        
        return getDocumentXML_parseResponse(dType, responseXML);
    }
    
    private static String getDocumentXML_generateRequest(IR_ExpressConnect.DocType dType, String confCode) {
        if (dType == IR_ExpressConnect.DocType.RESULT) {
            return 'GET_RESULT:' + confCode;
        } else if (dType == IR_ExpressConnect.DocType.CONNOTE) {
            return 'GET_CONNOTE:' + confCode;
        } else if (dType == IR_ExpressConnect.DocType.LABEL) {
            return 'GET_LABEL:' + confCode;
        } else if (dType == IR_ExpressConnect.DocType.MANIFEST) {
            return 'GET_MANIFEST:' + confCode;
        } else if (dType == IR_ExpressConnect.DocType.INVOICE) {
            return 'GET_INVOICE:' + confCode;
        }
        
        return '';
    }
    
    public static String getDocumentXML_parseResponse(IR_ExpressConnect.DocType dType, String responseXML) {
        String response = '';
        XmlStreamReader reader = new XmlStreamReader(responseXML);
        
        if (dType == IR_ExpressConnect.DocType.RESULT) {
            while(reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if ('BOOK' == reader.getLocalName()) {
                        response = getDocumentXML_parseResponse_parseBook(reader);
                    }
                }
                
                reader.next();
            }
            
            if (response != 'Y') {
                response = responseXML;
            }
        } else {
            response = responseXML.replaceAll('<\\?.*\\?>', '');
        }
        
        return response;
    }
    
    private static String getDocumentXML_parseResponse_parseBook(XmlStreamReader reader) {
        String status = '';
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('CONSIGNMENT' == reader.getLocalName()) {
                    status = getDocumentXML_parseResponse_getStatus(reader);
                }
            }
            
            reader.next();
        }
        
        return status;
    }
    
    private static String getDocumentXML_parseResponse_getStatus(XmlStreamReader reader) {
        String status = '';
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('SUCCESS' == reader.getLocalName()) {
                    status = getElementText(reader);
                } else {
                    getElementText(reader);
                }
            } else if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            
            reader.next();
        }
        
        return status;
    }
    
    public enum DocType {RESULT, CONNOTE, LABEL, MANIFEST, INVOICE}
    
    private static String getElementText(XmlStreamReader reader) {
        String elementText;
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                elementText = reader.getText();
            }
            
            reader.next();
        }
        
        return elementText;
    }
    
    /********************************************************************/
    /*********************START OF HAPPY DAY SCENARIO********************/
    /********************************************************************/
    TestMethod static void test_rateCheck_Domestic() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        IR_Package__c testPackage = new IR_Package__c(Height__c=1,Length__c=1,Width__c=1,Weight_kg__c=1,Consignment_IR__c=testCon.Id);
        insert testPackage;
        
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        LIST<IR_Consignment__c> consignments = new LIST<IR_Consignment__c>();
        consignments.add(testCon);
        IR_Global_Class.RateCheckRequest testRequest = IR_Global_Class.createRequest(IR_Global_Class.getConsignmentBundles(consignments)[0]);
        
        Test.startTest();
        System.debug(IR_ExpressConnect.rateCheck(testRequest, true));
        Test.stopTest();
    }
    
    TestMethod static void test_rateCheck_International() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        IR_Package__c testPackage = new IR_Package__c(Height__c=1,Length__c=1,Width__c=1,Weight_kg__c=1,Consignment_IR__c=testCon.Id);
        insert testPackage;
        
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        LIST<IR_Consignment__c> consignments = new LIST<IR_Consignment__c>();
        consignments.add(testCon);
        IR_Global_Class.RateCheckRequest testRequest = IR_Global_Class.createRequest(IR_Global_Class.getConsignmentBundles(consignments)[0]);
        
        Test.startTest();
        System.debug(IR_ExpressConnect.rateCheck(testRequest, false));
        Test.stopTest();
    }
    
    TestMethod static void test_rateCheck_generateRequest() {
        IR_Customer__c testCust = new IR_Customer__c(Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        IR_Package__c testPackage = new IR_Package__c(Height__c=1,Length__c=1,Width__c=1,Weight_kg__c=1,Consignment_IR__c=testCon.Id);
        insert testPackage;
        
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        LIST<IR_Consignment__c> consignments = new LIST<IR_Consignment__c>();
        consignments.add(testCon);
        IR_Global_Class.RateCheckRequest testRequest = IR_Global_Class.createRequest(IR_Global_Class.getConsignmentBundles(consignments)[0]);
        
        Test.startTest();
        System.debug(IR_ExpressConnect.rateCheck_generateRequest(testRequest, false));
        Test.stopTest();
    }
    
    TestMethod static void test_rateCheck_parseResponse_Domestic() {
        Test.startTest();
        System.debug(IR_ExpressConnect.rateCheck_parseDomResponse('<?xml version="1.0" standalone="yes"?><document><DATASETS><COUNTRY>NEW</COUNTRY><CURRENCY>NEW</CURRENCY><POSTCODEMASK>NEW</POSTCODEMASK><TOWNGROUP>NEW</TOWNGROUP><SERVICE>NEW</SERVICE><OPTION>NEW</OPTION></DATASETS><ERROR><CODE>P13</CODE><DESCRIPTION>RATEID: RATE0 - STANDARD RATES</DESCRIPTION></ERROR><PRICE><RATEID>RATE0</RATEID><SERVICE>09D</SERVICE><SERVICEDESC>9:00 EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>179.14</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>10D</SERVICE><SERVICEDESC>10:00 EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>168.19</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>12D</SERVICE><SERVICEDESC>12:00 EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>151.76</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>15D</SERVICE><SERVICEDESC>GLOBAL EXPRESS</SERVICEDESC><OPTION>PR</OPTION><OPTIONDESC>PRIORITY</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>132.96</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>15D</SERVICE><SERVICEDESC>GLOBAL EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>107.96</RATE><RESULT>Y</RESULT></PRICE></document>'));
        Test.stopTest();
    }
    
    TestMethod static void test_rateCheck_parseResponse_International() {
        Test.startTest();
        //System.debug(IR_ExpressConnect.rateCheck_parseIntResponse('<?xml version="1.0" standalone="yes"?><document><DATASETS><COUNTRY>NEW</COUNTRY><CURRENCY>NEW</CURRENCY><POSTCODEMASK>NEW</POSTCODEMASK><TOWNGROUP>NEW</TOWNGROUP><SERVICE>NEW</SERVICE><OPTION>NEW</OPTION></DATASETS><ERROR><CODE>P13</CODE><DESCRIPTION>RATEID: RATE0 - STANDARD RATES</DESCRIPTION></ERROR><PRICE><RATEID>RATE0</RATEID><SERVICE>09D</SERVICE><SERVICEDESC>9:00 EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>179.14</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>10D</SERVICE><SERVICEDESC>10:00 EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>168.19</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>12D</SERVICE><SERVICEDESC>12:00 EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>151.76</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>15D</SERVICE><SERVICEDESC>GLOBAL EXPRESS</SERVICEDESC><OPTION>PR</OPTION><OPTIONDESC>PRIORITY</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>132.96</RATE><RESULT>Y</RESULT></PRICE><PRICE><RATEID>RATE0</RATEID><SERVICE>15D</SERVICE><SERVICEDESC>GLOBAL EXPRESS</SERVICEDESC><OPTION>NONE</OPTION><OPTIONDESC>NONE</OPTIONDESC><CURRENCY>GBP</CURRENCY><RATE>107.96</RATE><RESULT>Y</RESULT></PRICE></document>'));
        Test.stopTest();
    }
    
    TestMethod static void test_setDatasets() {
        Test.startTest();
        IR_ExpressConnect.setDatasets();
        Test.stopTest();
    }
    
    TestMethod static void test_setDatasets_postcodeMask() {
        Test.startTest();
        IR_ExpressConnect.setDatasets();
        Test.stopTest();
    }
    
    TestMethod static void test_setDatasets_country() {
        Test.startTest();
        IR_ExpressConnect.setDatasets();
        Test.stopTest();
    }
    
    TestMethod static void test_setDatasets_currency() {
        Test.startTest();
        IR_ExpressConnect.setDatasets();
        Test.stopTest();
    }
    
    TestMethod static void test_setDatasets_towngroup() {
        Test.startTest();
        IR_ExpressConnect.setDatasets();
        Test.stopTest();
    }
    
    TestMethod static void test_setDatasets_service() {
        Test.startTest();
        IR_ExpressConnect.setDatasets();
        Test.stopTest();
    }
    
    TestMethod static void test_setDatasets_option() {
        Test.startTest();
        IR_ExpressConnect.setDatasets();
        Test.stopTest();
    }
    
    TestMethod static void test_book() {
        IR_Customer__c testCust = new IR_Customer__c(Domestic_Account_Number__c='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(From_Contact_Number__c='+44 (0)20 123456',To_Contact_Number__c='+44 (0)20 1234567',Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        IR_Package__c testPackage = new IR_Package__c(Height__c=1,Length__c=1,Width__c=1,Weight_kg__c=1,Consignment_IR__c=testCon.Id);
        insert testPackage;
        
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        Test.startTest();
        System.debug(IR_ExpressConnect.book(testCust, testOrder, testCon));
        Test.stopTest();
    }
    
    TestMethod static void test_book_generateRequest() {
        IR_Customer__c testCust = new IR_Customer__c(Domestic_Account_Number__c='1234567890',International_Account_Number__c ='123456789',Surname__c='TEST',Postcode__c='SE10HS',Email__c='TEST@TEST.TEST',Mobile_Phone__c='0123456789',Fax__c='0123456789',First_Name__c='TEST',Address_1__c='TEST',Telephone__c='1234567890123456',Company__c='TEST',Job_Title__c='TEST');
        insert testCust;
        
        IR_Order__c testOrder = new IR_Order__c(Amount_Quoted__c=0,Customer__c=testCust.Id);
        insert testOrder;
        
        IR_Consignment__c testCon = new IR_Consignment__c(From_Contact_Number__c='+44 (0)20 123456',To_Contact_Number__c='+44 (0)20 123456',Order_IR__c=testOrder.Id,From_Postcode__c='SE10HS',To_Postcode__c='SE10HS',Type__c='Document',Pickup_Collection_Date__c=System.today());
        insert testCon;
        
        IR_Package__c testPackage = new IR_Package__c(Height__c=1,Length__c=1,Width__c=1,Weight_kg__c=1,Consignment_IR__c=testCon.Id);
        insert testPackage;
        testCust = IR_Global_Class.getCustomer(testCust.Id);
		testOrder = IR_Global_Class.getOrder(testOrder.Id);		       
        testCon = IR_Global_Class.getConsignment(testCon.Id);
        testPackage = IR_Global_Class.getPackage(testPackage.Id);
        Test.startTest();
        System.debug(IR_ExpressConnect.book(testCust, testOrder, testCon));
        Test.stopTest();
    }
    
    TestMethod static void test_book_parseResponse() {
        Test.startTest();
        System.debug(IR_ExpressConnect.book_parseResponse(''));
        System.debug(IR_ExpressConnect.book_parseResponse('123:456'));
        Test.stopTest();
    }
    /********************************************************************/
    /**********************END OF HAPPY DAY SCENARIO*********************/
    /********************************************************************/
}