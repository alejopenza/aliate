({
    init : function(component, event, helper) {
        console.log('init');

        var action = component.get("c.doInit");
        action.setParams({
            'recordId': component.get('v.recordId')
        });

        action.setCallback(this, function(response) {

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
                }else{
                    component.set('v.cliente', result.cliente);
                    component.set('v.cotizacion', result.cotizacion);
                    component.set('v.ramo', result.ramo);
                    if (result.ramo === 'Automotor') {
                        var marcas = [];
                        marcas.push('Ford');
                        marcas.push('Chevrolet');
                        marcas.push('Fiat');

                        var ajustes = [];
                        ajustes.push('10');
                        ajustes.push('20');
                        ajustes.push('30');
                        ajustes.push('40');
                        ajustes.push('50');
                        ajustes.push('60');
                        ajustes.push('70');
                        ajustes.push('80');
                        ajustes.push('90');
                        ajustes.push('100');
                        
                        var tiposDeCobertura = [];
                        tiposDeCobertura.push('Contra Terceros');
                        tiposDeCobertura.push('Todo Riesgo');
                        
                        var initAuto = result.auto;
                        console.log('initAuto: ' , initAuto);
                        
                        var modelos = [];
                        modelos.push(initAuto.modelo);
                        
                        var anios = [];
                        anios.push(initAuto.anio);
                        
                        var versiones = [];
                        versiones.push(initAuto.version);
                        
                        var auto = {
                            'marcas': marcas,
                            'marca': initAuto.marca,
                            'modelos': modelos,
                            'modelo': initAuto.modelo,
                            'anio': initAuto.anio,
                            'anios': anios,
                            'version': initAuto.version,
                            'versiones': versiones,
                            'ajustes': ajustes,
                            'ajuste': initAuto.ajuste,
                            'uso': initAuto.uso,
                            'gnc': initAuto.gnc,
                            'sumaAseguradaGNC': initAuto.sumaAseguradaGNC,
                            'km': initAuto.km,
                            'rastreador': initAuto.rastreador,
                            'tiposDeCobertura': tiposDeCobertura,
                            'accesorio': initAuto.accesorio,
                            'tipoAccesorio': initAuto.tipoAccesorio,
                            'sumaAseguradaAccesorio': initAuto.sumaAseguradaAccesorio,
                            'tipoDeCobertura': initAuto.tipoDeCobertura,
                            'patente': initAuto.patente,
                            'nroMotor': initAuto.nroMotor,
                            'nroChasis': initAuto.nroChasis
                        };
                        component.set('v.auto', auto);
                    }else{
                        var nomina = [];
                        for(var i=0; i<result.nomina.length; i++){
                            nomina.push(result.nomina[i]);
                        }
                        console.log('nomina: ' , nomina)
                        component.set('v.nomina', nomina);
                    }
                    component.set('v.isLoading', false);
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
    }
})