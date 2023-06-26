public class ContactTriggerHandlerNew {
    public static void checkContactActive(List<Contact> conList){
        //set to store the unique Account IDs associated with the contacts.
        Set<Id> accountIds = new Set<Id>();
        // for inserting new contacts
        for(Contact con : conList){
            //is contact have any account associated , if yes then that account Id is put in set
            if(con.AccountId != null){
                accountIds.add(con.AccountId);
            }
        }
        
        //it fetches all the active contacts whose accountId are present in set
        List<Contact> confetch = [Select Id,Name,Active__c from Contact where AccountId in: accountIds and Active__c = true];

        // for updating contacts
        for(Contact con:conList){
            //checks if there are one or more active contacts with the same account and current contact Active is true 
            if(confetch.size() >= 1 && con.Active__c == true){
                //it shows error by using addError method and prevents any creation or updation
                con.addError('An Active Contact already associated with this account');
            }
        }
    }
}