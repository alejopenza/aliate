public with sharing class SCAccidentesPersonalesEmision {
    
    public static Wrapper emitirAccidentesPersonales(String policyPeriodId, String cbu, String creditCardNumber, String code, String description, Boolean updateLinkedAddresses, String addressLine1, String addressLine2, String addressLine3, String addressTypeCode, String addressTypeDescription, String block, String city, String countryCode, String countryDescription, String county, String countyDescription, String displayText, Boolean policyAddress, String postalCode, Boolean primaryAddress, String publicID, String stateCode, String stateDescription, String streetNumber)
    {
        Wrapper result = new Wrapper();

        try{

            Credencial__mdt credencial = getCredencialInfo();

            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c);
            req.setMethod('POST');
            req.setTimeout(16000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            
            
            req.setBody(setBody(policyPeriodId, cbu, creditCardNumber, code, description, updateLinkedAddresses, addressLine1, addressLine2, addressLine3, addressTypeCode, addressTypeDescription, block, city, countryCode, countryDescription, county, countyDescription, displayText, policyAddress, postalCode, primaryAddress, publicID, stateCode, stateDescription, streetNumber));

            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if (res.getStatusCode() == 200){
                if (!res.getBody().contains('"HasError":true')){
                    //Success
                    result.response = SCAccPersEmisionResponse.parse(res.getBody()); //CAMBIAR
                } else {
                    //Error
                    result.hasError = true;
                    result.responseError = SCAccPersEmisionResponseError.parse(res.getBody()); //CAMBIAR
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
    
    public static String setBody(String policyPeriodId, String cbu, String creditCardNumber, String code, String description, Boolean updateLinkedAddresses, String addressLine1, String addressLine2, String addressLine3, String addressTypeCode, String addressTypeDescription, String block, String city, String countryCode, String countryDescription, String county, String countyDescription, String displayText, Boolean policyAddress, String postalCode, Boolean primaryAddress, String publicID, String stateCode, String stateDescription, String streetNumber) {

        String JSONContent = '{"PolicyPeriodId":"' + policyPeriodId + '","CBU":' + cbu + ',"CreditCardNumber":' + creditCardNumber + ',"PaymentEntity":{"Code":' + code + ',"Description":' + description + '},"Address":{"policyPeriodID":"' + policyPeriodId + '","updateLinkedAddresses":' + updateLinkedAddresses + ',"AddressLine1":"' + addressLine1 + '","AddressLine2":"' + addressLine2 + '","AddressLine3":"' + addressLine3 + '","AddressType":{"Code":"' + addressTypeCode + '","Description":"' + addressTypeDescription + '"},"Block":' + block + ',"City":"' + city + '","Country":{"Code":"' + countryCode + '","Description":"' + countryDescription + '"},"County":"' + county + '","Description":' + description + ',"DisplayText":"' + displayText + '","PolicyAddress":' + policyAddress + ',"PostalCode":"' + postalCode + '","PrimaryAddress":' + primaryAddress + ',"PublicID":"' + publicID + '","State":{"Code":"' + stateCode + '","Description":"' + stateDescription + '"},"StreetNumber":"' + streetNumber + '"}}';
        JSONParser parser = JSON.createParser(JSONContent);
        SCAccidentesPersonalesEmisionReq request = new SCAccidentesPersonalesEmisionReq(parser);

        return JSON.serialize(request);
    }

    public static Credencial__mdt getCredencialInfo(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_Emision_Accidentes'
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
        public SCAccPersEmisionResponse response; 

        @AuraEnabled
        public SCAccPersEmisionResponseError responseError;

    }
}