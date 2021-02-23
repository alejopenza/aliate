@isTest
public with sharing class SCAccidentesPersonalesEmisionTest {

    @isTest
    static void testEmisionAccidentesPersonalesSuccess() {
        Test.setMock(HttpCalloutMock.class, new SCAccidentesPersonalesEmisionMockSuccess());
  
        test.StartTest();
        SCAccidentesPersonalesEmision.Wrapper wrapper = new SCAccidentesPersonalesEmision.Wrapper();
        wrapper = SCAccidentesPersonalesEmision.emitirAccidentesPersonales('pc:8631634', 'null', null, null, null, false, 'Av Directorio', '10', 'A', 'Ext_LegalAddress', 'Domicilio Legal', null, 'CAPITAL FEDERAL:1406', 'AR', 'Argentina', '000', null, 'Av Directorio 2600, Piso 9, Dpto A, CAPITAL FEDERAL:1000, CAPITAL FEDERAL, 1000', true, '1406', true, 'pc:7298684', 'AR_23', 'CAPITAL FEDERAL', '2600');
        
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue devuelta sin errores.');
    }

    @isTest
    static void testEmisionAccidentesPersonalesFail() {
        Test.setMock(HttpCalloutMock.class, new SCAccidentesPersonalesEmisionMockFail());
  
        test.StartTest();
        SCAccidentesPersonalesEmision.Wrapper wrapper = new SCAccidentesPersonalesEmision.Wrapper();
        wrapper = SCAccidentesPersonalesEmision.emitirAccidentesPersonales('pc:8631634', 'null', null, null, null, false, 'Av Directorio', '10', 'A', 'Ext_LegalAddress', 'Domicilio Legal', null, 'CAPITAL FEDERAL:1406', 'AR', 'Argentina', '000', null, 'Av Directorio 2600, Piso 9, Dpto A, CAPITAL FEDERAL:1000, CAPITAL FEDERAL, 1000', true, '1406', true, 'pc:7298684', 'AR_23', 'CAPITAL FEDERAL', '2600');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testEmisionAccidentesPersonalesFail500() {
        Test.setMock(HttpCalloutMock.class, new SCAccidentesPersonalesEmisionMock500());
  
        test.StartTest();
        SCAccidentesPersonalesEmision.Wrapper wrapper = new SCAccidentesPersonalesEmision.Wrapper();
        wrapper = SCAccidentesPersonalesEmision.emitirAccidentesPersonales('pc:8631634', 'null', null, null, null, false, 'Av Directorio', '10', 'A', 'Ext_LegalAddress', 'Domicilio Legal', null, 'CAPITAL FEDERAL:1406', 'AR', 'Argentina', '000', null, 'Av Directorio 2600, Piso 9, Dpto A, CAPITAL FEDERAL:1000, CAPITAL FEDERAL, 1000', true, '1406', true, 'pc:7298684', 'AR_23', 'CAPITAL FEDERAL', '2600');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    } 

}