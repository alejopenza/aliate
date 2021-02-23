({
    initHelper : function(component, event, helper) {
        
    },
    resetComponent: function(component, event, helper){
        component.set('v.cliente', null);
    },
    createCotizacionesComponent: function(component, event, helper){
        console.log('createCotizacionesComponent()');
        console.log('cliente: ' , JSON.stringify(component.get('v.cliente')));
        console.log('auto: ' , JSON.stringify(event.getSource().get('v.auto')));
        console.log('oppId: ', component.get('v.oppId'));
        console.log('nomina: ', component.get('v.nomina'));

        $A.createComponent( 'c:CotizadorCotizaciones', {
            'cliente' : component.get('v.cliente'),
            'auto' : event.getSource().get('v.auto'),
            'oppId': component.get('v.oppId'),
            'nomina': component.get('v.nomina')
        },
        function(modalComponent, status, errorMessage) {
            console.log('status: ' , status);
            if (status === "SUCCESS") {
                //Appending the newly created component in div
                var body = component.find('cotizaciones').get("v.body");
                body.push(modalComponent);
                component.find('cotizaciones').set("v.body", body);
            } else if (status === "INCOMPLETE") {
                console.log('Server issue or client is offline.');
            } else if (status === "ERROR") {
                console.log('error: ' , errorMessage);
            }
        });
    }
})