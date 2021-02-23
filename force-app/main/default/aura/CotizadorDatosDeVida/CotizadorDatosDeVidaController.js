({
    init : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    handleRemover: function(component, event, helper){
		helper.doRemover(component, event, helper);
    },
    handleCargarEmpleados: function(component, event, helper){
		component.set('v.showAddEmployee', true);
    },
    handleDoGuardar: function(component, event, helper){
        helper.doGuardar(component, event, helper);
    },
    handleDoAtras: function(component, event, helper){
        component.set('v.showAddEmployee', false);
    },
    handleDoAgregar: function(component, event, helper){
        helper.doAgregar(component, event, helper);
    }
})