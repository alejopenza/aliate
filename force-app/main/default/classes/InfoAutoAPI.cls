public with sharing class InfoAutoAPI {
    public InfoAutoAPI() {

    }

    public Wrapper getMarcas(){
        Wrapper result = new Wrapper();

        try{
            Credencial__mdt credencial = [
                SELECT Url__c, User__c, Clave__c
                FROM Credencial__mdt
                WHERE Label = 'INFOAUTO MARCAS'
            ];

            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c);
            req.setMethod('GET');
            req.setTimeout(16000);
            req.setHeader('content-type','application/Json');
			req.setHeader('USERNAME',credencial.User__c);
			req.setHeader('PASS',credencial.Clave__c);            
            
            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if(res.getStatusCode() == 200){
                for(InfoAutoAPIMarcasResponse.Marcas marca : InfoAutoAPIMarcasResponse.parse(res.getBody()).Marcas){
                    result.marcas.put(marca.Numero, marca.Descripcion);
                }
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
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public Wrapper getModelos(String marca){
        Wrapper result = new Wrapper();
        try{
            Credencial__mdt credencial = [
                SELECT Url__c, User__c, Clave__c
                FROM Credencial__mdt
                WHERE Label = 'INFOAUTO MODELOS'
            ];

            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c + String.valueOf(marca)); 
            req.setMethod('GET');
            req.setTimeout(16000);
            req.setHeader('content-type','application/Json');
			req.setHeader('USERNAME',credencial.User__c);
			req.setHeader('PASS',credencial.Clave__c);            
            
            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if(res.getStatusCode() == 200){
                for(InfoAutoAPIModelosResponse.Modelos modelo : InfoAutoAPIModelosResponse.parse(res.getBody()).Modelos){
                    result.modelos.put(modelo.Numero, modelo.Descripcion);
                }
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
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public Wrapper getVersiones(String marca, String modelo, String anio){
        Wrapper result = new Wrapper();
        try{
            Credencial__mdt credencial = [
                SELECT Url__c, User__c, Clave__c
                FROM Credencial__mdt
                WHERE Label = 'INFOAUTO VERSIONES'
            ];

            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c + 'MarcaNumero=' + String.valueOf(marca) + 
            '&NumeroModelo=' + String.valueOf(modelo) + 
            '&Anio=' + String.valueOf(anio)); 
            req.setMethod('GET');
            req.setTimeout(16000);
            req.setHeader('content-type','application/Json');
			req.setHeader('USERNAME',credencial.User__c);
			req.setHeader('PASS',credencial.Clave__c);            
            
            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if(res.getStatusCode() == 200){
                for(InfoAutoAPIVersionesResponse.Versiones version : InfoAutoAPIVersionesResponse.parse(res.getBody()).Versiones){
                    result.versiones.put(version.CodigoInfoAuto, version.NombreCompleto);
                }
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
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    //Wrapper
    public class Wrapper{
        public Wrapper(){
            this.hasError = false;
            this.errors = new List<String>();
            this.marcas = new Map<Integer, String>();
            this.modelos = new Map<Integer, String>();
            this.versiones = new Map<Integer, String>();
        }

        @AuraEnabled
        public boolean hasError;

        @AuraEnabled
        public List<String> errors;

        @AuraEnabled
        public Map<Integer, String> marcas;

        @AuraEnabled
        public Map<Integer, String> modelos;

        @AuraEnabled
        public Map<Integer, String> versiones;
    }
}