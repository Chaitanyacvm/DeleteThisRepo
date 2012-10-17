public class DMD_InspectionFormItem_Controller {

    public Id InspectionFormItemId {get;set;}
    public Inspection_Form_Item__c InspectionFormItem {get;set;}
    public String AnswerVal{get;set;}
    public String AnswerPickListVal{get;set;}
    public Map<String, Decimal> MapSelectOptions {get;set;}
    public String PicklistAnswerTypePanel{get;set;}
    public String FreeFormTextAnswerTypePanel{get;set;}

    public DMD_InspectionFormItem_Controller(ApexPages.StandardController controller) {
        InspectionFormItem  = new Inspection_Form_Item__c();
        MapSelectOptions = new Map<String, Decimal>();
        InspectionFormItemId = ApexPages.currentPage().getParameters().get('id');
        InspectionFormItem.Picklist_Builder__c = '';
        if(InspectionFormItemId != null){
            InspectionFormItem = getInspectionFormItemDetail(InspectionFormItemId);
            if(InspectionFormItem.Answer_Type__c == 'Picklist'){
                PicklistAnswerTypePanel = 'block';
                FreeFormTextAnswerTypePanel = 'none';
                AnswerPickListVal = InspectionFormItem.Answer__c;
            }else{
                PicklistAnswerTypePanel = 'none';
                FreeFormTextAnswerTypePanel = 'block';
                AnswerVal = InspectionFormItem.Answer__c;
            }
        }
    }
    
    public void setAnswerPickListVal(String value){
        this.AnswerPickListVal = value;
    }
    
    public String getAnswerPickListVal(){
        return this.AnswerPickListVal;
    }
    
    public void setPicklistAnswerTypePanel(String value){
        this.PicklistAnswerTypePanel = value;
    }
    
    public void setFreeFormTextAnswerTypePanel(String value){
        this.FreeFormTextAnswerTypePanel = value;
    }
    
    public void setAnswerVal(String value){
        this.AnswerVal = value;
    }
    
    public String getAnswerVal(){
        return this.AnswerVal;
    }
    
    public void setInspectionFormItem(Inspection_Form_Item__c value){
        this.InspectionFormItem = value;
    }
    
    public Inspection_Form_Item__c getInspectionFormItem(){
        return this.InspectionFormItem;
    }
    
    public void setInspectionFormItemId(Id value){
        this.InspectionFormItemId = value;
    }
    
    public void setMapSelectOptions(Map<String, Decimal> value){
        this.MapSelectOptions = value;
    }
    
    public Id getInspectionFormItemId(){
        return this.InspectionFormItemId;
    }
    
    public Inspection_Form_Item__c getInspectionFormItemDetail(Id InspectionFrmItmid){
        
        Inspection_Form_Item__c tempData = new Inspection_Form_Item__c();
        tempData = [SELECT Score__c, Question__c, PUD_Fleet_Operational__c, Name, Id, Group_Number__c, Answer_Type__c, Data_Type__c, 
        Group_Name__c, Form__c, Date_Completed__c, By_Whom__c, Answer__c, Action_Required__c, Picklist_Builder__c, Picklist_Score__c
        FROM Inspection_Form_Item__c i WHERE i.Id =: InspectionFrmItmid LIMIT 1];
        
        return tempData;
    }
    
    public List<SelectOption> getAnswerValueList()
    {
       List<SelectOption> options = new List<SelectOption>();
       if(InspectionFormItem.Picklist_Builder__c != null){
           String PicklistBuild = InspectionFormItem.Picklist_Builder__c;    
           String[] AnswerList = PicklistBuild.split('\n');
           PicklistBuild = InspectionFormItem.Picklist_Score__c;
           String[] ScoreList = PicklistBuild.split('\n');
           Integer index = 0;
           for( String s : AnswerList)
           {
              String tempData = ScoreList[index].trim();
                if(tempData.contains('.') == false){
                    tempData = tempData + '.0';
                }
                Decimal temp = decimal.valueOf(tempData);
                MapSelectOptions.put(s.trim(), temp);
              options.add(new SelectOption(s.trim(), s.trim()));
              index = index + 1;
           }       
       }
       return options;
    }
    
    /*PageReference operations, which are Save(), Cancel() and SaneAndNew() methods*/
    public PageReference Save() {
        PageReference InspectionFormItemPage = new ApexPages.StandardController(InspectionFormItem).view();
        InspectionFormItemPage.setRedirect(true);
        
        try{
            
            if(InspectionFormItem.Answer_Type__c.equalsIgnoreCase('Free form text')){
                if(InspectionFormItem.Data_Type__c.trim().equalsIgnoreCase('Number')){
                    Boolean checkNum = pattern.matches('[a-zA-Z]+', AnswerVal.trim());
                    if(checkNum == true){
                        AnswerVal = '';
                        InspectionFormItem.addError('Answer field has to be Number');
                        return null;
                    }
                }
                InspectionFormItem.InspectionScore__c = 1.0;
                InspectionFormItem.Maximum_Score__c = 1.0;
                InspectionFormItem.Answer__c = AnswerVal;
            }else{
                InspectionFormItem.InspectionScore__c = MapSelectOptions.get(AnswerPickListVal);
                InspectionFormItem.Answer__c = AnswerPickListVal;
            }
            update InspectionFormItem;
        }catch(DMLException dmlEx){
            InspectionFormItem.addError(dmlEx.getMessage());
        }
        
        return new ApexPages.StandardController(InspectionFormItem).view();
    }
   
    public PageReference Cancel() {
        PageReference InspectionFormItemPage = new ApexPages.StandardController(InspectionFormItem).view();
        InspectionFormItemPage.setRedirect(false);
        return InspectionFormItemPage;
    }
    
    /*End*/
    
    /*Test case*/
    TestMethod static void TestUpdateOperation(){
    	Form__c form = new Form__c();
    	Inspection_Form_Item__c TestIFI = new Inspection_Form_Item__c();
    	form = [SELECT Id, Name, Date__c FROM Form__c order by Date__c desc LIMIT 1];
    	
    	TestIFI.Answer_Type__c = 'Free form Text';
    	TestIFI.Answer__c = 'for deploy';
    	TestIFI.Data_Type__c = 'Text';
    	TestIFI.Form__c = form.Id;
    	TestIFI.Group_Name__c = 'Cloud';
    	TestIFI.Group_Number__c = 2.0;
    	TestIFI.InspectionScore__c = 1.0;
    	TestIFI.Maximum_Score__c = 1.0;
    	TestIFI.Question__c = 'Why Test?';
    	
    	insert TestIFI;
    	
    	ApexPages.CurrentPage().getParameters().put('id', TestIFI.Id);
    	Test.startTest();
    	DMD_InspectionFormItem_Controller cont = new DMD_InspectionFormItem_Controller(new ApexPages.StandardController(TestIFI));
    	cont.Save();
    	
    	//@Dinesh-Acharya: Test for Data Type is number
    	cont.getAnswerPickListVal();
    	cont.getAnswerVal();
    	cont.getInspectionFormItem();
    	cont.getAnswerValueList();
    	
    	cont.setAnswerPickListVal('');
    	cont.setAnswerVal('For Deploy');
    	cont.setFreeFormTextAnswerTypePanel('block');
    	cont.setInspectionFormItemId(TestIFI.Id);
    	cont.setPicklistAnswerTypePanel('none');
    	
    	TestIFI.Answer_Type__c = 'Free form Text';
    	TestIFI.Answer__c = '45';
    	TestIFI.Data_Type__c = 'Number';
    	TestIFI.Group_Name__c = 'Cloud';
    	TestIFI.Group_Number__c = 2.0;
    	TestIFI.InspectionScore__c = 1.0;
    	TestIFI.Maximum_Score__c = 1.0;
    	TestIFI.Question__c = 'Why Test?';
    	
    	cont.setInspectionFormItem(TestIFI);
    	cont.Save();
    	//End
    	
    	cont.InspectionFormItem.Answer_Type__c = 'Picklist';
    	cont.InspectionFormItem.Data_Type__c = null;
    	cont.InspectionFormItem.Answer__c = 'For Deploy';
    	cont.InspectionFormItem.InspectionScore__c = 4;
    	cont.InspectionFormItem.Maximum_Score__c = 4;
    	cont.InspectionFormItem.Picklist_Builder__c = 'For Deploy\nFor Test\nBest Practise';
    	cont.InspectionFormItem.Picklist_Score__c = '4.0\n2\n0';
    	
    	cont.getAnswerPickListVal();
    	cont.getAnswerVal();
    	cont.getInspectionFormItem();
    	cont.getAnswerValueList();
    	
    	cont.Save();
    	cont.Cancel();
    	
    	test.stopTest();
    }
    /*End Test*/
}