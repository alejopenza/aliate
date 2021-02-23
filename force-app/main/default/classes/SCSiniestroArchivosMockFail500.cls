@isTest
global with sharing class SCSiniestroArchivosMockFail500 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //TODO el body siguiente habría que reemplazarlo por una response 500 REAL
        res.setBody('{"ClaimFiles":null,"HasError":false,"HasWarning":false,"HasInformation":false,"Messages":[]}');
        res.setStatusCode(500);
        return res;
    }
}