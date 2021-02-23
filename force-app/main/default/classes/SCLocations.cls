public inherited sharing class SCLocations {

    public static Wrapper getLocations(String policyPeriodId){
        Wrapper result = new Wrapper();

        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(setUrl() + policyPeriodId);
            req.setMethod('GET');
            req.setTimeout(16000);

            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if(res.getStatusCode() == 200){
                result.location = SCLocationsResponse.parse(res.getBody());
                system.debug('result.cliente: ' + result.location);
            }else if(res.getStatusCode() == 404){
                result.hasError = true;
                result.errors.add('Servicio no disponible. Intente mas tarde.');
            }else{
                result.hasError = true;
                result.errors.add('Error al realizar la consulta, revise los datos ingresados.');
                throw new Exceptions.NoActiveUrlConnectionException('Error al realizar la consulta');
            }
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public static String setUrl(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_GetLocations'
        ];

        return credencial.url__c + '/' + credencial.user__c + '/' + credencial.clave__c;
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
        public SCLocationsResponse location;

    }   
}