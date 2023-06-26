public class CaseTriggerHandlerNew {
    public static void checkCaseActive(List<Case> caseList){
        Set<Id> accIds = new Set<Id>();
        // for inserting new cases
        for(Case c : caseList){
            if(c.AccountId != null){
                accIds.add(c.AccountId);
            }
        }
        
        List<Case> activeCases = [SELECT Id, AccountId FROM Case where AccountId in: accIds and Active__c = true];
        // for updating cases
        for(Case c: caseList){
            if(activeCases.size() >= 1 && c.Active__c == true){
                c.addError('An Active Case already associated with this account');
            }
        }
    }
}