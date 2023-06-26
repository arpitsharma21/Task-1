trigger OpportunityTriggerNew on Opportunity (before insert) {
	if((Trigger.isInsert && Trigger.isbefore) || (Trigger.isUpdate && Trigger.isbefore)){
        OpportunityTriggerHandlerNew.checkOppActive(Trigger.new);
    }
}