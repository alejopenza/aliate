@isTest
public inherited sharing class SCPersonOccupationTest {

    @isTest
    static void getOccupationsTestSuccess() {     
		Test.setMock(HttpCalloutMock.class, new SCPersonOccupationMockSuccess());
        test.StartTest();
        SCPersonOccupation.Wrapper service = new SCPersonOccupation.Wrapper();
        service = SCPersonOccupation.Wrapper.getOccupations();
        test.stopTest();
        
		System.assertEquals(false, service.hasError, 'La conexión fue devuelta con errores.');
    }

    @isTest
    static void getOccupationsTestFail() {     
		Test.setMock(HttpCalloutMock.class, new SCPersonOccupationMockFail());
        test.StartTest();
        SCPersonOccupation.Wrapper service = new SCPersonOccupation.Wrapper();
        service = SCPersonOccupation.Wrapper.getOccupations();
        test.stopTest();
        
		System.assertEquals(true, service.hasError, 'La conexión fue devuelta sin errores.');
    }

    @isTest
    static void getOccupationsTestFail500() {     
		Test.setMock(HttpCalloutMock.class, new SCPersonOccupationMockFail500());
        test.StartTest();
        SCPersonOccupation.Wrapper service = new SCPersonOccupation.Wrapper();
        service = SCPersonOccupation.Wrapper.getOccupations();
        test.stopTest();
        
		System.assertEquals(true, service.hasError, 'La conexión fue devuelta sin errores.');
    }

}