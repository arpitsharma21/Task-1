import { LightningElement,wire} from 'lwc';
//importing getDetails method from AccountDetails class
import getDetails from '@salesforce/apex/AccountDetails.getDetails';
//used to update records
import { updateRecord } from 'lightning/uiRecordApi';
//this library is used to show notifications regarding success or failure of record
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//used to refresh the window automaticaly
import { refreshApex } from '@salesforce/apex';

//defining the columns used in the Lwc table 
const COLUMNS = [
    { label: 'Account Name', fieldName: 'Name', type: 'text' },
    { label: 'Account Number', fieldName: 'AccountNumber', type: 'text' },
    { label: 'Email', fieldName: 'Email__c', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Fax', fieldName: 'Fax', type: 'phone' },
    { label: 'Website', fieldName: 'Website', type: 'url' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Rating', fieldName: 'Rating', type: 'text' },
    {label:'Active',fieldName: 'RelatedData',type:'url'},
    {
        type : 'button', typeAttributes: {
            label: 'Dismiss', // text label to be  displayed on the button
            name: 'dismiss', //name is used to identify the button 
            title: 'Click to Dismiss', // it is used to show the content when hover on the button
            variant: 'destructive'// defines the style of button
        }
    }
];

export default class Details extends LightningElement {
    columns = COLUMNS;
    //creating an empty array to store the account data
    accountData = [];

    @wire(getDetails)
    //it returns data and error in the result
    wiredResult(result){
        //here it checks if result has data then store it in accountData array 
        if(result.data){
           // this.accountData = result.data;

           this.accountData = result.data.map((account) => {
            return {
                ...account,
                Name:account.Name,
                //RelatedData: this.combineRelatedData(account)
            };
        });

            //printing on console for check
            console.log(result);
        }
        if(result.error){
            console.log('Error occured while fetching Account Data- ', result.error);
        }
    }


    combineRelatedData(account) {
        console.log('Checking');
        let contacts = account.Contacts.map((contact) => contact.Name).join(', ');
        let opportunities = account.Opportunities.map((opp) => opp.Name).join(', ');
        let cases = account.Cases.map((cas) => cas.CaseNumber).join(', ');
        console.log('Checking 2');
        return `${contacts}; ${opportunities}; ${cases}`;
    }


    //it checks if no data is present then it will return true and 'No Records found ' will be shown on LWC  
    get noRecordsFound() {
        return this.accountData.length == 0;
    }


    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        switch (action.name) {
            case 'dismiss':
                //if the action is dismiss then it will call dissmissAccount()
                this.dismissAccount(row);
                break;
            default:
                break;
        }
    }

    dismissAccount(account) {
        //creating an empty set
        const fields = {};
        console.log('Account is - ', account);
        // storing the accId in fields id
        fields.Id = account.Id;
        fields.Dismissed__c = true;

        console.log('Values are - ', fields.Id);
        console.log('Values of dismiss are - ', fields.Dismissed__c);

        const recordInput = { fields };
        
        //updating the record with the help of Id 
        updateRecord(recordInput)
            .then(() => {
                //it will display a success msg on the LWC
                this.showToast('Success', 'Account Dismissed', 'success');
                //this will remove that particular record from the table
                this.accountData = this.accountData.filter(acc => acc.Id !== account.Id);
                //it will update the table automatically
                refreshApex(this.accountData);
            })
            .catch((error) => {
                this.showToast('Error', 'Error Dismissing Account', 'error');
                console.error(error);
            });
    }

    showToast(title, message, variant) {
        //creating new instance of ShowToastevent with its value provided by the arguments
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        //it triggers the  event to display a toast notification
        this.dispatchEvent(toastEvent);
    }
}