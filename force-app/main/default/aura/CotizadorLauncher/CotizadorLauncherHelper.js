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
                            'tipoDeCobertura': initAuto.tipoDeCobertura
                        };
                        console.log('auto: ' , auto);
                        component.set('v.auto', auto);
                        
                        component.set('v.cotizacion', result.cotizacion);
                    }
                    
                }
            }else if(state === 'ERROR'){
                
            }
        });
        $A.enqueueAction(action);
        */
    }
})