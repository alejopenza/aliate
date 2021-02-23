public inherited sharing class EstadoDeCuentaTriggerHandler extends TriggerHandler {

    public override void afterInsert(){
        EstadoDeCuentaTriggerHelper.crearPagosDeEstadosDeCuenta((List<Estado_de_cuenta__c>) Trigger.new);
    }

}