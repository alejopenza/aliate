@isTest
global with sharing class SCApiQuoteMockSuccess implements HttpCalloutMock  {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody('{"AccountNumber":"01-00013479","StartDate":"2019-01-14 T13:47:06.891Z","PostalCodeRiskLocation":"3500","PolicyTermCode":"HalfYear","PaymentFees":6,"CommercialAlternative":"0","PaymentMethodCode":"creditcard","CurrencyCode":"ars","Vehiculos":[{"CodigoInfoAuto":"180645","Year":2015,"Is0Km":false,"StatedAmount":470000,"Usage":"Personal","AutomaticAdjust":"20","Category":"Car","AccesoryAmount":0}],"Versiones":[{"CA7Product":"CA7_C"},{"CA7Product":"CA7_D"}]}');
        res.setStatusCode(200);
        return res;
    }
}