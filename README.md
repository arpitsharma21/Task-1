# Task-1

1. Create a LWC component to display Account Record Details that the user have access to (Make Account record as Private). It will have below columns:
- Account Name
- Account Number
- Email
- Phone
- Fax
- Website
- Industry
- Rating
- Active Contact (Contact Name), Case (Case Number) and Opportunity (Opp Name) Links that navigate to the respective records
- Dismiss button
2. There should be only one active related record at a time. For e.g. if one of the related contact has Active__c checkbox set to true, then the other Contacts (related to the same Account) should not be able to check this box. Similarly for opp and case records.
3. Once Dismiss button is clicked, the Dismiss__c checkbox field on that respective Account record should be checked and removed from the table automatically 
4. Create a scheduled batch class to delete the account records having Dismiss__c checkbox as true. Batch Size should be configurable using Custom Metadata and passed on to the apex class as parameter.
