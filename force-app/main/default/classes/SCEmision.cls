public with sharing class SCEmision {

    public static EmitirPolizaController.Wrapper emitir(Opportunity opp, EmitirPolizaController.Param params){
        system.debug('emitir: ' + opp + ' ' + params);

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();

        result = doSaveAsDraft(opp);
        system.debug('hasError: ' + result.hasError);
        
        if(!result.hasError){
            result = doUpdateCar(opp, params);
            system.debug('hasError: ' + result.hasError);

            if(!result.hasError){
                result = doQuoteJob(opp);
                system.debug('hasError: ' + result.hasError);

                if(!result.hasError){
                    result = doPost(result, opp);
                    system.debug('hasError: ' + result.hasError);
                }
            }
        }

        return result;
    }

    public static EmitirPolizaController.Wrapper doSaveAsDraft(Opportunity opp){
        system.debug('doSaveAsDraft: ' + opp.policyPeriodId__c);

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();

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
            system.debug('Request: ' + req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug('Response: ' + res.getBody());
            system.debug('Response status code: ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
                SCSetAsDraftResponse response = SCSetAsDraftResponse.parse(res.getBody());
                system.debug(response);
                if(response.HasError){
                    result.hasError = true;
                    result.errors.add(response.Messages[0].MessageBeautiful);
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

    public static EmitirPolizaController.Wrapper doUpdateCar(Opportunity opp, EmitirPolizaController.Param params){
        system.debug('doUpdateCar: ' + opp.policyPeriodId__c);

        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();

        try{
            
            Credencial__mdt credencial = [
                SELECT User__c, Clave__c, Url__c
                FROM Credencial__mdt
                WHERE Label = 'SCUpdateVehicle'
            ];
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(setDoUpdateCarBody(opp,params));
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            
            Http h = new Http();
            system.debug('Request: ' + req.getEndpoint());
            system.debug('Request: ' + req.getBody());
            HttpResponse res = h.send(req);
            system.debug('Response: ' + res.getBody());
            system.debug('Response status code: ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
                SCUpdateVehiculeResponse response = SCUpdateVehiculeResponse.parse(res.getBody());
                if(!response.HasError){
                    //todo ver q hacer
                }else{
                    result.hasError = true;
                    result.errors.add(response.Messages[0].MessageBeautiful);
                }
            }else{
                result.hasError = true;
                result.errors.add('Error al consumir la API de UPDATE VEHICLE.');
            }

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public static String setDoUpdateCarBody(Opportunity opp, EmitirPolizaController.Param params){
        SCUpdateVehicleRequest req = new SCUpdateVehicleRequest();
        req.PolicyPeriodId = opp.PolicyPeriodId__c;

        SCUpdateVehicleRequest.Vehicle vehicle = new SCUpdateVehicleRequest.Vehicle();
        SCUpdateVehicleRequest.Accesories accesory = new SCUpdateVehicleRequest.Accesories();
        

        vehicle.Accesories = new List<SCUpdateVehicleRequest.Accesories>{accesory};

        vehicle.EngineNumber = params.nroMotor;
        vehicle.LicensePlate = params.patente;
        req.Vehicle = vehicle;
        return JSON.serialize(req);
    }

    public static EmitirPolizaController.Wrapper doQuoteJob(Opportunity opp){
        system.debug('doQuoteJob(): ' + opp.policyPeriodId__c);
        EmitirPolizaController.Wrapper result = new EmitirPolizaController.Wrapper();

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
            system.debug('Request: ' + req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug('Response: ' + res.getBody());

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

    public static EmitirPolizaController.Wrapper doPost(EmitirPolizaController.Wrapper result, Opportunity opp){
        system.debug('doPost: ' + result);
        try{
            
            Credencial__mdt credencial = [
                SELECT User__c, Clave__c, Url__c
                FROM Credencial__mdt
                WHERE Label = 'SCIssueSubmissionPost'
            ];
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c);
            req.setMethod('GET');
            req.setBody(setDoPostBody(result, opp));
            req.setTimeout(120000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            
            Http h = new Http();
            system.debug('Request: ' + req.getEndpoint());
            system.debug('Request: ' + req.getBody());
            HttpResponse res = h.send(req);
            system.debug('Response: ' + res.getBody());

            if(res.getStatusCode() == 200){
                SCIssueSubmissionPostResponse response = SCIssueSubmissionPostResponse.parse(res.getBody());
                if(!response.HasError){
                    
                }else{
                    result.hasError = true;
                    result.errors.add(response.Messages[0].MessageBeautiful);
                }
            }else{
                result.hasError = true;
                result.errors.add('Error al consumir la API de POST.');
            }

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public static String setDoPostBody(EmitirPolizaController.Wrapper result, Opportunity opp){
        SCIssueSubmissionPostRequest req = new SCIssueSubmissionPostRequest();
        req.jobNumber = result.JobNumber;
        req.BranchNumber = Integer.valueOf(opp.BranchNumber__c);

        return json.serialize(req);
    }

}