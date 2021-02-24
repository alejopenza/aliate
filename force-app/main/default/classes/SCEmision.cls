public with sharing class SCEmision {

    public static EmitirPolizaController.Wrapper emitir(Opportunity opp){
        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();

        result = doQuoteJob(result, opp);

        if(!result.hasError){
            result = doPost(result);
        }

        return result;
    }

    public static EmitirPolizaController.Wrapper doQuoteJob(EmitirPolizaController.Wrapper result, Opportunity opp){

        try{
            
            Credencial__mdt credencial = [
                SELECT User__c, Clave__c, Url__c
                FROM Credencial__mdt
                WHERE Label = 'SCQuoteJob'
            ];
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c + opp.policyPeriodId__c);
            req.setMethod('GET');
            req.setTimeout(120000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            
            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);

            if(res.getStatusCode() == 200){
                SCQuoteJobResponse response = SCQuoteJobResponse.parse(res.getBody());
                if(!response.HasError){
                    result.PolicyPeriodId = response.PolicyPeriodId;
                    result.JobNumber = response.JobNumber;
                }else{
                    result.hasError = true;
                    result.errors.add('Error al consumir la API de QuoteJob.');
                }
            }else{
                result.hasError = true;
                result.errors.add('Error al consumir la API de QuoteJob.');
            }

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public static EmitirPolizaController.Wrapper doPost(EmitirPolizaController.Wrapper result){

        try{
            
            Credencial__mdt credencial = [
                SELECT User__c, Clave__c, Url__c
                FROM Credencial__mdt
                WHERE Label = 'SCIssueSubmissionPost'
            ];
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c);
            req.setMethod('GET');
            req.setBody(setDoPostBody(result));
            req.setTimeout(120000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            
            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);

            if(res.getStatusCode() == 200){
                SCIssueSubmissionPostResponse response = SCIssueSubmissionPostResponse.parse(res.getBody());
                if(!response.HasError){
                    
                }else{
                    result.hasError = true;
                    result.errors.add('Error al consumir la API de QuoteJob.');
                }
            }else{
                result.hasError = true;
                result.errors.add('Error al consumir la API de QuoteJob.');
            }

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public static String setDoPostBody(EmitirPolizaController.Wrapper result){
        SCIssueSubmissionPostRequest req = new SCIssueSubmissionPostRequest();
        req.jobNumber = result.JobNumber;
        //req.BranchNumber = ;

        return json.serialize(req);
    }

    /*
    public static Wrapper doSaveAsDraft(Wrapper result, Opportunity opp){

        try{
            //Save as draft
            Credencial__mdt credencial = [
                SELECT User__c, Clave__c, Url__c
                FROM Credencial__mdt
                WHERE Label = 'SCSetAsDraft'
            ];
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c + opp.policyPeriodId__c);
            req.setMethod('GET');
            req.setTimeout(120000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            
            Http h = new Http();
            system.debug(req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug(res);

            if(res.getStatusCode() == 200){
                SCSetAsDraftResponse response = SCSetAsDraftResponse.parse(res.getBody());
                if(response.HasError = true){
                    result.hasError = true;
                    result.errors.add(response.Messages[0].Description);
                }else{
                    system.debug('Se guardo como draft correctamente!');
                }
            }else{
                result.hasError = true;
                result.errors.add('Error al consumir la API de DRAFT.');
            }

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public static String setBody(CotizadorController.Auto auto, CotizadorController.Cliente cliente){
        String body = '';

        SCEmisionRequest req = new SCEmisionRequest();
        
        SCEmisionRequest.PreSubmissionRequest psr = new SCEmisionRequest.PreSubmissionRequest();
        SCEmisionRequest.Location location = new SCEmisionRequest.Location();
        List<SCEmisionRequest.AdditionalInterestContacts> aics = new List<SCEmisionRequest.AdditionalInterestContacts>();
        
        SCEmisionRequest.AdditionalInterestContacts aic = new SCEmisionRequest.AdditionalInterestContacts();
        
        SCEmisionRequest.Contact contact = new SCEmisionRequest.Contact();
        
        List<SCEmisionRequest.Addresses> addresses = new List<SCEmisionRequest.Addresses>();
        SCEmisionRequest.Addresses address = new SCEmisionRequest.Addresses();
        address.City = cliente.Codigo_Provincia;
        address.PostalCode = String.valueOf(cliente.Codigo_Postal);
        addresses.add(address);
        contact.Addresses = addresses;

        SCEmisionRequest.Attorney at = new SCEmisionRequest.Attorney();
        if(cliente.es_empleador){
            contact.CUIL = cliente.Numero_de_Documento;
        }else{
            at.DocumentNumber = cliente.Numero_de_Documento;    
        }
        at.FirstName = cliente.nombre;
        at.LastName = cliente.apellido;
        contact.Attorney = at;
        
        aic.Contact = contact;
        
        aics.add(aic);
        
        location.AdditionalInterestContacts = aics;
        
        psr.Location = location;
        
        req.PreSubmissionRequest = psr;
        
        return JSON.serialize(body);
    }

    public static Credencial__mdt getCredencialInfo(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_Emision'
        ];

        return credencial;
    }
    */

}