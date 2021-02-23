public with sharing class PEYPEDatosAPI {
	public PEYPEDatosAPI() {}

    public Wrapper getDataFromAPI(String cuit){
        Wrapper result = new Wrapper();

        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(setUrl() + '/' + cuit + '/S/json');
            req.setMethod('GET');
            req.setTimeout(16000);

            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if(res.getStatusCode() == 200){
                result.response = PEYPEDatosAPIResponse.parse(res.getBody());
                system.debug('result.response: ' + result.response);
            }else if(res.getStatusCode() == 404){
                result.hasError = true;
                result.errors.add('Servicio no disponible. Intente mas tarde.');
            }else{
                result.hasError = true;
                result.errors.add('Error al realizar la consulta, revise los datos ingresados.');
            }
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage());
        }

        return result;
    }

    public String setUrl(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'PEYPE'
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
        public PEYPEDatosAPIResponse response;
    }
}