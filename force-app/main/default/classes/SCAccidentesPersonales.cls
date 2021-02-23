public with sharing class SCAccidentesPersonales {
    
    public static Wrapper cotizarAccidentesPersonales(String activityStartDate, Boolean startDateSpecified, String dateOfBirth, Boolean dateOfBirthSpecified, Boolean entityPerson, String firstName, String gender, String lastName, String tipoDocumento, String postalCode, String state, String city, String subType, String taxID, String originationDate, Boolean originationDateSpecified, String primaryLocationPostalCode, String primaryLocationState, String producerCode, String startDate, String policyTermCode, Integer paymentFees, String paymentMethod, String currencyCode, String paquete, String offeringCode, String scopeCoverageCode, String offeringPlanCode, String occupationCode)
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
    
            req.setBody(setBody(activityStartDate, startDateSpecified, dateOfBirth, dateOfBirthSpecified, entityPerson, firstName, gender, lastName, tipoDocumento, postalCode, state, city, subType, taxID, originationDate, originationDateSpecified, primaryLocationPostalCode, primaryLocationState, producerCode, startDate, policyTermCode, paymentFees, paymentMethod, currencyCode, paquete, offeringCode, scopeCoverageCode, offeringPlanCode, occupationCode));

            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if (res.getStatusCode() == 200){
                if (!res.getBody().contains('"HasError":true')){
                    //Success
                    result.response = SCAccidentesPersonalesResponse.parse(res.getBody());
                } else {
                    //Error
                    result.hasError = true;
                    result.responseError = SCAccidentesPersErrorResponse.parse(res.getBody());
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
    
    public static String setBody(String activityStartDate, Boolean startDateSpecified, String dateOfBirth, Boolean dateOfBirthSpecified, Boolean entityPerson, String firstName, String gender, String lastName, String tipoDocumento, String postalCode, String state, String city, String subType, String taxID, String originationDate, Boolean originationDateSpecified, String primaryLocationPostalCode, String primaryLocationState, String producerCode, String startDate, String policyTermCode, Integer paymentFees, String paymentMethod, String currencyCode, String paquete, String offeringCode, String scopeCoverageCode, String offeringPlanCode, String occupationCode) {

        String JSONContent = '{"Account":{"AccountHolderContact":{"EntityCompany":{"Ext_ActivityStartDate":"' + activityStartDate + '","Ext_ActivityStartDateSpecified":' + startDateSpecified + '},"EntityPerson":{"DateOfBirth":"' + dateOfBirth + '","DateOfBirthSpecified":' + dateOfBirthSpecified +',"EntityPerson":' + entityPerson + ',"FirstName":"' + firstName + '","Gender":"' + gender + '","LastName":"' + lastName + '"},"OfficialIDType":"' + tipoDocumento + '","PrimaryAddress":{"PostalCode":"' + postalCode + '","State":"' + state + '","City":"' + city + '"},"Subtype":"' + subType + '","TaxID":"' + taxID + '"},"OriginationDate":"' + originationDate + '","OriginationDateSpecified":' + originationDateSpecified + ',"PrimaryLocation":{"PostalCode":"' + primaryLocationPostalCode + '","State":"' + primaryLocationState + '"},"ProducerCode":"' + producerCode + '"},"StartDate":"' + startDate + '","PolicyTermCode":"' + policyTermCode + '","PaymentFees":' + paymentFees + ',"PaymentMethodCode":"' + paymentMethod + '","CurrencyCode":"' + currencyCode + '","Paquete":"' + paquete + '","OfferingCode":"' + offeringCode + '","ScopeCoverageCode":"' + scopeCoverageCode + '","OfferingPlanCode":"' + offeringPlanCode + '","OccupationCode":"' + occupationCode + '"}';
        JSONParser parser = JSON.createParser(JSONContent);
        SCAccidentesPersonalesRequest request = new SCAccidentesPersonalesRequest(parser);

        return JSON.serialize(request);
    }

    public static Credencial__mdt getCredencialInfo(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_Accidentes'
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
        public SCAccidentesPersonalesResponse response; 

        @AuraEnabled
        public SCAccidentesPersErrorResponse responseError;

    }
    
}