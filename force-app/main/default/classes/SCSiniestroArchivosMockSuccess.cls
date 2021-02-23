@isTest
global with sharing class SCSiniestroArchivosMockSuccess implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //TODO el body siguiente habría que reemplazarlo por una response 200 REAL
        res.setBody('{"ClaimFiles":null,"HasError":false,"HasWarning":false,"HasInformation":false,"Messages":[]}');
        res.setStatusCode(200);
        return res;
    }
}