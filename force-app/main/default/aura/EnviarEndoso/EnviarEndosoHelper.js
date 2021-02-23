({
	init : function(component, event, helper) {
		var action = component.get("c.doInit");
        action.setParams({
            'oppId': component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('state: ' , state);
            
            let result = response.getReturnValue();
            
            if (state === "SUCCESS") {
                console.log('stringify: ' , JSON.stringify(result));
                
                if(result.hasError){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result.endosoId
                    });
                    navEvt.fire();
                }
            }
            else if(state==='ERROR'){
                
            }
            
        });
        $A.enqueueAction(action);
	}
})