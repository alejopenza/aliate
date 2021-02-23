@isTest
global with sharing class SCEmisionFailMock500 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody('{"Response":{"Issue":"string"},"HasError":true,"HasWarning":true,"HasInformation":true,"Messages":[{"NombreServicio":"string","VersionServicio":"string","Description":"string","MessageBeautiful":"string","StackTrace":"string","ErrorLevel":0}]}');
        res.setStatusCode(500);
        return res;
    }
}