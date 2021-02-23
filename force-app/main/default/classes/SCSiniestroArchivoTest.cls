@isTest
public with sharing class SCSiniestroArchivoTest {

    /*
    Falta recibir request y response válidos por parte de SC para poder hacer correctamente los tests.
    */

    @isTest
    static void testRegistrarArchivoDeSiniestroSuccess() {
        Test.setMock(HttpCalloutMock.class, new SCSiniestroArchivosMockSuccess());
  
        test.StartTest();
        SCSiniestroArchivo.Wrapper wrapper = new SCSiniestroArchivo.Wrapper();
        wrapper = SCSiniestroArchivo.registrarArchivoDeSiniestro('string', 'string', 'string', 'string', 'string');
        
        test.stopTest();
  
        System.assertEquals(false, wrapper.hasError, 'La conexión fue devuelta sin errores.');
    }

    @isTest
    static void testRegistrarArchivoDeSiniestroFail() {
        Test.setMock(HttpCalloutMock.class, new SCSiniestroArchivosMockFail());
  
        test.StartTest();
        SCSiniestroArchivo.Wrapper wrapper = new SCSiniestroArchivo.Wrapper();
        wrapper = SCSiniestroArchivo.registrarArchivoDeSiniestro('string', 'string', 'string', 'string', 'string');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testRegistrarArchivoDeSiniestroFail500() {
        Test.setMock(HttpCalloutMock.class, new SCSiniestroArchivosMockFail500());
  
        test.StartTest();
        SCSiniestroArchivo.Wrapper wrapper = new SCSiniestroArchivo.Wrapper();
        wrapper = SCSiniestroArchivo.registrarArchivoDeSiniestro('string', 'string', 'string', 'string', 'string');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    } 
}