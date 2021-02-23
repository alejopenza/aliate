public with sharing class SCEmision {

    public Wrapper emitir(){
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
            
            //MOCK
            //req.setBody(setMockBody());
            
            //FINAL
            //req.setBody(setBody(auto, cliente));

            Http h = new Http();

            system.debug(req.getBody());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());

            if(res.getStatusCode() == 200){
                
                try{
                    //Error
                    result.errorResponse = SCEmitirResponse.parse(res.getBody());
                }catch(Exception e){
                    //Success
                    //todo desrealizar con la clase creada con la respuesta correcta
                }
                
                //result.auto = SCResponse.parse(res.getBody());
                //system.debug('result.auto: ' + result.auto);

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

    public static Credencial__mdt getCredencialInfo(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_Emision'
        ];

        return credencial;
    }
    
    /*
    public static String setMockBody() {
        SCEmitirParser request = new SCEmitirParser();
        request.PolicyPeriodId = null;
        request.PreSubmissionRequest = null;

        return JSON.serialize(request);
    }
*/    

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
        public SCEmitirParser emision;

        @AuraEnabled
        public SCEmitirResponse errorResponse;

    }

}