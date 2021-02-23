({
    initHelper : function(component, event, helper) {
        /*
        console.log('initHelper: ' , component.get('v.recordId'));
        var action = component.get("c.initLauncher");
        action.setParams({
            'recordId': component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            
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
                    component.set('v.cliente', result.cliente);
                    
                    if(result.auto){
                        var marcas = [];
                        marcas.push('Ford');
                        marcas.push('Chevrolet');
                        marcas.push('Fiat');
                        
                        var ajustes = [];
                        ajustes.push('10');
						ajustes.push('20');
						
					}}
				}
				else if(state==='ERROR'){

				}
			
		});
		$A.enqueueAction(action);
        */
    }

})