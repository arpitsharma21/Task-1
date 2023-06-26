trigger ContactTriggerNew on Contact (before insert,before update) {
    if((Trigger.isInsert && Trigger.isbefore) || (Trigger.isUpdate && Trigger.isbefore)){
        ContactTriggerHandlerNew.checkContactActive(Trigger.new);
    }
}