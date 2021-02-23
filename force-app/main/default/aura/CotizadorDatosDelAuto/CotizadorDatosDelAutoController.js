({
	init : function(component, event, helper) {
        helper.initHelper(component, event, helper);
    },
    doNext: function(component, event, helper){
        helper.doNext(component, event, helper);
    },
    doBefore:function(component, event, helper){
        helper.doBefore(component, event, helper);
    },
    handleChangeMarca: function(component, event, helper){
        helper.handleChangeMarca(component, event, helper);
    },
    handleChangeModelo: function(component, event, helper){
        helper.handleChangeModelo(component, event, helper);
    },
    handleChangeAnio: function(component, event, helper){
        helper.handleChangeAnio(component, event, helper);
    },
    handleChangeVersion: function(component, event, helper){
        helper.handleChangeVersion(component,event,helper);
    },
    handleGNC: function(component, event, helper){
        helper.handleGNC(component, event, helper);
    },
    handleUso: function(component, event, helper){
        helper.handleUso(component, event, helper);
    },
    handleKM: function(component, event, helper){
        helper.handleKM(component, event, helper);
    },
    handleRastreador: function(component, event, helper){
        helper.handleRastreador(component, event, helper);
    },
    handleAccesorio: function(component, event, helper){
        helper.handleAccesorio(component, event, helper);
    },
    handleChange: function (component, event) {
        console.log('event: ' , JSON.stringify(component.get("v.value")));
    },
    handleChangeCoberturasSC: function (component, event) {
        console.log('event: ' , JSON.stringify(component.get("v.valueCoberturasSC")));
    }
})