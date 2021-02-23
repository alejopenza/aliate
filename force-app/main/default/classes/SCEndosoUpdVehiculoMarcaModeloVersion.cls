public with sharing class SCEndosoUpdVehiculoMarcaModeloVersion {

    public static Wrapper actualizarDatosDeVehiculo(String policyNumber, String codInfoAuto, String anio, String effectiveDate)
    {
        Wrapper result = new Wrapper();

        try{

            Credencial__mdt credencial = getCredencialInfo();

            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c + policyNumber + '&codInfoAuto=' + codInfoAuto + '&anio=' + anio + '&effectiveDate=' + effectiveDate);
            req.setMethod('POST');
            req.setTimeout(16000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
    
            req.setBody(setBody(policyNumber, codInfoAuto, anio, effectiveDate));

            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if (res.getStatusCode() == 200){
                if (!res.getBody().contains('"HasError":true')){
                    //Success
                    result.response = SCEndosoUpdVehicMarcaModResponse.parse(res.getBody());
                } else {
                    //Error
                    result.hasError = true;
                    result.responseError = SCEndosoUpdVehicMarcaModResponse.parse(res.getBody()); //CAMBIAR
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

    public static String setBody(String policyNumber, String codInfoAuto, String anio, String effectiveDate) {

        String JSONContent = '{"PolicyNumber":"' + policyNumber + '","CodInfoAuto":"' + codInfoAuto + '","Anio":"' + anio + '","EffectiveDate":"' + effectiveDate + '"}';
        JSONParser parser = JSON.createParser(JSONContent);
        SCEndosoUpdateVehicleMarcaModReq request = new SCEndosoUpdateVehicleMarcaModReq(parser);

        return JSON.serialize(request);
    }

    public static Credencial__mdt getCredencialInfo(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_UpdMarcaModeloVers'
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
        public SCEndosoUpdVehicMarcaModResponse response;

        @AuraEnabled
        public SCEndosoUpdVehicMarcaModResponse responseError;

    }
}