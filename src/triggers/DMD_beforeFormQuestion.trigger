trigger DMD_beforeFormQuestion on Inspection_Form_Question__c (before insert, before update) {
    List<Inspection_Form_Question__c> FormQuestionList = new List<Inspection_Form_Question__c>(trigger.new);
    
    for(Inspection_Form_Question__c IFQ: FormQuestionList){
        if(IFQ.Answer_Type__c.trim().equalsIgnoreCase('picklist') && IFQ.Picklist_Builder__c != null && IFQ.Picklist_Score__c != null){
        	String[] splitPicklistBuilderLine = IFQ.Picklist_Builder__c.split('\n');
	        String[] splitPicklistScoreLine = IFQ.Picklist_Score__c.split('\n');
	        
	        if(splitPicklistBuilderLine.size() != splitPicklistScoreLine.size()){
	            IFQ.addError('Number of Picklist Builder values does not match with Picklist Score');
	        }
	        Integer index = 0;
	        for(String s: splitPicklistBuilderLine){
	        	s = s.trim();
	        	if(s.length() < 1){
	        		IFQ.addError('Picklist Builder value can\'t have space as option');
	        	}
	        }	
        }else if(IFQ.Answer_Type__c.trim().equalsIgnoreCase('picklist') && (IFQ.Picklist_Builder__c == null || IFQ.Picklist_Builder__c == '')){
        	IFQ.addError('Picklist Builder value can\'t be empty');
        }else if(IFQ.Answer_Type__c.trim().equalsIgnoreCase('picklist') && (IFQ.Picklist_Score__c == null || IFQ.Picklist_Score__c == '')){
        	IFQ.addError('Picklist Score value can\'t be empty');
        }
    }
    
}