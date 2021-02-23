@isTest
public with sharing class SCEndosoEmisionPostTest {

    @isTest
    static void testEmisionSuccessWithError() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoEmisionPostMockSuccess());
  
        test.StartTest();
        SCEndosoEmisionPost.Wrapper wrapper = new SCEndosoEmisionPost.Wrapper();
        wrapper = SCEndosoEmisionPost.emitir('01-05-01773108', '1224374', true);
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue devuelta con errores.');
    }

    @isTest
    static void testEmisionFail() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoEmisionPostMockFail());
  
        test.StartTest();
        SCEndosoEmisionPost.Wrapper wrapper = new SCEndosoEmisionPost.Wrapper();
        wrapper = SCEndosoEmisionPost.emitir('01-05-01773108', '1224374', true);
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }

    @isTest
    static void testEmisionFail500() {
        Test.setMock(HttpCalloutMock.class, new SCEndosoEmisionPostMockFail500());
  
        test.StartTest();
        SCEndosoEmisionPost.Wrapper wrapper = new SCEndosoEmisionPost.Wrapper();
        wrapper = SCEndosoEmisionPost.emitir('01-05-01773108', '1224374', true);
        test.stopTest();
  
        System.assertEquals(true, wrapper.hasError, 'La conexión fue exitosa.');
    }    

}