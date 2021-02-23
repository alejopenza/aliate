public with sharing class CotizadorDatosDeVidaController {
    //comentado por errores de compilacion al deployar a uat
    /*
    @AuraEnabled
    public static Wrapper initLauncher(Id recordId){
        system.debug('initLauncher: ' + recordId);
        Wrapper result = new Wrapper();
        
        try{
            
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }
    
    @AuraEnabled
    public static Wrapper doGuardar(Id recordId, String nuevos){
        system.debug('doGuardar: ' + recordId + ' ' + nuevos);
        Wrapper result = new Wrapper();
        
        try{
            Quote presupuesto = [
                SELECT Id, Opportunity.Name
                FROM Quote
                WHERE OpportunityId = :recordId
            ];
            
            String pbeName = presupuesto.Opportunity.Name.remove('Endoso ');
            
            PriceBookEntry pbe = [
                SELECT ID, Product2Id, UnitPrice
                FROM PriceBookEntry
                WHERE Name = :pbeName
            ];
            
            List<CotizadorController.NominaItem> nuevosEmpleados = (List<CotizadorController.NominaItem>) JSON.deserialize(nuevos, List<CotizadorController.NominaItem>.class);
            system.debug('nuevosEmpleados: ' + nuevosEmpleados);
            
            List<QuoteLineItem> qlis = new List<QuoteLineItem>();
            for(CotizadorController.NominaItem nuevoEmpleado : nuevosEmpleados){
                QuoteLineItem qli = new QuoteLineItem();
                qli.PricebookEntryId = pbe.Id; 
                qli.Product2Id = pbe.Product2Id;
                qli.Quantity = 1;
                qli.QuoteId = presupuesto.Id;
                qli.UnitPrice = pbe.UnitPrice;
                
                qli.Apellido_y_Nombres__c = nuevoEmpleado.apellidoYNombre;
                List<String> dates = nuevoEmpleado.fechaAlta.split('-');
                qli.Fecha_de_Alta__c = Date.newInstance(Integer.valueOf(dates[0]), Integer.valueOf(dates[1]), Integer.valueOf(dates[2]));
                
                dates = nuevoEmpleado.fechaNacimiento.split('-');
                qli.Fecha_de_Nacimiento__c = Date.newInstance(Integer.valueOf(dates[0]), Integer.valueOf(dates[1]), Integer.valueOf(dates[2]));
                
                qli.Numero_Adherente__c = nuevoEmpleado.nroAdherente;
                qli.Tipo_y_Numero_de_Documento__c = nuevoEmpleado.tipoYNumeroDocumento;
                
                qli.Grupo_Adherente__c = nuevoEmpleado.grupoAdherente;
                
                qlis.add(qli);
            }
            
            database.insert(qlis);
            
            //OBTENER NUEVO LISTADO DE EMPLEADOS
            for(QuoteLineItem item : [
                SELECT ID, Numero_Adherente__c, Apellido_y_Nombres__c,
                Fecha_de_Nacimiento__c, Fecha_de_Alta__c, Grupo_Adherente__c,
                Tipo_y_Numero_de_Documento__c
                FROM QuoteLineItem
                WHERE QuoteId = :presupuesto.Id
            ]){
                CotizadorController.NominaItem itemNomina = new CotizadorController.NominaItem();
                itemNomina.nroAdherente = Integer.valueOf(item.Numero_Adherente__c);
                itemNomina.apellidoYNombre = item.Apellido_y_Nombres__c;
                itemNomina.fechaNacimiento = item.Fecha_de_Nacimiento__c.format();
                itemNomina.fechaAlta = item.Fecha_de_Alta__c.format();
                itemNomina.grupoAdherente = item.Grupo_Adherente__c;
                itemNomina.tipoYNumeroDocumento = item.Tipo_y_Numero_de_Documento__c;
                result.nomina.add(itemNomina);
            }
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }
    
    @AuraEnabled
    public static Wrapper doRemover(Id recordId, String lines){
        system.debug('doRemover: ' + recordId + ' - ' + lines);
        Wrapper result = new Wrapper();
        
        try{
            List<CotizadorController.NominaItem> itemsNomina = (List<CotizadorController.NominaItem>) JSON.deserialize(lines, List<CotizadorController.NominaItem>.class);
            
            Quote presupuesto = [
                SELECT ID
                FROM Quote
                WHERE OpportunityId = :recordId
            ];
            
            List<QuoteLineItem> toRemove = new List<QuoteLineItem>();
            for(QuoteLineItem item : [
                SELECT ID, Numero_Adherente__c 
                FROM QuoteLineItem
                WHERE QuoteId = :presupuesto.Id
            ]){
                boolean hasFound = false;
                for(CotizadorController.NominaItem itemNomina : itemsNomina){
                    if(item.Numero_Adherente__c == itemNomina.nroAdherente){
                        hasFound = true;
                        break;
                    }
                }
                
                if(hasFound){
                    toRemove.add(item);
                }
            }
            
            database.delete(toRemove);
            
            //OBTENER NUEVO LISTADO DE EMPLEADOS
            for(QuoteLineItem item : [
                SELECT ID, Numero_Adherente__c, Apellido_y_Nombres__c,
                Fecha_de_Nacimiento__c, Fecha_de_Alta__c, Grupo_Adherente__c,
                Tipo_y_Numero_de_Documento__c
                FROM QuoteLineItem
                WHERE QuoteId = :presupuesto.Id
            ]){
                CotizadorController.NominaItem itemNomina = new CotizadorController.NominaItem();
                itemNomina.nroAdherente = Integer.valueOf(item.Numero_Adherente__c);
                itemNomina.apellidoYNombre = item.Apellido_y_Nombres__c;
                itemNomina.fechaNacimiento = item.Fecha_de_Nacimiento__c.format();
                itemNomina.fechaAlta = item.Fecha_de_Alta__c.format();
                itemNomina.grupoAdherente = item.Grupo_Adherente__c;
                itemNomina.tipoYNumeroDocumento = item.Tipo_y_Numero_de_Documento__c;
                result.nomina.add(itemNomina);
            }
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }
    
    //WRAPPERS
    public class Wrapper{
        public Wrapper(){
            this.hasError = false;
            this.errors = new List<String>();
            this.nomina = new List<CotizadorCOntroller.NominaItem>();
        }
        
        @AuraEnabled
        public boolean hasError {get;set;}
        
        @AuraEnabled
        public List<String> errors {get;set;}
        
        @AuraEnabled
        public List<CotizadorController.NominaItem> nomina {get;set;}
        
    }
    */
}