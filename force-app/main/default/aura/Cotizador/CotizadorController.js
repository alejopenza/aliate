({
	init : function(component, event, helper) {
        helper.initHelper(component, event, helper);
    },
    handleEventoCotizaciones: function(component, event, helper){
        helper.createCotizacionesComponent(component, event, helper);
    },
    handleEventoAtras: function(component, event, helper){
        helper.resetComponent(component, event, helper);
    },
    handleEnviarYGuardar: function(component, event, helper){
        var selectedRows = event.getParam("selectedRows");
        console.log('selectedRows: ' , JSON.stringify(selectedRows));
        
        var email = event.getParam("email");
        console.log('email: ' , JSON.stringify(email));
        
    }
})