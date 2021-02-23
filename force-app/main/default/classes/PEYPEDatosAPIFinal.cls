public with sharing class PEYPEDatosAPIFinal {
    public PEYPEDatosAPIFinal() {}

    public static CotizadorController.Wrapper doDNICallout(CotizadorController.Wrapper result, String numero, String sexo){
        system.debug('doDNICallout(): ' + numero + ' ' + sexo);
        
        String genero = '';
        if(sexo == 'MASCULINO'){
            genero = 'M';
        }else{
            genero = 'F';
        }
        PEYPEDatosAPIFinal.Wrapper response = getDataFromAPI(numero, genero);

        if (!response.hasError){
            CotizadorController.Cliente cliente = new CotizadorController.Cliente();

            List<String> apellidoYNombre = response.cliente.RESULTADO.Existencia_Fisica.row.apenom.split(' ');
            cliente.apellido = apellidoYNombre[0];
            cliente.nombre = apellidoYNombre[1];

            cliente.Numero_de_Documento = String.valueOf(response.cliente.RESULTADO.Existencia_Fisica.row.doc);
            cliente.Codigo_Postal = response.cliente.RESULTADO.Existencia_Fisica.row.cp;

            cliente.genero = response.cliente.RESULTADO.Existencia_Fisica.row.sexo;
            cliente.tipoDeDocumento = 'Ext_DNI96'; //CHEQUEAR
            cliente.fecha_nacimiento = response.cliente.RESULTADO.Existencia_Fisica.row.fecha_nac;
            cliente.estado = response.cliente.RESULTADO.Existencia_Fisica.row.provincia; //CHEQUEAR
            System.debug('PEYPE: ' + response.cliente.RESULTADO.Existencia_Fisica);
            result.cliente = cliente;

        } else {
            result.hasError = true;
            result.errors.addAll(response.errors);
        }
        return result;
    }

    public static CotizadorController.Wrapper doCUITCallout(CotizadorController.Wrapper result, String numero){
        
        PEYPEDatosAPIFinal.Wrapper response = getDataFromAPI(numero);

        if(!response.hasError){
            CotizadorController.Cliente cliente = new CotizadorController.Cliente();
            if(String.isNotBlank(response.clienteCuit.RESULTADO.Existencia.row.razon)){
                cliente.es_empleador = true;
                cliente.nombre = response.clienteCuit.RESULTADO.Existencia.row.razon;
                cliente.Numero_de_Documento = String.valueOf(response.clienteCuit.RESULTADO.Existencia.row.cuit);
                cliente.Codigo_Postal = response.clienteCuit.RESULTADO.Existencia.row.cp;
                cliente.tipoDeDocumento = 'CUIT'; //CHEQUEAR
            }
            System.debug('PEYPE CUIT: ' + response.clienteCuit.RESULTADO);
            result.cliente = cliente;
            
            system.debug('response.clienteCuit.RESULTADO.Existencia_Fisica.row.isEmpty(): ' + response.clienteCuit.RESULTADO.Existencia_Fisica.row.isEmpty());
            if(!response.clienteCuit.RESULTADO.Existencia_Fisica.row.isEmpty()){
                for(Integer i=0; i< response.clienteCuit.RESULTADO.Existencia_Fisica.row.size(); i++){
                    system.debug(response.clienteCuit.RESULTADO.Existencia_Fisica.row[i]);
                    CotizadorController.NominaItem item = new CotizadorController.NominaItem();
                    item.apenom = response.clienteCuit.RESULTADO.Existencia_Fisica.row[i].apenom;
                    item.doc = response.clienteCuit.RESULTADO.Existencia_Fisica.row[i].doc;
                    item.edad = response.clienteCuit.RESULTADO.Existencia_Fisica.row[i].edad;
                    item.fecha_nac = response.clienteCuit.RESULTADO.Existencia_Fisica.row[i].fecha_nac;
                    item.localidad = response.clienteCuit.RESULTADO.Existencia_Fisica.row[i].localidad;
                    result.nomina.add(item);
                }    
            }
            
        }else{
            result.hasError = true;
            result.errors.addAll(response.errors);
        }
        
        return result;
    }

    public static Decimal getCondicionAnteIVA(CotizadorController.Wrapper result){
        if(result.cliente.tipoDeDocumento == 'DNI'){
            return [
                SELECT Codigo__c
                FROM Condicion_IVA__mdt
                WHERE Nombre__c = 'Consumidor Final'
            ].Codigo__c;
        }else if(result.cliente.tipoDeDocumento == 'CUIT'){
            return [
                SELECT Codigo__c
                FROM Condicion_IVA__mdt
                WHERE Nombre__c = 'Responsable Inscripto'
            ].Codigo__c;
        }else{
            //TODO agregar demas tipos de documentos y consultar valor x default
            return [
                SELECT Codigo__c
                FROM Condicion_IVA__mdt
                WHERE Nombre__c = 'Exento'
            ].Codigo__c;
        }
    }

    public static Wrapper getDataFromAPI(String dni, String sexo){
        Wrapper result = new Wrapper();

        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(setUrl() + '/' + dni + '/' + sexo + '/json');
            req.setMethod('GET');
            req.setTimeout(16000);

            Http h = new Http();
            system.debug('Request: ' + req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug('Response: ' + res.getBody());
            
            if(res.getStatusCode() == 200){
                if(res.getBody().contains('descripcion_error')){
                    PEYPEErrorResponse errorResponse = PEYPEErrorResponse.parse(res.getBody());
                    result.errors.add(errorResponse.RESULTADO.ERROR.descripcion_error);
                }else{
                    result.cliente = PEYPEDatosAPIFinalResponse.parse(res.getBody());
                    system.debug('result.cliente: ' + result.cliente);
                }
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

    public static Wrapper getDataFromAPI(String cuit){
        Wrapper result = new Wrapper();

        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(setUrl() + '/' + cuit + '/S/json');
            req.setMethod('GET');
            req.setTimeout(16000);

            Http h = new Http();
            system.debug('Request: ' + req.getEndpoint());
            HttpResponse res = h.send(req);
            system.debug('Result: ' + res.getBody());
            
            if(res.getStatusCode() == 200){
                if(res.getBody().contains('descripcion_error')){
                    result.hasError = true;
                    result.errors.add('No se ha encontrado informacion, por favor intente con otros datos.');
                }else{
                    result.clienteCUIT = PEYPEDatosAPIFinalResponseCUIT.parse(res.getBody());
                    system.debug('result.cliente: ' + result.clienteCUIT);
                }
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
            WHERE Label = 'PeypeFinal'
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
        public PEYPEDatosAPIFinalResponse cliente;

        @AuraEnabled
        public PEYPEDatosAPIFinalResponseCUIT clienteCuit;
    }

}