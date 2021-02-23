@isTest
public inherited sharing class SCLocationsTest {

    @isTest
    static void getLocationsTestSuccess() {     
		Test.setMock(HttpCalloutMock.class, new SCPersonOccupationMockSuccess());
        test.StartTest();
        SCLocations.Wrapper service = new SCLocations.Wrapper();
        service = SCLocations.Wrapper.getLocations('7532667');
        test.stopTest();
        
		System.assertEquals(false, service.hasError, 'La conexión fue devuelta con errores.');
    }

    @isTest
    static void getLocationsTestFail() {     
		Test.setMock(HttpCalloutMock.class, new SCPersonOccupationMockFail());
        test.StartTest();
        SCLocations.Wrapper service = new SCLocations.Wrapper();
        service = SCLocations.Wrapper.getLocations('7532667');
        test.stopTest();
        
		System.assertEquals(true, service.hasError, 'La conexión fue devuelta sin errores.');
    }

    @isTest
    static void getLocationsTestFail500() {     
		Test.setMock(HttpCalloutMock.class, new SCPersonOccupationMockFail500());
        test.StartTest();
        SCLocations.Wrapper service = new SCLocations.Wrapper();
        service = SCLocations.Wrapper.getLocations('7532667');
        test.stopTest();
        
		System.assertEquals(true, service.hasError, 'La conexión fue devuelta sin errores.');
    }
}