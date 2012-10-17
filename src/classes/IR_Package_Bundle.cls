public class IR_Package_Bundle {
    public IR_Package__c thePackage {get; set;}
    public Integer index {get; set;}
    public Integer packageRef {get; set;}
    
    public IR_Package_Bundle(Integer packageRef, IR_Package__c thePackage) {
        try {
            this.thePackage = thePackage;
            this.index = (Math.random() * 100000).intValue();
            this.packageRef = packageRef;
            this.thePackage.Sequence__c = Decimal.valueOf(packageRef);
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
}