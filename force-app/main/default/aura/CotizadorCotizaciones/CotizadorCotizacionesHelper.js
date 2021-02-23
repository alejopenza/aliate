({
    initHelper: function(component, event, helper){

        var oppId = component.get('v.oppId');
        if(oppId === ''){
            console.log('oppId esta vacio: se pone en null');
            oppId = null;
        }
        console.log('oppId: ' , oppId);

        component.set('v.columns', [
            {label: 'Aseguradora', fieldName: 'aseguradora', type: 'text'},
            {label: 'Descripcion', fieldName: 'descripcionCorta', type: 'text'},
            {label: 'Iva Mensual', fieldName: 'ivaMensual', type: 'number'},
            {label: 'Iva Total', fieldName: 'ivaTotal', type: 'number'},
            {label: 'Premio Mensual', fieldName: 'premioMensual', type: 'number'},
            {label: 'Premio Total', fieldName: 'premioTotal', type: 'number'}
        ]);

        var action = component.get("c.doSancorCallout");
        action.setParams({
            'auto': JSON.stringify(component.get('v.auto')),
            'cliente': JSON.stringify(component.get('v.cliente')),
            'oppId': oppId
        });
        component.set('v.isLoading', true);
        component.set('v.sancorCallout', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            component.set('v.sancorCallout', false);
            var state = response.getState();
            console.log('state: ' , state);
            
            let result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('result: ' , result);
                
                if(result.hasError){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error al cotizar con SANCOR!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    
                    var wrapper = response.getReturnValue();
                    
                    //AUTO
                    var data = [];

                    //SANCOR
                    console.log('cotizaciones: ' , wrapper.cotizacionesSancor);
                    for(var i = 0; i < wrapper.cotizacionesSancor.length; i++){
                        data.push(wrapper.cotizacionesSancor[i]);
                    }
                    component.set('v.data', data);

                }

                //SAN CRISTOBAL
                this.sanCristobal(component, event, helper, oppId);
                
            }else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error al cotizar con SANCOR!",
                    "message": result.errors[0],
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    sanCristobal: function(component, event, helper, oppId){
        var action = component.get("c.doSanCristobalCallout");
        action.setParams({
            'auto': JSON.stringify(component.get('v.auto')),
            'cliente': JSON.stringify(component.get('v.cliente')),
            'oppId': oppId
        });
        component.set('v.isLoading', true);
        component.set('v.sanCristobalCallout', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            component.set('v.sanCristobalCallout', false);
            var state = response.getState();
            console.log('state: ' , state);
            
            let result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('result: ' , result);
                
                if(result.hasError){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error al cotizar con SAN CRISTOBAL!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    
                    var wrapper = response.getReturnValue();
                    
                    //AUTO
                    var data = component.get('v.data');

                    //SAN CRISTOBAL
                    console.log('cotizaciones: ' , wrapper.cotizacionesSanCristobal);
                    for(var i = 0; i < wrapper.cotizacionesSanCristobal.length; i++){
                        data.push(wrapper.cotizacionesSanCristobal[i]);
                    }
                    component.set('v.data', data);
                    console.log('termino!');
                }
            }else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error al cotizar con SAN CRISTOBAL!",
                    "message": result.errors[0],
                    "type": "error"
                });
                toastEvent.fire();
            }

            this.cotizacionRioUruguay(component, event, helper, oppId);
        });
        $A.enqueueAction(action);
    },
    cotizacionRioUruguay: function (component, event, helper, oppId) {
        var action = component.get("c.doRioUruguayCallout");

        action.setParams(
            {
                'auto': JSON.stringify(component.get('v.auto')),
                'cliente': JSON.stringify(component.get('v.cliente'))
            }
        );

        component.set('v.isLoading', true);
        component.set('v.rioUruguayCallout', true);

        action.setCallback(
            this,
            function (response) {
                component.set('v.isLoading', false);
                component.set('v.rioUruguayCallout', false);

                let errorTitle = "Error al cotizar con RIO URUGAY SEGUROS!";
                let result = response.getReturnValue();
                let state = response.getState();

                if (state === "SUCCESS") {

                    if (result.hasError) {
                        this.launchToast(errorTitle, result.errors[0]);
                    } else {
                        var wrapper = response.getReturnValue();
                        var data = component.get('v.data');

                        console.log('cotizaciones: ', wrapper.cotizacionesRUS);
                        for (var i = 0; i < wrapper.cotizacionesRUS.length; i++) {
                            data.push(wrapper.cotizacionesRUS[i]);
                        }
                        component.set('v.data', data);
                    }

                } else if (state === 'ERROR') {
                    this.launchToast ( errorTitle, result.errors[0] );
                }

                //todo aqui iria el metodo al siguiente callback para la siguiente integracion
                //this.doAnotherCompanyCallout(component, event, helper);
            }
        );
        $A.enqueueAction(action);

    },
    launchToast: function (title, errorMessage, errorType) {
        var type = errorType ? errorType : "error";

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": errorMessage,
            "type": type
        });
        toastEvent.fire();
    }
})