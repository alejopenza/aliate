({
    initHelper: function(component, event, helper){
        console.log('initHelper()');

        component.set('v.columnsNomina', [
            {label: 'APELLIDO Y NOMBRES', fieldName: 'apenom', type: 'text'},
            {label: 'NRO DOCUMENTO', fieldName: 'doc', type: 'number'},
            {label: 'EDAD', fieldName: 'edad', type: 'number'},
            {label: 'FECHA NACIMIENTO', fieldName: 'fecha_nac', type: 'text'},
            {label: 'LOCALIDAD', fieldName: 'localidad', type: 'text'}
        ]);

        
        /*
        var oppId = component.get('v.oppId');
        if(oppId === ''){
            console.log('oppId esta vacio: se pone en null');
            oppId = null;
        }
        console.log('oppId: ' , oppId);

        component.set('v.columnsNomina', [
            {label: 'NUMERO ADHERENTE', fieldName: 'nroAdherente', type: 'number'},
            {label: 'APELLIDO Y NOMBRES', fieldName: 'apellidoYNombre', type: 'text'},
            {label: 'TIPO Y NUM DOC', fieldName: 'tipoYNumeroDocumento', type: 'text'},
            {label: 'FECHA NAC.', fieldName: 'fechaNacimiento', type: 'text'},
            {label: 'FECHA ALTA', fieldName: 'fechaAlta', type: 'text'},
            {label: 'GRUPO ADHE.', fieldName: 'grupoAdherente', type: 'text'}
        ]);
        
        var action = component.get("c.doInitCotizaciones");
        action.setParams({
            'auto': JSON.stringify(component.get('v.auto')),
            'cliente': JSON.stringify(component.get('v.cliente')),
            'oppId': oppId
        });
        component.set('v.isLoading', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            var state = response.getState();
            console.log('state: ' , state);
            
            let result = response.getReturnValue();
            if (state === "SUCCESS") {
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
                    
                    component.set('v.columns', [
                        {label: 'Aseguradora', fieldName: 'aseguradora', type: 'text'},
                        {label: 'Tipo de Cobertura', fieldName: 'tipoCobertura', type: 'text'},
                        {label: 'Precio', fieldName: 'unitPrice', type: 'text'}
                    ]);
                    
                    var wrapper = response.getReturnValue();
                    
                    //AUTO
                    var data = [];
                    for(var i = 0; i < wrapper.cotizaciones.length; i++){
                        console.log(wrapper.cotizaciones[i]);
                        data.push(wrapper.cotizaciones[i]);
                    }
                    component.set('v.data', data);
                    
                    //VIDA
                    component.set('v.columnsVida', [
                        {label: 'Aseguradora', fieldName: 'aseguradora', type: 'text'},
                        {label: 'Tipo de Cobertura', fieldName: 'tipoCobertura', type: 'text'},
                        {label: 'Cobertura Adicional', fieldName: 'coberturaAdicional', type: 'text'},
                        {label: 'Suma Asegurada Individual', fieldName: 'sumaAseguradaIndividual', type: 'number'},
                        {label: 'Total Asegurados', fieldName: 'totalAsegurados', type: 'text'},
                        {label: 'Suma Asegurada Total', fieldName: 'sumaAseguradaTotal', type: 'number'}
                    ]);
                    
                    var dataVida = [];
                    for(var i = 0; i < wrapper.cotizaciones_vida.length; i++){
                        console.log(wrapper.cotizaciones_vida[i]);
                        dataVida.push(wrapper.cotizaciones_vida[i]);
                    }
                    component.set('v.dataVida', dataVida);
                    
                    if(wrapper.cotizacion){
                        console.log('wrapper.cotizacion.Ramo__c: ' , wrapper.cotizacion.Ramo__c);
                        
                        if(wrapper.cotizacion.Ramo__c === 'Vida'){
                            component.set('v.mostrarCotizacionesVida', true);
                        }
                    }
                    
                }
            }else if(state === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": result.errors[0],
                    "type": "error"
                });
                toastEvent.fire();
                component.destroy();
            }
        });
        $A.enqueueAction(action);
        */
    },
    doSave: function(component, event, helper){
        
        var action = component.get("c.doSave1");
        action.setParams({
            'cliente': JSON.stringify(component.get('v.cliente')),
            'auto': JSON.stringify(component.get('v.auto')),
            'cotizaciones': JSON.stringify(component.get('v.data'))
        });
        
        component.set('v.isLoading', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            
            var state = response.getState();
            console.log('state: ' , state);
            
            let result = response.getReturnValue();
            console.log(result);
            
            if (state === "SUCCESS") {
                console.log('result: ' , result);
                
                var toastEvent = $A.get("e.force:showToast");
                if(result.hasError){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    console.log('result.returnId: ' , result.returnId);
                    
                    toastEvent.setParams({
                        "title": "Cotizacion Guardada!",
                        "message": '',
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    $A.get('e.force:refreshView').fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result.returnId
                    });
                    navEvt.fire();
                }
            }else if(state === 'ERROR'){
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
    enviarEmailYGuardarCotizacion: function(component, event, helper){
        
        var oppId = component.get('v.oppId');
        if(oppId === ''){
            console.log('oppId esta vacio: se pone en null');
            oppId = null;
        }
        console.log('oppId: ' , oppId);
        
        var mostrarCotizacionesVida = component.get('v.mostrarCotizacionesVida');
        console.log('mostrarCotizacionesVida: ' , mostrarCotizacionesVida);
        
        var cotizacion = JSON.stringify(component.get('v.cotizacion'));
        console.log('cotizacion: ' , cotizacion);
        
        var nomina = JSON.stringify(component.get('v.dataNomina'));
        console.log('nomina: ' , nomina);
        
        var cliente = JSON.stringify(component.get('v.cliente'));
        console.log('cliente: ' , cliente);
        
        var auto = JSON.stringify(component.get('v.auto'));
        console.log('auto: ' , auto);
        
        var data = JSON.stringify(component.get('v.data'));
        console.log('data: ' , data);
        
        var cotizacionesSeleccionadasVida = JSON.stringify(component.get('v.dataVida'));
        console.log('cotizacionesSeleccionadasVida: ' , cotizacionesSeleccionadasVida);
        
        var action = component.get("c.doSave");
        action.setParams({
            'cliente': cliente,
            'auto': auto,
            'cotizacionesSeleccionadas': data,
            'oppId': oppId,
            'vida': mostrarCotizacionesVida,
            'cotizacionesSeleccionadasVida': cotizacionesSeleccionadasVida,
            'cotizacionParam': cotizacion,
            'nomina': nomina
        });
        
        component.set('v.isLoading', true);
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            
            var state = response.getState();
            console.log('state: ' , state);
            
            let result = response.getReturnValue();
            console.log(result);
            
            if (state === "SUCCESS") {
                console.log('result: ' , result);
                
                var toastEvent = $A.get("e.force:showToast");
                if(result.hasError){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.errors[0],
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    console.log('result.returnId: ' , result.returnId);
                    
                    toastEvent.setParams({
                        "title": "Cotizacion Guardada!",
                        "message": '',
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    $A.get('e.force:refreshView').fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result.returnId
                    });
                    navEvt.fire();
                }
            }else if(state === 'ERROR'){
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
    handleVerNomina: function(component, event, helper){
        component.set('v.mostrarNomina', true);
    },
    handleAtras: function(component, event, helper){
        component.set('v.mostrarNomina', false);
    },
    doCotizarVida: function(component, event, helper){
        var data = component.get('v.dataNomina');
        if(!data){
            var data = [];
            data.push({
                'nroAdherente': 1,
                'apellidoYNombre': 'MARQUEZ EDGAR',
                'tipoYNumeroDocumento': 'C.U.I.L. 20-32276827-0 ',
                'fechaNacimiento': '19/07/1986',
                'fechaAlta': '01/07/2020',
                'grupoAdherente': 'Adherentes',
            });
            data.push({
                'nroAdherente': 2,
                'apellidoYNombre': 'MARTINEZ JUAN MANUEL ',
                'tipoYNumeroDocumento': 'C.U.I.L. 20-31668229-0',
                'fechaNacimiento': '09/12/1985',
                'fechaAlta': '01/07/2020',
                'grupoAdherente': 'Adherentes',
            });
            data.push({
                'nroAdherente': 3,
                'apellidoYNombre': 'IRAZOQUE OLGA MERCEDES ',
                'tipoYNumeroDocumento': 'C.U.I.L. 20-30438359-0',
                'fechaNacimiento': '30/09/1988',
                'fechaAlta': '01/07/2020',
                'grupoAdherente': 'Adherentes',
            });
            data.push({
                'nroAdherente': 4,
                'apellidoYNombre': 'LUNA ADRIAN D',
                'tipoYNumeroDocumento': 'C.U.I.L. 20-36355115-0',
                'fechaNacimiento': '09/05/1992',
                'fechaAlta': '01/07/2020',
                'grupoAdherente': 'Adherentes',
            });
            component.set('v.dataNomina', data);    
        }
        component.set('v.mostrarCotizacionesVida', true);
    }
});