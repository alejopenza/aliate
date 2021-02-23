@isTest
public with sharing class SCApiQuoteTest {

    @isTest
    static void SCApiQuoteTestFail() {     
      Test.setMock(HttpCalloutMock.class, new SCApiQuoteMockFail());
      CotizadorController.Auto auto = new CotizadorController.Auto();
      CotizadorController.Cliente cliente = new CotizadorController.Cliente();
      auto.uso = true;
      test.StartTest();
      SCApiQuote service = new SCApiQuote();
      SCApiQuote.Wrapper wrapper = new SCApiQuote.Wrapper();
      wrapper = service.getDataFromAPI(auto, cliente);
      test.stopTest();

      System.assertEquals(true, wrapper.hasError, 'Conexión devuelta sin errores.');
    }

    @isTest
    static void SCApiQuoteTestFail500() {     
		  Test.setMock(HttpCalloutMock.class, new SCApiQuoteMockFail500());
      CotizadorController.Auto auto = new CotizadorController.Auto();
      CotizadorController.Cliente cliente = new CotizadorController.Cliente();
      auto.uso = false;

      test.StartTest();
      SCApiQuote service = new SCApiQuote();
      SCApiQuote.Wrapper wrapper = new SCApiQuote.Wrapper();
      wrapper = service.getDataFromAPI(auto, cliente);
      test.stopTest();

		  System.assertEquals(true, wrapper.hasError, 'Conexión devuelta sin errores.');
    }

    @isTest
    static void SCApiQuoteTestSuccess() {     
      Test.setMock(HttpCalloutMock.class, new SCApiQuoteMockSuccess());
      CotizadorController.Auto auto = new CotizadorController.Auto();
      CotizadorController.Cliente cliente = new CotizadorController.Cliente();
      auto.uso = true;

      test.StartTest();
      SCApiQuote service = new SCApiQuote();
      SCApiQuote.Wrapper wrapper = new SCApiQuote.Wrapper();
      wrapper = service.getDataFromAPI(auto, cliente);
      test.stopTest();

      String expectedValue = '01-00013479';
      //String actualValue = wrapper.auto.AccountNumber;

      //System.assertEquals(expectedValue, actualValue, 'Account Number devuelto incorrectamente.');
      System.assertEquals(false, wrapper.hasError, 'La conexión no fue exitosa.');
    }

}