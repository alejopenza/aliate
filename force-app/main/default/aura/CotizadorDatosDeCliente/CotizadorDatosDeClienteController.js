({
    init : function(component, event, helper) {
        helper.initHelper(component, event, helper);
    },
    doNext: function(component, event, helper){
        
        var numero = component.find("numero").get("v.value");
        var tipoDocumento = component.find("tipoDocumento").get("v.value");
        console.log(tipoDocumento);
        console.log(numero);
        
        var toastEvent = $A.get("e.force:showToast");
        if(!numero){
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Ingrese un numero de DNI o CUIT',
                "type": "error"
            });
            toastEvent.fire();
        }else{
            console.log('length: ' , numero.length);
            if(tipoDocumento === 'DNI'){
                if(numero.length < 7 || numero.length > 8){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'El numero de CUIT debe tener entre 7 y 8 digitos, por favor revise.',
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    helper.doNext(component, event, helper);
                }
            }else if(tipoDocumento == 'CUIT'){
                if(numero.length != 11){
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'El numero de CUIT debe tener 11 digitos, por favor revise.',
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    helper.doNext(component, event, helper);
                }
            }
        }
        
    }
})