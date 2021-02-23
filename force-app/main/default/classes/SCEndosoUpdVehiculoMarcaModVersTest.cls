@isTest
public with sharing class SCEndosoUpdVehiculoMarcaModVersTest {

    @isTest
    static void testActualizarVehiculoSuccess() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoActualizarMarcaModVerMockSuccess());
  
        test.StartTest();
        SCEndosoUpdVehiculoMarcaModeloVersion.Wrapper wrapper = new SCEndosoUpdVehiculoMarcaModeloVersion.Wrapper();
        wrapper = SCEndosoUpdVehiculoMarcaModeloVersion.actualizarDatosDeVehiculo('01-05-01-30005489', '460531', '2010', '2019-10-31');
        test.stopTest();
  
        System.assertEquals(false, wrapper.hasError, 'La conexión fue devuelta con errores.');
    }

    @isTest
    static void testActualizarVehiculoFail() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoActualizarMarcaModVerMockFail());
  
        test.StartTest();
        SCEndosoUpdVehiculoMarcaModeloVersion.Wrapper wrapper = new SCEndosoUpdVehiculoMarcaModeloVersion.Wrapper();
        wrapper = SCEndosoUpdVehiculoMarcaModeloVersion.actualizarDatosDeVehiculo('01-05-01-30005489', '460531', '2010', '2019-10-31');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testActualizarVehiculoFail500() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoActualizarMarcaModVerMockFail500());
  
        test.StartTest();
        SCEndosoUpdVehiculoMarcaModeloVersion.Wrapper wrapper = new SCEndosoUpdVehiculoMarcaModeloVersion.Wrapper();
        wrapper = SCEndosoUpdVehiculoMarcaModeloVersion.actualizarDatosDeVehiculo('01-05-01-30005489', '460531', '2010', '2019-10-31');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }    
}