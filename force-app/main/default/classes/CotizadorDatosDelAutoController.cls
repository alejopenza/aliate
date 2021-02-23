public with sharing class CotizadorDatosDelAutoController {
    public CotizadorDatosDelAutoController() {

    }

    @AuraEnabled
    public static CotizadorController.Wrapper doInit(){

        CotizadorController.Wrapper result = new CotizadorController.Wrapper();

        try{
            result.modulosCoberturas = [
                SELECT Nombre__c, Codigo__c
                FROM Modulo_Cobertura__mdt 
                WHERE Disponible__c = true
            ];

            result.modulosCoberturasSC = [
                SELECT Description__c, Code__c
                FROM AllValidProductOffering__c 
                WHERE Retired__c = false 
            ];

            result.periodosDeValidez = [
                SELECT Nombre__c, Codigo__c
                FROM Periodo_Validez__mdt 
            ];

            result.tiposDeAccesorios = [
                SELECT Nombre__c, Codigo__c
                FROM Tipo_Accesorio__mdt 
                WHERE Disponible__c = true
                ORDER BY Codigo__c ASC
            ];

            result.frecuenciaPagos = [
                SELECT Nombre__c, Codigo__c
                FROM Frecuencia_Pago__mdt
            ];

            InfoAutoAPI api = new InfoAutoAPI();
            InfoAutoAPI.Wrapper iaWrapper = api.getMarcas();
            result.marcasIA = iaWrapper.marcas;

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
    
        return result;
    }

    @AuraEnabled
    public static CotizadorController.Wrapper doGetModelos1(String codigoMarca){
        system.debug('doGetModelos(): ' + codigoMarca);

        CotizadorController.Wrapper result = new CotizadorController.Wrapper();

        try{

            InfoAutoAPI api = new InfoAutoAPI();
            InfoAutoAPI.Wrapper iaWrapper = api.getModelos(codigoMarca);
            result.modelosIA = iaWrapper.modelos;

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
    
        return result;
    }

    @AuraEnabled
    public static CotizadorController.Wrapper doGetVersiones(String marca, String modelo, String anio){
        system.debug('doGetVersiones()');

        CotizadorController.Wrapper result = new CotizadorController.Wrapper();

        try{

            InfoAutoAPI api = new InfoAutoAPI();
            InfoAutoAPI.Wrapper iaWrapper = api.getVersiones(marca, modelo, anio);
            result.versionesIA = iaWrapper.versiones;

        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
    
        return result;
    }
    
    
}