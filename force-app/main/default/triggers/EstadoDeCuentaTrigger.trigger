trigger EstadoDeCuentaTrigger on Estado_de_Cuenta__c (after insert) {

    new EstadoDeCuentaTriggerHandler().run();

}