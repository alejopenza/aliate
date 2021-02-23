@isTest
public with sharing class SCEndosoFormaDePagoTests {

    @isTest
    static void testUpdateFormaDePagoEfectivoSuccess() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockSuccess200());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToResponsive('01-05-07-30006075', '2020-01-01');
        test.stopTest();
  
        System.assertEquals(false, wrapper.hasError, 'La conexión fue exitosa y devuelta sin errores.');
    }    
    
    
    @isTest
    static void testUpdateFormaDePagoEfectivoSuccessWithError() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockSuccess());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToResponsive('01-05-07-30006075', '2020-01-01');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa y devuelta sin errores.');
    }

    @isTest
    static void testUpdateFormaDePagoEfectivoFail() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockFail());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToResponsive('01-05-07-30006075', '2020-01-01');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testUpdateFormaDePagoEfectivoFail500() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockFail500());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToResponsive('01-05-07-30006075', '2020-01-01');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testUpdateFormaDePagoDebitoSuccessWithError() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockSuccess());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToDirectDebit('01-05-07-30006075', '2020-01-01', 'XXXXXXXXXXXXXXXXXXXXXX');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa y devuelta sin errores.');
    }

    @isTest
    static void testUpdateFormaDePagoDebitoFail() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockFail());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToDirectDebit('01-05-07-30006075', '2020-01-01', 'XXXXXXXXXXXXXXXXXXXXXX');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testUpdateFormaDePagoDebitoFail500() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockFail500());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToDirectDebit('01-05-07-30006075', '2020-01-01', 'XXXXXXXXXXXXXXXXXXXXXX');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testUpdateFormaDePagoCreditoSuccessWithError() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockSuccess());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToCreditCard('01-05-07-30006075', '2020-01-01', 'XXXXXXXXXXXXXXXX', 'VISA ARGENTINA S.A.');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa y devuelta sin errores.');
    }

    @isTest
    static void testUpdateFormaDePagoCreditoFail() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockFail());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToCreditCard('01-05-07-30006075', '2020-01-01', 'XXXXXXXXXXXXXXXX', 'VISA ARGENTINA S.A.');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testUpdateFormaDePagoCreditoFail500() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoMockFail500());
  
        test.StartTest();
        SCEndosoFormaDePago.Wrapper wrapper = new SCEndosoFormaDePago.Wrapper();
        wrapper = SCEndosoFormaDePago.updatePaymentMethodToCreditCard('01-05-07-30006075', '2020-01-01', 'XXXXXXXXXXXXXXXX', 'VISA ARGENTINA S.A.');
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

}