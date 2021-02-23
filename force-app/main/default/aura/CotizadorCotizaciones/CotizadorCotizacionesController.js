({
    init: function (component, event, helper) {
        helper.initHelper(component, event, helper);
    },
	closeModal : function(component, event, helper) {
		component.destroy();
	}
})