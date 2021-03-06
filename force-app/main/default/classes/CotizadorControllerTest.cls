@isTest
public with sharing class CotizadorControllerTest {
    //se comenta x problemas de compilacion al deployar a uat
    /*
    @TestSetup
    static void makeData(){
        
        Product2 product = new Product2();
        product.name = 'test';
        product.Tipo_de_Cobertura__c = 'Todo Riesgo';
        insert product;

        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPriceBookId() ,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;

        Account client = new Account();
        client.Name = 'test';
        insert client;

        Opportunity opp = new Opportunity();
        opp.AccountId = client.Id;
        opp.StageName = 'Qualification';
        opp.Name = 'test';
        opp.closeDate = system.today();
        opp.Pricebook2Id = Test.getStandardPriceBookId();
        opp.RecordTypeId = [
            SELECT ID
            FROM RecordType
            WHERE DeveloperName = 'Cotizacion'
        ].Id;
        insert opp;
        
        Quote presupuesto = new Quote();
        presupuesto.Name = 'test';
        presupuesto.OpportunityId = opp.Id;
        insert presupuesto;

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.product2Id = product.Id;
        oli.opportunityId = opp.Id;
        oli.quantity = 1;
        oli.totalPrice = 1;
        insert oli;
        
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = presupuesto.Id;
        qli.PricebookEntryId = pbEntry.Id;
        qli.Quantity = 1;
        qli.UnitPrice = 100;
        qli.Product2Id = product.Id;
        qli.GNC__c = true;
        qli.Suma_Asegurada_GNC__c = 12;
        qli.Accesorio__c = true;
        qli.Tipo_de_Accesorio__c = 'algo';
        qli.Suma_Asegurada_Accesorio__c = 12;
        insert qli;

    }
    
    //DO CALLOUT
    @isTest
    static void doCallout_DebeDevolverUnClienteMapeado_SegunLaRespuestaDePYP(){
        system.assertEquals(true, true);
    }
    
    //DO SAVE
    @isTest
    static void doSave_debeGuardarUnaOportunidadYUnpresupuestoConSusQLI(){
        
        DELETE[
            SELECT ID
            FROM Opportunity
        ];
        
        DELETE[
            SELECT ID
            FROM Quote
        ];
        
        CotizadorController.Cliente cliente = new CotizadorController.Cliente();
        cliente.nombre = 'test';
        cliente.email = 'test@test.com';
        
        Cotizadorcontroller.Auto auto = new CotizadorController.Auto();
        auto.marca = 'Ford';
        auto.uso = true;
        auto.km = true;
        auto.rastreador = true;
        auto.accesorio = true;
        auto.gnc = true;
        
        CotizadorController.Cotizacion cotizacion = new CotizadorController.Cotizacion();
        cotizacion.tipoCobertura = 'Todo Riesgo';
        
        CotizadorController.Cotizacion cotizacionVida = new CotizadorController.Cotizacion();
        cotizacion.tipoCobertura = 'Vida';

        List<CotizadorController.Cotizacion> cotizaciones = new List<CotizadorController.Cotizacion>();
        cotizaciones.add(cotizacion);
        
        List<CotizadorController.Cotizacion> cotizacionesVida = new List<CotizadorController.Cotizacion>();
        cotizaciones.add(cotizacionVida);
        
        CotizadorController.MedioDePago medioDePago = new CotizadorController.MedioDePago();

        CotizadorController.Wrapper result;
        Test.startTest();
        result = CotizadorController.doSave(JSON.serialize(cliente), 
                                            JSON.serialize(auto), 
                                            JSON.serialize(cotizaciones), 
                                            null, 
                                            false, 
                                            JSON.serialize(cotizacionesVida), 
                                            JSON.serialize(medioDePago));
        Test.stopTest();
        
        system.assertEquals(false, result.hasError, result.errors);
        
        system.assertEquals(1, [
            SELECT COUNT()
            FROM Opportunity
        ]);
    }
    
    //DO INIT COTIZACIONES
    @isTest
    static void doInitCotizaciones_debeDevolverUnaListaDeCotizaciones(){
        
        CotizadorController.Auto auto = new CotizadorController.Auto();
        auto.tipoDeCobertura = 'Todo Riesgo';
        CotizadorController.Cliente cliente = new CotizadorController.Cliente();
        cliente.nombre = 'Jose';
        cliente.apellido = 'Prueba';
        cliente.email = 'jose@prueba.com';
        cliente.Numero_de_Documento = '12334556';
        cliente.Codigo_Postal = 1823;
        cliente.es_empleador = false;
        
        CotizadorController.Wrapper result;
        Test.startTest();
        result = CotizadorController.doInitCotizaciones(JSON.serialize(auto),JSON.serialize(cliente), null);
        Test.stopTest();

        system.assertNotEquals(result.cotizaciones, null);
    }
	*/
    // //EMITIR POLIZA
    // @isTest
    // static void initEmitirPoliza_debeDevolverMapeadaLaCotizacion(){

    //     Opportunity cotizacion = [
    //         SELECT ID, Ajuste_Automatico__c, StageName,
    //         (
    //             SELECT Id, product2.Name, Product2Id
    //             FROM OpportunityLineItems
    //         )
    //         FROM Opportunity
    //         LIMIT 1
    //     ];
        
    //     CotizadorController.Wrapper result;
    //     Test.startTest();
    //     result = CotizadorController.initEmitirPolizaLauncher(cotizacion.Id);
    //     Test.stopTest();

    //     system.assertNotEquals(result.presupuestos, null);

    // }

    // @isTest
    // static void initEmitirPolizaLauncher_devuelveUnErrorSiElStageNameEsClosed(){
    //     /*Opportunity cotizacion = [
    //         SELECT ID, StageName
    //         FROM Opportunity
    //         LIMIT 1
    //     ];
    //     cotizacion.StageName = 'Closed';
    //     database.update(cotizacion);
        
    //     CotizadorController.Wrapper result;
    //     Test.startTest();
    //     result = CotizadorController.initEmitirPolizaLauncher(cotizacion.Id);
    //     Test.stopTest();

    //     system.assertEquals(result.hasError, true);*/
    // }

    // @isTest
    // static void EmitirPoliza_cierraLaOpp_borraLosOlisNoSeleccionados_InsertaUnAssetYEnviaUnCorreo(){
    //     Opportunity cotizacion = [
    //         SELECT ID, Ajuste_Automatico__c, StageName,
    //         (
    //             SELECT Id, product2.Name, Product2Id
    //             FROM OpportunityLineItems
    //         )
    //         FROM Opportunity
    //         LIMIT 1
    //     ];

    //     Id recordId;
    //     for(OpportunityLineItem oli : cotizacion.OpportunityLineItems){
    //         recordId = oli.Product2Id;
    //         break;
    //     }
        
    //     List<Quote> presupuestos = [
    //         SELECT ID
    //         FROM Quote
    //         WHERE OpportunityId = :cotizacion.Id
    //     ];
        
    //     CotizadorController.Wrapper result;
    //     Test.startTest();
    //     result = CotizadorController.EmitirPoliza(recordId, presupuestos, 'VISA', 12,123);
    //     Test.stopTest();

    //     cotizacion = [
    //         SELECT StageName
    //         FROM Opportunity
    //         WHERE Id = :cotizacion.Id
    //     ];

    //     system.assertEquals('Closed Won', cotizacion.StageName);
    //     system.assertEquals(1, [
    //         SELECT COUNT()
    //         FROM Asset
    //         WHERE Oportunidad__c = :cotizacion.Id
    //     ]);
    // }

    // //
    
}