@isTest
public with sharing class SCEndosoActualizarVehiculoTest {

    @isTest
    static void testActualizarVehiculoSuccessWithError() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoActualizarVehiculoMockSuccess());
  
        test.StartTest();
        SCEndosoActualizarVehiculo.Wrapper wrapper = new SCEndosoActualizarVehiculo.Wrapper();
        wrapper = SCEndosoActualizarVehiculo.actualizarDatosDeVehiculo('01-05-01-30005489', '1', 'AA000AA', '', '');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa y devuelta sin errores.');
    }

    @isTest
    static void testActualizarVehiculoFail() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoActualizarVehiculoMockFail());
  
        test.StartTest();
        SCEndosoActualizarVehiculo.Wrapper wrapper = new SCEndosoActualizarVehiculo.Wrapper();
        wrapper = SCEndosoActualizarVehiculo.actualizarDatosDeVehiculo('01-05-01-30005489', '1', 'AA000AA', '', '');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testActualizarVehiculoFail500() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoActualizarVehiculoMockFail500());
  
        test.StartTest();
        SCEndosoActualizarVehiculo.Wrapper wrapper = new SCEndosoActualizarVehiculo.Wrapper();
        wrapper = SCEndosoActualizarVehiculo.actualizarDatosDeVehiculo('01-05-01-30005489', '1', 'AA000AA', '', '');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }    
}