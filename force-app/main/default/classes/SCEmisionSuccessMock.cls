@isTest
global with sharing class SCEmisionSuccessMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //TODO el body siguiente habría que reemplazarlo por una response 200 real
        res.setBody('{"Response":{"Issue":"string"},"HasError":false,"HasWarning":false,"HasInformation":true,"Messages":[{"NombreServicio":"string","VersionServicio":"string","Description":"string","MessageBeautiful":"string","StackTrace":"string","ErrorLevel":0}]}');
        res.setStatusCode(200);
        return res;
    }
}