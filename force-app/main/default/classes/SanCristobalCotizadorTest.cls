@isTest
public inherited sharing class SanCristobalCotizadorTest {
    
    @TestSetup
    static void makeData(){

        AllValidProductOffering__c config = new AllValidProductOffering__c();
        config.name = 'test';
        config.code__c = 'test';
        config.description__c = 'test';
        insert config;

        Product2 product = new Product2();
        product.Name = 'San Cristobal';
        insert product;
        
        PricebookEntry standardPBE = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), 
            Product2Id = product.Id, 
            UnitPrice = 1000, 
            IsActive = true
        );
        insert standardPBE;

        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.StageName = 'test';
        opp.CloseDate = System.today().addMonths(1);
        insert opp;

    }

    @isTest
    static void doSanCristobalCalloutMethod_ShouldCallTheWSAndHandleCorrectResponseCorrectly(){

        CotizadorController.Wrapper result = new CotizadorController.Wrapper();
        CotizadorController.Auto auto = new CotizadorController.Auto();
        auto.uso = true;
        auto.codigosDeModuloDeCoberturasSC = new List<String>();
        auto.codigosDeModuloDeCoberturasSC.add(
            [
                SELECT Code__c
                FROM AllValidProductOffering__c
                LIMIT 1
            ].Code__c
        );
        CotizadorController.Cliente cliente = new CotizadorController.Cliente();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SCApiQuoteMockSuccess());
        result = SanCristobalCotizador.doSanCristobalCallout(result, auto, cliente);
        Test.stopTest();

        system.assertEquals(result.hasError, false, 'No deberia haber error');
        system.assertEquals(result.cotizacionesSanCristobal.isEmpty(), false, 'Deberia tener las cotizaciones mapeadas');
    }

    @isTest
    static void doSanCristobalCalloutMethod_ShouldCallTheWSAndHandleErrorResponseCorrectly(){
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();
        CotizadorController.Auto auto = new CotizadorController.Auto();
        CotizadorController.Cliente cliente = new CotizadorController.Cliente();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SCApiQuoteMockFail());
        result = SanCristobalCotizador.doSanCristobalCallout(result, auto, cliente);
        Test.stopTest();

        system.assertEquals(result.hasError, true, 'Deberia haber error');
    }

    
    @isTest
    static void doSaveMethodShouldSaveCorrectly(){
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();
        CotizadorController.Auto auto = new CotizadorController.Auto();
        auto.uso = true;
        auto.gnc = true;
        auto.km = true;
        auto.marca = 'test';
        auto.modelo = 'test';
        auto.rastreador = false;
        auto.version = 'test';
        auto.accesorio = true;
        auto.tipoAccesorio = 'test';
        auto.sumaAseguradaAccesorio = 1;
        auto.sumaAseguradaGNC = 1;
        CotizadorController.CotizacionSancor cotizacion = new CotizadorController.CotizacionSancor();
        cotizacion.aseguradora = 'test';
        cotizacion.descripcionCorta = 'test';
        cotizacion.ivaMensual = 1;
        cotizacion.ivaTotal = 1;
        cotizacion.premioMensual = 1;
        cotizacion.premioTotal = 1;
        cotizacion.policyPeriodId = 'test';
        List<CotizadorController.CotizacionSancor> cotizaciones = new List<CotizadorController.CotizacionSancor>{cotizacion};
        Opportunity opp = [
            SELECT ID
            FROM Opportunity
            LIMIT 1
        ];

        Test.startTest();
        result = SanCristobalCotizador.doSave(result, auto, cotizaciones, opp);
        Test.stopTest();

        system.assertEquals(result.hasError, false, 'No deberia haber error');
        system.assertNotEquals(result.returnId, null, 'Deberia contener el ID de la OPP' + result.errors);
    }

    @isTest
    static void doSaveMethodShouldThrownAnErrorIfSomethingWentWrong(){
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();
        CotizadorController.Auto auto = new CotizadorController.Auto();
        CotizadorController.CotizacionSancor cotizacion = new CotizadorController.CotizacionSancor();
        cotizacion.aseguradora = 'test';
        cotizacion.descripcionCorta = 'test';
        cotizacion.ivaMensual = 1;
        cotizacion.ivaTotal = 1;
        cotizacion.premioMensual = 1;
        cotizacion.premioTotal = 1;
        List<CotizadorController.CotizacionSancor> cotizaciones = new List<CotizadorController.CotizacionSancor>{cotizacion};
        Opportunity opp = new Opportunity();

        Test.startTest();
        result = SanCristobalCotizador.doSave(result, auto, cotizaciones, opp);
        Test.stopTest();

        system.assertEquals(result.hasError, true, 'Deberia haber error');
        system.assertNotEquals(result.errors.isEmpty(), true, 'Deberia contener el mensaje de error');
    }

}
