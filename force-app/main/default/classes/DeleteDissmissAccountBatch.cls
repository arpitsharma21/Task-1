
public class DeleteDissmissAccountBatch implements Database.Batchable<sObject>, Schedulable,Database.stateful{
    // To maintain variable value inside the Batch class, Database.stateful is used
    private Integer batchSize;
    public Integer sized = 0;
    
    //this returns either a Database.QueryLocator or a iterator that contains records which is passed to execute method
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Account WHERE Dismissed__c = true]);
    }
    
    //this method takes list of account and delete it
    public void execute(Database.BatchableContext bc, List<Account> accList){
        List<Account> accToBeDeleted = new List<Account>();
        for(Account acc: accList){
            accToBeDeleted.add(acc);
        }
        //storing the size of accToBeDeleted in sized variable
        sized = sized + accToBeDeleted.size();
        
        if(!accToBeDeleted.isEmpty()){
            //deleting the accounts
            delete accToBeDeleted;
        }
    }
    
    //this method shows how many records are being deleted
     public void finish(Database.BatchableContext context) {
        System.debug('Total accounts deleted are: '+sized);
    }
    
    //implements the schedule method
    public void execute(SchedulableContext sc){
        //querying meta data
        Decimal batchConfig = Account_Batch__mdt.getInstance('Batch_Size').Value__c;
        Integer configuredBatchSize = Integer.valueOf(batchConfig);
        
        if (configuredBatchSize != null && configuredBatchSize > 0) {
            this.batchSize = configuredBatchSize;
        }
        
        //Database.executeBatch(this, this.batchSize);
        DeleteDissmissAccountBatch batch = new DeleteDissmissAccountBatch();
        // Schedule the batch job with the specified batch class, job name, and batch size
        return System.scheduleBatch(batch, 'DeleteDissmissAccountBatch', batchSize);
    }
} 