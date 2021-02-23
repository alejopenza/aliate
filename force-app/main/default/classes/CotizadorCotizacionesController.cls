public with sharing class CotizadorCotizacionesController {
    public CotizadorCotizacionesController() {

    }

    @AuraEnabled
    public static CotizadorController.Wrapper doSancorCallout(String auto, String cliente, Id oppId){
        system.debug('doSancorCallout()');
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();

        try{
            
            system.debug('auto: ' + auto);
            system.debug('cliente: ' + cliente);
            system.debug('oppId: ' + oppId);

            //EL ERROR SE ESTA DANDO XQ EL AJUSTE VIENE EN CERO, PONERLE UN VALOR X DEFAULT TANTO AL INPUT COMO AL MAPEO CUANDO SE COTIZA ENDOSO
            CotizadorController.Auto autoFromParam = (CotizadorController.Auto) JSON.deserialize(auto, CotizadorController.Auto.class);
            CotizadorController.Cliente clienteFromParam = (CotizadorController.Cliente) JSON.deserialize(cliente, CotizadorController.Cliente.class);

            system.debug('autoFromParam: ' + autoFromParam);
            system.debug('clienteFromParam: ' + clienteFromParam);

            //SANCOR
            result = SancorCotizador.doSancorCallout(result, autoFromParam, clienteFromParam);
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }

    @AuraEnabled
    public static CotizadorController.Wrapper doSanCristobalCallout(String auto, String cliente, Id oppId){
        system.debug('doSanCristobalCallout()');
        System.debug('LOG AUTO: ' + auto);
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();

        try{
            
            system.debug('auto: ' + auto);
            system.debug('cliente: ' + cliente);
            system.debug('oppId: ' + oppId);

            //EL ERROR SE ESTA DANDO XQ EL AJUSTE VIENE EN CERO, PONERLE UN VALOR X DEFAULT TANTO AL INPUT COMO AL MAPEO CUANDO SE COTIZA ENDOSO
            CotizadorController.Auto autoFromParam = (CotizadorController.Auto) JSON.deserialize(auto, CotizadorController.Auto.class);
            CotizadorController.Cliente clienteFromParam = (CotizadorController.Cliente) JSON.deserialize(cliente, CotizadorController.Cliente.class);

            system.debug('autoFromParam: ' + autoFromParam);
            system.debug('clienteFromParam: ' + clienteFromParam);

            //SAN CRISTOBAL
            result = SanCristobalCotizador.doSanCristobalCallout(result, autoFromParam, clienteFromParam);
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }

    /*
    @AuraEnabled
    public static CotizadorController.Wrapper doInitCotizaciones(String auto, String cliente, Id oppId){
        system.debug('doInitCotizaciones()');
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();

        try{
            
            system.debug('auto: ' + auto);
            system.debug('cliente: ' + cliente);
            system.debug('oppId: ' + oppId);

            //EL ERROR SE ESTA DANDO XQ EL AJUSTE VIENE EN CERO, PONERLE UN VALOR X DEFAULT TANTO AL INPUT COMO AL MAPEO CUANDO SE COTIZA ENDOSO
            CotizadorController.Auto autoFromParam = (CotizadorController.Auto) JSON.deserialize(auto, CotizadorController.Auto.class);
            CotizadorController.Cliente clienteFromParam = (CotizadorController.Cliente) JSON.deserialize(cliente, CotizadorController.Cliente.class);

            system.debug('autoFromParam: ' + autoFromParam);
            system.debug('clienteFromParam: ' + clienteFromParam);

            //SANCOR
            result = SancorCotizador.doSancorCallout(result, autoFromParam, clienteFromParam);

            //SAN CRISTOBAL
            result = SanCristobalCotizador.doSanCristobalCallout(result, autoFromParam, clienteFromParam);
            
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }

    @AuraEnabled
    public static Wrapper doInitCotizaciones(String auto, String cliente, Id oppId){
        
        Wrapper result = new Wrapper();
        
        try{
            
            system.debug('auto: ' + auto);
            system.debug('cliente: ' + cliente);
            system.debug('oppId: ' + oppId);

            //EL ERROR SE ESTA DANDO XQ EL AJUSTE VIENE EN CERO, PONERLE UN VALOR X DEFAULT TANTO AL INPUT COMO AL MAPEO CUANDO SE COTIZA ENDOSO
            Auto autoFromParam = (Auto) JSON.deserialize(auto, Auto.class);
            Cliente clienteFromParam = (Cliente) JSON.deserialize(cliente, Cliente.class);

            system.debug('autoFromParam: ' + autoFromParam);
            system.debug('clienteFromParam: ' + clienteFromParam);

            //SANCOR
            result = SancorCotizador.doSancorCallout(result, autoFromParam, clienteFromParam);
            
            if(String.isNotBlank(oppId)){
                Opportunity opp = [
                    SELECT ID, Ramo__c
                    FROM Opportunity
                    WHERE Id = :oppId
                ];
                
                result.cotizacion = opp;
                
                Quote presupuesto = [
                    SELECT ID
                    FROM Quote
                    WHERE OpportunityId = :oppId
                ];
                
                QuoteLineItem qli = [
                    SELECT ID, Product2Id, Product2.Account__c
                    FROM QuoteLineItem
                    WHERE QuoteId = :presupuesto.Id
                ];
                
                for(PricebookEntry entry:[
                    SELECT Id, Name, Pricebook2Id, ProductCode,
                    Product2Id, Product2.Name, Product2.Tipo_de_Cobertura__c, 
                    Product2.Account__r.Name,
                    UnitPrice, IsActive
                    FROM PriceBookEntry
                    WHERE Product2.Tipo_de_Cobertura__c = :autoFromParam.tipoDeCobertura
                    AND Product2.isActive = true
                    AND Product2.RecordType.DeveloperName = 'Vehiculo'
                    AND Product2.Account__c = :qli.product2.Account__c
                    ORDER BY Product2.Account__r.Name, Product2.Tipo_de_Cobertura__c
                ]){
                    Cotizacion nuevaCotizacion = new Cotizacion();
                    nuevaCotizacion.aseguradora = entry.Product2.Account__r.Name;
                    nuevaCotizacion.unitPrice = entry.UnitPrice;
                    nuevaCotizacion.tipoCobertura = entry.Product2.Tipo_de_Cobertura__c;
                    nuevaCotizacion.productCode = entry.ProductCode;
                    result.cotizaciones.add(nuevaCotizacion);
                }
                
                
            }else{
                
                for(PricebookEntry entry:[
                    SELECT Id, Name, Pricebook2Id, ProductCode,
                    Product2Id, Product2.Name, Product2.Tipo_de_Cobertura__c, 
                    Product2.Account__r.Name,
                    UnitPrice, IsActive
                    FROM PriceBookEntry
                    WHERE Product2.Tipo_de_Cobertura__c = :autoFromParam.tipoDeCobertura
                    AND Product2.isActive = true
                    AND Product2.RecordType.DeveloperName = 'Vehiculo'
                    ORDER BY Product2.Account__r.Name, Product2.Tipo_de_Cobertura__c
                ]){
                    Cotizacion nuevaCotizacion = new Cotizacion();
                    nuevaCotizacion.aseguradora = entry.Product2.Account__r.Name;
                    nuevaCotizacion.unitPrice = entry.UnitPrice;
                    nuevaCotizacion.tipoCobertura = entry.Product2.Tipo_de_Cobertura__c;
                    nuevaCotizacion.productCode = entry.ProductCode;
                    result.cotizaciones.add(nuevaCotizacion);
                }
            }
            
            //todo esto no es asi, corregir
            if(clienteFromParam.es_empleador == null){
                clienteFromParam.es_empleador = true;
                result.cliente = clienteFromParam;
            }
            
            // todo: es empleador tiene que venir el campo en true o false.
            system.debug('es empleador?: ' + clienteFromParam.es_empleador);
            if(clienteFromParam.es_empleador != null && clienteFromParam.es_empleador){
                for(PricebookEntry entry:[
                    SELECT Id, Name, Pricebook2Id, ProductCode,
                    Product2Id, Product2.Name, Product2.Tipo_de_Cobertura__c, 
                    Product2.Account__r.Name, UnitPrice, IsActive, Product2.Suma_Asegurada_Individual__c,
                    Product2.Cobertura_Adicional__c, Product2.Total_Asegurados__c, Product2.Suma_Asegurada_Total__c
                    FROM PriceBookEntry
                    WHERE Product2.isActive = true
                    AND Product2.RecordType.DeveloperName = 'Vida'
                    ORDER BY Product2.Account__r.Name, Product2.Tipo_de_Cobertura__c
                ]){
                    Cotizacion nuevaCotizacion = new Cotizacion();
                    nuevaCotizacion.aseguradora = entry.Product2.Account__r.Name;
                    nuevaCotizacion.unitPrice = entry.UnitPrice;
                    nuevaCotizacion.productCode = entry.ProductCode;
                    nuevaCotizacion.sumaAseguradaIndividual = entry.Product2.Suma_Asegurada_Individual__c;
                    nuevaCotizacion.sumaAseguradaTotal = entry.Product2.Suma_Asegurada_Total__c;
                    nuevaCotizacion.totalAsegurados = entry.Product2.Total_Asegurados__c;
                    nuevaCotizacion.coberturaAdicional = entry.Product2.Cobertura_Adicional__c;
                    nuevaCotizacion.tipoCobertura = entry.Product2.Tipo_de_Cobertura__c;
                    result.cotizaciones_vida.add(nuevaCotizacion);
                }
            }
            
            if(result.cotizaciones.isEmpty()){
                result.hasError = true;
                result.errors.add('Error al obtener cotizaciones. Contacte a su administrador de Salesforce.');
            }
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }
*/

}