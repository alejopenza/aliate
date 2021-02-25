@isTest
public with sharing class SCEmisionTest {

    @TestSetup
    static void makeData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.StageName = 'test';
        opp.closeDate = system.today().addDays(1);
        opp.policyPeriodId__c = 'test';
        insert opp;
    }

    @isTest
    static void doSaveAsDraftMethod_shouldProcessCorrectly(){
        
        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        Test.startTest();
        SCEmision.doSaveAsDraft(opp);
        Test.stopTest();

        system.assertEquals(result.hasError, false, 'No deberia haber error');
    }

    @isTest
    static void doSaveAsDraftMethod_shouldReturnAnErrorIfFails(){
        
        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        Test.startTest();
        SCEmision.doSaveAsDraft(opp);
        Test.stopTest();

        system.assertEquals(result.hasError, true, 'Deberia haber error');
        system.assertNotEquals(result.errors.isEmpty(), true, 'Deberia haber mensajes de error');
    }

    @isTest
    static void doUpdateCartMethod_shouldProcessCorrectly(){
        
        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];

        EmitirPolizaController.Param params = new EmitirPolizaController.Param();
        //todo datos

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        Test.startTest();
        SCEmision.doUpdateCar(opp, params);
        Test.stopTest();

        system.assertEquals(result.hasError, false, 'No deberia haber error');
    }

    @isTest
    static void doUpdateCartMethod_shouldReturnAnErrorIfFails(){
        
        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];

        EmitirPolizaController.Param params = new EmitirPolizaController.Param();
        //todo datos

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        Test.startTest();
        SCEmision.doUpdateCar(opp, params);
        Test.stopTest();

        system.assertEquals(result.hasError, true, 'Deberia haber error');
        system.assertNotEquals(result.errors.isEmpty(), true, 'Deberia haber mensajes de error');
    }

    @isTest
    static void doQuoteJobMethod_shouldProcessCorrectly(){
        
        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        Test.startTest();
        result = SCEmision.doQuoteJob( opp);
        Test.stopTest();

        system.assertEquals(result.hasError, false, 'No deberia haber error');
    }

    @isTest
    static void doQuoteJobMethod_shouldReturnAnErrorIfFails(){
        
        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        Test.startTest();
        result = SCEmision.doQuoteJob(opp);
        Test.stopTest();

        system.assertEquals(result.hasError, true, 'Deberia haber error');
        system.assertNotEquals(result.errors.isEmpty(), true, 'Deberia haber mensajes de error');
    }

    @isTest
    static void doPostMethod_shouldProcessCorrectly(){

        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        result.JobNumber = 'test';
        Test.startTest();
        result = SCEmision.doPost(result, opp);
        Test.stopTest();

        system.assertEquals(result.hasError, false, 'No deberia haber error');
    }

    @isTest
    static void doPostMethod_shouldReturnAnErrorIfFails(){

        Opportunity opp = [
            SELECT ID, policyPeriodId__c
            FROM Opportunity
            LIMIT 1
        ];
        
        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();
        result.JobNumber = 'test';
        Test.startTest();
        result = SCEmision.doPost(result, opp);
        Test.stopTest();

        system.assertEquals(result.hasError, true, 'Deberia haber error');
        system.assertNotEquals(result.errors.isEmpty(), true, 'Deberia haber mensajes de error');
    }
	
}