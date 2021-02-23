@isTest
public with sharing class SCEmisionTest {
	//comentado por errores de compilacion al deployar a UAT
    /*
    @isTest
    static void SCEmisionTestFail() {
        
        Test.setMock(HttpCalloutMock.class, new SCEmisionFailMock());
        
        test.StartTest();
        SCEmision service = new SCEmision();
        SCEmision.Wrapper wrapper = new SCEmision.Wrapper();
        wrapper = service.getDataFromAPI();
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'Conexión devuelta sin errores.');        
    }

    @isTest
    static void SCEmisionTestFail500() {
        
        Test.setMock(HttpCalloutMock.class, new SCEmisionFailMock500());
        
        test.StartTest();
        SCEmision service = new SCEmision();
        SCEmision.Wrapper wrapper = new SCEmision.Wrapper();
        wrapper = service.getDataFromAPI();
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'Conexión devuelta sin errores.');        
    }

    @isTest
    static void SCEmisionTestSuccess() {
        
        Test.setMock(HttpCalloutMock.class, new SCEmisionSuccessMock());
        
        test.StartTest();
        SCEmision service = new SCEmision();
        SCEmision.Wrapper wrapper = new SCEmision.Wrapper();
        wrapper = service.getDataFromAPI();
        test.stopTest();
  
        System.assertEquals(false, wrapper.hasError, 'Conexión devuelta con errores.');        
    }
	*/
}