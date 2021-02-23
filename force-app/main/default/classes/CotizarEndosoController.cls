public class CotizarEndosoController {
    //comentado por errores de compilacion al deployar a uat
    /*
    @AuraEnabled
    public static Wrapper doInit(Id recordId){
        system.debug(recordId);
        Wrapper result = new Wrapper();
        
        try{
            
            Opportunity opp = [
                SELECT ID, accountId, tipo_de_cobertura__c, 
                Ajuste_Automatico__c, Ramo__c, Medio_de_Pago__c, 
                Numero_de_Tarjeta_de_Credito__c, Nombre_de_Tarjeta_de_Credito__c
                FROM Opportunity
                WHERE Id = :recordId
            ];
            
            CotizadorController.Cotizacion cotizacion = new CotizadorController.Cotizacion();
            cotizacion.medioDePago = opp.Medio_de_Pago__c;
            
            if( ! 'EFECTIVO'.equalsIgnoreCase(opp.Medio_de_Pago__c) && opp.Numero_de_Tarjeta_de_Credito__c != null ){
                cotizacion.numeroMedioDePago = Decimal.valueOf(opp.Numero_de_Tarjeta_de_Credito__c); //TODO CAMBIAR EL TIPO DE CAMPO A DECIMAL EN EL OBJETO
                cotizacion.nombreMedioDePago = opp.Nombre_de_Tarjeta_de_Credito__c;
            }
            
            Account client = [
                SELECT ID, FirstName, Numero_de_Documento__c, 
                lastName, Codigo_Postal__c
                FROM Account
                WHERE Id = :opp.AccountId
            ];
            CotizadorController.Cliente cliente = new CotizadorController.Cliente();
            cliente.nombre = client.FirstName;
            cliente.apellido = client.LastName;
            cliente.Numero_de_Documento = client.Numero_de_Documento__c;
            cliente.Codigo_Postal = Integer.valueOf(client.Codigo_Postal__c);
            
            Quote presupuesto = [
                SELECT ID
                FROM Quote
                WHERE OpportunityId = :recordId
            ];
            
            CotizadorController.Auto auto = new CotizadorController.Auto();
            
            List<QuoteLineItem> qlis = [
                SELECT Id, Aseguradora__c, Marca__c, Modelo__c, Anio__c,
                Version__c, Uso_Comercial__c, X0KM__c, Rastreador__c, GNC__c,
                Suma_Asegurada_GNC__c, Accesorio__c, Suma_Asegurada_Accesorio__c,
                Tipo_de_Accesorio__c, Numero_de_Chasis__c, Numero_de_Motor__c, Patente__c,
                Numero_Adherente__c, Apellido_y_Nombres__c, Fecha_de_Nacimiento__c,
                Fecha_de_Alta__c, Grupo_Adherente__c, Tipo_y_Numero_de_Documento__c 
                FROM QuoteLineItem
                WHERE QuoteId = :presupuesto.Id
            ];
            
            if('Automotor'.equalsIgnoreCase(opp.Ramo__c)){
                
                QuoteLineItem qli = qlis[0];
                
                auto.marca = qli.marca__c;
                auto.modelo = qli.Modelo__c;
                auto.anio = qli.Anio__c;
                auto.version = qli.Version__c;
                auto.uso = qli.Uso_Comercial__c;
                auto.km = qli.X0KM__c;
                auto.rastreador = qli.Rastreador__c;
                auto.gnc = qli.GNC__c;
                if(auto.gnc){
                    auto.sumaAseguradaGNC = qli.Suma_Asegurada_GNC__c;
                }
                auto.accesorio = qli.Accesorio__c;
                if(auto.accesorio){
                    auto.tipoAccesorio = qli.Tipo_de_Accesorio__c;
                    auto.sumaAseguradaAccesorio = qli.Suma_Asegurada_Accesorio__c;
                }
                auto.tipoDeCobertura = opp.Tipo_de_Cobertura__c;
                auto.ajuste = opp.Ajuste_Automatico__c;
                auto.patente = qli.Patente__c;
                auto.nroChasis = Integer.valueOf(qli.Numero_de_Chasis__c);
                auto.nroMotor = Integer.valueOf(qli.Numero_de_Motor__c);
                
                result.auto = auto;
            }else if('Vida'.equalsIgnoreCase(opp.Ramo__c)){
                
                List<ItemNomina> nomina = new List<ItemNomina>();
                
                for(QuoteLineItem qli : qlis){
                    ItemNomina item = new ItemNomina();    
                    item.nroAdherente = qli.Numero_Adherente__c;
                    item.apellidoYNombre = qli.Apellido_y_Nombres__c;
                    item.tipoYNumeroDocumento = qli.Tipo_y_Numero_de_Documento__c;
                    item.fechaNacimiento = qli.Fecha_de_Nacimiento__c;
                    item.fechaAlta = qli.Fecha_de_Alta__c;
                    item.grupoAdherente = qli.Grupo_Adherente__c;
                    
                    nomina.add(item);
                }
                
                result.nomina = nomina;
            }
            
            
            result.cliente = cliente;
            result.ramo = opp.Ramo__c;
            result.cotizacion = cotizacion;
            
        }catch(Exception e){
            system.debug(e.getMessage());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }
    
    //WRAPPERS
    public class Wrapper{
        public Wrapper(){
            this.ramo = '';
            this.hasError = false;
            this.errors = new List<String>();
        }
        
        @AuraEnabled
        public Boolean hasError {get;set;}
        
        @AuraEnabled
        public List<String> errors {get;set;}
        
        @AuraEnabled
        public String ramo {get;set;}
        
        @AuraEnabled
        public CotizadorController.Cliente cliente {get;set;}
        
        @AuraEnabled
        public CotizadorController.Auto auto {get;set;}
        
        @AuraEnabled
        public CotizadorController.Cotizacion cotizacion {get;set;}
        
        @AuraEnabled
        public List<ItemNomina> nomina {get;set;}
    }
    
    public Class ItemNomina{
        
        public ItemNomina(){}
        
        @AuraEnabled
        public Decimal nroAdherente {get;set;}
        
        @AuraEnabled
        public String apellidoYNombre {get;set;}
        
        @AuraEnabled
        public String tipoYNumeroDocumento {get;set;}
        
        @AuraEnabled
        public Date fechaNacimiento {get;set;}
        
        @AuraEnabled
        public Date fechaAlta {get;set;}
        
        @AuraEnabled
        public String grupoAdherente {get;set;}
        
    }
    */
}