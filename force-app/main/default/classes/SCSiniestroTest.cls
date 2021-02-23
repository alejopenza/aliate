@isTest
public with sharing class SCSiniestroTest {

    /*
    Falta recibir request y response válidos por parte de SC para poder hacer correctamente los tests.
    */

    @isTest
    static void testRegistrarSiniestroSuccess() {
        Test.setMock(HttpCalloutMock.class, new SCSiniestroArchivosMockSuccess());
  
        test.StartTest();
        SCSiniestro.Wrapper wrapper = new SCSiniestro.Wrapper();
        wrapper = SCSiniestro.registrarSiniestro();
        
        test.stopTest();
  
        System.assertEquals(false, wrapper.hasError, 'La conexión fue devuelta sin errores.');
    }

    @isTest
    static void testRegistrarSiniestroFail() {
        Test.setMock(HttpCalloutMock.class, new SCSiniestroArchivosMockFail());
  
        test.StartTest();
        SCSiniestro.Wrapper wrapper = new SCSiniestro.Wrapper();
        wrapper = SCSiniestro.registrarSiniestro();
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testRegistrarSiniestroFail500() {
        Test.setMock(HttpCalloutMock.class, new SCSiniestroArchivosMockFail500());
  
        test.StartTest();
        SCSiniestro.Wrapper wrapper = new SCSiniestro.Wrapper();
        wrapper = SCSiniestro.registrarSiniestro();
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    } 
}