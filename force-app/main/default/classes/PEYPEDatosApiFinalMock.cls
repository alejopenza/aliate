global with sharing class PEYPEDatosApiFinalMock implements HttpCalloutMock  {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody('{"RESULTADO": {"Existencia": {"row": {"cuit": 30694303451,"altura": 1860,"direccion": "MARIO E ARRUABARRENA","localidad": "CERRO DE LAS ROSAS","provincia": "CORDOBA","cp": 5009,"razon": "BDP S.A."}},"Validacion": {"row": {"estitot": 2.545971,"cuit": 30694303451,"cantemp": 6}}}}');
        res.setStatusCode(200);
        return res;
    }
}