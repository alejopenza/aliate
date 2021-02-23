public with sharing class SCEndosoFormaDePago {


    public static Wrapper updatePaymentMethodToResponsive(String policyNumber, String effectiveDate){
        Credencial__mdt credencial = getCredencialInfo();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(credencial.Url__c + policyNumber + '&effectiveDate=' + effectiveDate);
        req.setMethod('POST');
        req.setTimeout(16000);

        req.setBody(setBodyResponsive());

        return updatePaymentMethod(policyNumber, effectiveDate, req);
    }

    public static Wrapper updatePaymentMethodToDirectDebit(String policyNumber, String effectiveDate, String cbu){
        Credencial__mdt credencial = getCredencialInfo();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(credencial.Url__c + policyNumber + '&effectiveDate=' + effectiveDate);
        req.setMethod('POST');
        req.setTimeout(16000);
        req.setHeader('content-type','application/Json');
        req.setHeader('USERNAME', credencial.User__c);
        req.setHeader('PASS', credencial.Clave__c);

        req.setBody(setBodyCBU(cbu));

        return updatePaymentMethod(policyNumber, effectiveDate, req);
    }    

    public static Wrapper updatePaymentMethodToCreditCard(String policyNumber, String effectiveDate, String creditCardNumber, String tipoTarjeta){
        Credencial__mdt credencial = getCredencialInfo();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(credencial.Url__c + policyNumber + '&effectiveDate=' + effectiveDate);
        req.setMethod('POST');
        req.setTimeout(16000);

        req.setBody(setBodyCreditCard(creditCardNumber, tipoTarjeta));

        return updatePaymentMethod(policyNumber, effectiveDate, req);
    }    

    public static Wrapper updatePaymentMethod(String policyNumber, String effectiveDate, HttpRequest req) {
        Wrapper result = new Wrapper();

        try{
            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if (res.getStatusCode() == 200){
                if (!res.getBody().contains('"HasError":true')){
                    //Success
                    result.response = SCEndosoFormaPagoResponse.parse(res.getBody()); //todo falta response 200 REAL
                } else {
                    //Error
                    result.hasError = true;
                    result.responseError = SCEndosoFormaPagoResponseError.parse(res.getBody());
                }

            } else if (res.getStatusCode() == 404){
                result.hasError = true;
                result.errors.add('Servicio no disponible. Intente mas tarde.');
                throw new Exceptions.NoActiveUrlConnectionException('Error al realizar la consulta');
            } else {
                result.hasError = true;
                result.errors.add('Error al realizar la consulta, revise los datos ingresados.');
                throw new Exceptions.NoActiveUrlConnectionException('Error al realizar la consulta');
            }
        } catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }
        return result;
    }

    public static String setBodyResponsive() {

        String JSONContent = '{"Method":{"Code":"responsive","Description":"Efectivo"}}';
        JSONParser parser = JSON.createParser(JSONContent);
        SCEndosoEfectivo request = new SCEndosoEfectivo(parser);

        return JSON.serialize(request);
    }

    public static String setBodyCreditCard(String creditCardNumber, String tipoTarjeta) {

        String JSONContent = '{"CreditCardNumber":"' + creditCardNumber + '","PaymentEntity":{"Code":"default_data:10020","Description":" ' + tipoTarjeta + '"},"Method":{"Code":"creditcard","Description":"Tarjeta de crédito"}}';
        JSONParser parser = JSON.createParser(JSONContent);
        SCEndosoCredito request = new SCEndosoCredito(parser);

        return JSON.serialize(request);
    }

    public static String setBodyCBU(String cbu) {

        String JSONContent = '{"CBU":"' + cbu + '","Method":{"Code":"directDebit","Description":"Débito Directo"}}';
        JSONParser parser = JSON.createParser(JSONContent);
        SCEndosoDebito request = new SCEndosoDebito(parser);

        return JSON.serialize(request);
    }

    public static Credencial__mdt getCredencialInfo(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_Endoso'
        ];

        return credencial;
    }   

    //Wrapper
    public class Wrapper{
        public Wrapper(){
            this.hasError = false;
            this.errors = new List<String>();
        }

        @AuraEnabled
        public boolean hasError;

        @AuraEnabled
        public List<String> errors;

        @AuraEnabled
        public SCEndosoFormaPagoResponse response;

        @AuraEnabled
        public SCEndosoFormaPagoResponseError responseError;

    }

}