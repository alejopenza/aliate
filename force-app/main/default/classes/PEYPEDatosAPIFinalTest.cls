@isTest
public with sharing class PEYPEDatosAPIFinalTest {

    @isTest
    static void PEYPEDatosAPIFinalTestCuit() {     
		Test.setMock(HttpCalloutMock.class, new PEYPEDatosApiFinalMock());
        test.StartTest();
        PEYPEDatosAPIFinal.Wrapper service = new PEYPEDatosAPIFinal.Wrapper();
        service = PEYPEDatosAPIFinal.Wrapper.getDataFromAPI('30694303451');
        test.stopTest();
        
        Long valorEsperadoCuit = 30694303451L;
        Long valorRealCuit = service.clienteCuit.RESULTADO.Existencia.row.cuit;
        
        Integer valorEsperadoCantidadEmpleados = 6;
        Integer valorRealCantidadEmpleados = service.clienteCuit.RESULTADO.Validacion.row.cantemp;

        System.assertEquals(valorEsperadoCuit, valorRealCuit);
        System.assertEquals(valorEsperadoCantidadEmpleados, valorRealCantidadEmpleados);
		System.assertEquals(false, service.hasError);
    }

    @isTest
    static void PEYPEDatosAPIFinalTestDni() {     
		Test.setMock(HttpCalloutMock.class, new PEYPEDatosApiFinalMockDni());
        test.StartTest();
        PEYPEDatosAPIFinal.Wrapper service = new PEYPEDatosAPIFinal.Wrapper();
		service = PEYPEDatosAPIFinal.Wrapper.getDataFromAPI('18081685', 'M');
        test.stopTest();

        //System.debug(service.cliente.RESULTADO.Existencia_Fisica.row.provincia);

        System.assertEquals(false, service.hasError);
    }

    @isTest
    static void PEYPEDatosAPIFinalTestCuitFail404() {            
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();     
        mock.setStaticResource('cuitResponse');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');         
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        PEYPEDatosAPIFinal.Wrapper service = new PEYPEDatosAPIFinal.Wrapper();
		service = PEYPEDatosAPIFinal.Wrapper.getDataFromAPI('30694303451');
        Test.stopTest();
              
        
        System.assertEquals(true, service.hasError);   

    }    

    @isTest
    static void PEYPEDatosAPIFinalTestDniFail404() {     
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();     
        mock.setStaticResource('dniResponse');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');         
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        PEYPEDatosAPIFinal.Wrapper service = new PEYPEDatosAPIFinal.Wrapper();
		service = PEYPEDatosAPIFinal.Wrapper.getDataFromAPI('18081685', 'M');
        Test.stopTest();
        
        System.assertEquals(true, service.hasError);   
    }    

    @isTest
    static void PEYPEDatosAPIFinalTestCuitFail500() {            
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();     
        mock.setStaticResource('cuitResponse');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');         
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        PEYPEDatosAPIFinal.Wrapper service = new PEYPEDatosAPIFinal.Wrapper();
		service = PEYPEDatosAPIFinal.Wrapper.getDataFromAPI('30694303451');
        Test.stopTest();
        
        System.assertEquals(true, service.hasError);   

    }    

    @isTest
    static void PEYPEDatosAPIFinalTestDniFail500() {     
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();     
        mock.setStaticResource('dniResponse');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');         
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        PEYPEDatosAPIFinal.Wrapper service = new PEYPEDatosAPIFinal.Wrapper();
		service = PEYPEDatosAPIFinal.Wrapper.getDataFromAPI('18081685', 'M');
        Test.stopTest();
        
        System.assertEquals(true, service.hasError);   
    }    

    //Test DNI Falla
    /*
    @isTest
    static void PEYPEDatosAPIFinalDoDNICalloutTest() {

        Test.setMock(HttpCalloutMock.class, new PEYPEDatosApiFinalMockDni());
        Test.startTest();
        CotizadorController.Wrapper controller = new CotizadorController.Wrapper();
        controller = PEYPEDatosAPIFinal.Wrapper.doDNICallout(controller, '18081685', 'MASCULINO');
        Test.stopTest();

    }
    */

    @isTest
    static void PEYPEDatosAPIFinalDoCUITCalloutTest() {

        Test.setMock(HttpCalloutMock.class, new PEYPEDatosApiFinalMock());

        Test.startTest();
        CotizadorController.Wrapper controller = new CotizadorController.Wrapper();
        controller = PEYPEDatosAPIFinal.Wrapper.doCUITCallout(controller, '30694303451');
        Test.stopTest();

        System.assertEquals(false, controller.hasError, 'Response was retrieved with error.');

    }

    @isTest
    static void PEYPEDatosAPIFinalDoCUITCalloutFailTest() {

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();     
        mock.setStaticResource('cuitResponse');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');   

        Test.startTest();
        CotizadorController.Wrapper controller = new CotizadorController.Wrapper();
        controller = PEYPEDatosAPIFinal.Wrapper.doCUITCallout(controller, '30694303451');
        Test.stopTest();

        System.assertEquals(true, controller.hasError, 'Response wasn\'t retrieved with error.');

    }
    
    @isTest
    static void PEYPEDatosAPIFinalGetCondicionAnteIvaTestDNI() {

        Test.startTest();
        CotizadorController.Wrapper controller = new CotizadorController.Wrapper();
        controller.cliente.tipoDeDocumento = 'DNI';
        Decimal result = PEYPEDatosAPIFinal.Wrapper.getCondicionAnteIVA(controller);
        Test.stopTest();

        System.assertEquals(false, controller.hasError, 'Response was retrieved with error.');
        System.assertEquals(4, result, 'Response was retrieved with error.');
    }
    
    @isTest
    static void PEYPEDatosAPIFinalGetCondicionAnteIvaTestCUIT() {

        Test.startTest();
        CotizadorController.Wrapper controller = new CotizadorController.Wrapper();
        controller.cliente.tipoDeDocumento = 'CUIT';
        Decimal result = PEYPEDatosAPIFinal.Wrapper.getCondicionAnteIVA(controller);
        Test.stopTest();

        System.assertEquals(1, result, 'Response was retrieved with error.');
    }

    @isTest
    static void PEYPEDatosAPIFinalGetCondicionAnteIvaTestElse() {

        Test.startTest();
        CotizadorController.Wrapper controller = new CotizadorController.Wrapper();
        controller.cliente.tipoDeDocumento = 'ELSE'; //todo averiguar qué tipo de docu puede ser, LC, DU, etc
        Decimal result = PEYPEDatosAPIFinal.Wrapper.getCondicionAnteIVA(controller);
        Test.stopTest();

        System.assertEquals(3, result, 'Response was retrieved with error.');
    }

}