@isTest
global with sharing class SCApiQuoteMockFail implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody('{"Summaries":null,"HasError":true,"HasWarning":false,"HasInformation":true,"Messages":[{"NombreServicio":null,"VersionServicio":null,"Description":"No se ingresó correctamente CodInfoAuto.","MessageBeautiful":null,"StackTrace":null,"ErrorLevel":0}]}');
        res.setStatusCode(404);
        return res;
    }

}