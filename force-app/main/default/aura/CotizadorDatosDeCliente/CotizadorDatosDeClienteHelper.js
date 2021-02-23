({
    initHelper : function(component, event, helper) {
        
    },
    doNext: function(component, event, helper){
        console.log('numero: ' , component.find("numero").get("v.value"));
        console.log('typeSelected: ' , component.get('v.typeSelected'));

        var sexo = '';
        if(component.get('v.typeSelected') === 'DNI'){
            console.log('sexo: ' , component.find("sexo").get("v.value"));
            sexo = component.find("sexo").get("v.value");
        }

        var action = component.get("c.doCallout1");
        action.setParams({
            numero: component.find("numero").get("v.value"),
            sexo: sexo,
            typeSelected: component.get('v.typeSelected')
        });
        
        component.set('v.isLoading', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false); 
            var state = response.getState();
            console.log('state: ' , state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log('result: ' , result);
                
                if(result.hasError){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    //component.set('v.cliente', result.cliente);
                    component.set('v.nomina', result.nomina);
                    this.getCodigoDeProvincia(component, event, helper, result.cliente);
                }
            }else if(state === 'ERROR'){
                console.log(result);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": result.errors[0],
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    getCodigoDeProvincia: function(component, event, helper, cliente){
        console.log('getCodigoDeProvincia: ' , cliente);
        var action = component.get("c.doGetCodigoDeProvincia1");
        action.setParams({
            cliente: cliente
        });
        
        component.set('v.isLoading', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false); 
            var state = response.getState();
            console.log('state: ' , state);
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log('result: ' , result);
                
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
                    console.log('cliente: ' , component.get('v.cliente'));
                }
            }else if(state === 'ERROR'){
                console.log(result);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": result.errors[0],
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
    
})