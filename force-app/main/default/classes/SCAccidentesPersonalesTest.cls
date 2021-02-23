@isTest
public with sharing class SCAccidentesPersonalesTest {

    @isTest
    static void testActualizarVehiculoSuccessWithError() {
        Test.setMock(HttpCalloutMock.class, new SCAccidentesPersonalesMockSuccess());
  
        test.StartTest();
        SCAccidentesPersonales.Wrapper wrapper = new SCAccidentesPersonales.Wrapper();
        wrapper = SCAccidentesPersonales.cotizarAccidentesPersonales('2020-01-24T00:00:00+00:00', true, '1991-01-04T00:00:00+00:00', true, true, 'Isabel Beatriz', 'F', 'Villalba', 'Ext_DNI96', '1406', 'AR_23', 'CAPITAL FEDERAL', 'Person', '18352714', '2019-11-13T00:00:00+00:00', true, '1406', 'AR_23', '05-006797', '2020-08-13T17:13:53.707Z', 'Annual', 12, 'resonsive', 'ars', '', 'AP24Base', '24Horas', 'apPlan10', 'Ext_Act1');
        
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue devuelta sin errores.');
    }

    @isTest
    static void testActualizarVehiculoFail() {
        Test.setMock(HttpCalloutMock.class, new SCAccidentesPersonalesMockFail());
  
        test.StartTest();
        SCAccidentesPersonales.Wrapper wrapper = new SCAccidentesPersonales.Wrapper();
        wrapper = SCAccidentesPersonales.cotizarAccidentesPersonales('2020-01-24T00:00:00+00:00', true, '1991-01-04T00:00:00+00:00', true, true, 'Isabel Beatriz', 'F', 'Villalba', 'Ext_DNI96', '1406', 'AR_23', 'CAPITAL FEDERAL', 'Person', '18352714', '2019-11-13T00:00:00+00:00', true, '1406', 'AR_23', '05-006797', '2020-08-13T17:13:53.707Z', 'Annual', 12, 'resonsive', 'ars', '', 'AP24Base', '24Horas', 'apPlan10', 'Ext_Act1');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testActualizarVehiculoFail500() {
        Test.setMock(HttpCalloutMock.class, new SCAccidentesPersonalesMockFail500());
  
        test.StartTest();
        SCAccidentesPersonales.Wrapper wrapper = new SCAccidentesPersonales.Wrapper();
        wrapper = SCAccidentesPersonales.cotizarAccidentesPersonales('2020-01-24T00:00:00+00:00', true, '1991-01-04T00:00:00+00:00', true, true, 'Isabel Beatriz', 'F', 'Villalba', 'Ext_DNI96', '1406', 'AR_23', 'CAPITAL FEDERAL', 'Person', '18352714', '2019-11-13T00:00:00+00:00', true, '1406', 'AR_23', '05-006797', '2020-08-13T17:13:53.707Z', 'Annual', 12, 'resonsive', 'ars', '', 'AP24Base', '24Horas', 'apPlan10', 'Ext_Act1');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    } 
}