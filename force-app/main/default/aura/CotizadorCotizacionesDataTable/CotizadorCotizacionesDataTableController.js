({
    init: function (component, event, helper) {
        helper.initHelper(component, event, helper);
    },
    updateRowSelection: function (cmp) {
        cmp.set('v.selectedRows', cmp.get('v.selection'));
    },
    handleGroupChange: function (cmp, event) {
        var value = event.getParam('value');
        cmp.set('v.selection', value);
    },
    closeModal : function(component, event, helper) {
        //todo evento que vaya al modal para que se destruya
    },
    handleEnviar: function(component, event, helper){
        var cliente = component.get('v.cliente');
        var email = cliente.email;
        if(email){
            //helper.enviarEmailYGuardarCotizacion(component,event,helper);
            helper.doSave(component, event, helper);
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Complete el correo electronico.',
                "type": "error"
            });
            toastEvent.fire();
        }
    },
    handleCotizarVida: function(component, event, helper){
        helper.doCotizarVida(component, event, helper);
    },
    handleSoloAutomovil: function(component, event, helper){
        component.set('v.mostrarCotizacionesVida', false);
    },
    handleVerNomina: function(component, event, helper){
        helper.handleVerNomina(component, event, helper);
    },
    handleAtras: function(component, event, helper){
        helper.handleAtras(component, event, helper);
    }
});