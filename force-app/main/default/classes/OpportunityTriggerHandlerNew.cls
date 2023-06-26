public class OpportunityTriggerHandlerNew {
    public static void checkOppActive(List<Opportunity> oppList){
        //set to store the unique Account IDs associated with the opportunities.
        Set<Id> accId = new Set<Id>();
        for(Opportunity opp: oppList){
            //is opportunity have any account associated , if yes then that account Id is put in set
            if(opp.AccountId != null){
                accId.add(opp.AccountId);
            }
        }
        
        //it fetches all the active opportunities whose accountId are present in set
        List<Opportunity> activeOpp = [Select Id,Active__c from Opportunity where AccountId in: accId and Active__c = true];
        
        for(Opportunity opp: oppList){
            //checks if there are one or more active opportunities with the same account and current opp Active is true 
            if(activeOpp.size() >= 1 && opp.Active__c == true){
                //it shows error by using addError method  and prevents any creation or updation
                opp.addError('An Active Opportunity already associated with this account');
            }
        }
    }
}