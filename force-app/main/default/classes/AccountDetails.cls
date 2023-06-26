public with sharing class AccountDetails {
   //method to get account and its associated contact,case and opportunity details 
    @AuraEnabled(cacheable=true)
    public static List<Account> getDetails(){
        try {
            //creating a new instance of account
            List<Account> accountData = new List<Account>();
            //Quering Account details where dismiss is not true and showing 10 data
            accountData = [Select ID,Name,AccountNumber, Email__c,Phone,Fax,Website,Industry,Rating,
                            //SubQuerying Contact data where active is true
                            (Select ID,Name from Contacts WHERE Active__c= true),
                            (Select Id,CaseNumber from Cases where Active__c= true),
                            (Select Id,Name from Opportunities where Active__c= true)
                            from Account where Dismissed__c != true 
                            ORDER BY CreatedDate DESC limit 10];
            return accountData;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}