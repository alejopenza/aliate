({
    doInit : function(component, event, helper) {
        component.set('v.nuevo', {
            'nroAdherente': '',
            'apellidoYNombre': '',
            'tipoYNumeroDocumento': '',
            'fechaNacimiento': '',
            'fechaAlta': '',
            'grupoAdherente': ''
        });
        
        component.set('v.columns', [
            {label: 'NUMERO ADHERENTE', fieldName: 'nroAdherente', type: 'number'},
            {label: 'APELLIDO Y NOMBRES', fieldName: 'apellidoYNombre', type: 'text'},
            {label: 'TIPO Y NUM DOC', fieldName: 'tipoYNumeroDocumento', type: 'text'},
            {label: 'FECHA NAC.', fieldName: 'fechaNacimiento', type: 'text'},
            {label: 'FECHA ALTA', fieldName: 'fechaAlta', type: 'text'},
            {label: 'GRUPO ADHE.', fieldName: 'grupoAdherente', type: 'text'}
        ]);
        console.log(component.get('v.data'));
        component.set('v.isLoading', false);
    },
    doRemover: function(component, event, helper){
        var action = component.get("c.doRemover");
        action.setParams({
            'recordId': component.get('v.recordId'),
            'lines': JSON.stringify(component.find('linesTable').getSelectedRows())
        });
        component.set('v.isLoading', true);
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
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Exito!",
                        "message": 'Nomina actualizada correctamente.',
                        "type": "success"
                    });
                    toastEvent.fire();
                    component.set('v.data', result.nomina);
                }
            }else if(state === 'ERROR'){
                
            }
        });
        $A.enqueueAction(action);
    },
    doGuardar: function(component, event, helper){
        
        var nuevos = component.get('v.nuevos');
        console.log('nuevos: ', nuevos.length);
        if(component.get('v.nuevo')){
            nuevos.push(component.get('v.nuevo'));
        }
        
        var action = component.get("c.doGuardar");
        action.setParams({
            'recordId': component.get('v.recordId'),
            'nuevos': JSON.stringify(component.get('v.nuevos'))
        });
        component.set('v.isLoading', true);
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
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Exito!",
                        "message": 'Nomina actualizada correctamente.',
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    component.set('v.data', result.nomina);
                    component.set('v.showAddEmployee', false);
                    var nuevos = [];
                    component.set('v.nuevos', nuevos);
                    
                    component.set('v.nuevo', {
                        'nroAdherente': '',
                        'apellidoYNombre': '',
                        'tipoYNumeroDocumento': '',
                        'fechaNacimiento': '',
                        'fechaAlta': '',
                        'grupoAdherente': ''
                    });
                }
            }else if(state === 'ERROR'){
                
            }
        });
        $A.enqueueAction(action);
    },
    doAgregar: function(component, event, helper){
        var nuevos = component.get('v.nuevos');
        console.log('nuevos: ', nuevos);
        nuevos.push(component.get('v.nuevo'))
        
        component.set('v.nuevo', {
            'nroAdherente': '',
            'apellidoYNombre': '',
            'tipoYNumeroDocumento': '',
            'fechaNacimiento': '',
            'fechaAlta': '',
            'grupoAdherente': ''
        });
        
    }
})