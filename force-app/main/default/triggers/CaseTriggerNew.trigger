trigger CaseTriggerNew on Case (before insert,before update) {
	if((Trigger.isInsert && Trigger.isbefore) || (Trigger.isUpdate && Trigger.isbefore)){
        CaseTriggerHandlerNew.checkCaseActive(Trigger.new);
    }
}