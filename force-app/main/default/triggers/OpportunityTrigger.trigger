trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            
        }else if(Trigger.isUpdate){
            
        }
    }else if(Trigger.isAfter){
        if(Trigger.isInsert){
            
        }else if(Trigger.isUpdate){
            //OpportunityHelper.handleEndoso(trigger.oldMap, trigger.new);
        }
    }
}