({
    initHelper: function(component, event, helper){
        var action = component.get("c.initEmitirPolizaLauncher");

        action.setParams( {  'recordId': component.get('v.recordId') } );

        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);

            var state = response.getState();
            console.log('state: ' , state);

            let result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                console.log('stringify: ' , JSON.stringify(result));

                if(result.hasError){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                } else {

                    var oppStage = result.cotizacion.StageName.toUpperCase();
                    if ('CLOSED LOST' === oppStage || 'CLOSED WON' === oppStage) {
                        toastEvent.setParams({
                            "title": "Operacion No Realizable",
                            "message": 'No Puede Realizar una Emision Sobre una Oportunidad Cerrada.',
                            "type": "error"
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                    }

					component.set('v.presupuestos', result.presupuestos);
                    var vida = false;
                    var items = [];
                    // se podria mejorar ¿?
                    for(var i = 0 ; i < result.presupuestos.length; i++){
                        for(var j = 0 ; j < result.presupuestos[i].QuoteLineItems.length; j++){
                            items.push(result.presupuestos[i].QuoteLineItems[j].Product2);
                            if(result.presupuestos[i].QuoteLineItems[j].Product2.RecordType.DeveloperName === 'Vida'){
                                vida = true;
                            }
                            break;
                        }
                    }

                    console.log(vida);
                    component.set('v.vida', vida);
                    component.set('v.items', items);

                    component.set('v.mediosDePago', [ 'DEBITO AUTOMATICO', 'EFECTIVO', 'TARJETA DE CREDITO' ]);
                    component.set('v.origenesDePago', [ 'VISA', 'MASTERCARD' ]);

                    var aniosDeVencimiento = [...Array(10).keys()].map(i => i + (new Date()).getFullYear());
                    component.set('v.aniosVencimientoTarjetaDeCredito', aniosDeVencimiento);
                }
            }else if(state === 'ERROR'){
                // Tenemos que hacer algo con esto.
            }
        });
        $A.enqueueAction(action);
    },
    handleEmitirPoliza : function(component, event, helper) {
        console.log('handleEmitirPoliza(): ');
        
        var nroMotor = 0;
        var nroChasis = 0;
        var patente = '';
        
        // Necesario hacer el find?
        if(component.get('v.vida') === false){
        	nroMotor = component.find('nroMotor').get('v.value');
        	nroChasis = component.find('nroChasis').get('v.value');
            patente = component.find('patente').get('v.value');
        }
        
        var action = component.get("c.emitirPoliza");
        action.setParams({
            'recordId': component.get('v.selectedItemId'),
            'presupuestos': component.get('v.presupuestos'),
            'medioDePago': component.get('v.medioDePago'),
            'origenDePago': component.get('v.origenDePago'),
            'numeroTarjetaCredito': component.get('v.numeroTarjetaDeCredito'),
            'nombreTarjetaCredito': component.get('v.nombreTarjetaDeCredito'),
            'CBU': component.get('v.CBU'),
            'nroMotor': nroMotor,
            'nroChasis': nroChasis,
            'mesVencimientoTarjetaCredito': component.get('v.mesVencimientoTarjeta'),
            'anioVencimientoTarjetaCredito': component.get('v.anioVencimientoTarjeta'),
            'patente': patente
        });
        component.set('v.isLoading', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            
            var state = response.getState();
            console.log('state: ' , state);
            
            let result = response.getReturnValue();
            
            if (state === "SUCCESS") {
                console.log('stringify: ' , JSON.stringify(result));
                
                var toastEvent = $A.get("e.force:showToast");
                if(result.hasError){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": 'Poliza Emitida!',
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    /*$A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();*/
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result.returnId
                    });
                    navEvt.fire();
                    
                }
            }else if(state === 'ERROR'){
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
    handleSiguiente: function(component, event, helper){
        component.set('v.showEmitirButton', true);
    },
    handleAtras: function(component, event, helper){
        component.set('v.showEmitirButton', false);
    },
    

})