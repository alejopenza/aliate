@isTest
global with sharing class SCEndosoMockFail implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //TODO el body siguiente habría que reemplazarlo por una response 404 REAL
        res.setBody('{"SummaryDetail":null,"HasError":false,"HasWarning":false,"HasInformation":false,"Messages":[]}');
        res.setStatusCode(404);
        return res;
    }
}