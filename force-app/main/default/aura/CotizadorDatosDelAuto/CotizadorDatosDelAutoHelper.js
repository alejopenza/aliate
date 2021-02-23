({
    initHelper : function(component, event, helper) {
        
        //DO INIT
        var action = component.get("c.doInit");
        
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

                    //MODULOS COBERTURAS
                    console.log('modulosCoberturas: ' , JSON.stringify(result.modulosCoberturas));
                    var options = [];
                    for(var i = 0 ; i < result.modulosCoberturas.length; i++){
                        var option = {
                            'label': result.modulosCoberturas[i].Nombre__c,
                            'value': result.modulosCoberturas[i].Codigo__c.toString()
                        }
                        options.push(option);
                    }
                    component.set('v.options',options);

                    console.log('modulosCoberturasSC: ' , JSON.stringify(result.modulosCoberturasSC));
                    var optionsSC = [];
                    for(var i = 0 ; i < result.modulosCoberturasSC.length; i++){
                        var option = {
                            'label': result.modulosCoberturasSC[i].Description__c,
                            'value': result.modulosCoberturasSC[i].Code__c.toString()
                        }
                        optionsSC.push(option);
                    }
                    component.set('v.optionsCoberturasSC', optionsSC);
                    
                    //TIPOS DE ACCESORIOS
                    console.log('tiposDeAccesorios: ' , JSON.stringify(result.tiposDeAccesorios));
                    options = [];
                    for(var i = 0 ; i < result.tiposDeAccesorios.length; i++){
                        var option = {
                            'label': result.tiposDeAccesorios[i].Nombre__c,
                            'value': result.tiposDeAccesorios[i].Codigo__c
                        }
                        console.log(option);
                        options.push(option);
                    }
                    component.set('v.optionsAccesorios',options);

                    //PERIODOS DE VALIDEZ
                    console.log('periodosDeValidez: ' , JSON.stringify(result.periodosDeValidez));
                    options = [];
                    for(var i = 0 ; i < result.periodosDeValidez.length; i++){
                        var option = {
                            'label': result.periodosDeValidez[i].Nombre__c,
                            'value': result.periodosDeValidez[i].Codigo__c
                        }
                        options.push(option);
                    }
                    component.set('v.optionsValidez',options);
                    
                    //FRECUENCIA DE PAGO
                    console.log('frecuenciaPagos: ' , JSON.stringify(result.frecuenciaPagos));
                    options = [];
                    for(var i = 0 ; i < result.frecuenciaPagos.length; i++){
                        var option = {
                            'label': result.frecuenciaPagos[i].Nombre__c,
                            'value': result.frecuenciaPagos[i].Codigo__c
                        }
                        options.push(option);
                    }
                    component.set('v.optionsFrecuencia',options);

                    //INFO AUTO MARCAS
                    console.log('marcas: ' , result.marcasIA);
                    options = [];
                    for(var key in result.marcasIA){
                        var option = {
                            'label': result.marcasIA[key],
                            'value': key
                        }
                        options.push(option);
                    }
                    component.set('v.marcasIA',options);

                    //Medios de Pago
                    component.set('v.mediosDePago', [ 'DEBITO AUTOMATICO', 'EFECTIVO', 'TARJETA DE CREDITO' ]);

                    //Auto
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
                    
                    var auto = {
                        'marca': null,
                        'ajustes': ajustes,
                        'ajuste': null,
                        'uso': false,
                        'gnc': false,
                        'sumaAseguradaGNC': null,
                        'km': false,
                        'rastreador': false,
                        'accesorio': false,
                        'sumaAsegurada': null,
                        'codigosDeModuloDeCoberturas': null
                    };
                    component.set('v.auto', auto);

                    var anios = [];
                    anios.push('1980');
                    anios.push('1981');
                    anios.push('1982');
                    anios.push('1983');
                    anios.push('1984');
                    anios.push('1985');
                    anios.push('1986');
                    anios.push('1987');
                    anios.push('1988');
                    anios.push('1989');
                    anios.push('1990');
                    anios.push('1991');
                    anios.push('1992');
                    anios.push('1993');
                    anios.push('1994');
                    anios.push('1995');
                    anios.push('1996');
                    anios.push('1997');
                    anios.push('1998');
                    anios.push('1999');
                    anios.push('2000');
                    anios.push('2001');
                    anios.push('2002');
                    anios.push('2003');
                    anios.push('2004');
                    anios.push('2005');
                    anios.push('2006');
                    anios.push('2007');
                    anios.push('2008');
                    anios.push('2009');
                    anios.push('2010');
                    anios.push('2011');
                    anios.push('2012');
                    anios.push('2013');
                    anios.push('2014');
                    anios.push('2015');
                    anios.push('2016');
                    anios.push('2017');
                    anios.push('2018');
                    anios.push('2019');
                    anios.push('2020');
                    anios.push('2021');
                    component.set('v.aniosIA', anios);

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
    doNext:function(component, event, helper){
        console.log('doNext()');
        var auto = component.get('v.auto');

        var nuevoAuto = {
            'marca': auto.marca,
            'modelo': auto.modelo,
            'version': auto.version,
            'anio': auto.anio,
            'uso': auto.uso,
            'gnc': auto.gnc,
            'km': auto.km,
            'rastreador': auto.rastreador,
            'sumaAseguradaGNC': auto.sumaAseguradaGNC,
            'ajuste': auto.ajuste,
            'accesorio': auto.accesorio,
            'tipoAccesorio': auto.tipoAccesorio,
            'sumaAseguradaAccesorio': auto.sumaAseguradaAccesorio,
            'sumaAsegurada': auto.sumaAsegurada,
            'codigosDeModuloDeCoberturas': component.get('v.value'),
            'codigosDeModuloDeCoberturasSC': component.get('v.valueCoberturasSC'),
            'periodoDeValidez': auto.periodoDeValidez,
            'frecuenciaPago': auto.frecuenciaPago,
            'cuota': auto.cuota
        };
        
        component.set('v.isLoading', true);
        component.set('v.auto', nuevoAuto);

        var cmpEvent = component.getEvent("eventoCotizaciones");
        cmpEvent.setParams({
            'auto': component.get('v.auto')
        });
        cmpEvent.fire();
        component.set('v.isLoading', false);
    },
    handleChangeVersion: function(component, event, helper){
        console.log(JSON.stringify(component.get('v.auto')));
    },
    handleChangeMarca: function(component, event, helper){

        //GET MODELOS
        var action = component.get("c.doGetModelos1");
        action.setParams({
            'codigoMarca': event.getSource().get('v.value')
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

                    //INFO AUTO MODELOS
                    console.log('modelos: ' , result.modelosIA);
                    var options = [];
                    for(var key in result.modelosIA){
                        var option = {
                            'label': result.modelosIA[key],
                            'value': key
                        }
                        options.push(option);
                    }
                    component.set('v.modelosIA',options);
                    console.log('modelosIA: ' , JSON.stringify(component.get('v.modelosIA')));
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
    handleChangeModelo: function(component, event, helper){
        console.log(JSON.stringify(component.get('v.auto')));
    },
    handleChangeAnio: function(component, event, helper){
        //GET VERSIONES
        var action = component.get("c.doGetVersiones");
        var auto = component.get('v.auto');
        action.setParams({
            'marca': auto.marca,
            'modelo': auto.modelo,
            'anio': auto.anio
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

                    //INFO AUTO VERSIONES
                    console.log('versiones: ' , result.versionesIA);
                    var options = [];
                    for(var key in result.versionesIA){
                        var option = {
                            'label': result.versionesIA[key],
                            'value': key
                        }
                        options.push(option);
                    }
                    component.set('v.versionesIA',options);
                    console.log('versionesIA: ' , JSON.stringify(component.get('v.versionesIA')));

                    console.log('length: ' , options.length);
                    if(options.length === 0){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": 'No se encontraron versiones para este anio, por favor intente con otro.',
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
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
    doBefore: function(component, event, helper){
        //demo
        var cmpEvent = component.getEvent("eventoAtras");
        cmpEvent.fire();
    },
    handleGNC: function(component, event, helper){
        var auto = component.get('v.auto');
        auto.gnc = event.getSource().get('v.checked');
        component.set('v.auto', auto);
        console.log(JSON.stringify(component.get('v.auto')));
    },
    handleUso: function(component, event, helper){
        var auto = component.get('v.auto');
        auto.uso = event.getSource().get('v.checked');
        component.set('v.auto', auto);
        console.log(JSON.stringify(component.get('v.auto')));
    },
    handleKM: function(component, event, helper){
        var auto = component.get('v.auto');
        auto.km = event.getSource().get('v.checked');
        component.set('v.auto', auto);
        console.log(JSON.stringify(component.get('v.auto')));
    },
    handleRastreador: function(component, event, helper){
        var auto = component.get('v.auto');
        auto.rastreador = event.getSource().get('v.checked');
        component.set('v.auto', auto);
        console.log(JSON.stringify(component.get('v.auto')));
    },
    handleAccesorio: function(component, event, helper){
        var auto = component.get('v.auto');
        auto.accesorio = event.getSource().get('v.checked');
        component.set('v.auto', auto);
        console.log(JSON.stringify(component.get('v.auto')));
    }
})