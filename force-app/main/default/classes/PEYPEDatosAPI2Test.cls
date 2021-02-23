@isTest
public with sharing class PEYPEDatosAPI2Test {
    @isTest
    static void PEYPEDatosAPITest() {     
		Test.setMock(HttpCalloutMock.class, new PEYPEDatosAPI2Mock());
        test.StartTest();
        PEYPEDatosAPI2 service = new PEYPEDatosAPI2();
		PEYPEDatosAPI2.Wrapper response = service.getDataFromAPI('30694303451');
        test.stopTest();
		System.assertEquals(false, response.hasError);
    }
}