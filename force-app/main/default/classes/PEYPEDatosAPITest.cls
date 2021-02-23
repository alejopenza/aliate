@isTest
public with sharing class PEYPEDatosAPITest {
    @isTest
    static void PEYPEDatosAPITest() {     
		Test.setMock(HttpCalloutMock.class, new PEYPEDatosApiMock());
        test.StartTest();
        PEYPEDatosApi service = new PEYPEDatosApi();
		PEYPEDatosApi.Wrapper response = service.getDataFromAPI('30694303451');
        test.stopTest();
		System.assertEquals(false, response.hasError);
    }
}