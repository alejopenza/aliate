public class NuevoEndosoController {
    
    @AuraEnabled
    public static Wrapper doInit(Id assetId){
        system.debug('doInit: ' + assetId);
        Wrapper result = new Wrapper();
        
        try{
            Asset asset = [
                SELECT ID, Name, AccountId, Product2Id, Medio_De_Pago__c, Numero_de_Tarjeta_de_Credito__c, 
                Nombre_de_Tarjeta_de_Credito__c, Medio_De_Pago_Numero__c, Tipo_de_Cobertura__c, Ajuste_automatico__c,
                Ramo__c
                FROM Asset
                WHERE Id = :assetId
            ];
            
            system.debug(asset.Ramo__c);
            
            //Opp
            Opportunity opp = new Opportunity();
            opp.Ajuste_Automatico__c = asset.Ajuste_automatico__c;
            opp.Medio_de_Pago__c = asset.Medio_de_Pago__c;
            opp.Numero_de_Tarjeta_de_Credito__c= asset.Numero_de_Tarjeta_de_Credito__c;
            opp.Nombre_de_Tarjeta_de_Credito__c= asset.Nombre_de_Tarjeta_de_Credito__c;
            opp.tipo_de_cobertura__c = asset.Tipo_de_Cobertura__c;
            opp.Name = 'Endoso ' + asset.Name;
            opp.AccountId = asset.AccountId;
            opp.StageName = 'Proposal';
            opp.Ramo__c = asset.Ramo__c;
            opp.LeadSource = 'Partner';
            opp.CloseDate = system.today().addDays(30);
            opp.RecordTypeId = [
                SELECT ID
                FROM RecordType
                WHERE DeveloperName = 'Endoso'
                AND SobjectType = 'Opportunity'
            ].Id;
            system.debug(opp.Ramo__c);
            database.insert(opp);
            
            //Asset
            asset.Oportunidad__c = opp.Id;
            database.update(asset);
            
            //PRICEBOOK
            PriceBookEntry pbe = [
                SELECT Id, UnitPrice, PriceBook2Id, product2.name
                FROM PricebookEntry
                WHERE Product2Id = :asset.Product2Id
            ];
            
            //QUOTE
            Quote presupuesto = new Quote();
            presupuesto.Name = pbe.product2.name;
            presupuesto.OpportunityId = opp.Id;
            presupuesto.Status = 'Presented';
            presupuesto.Pricebook2Id = pbe.PriceBook2Id;
            database.insert(presupuesto);
            
            //QLI
            List<QuoteLineItem> qlis = new List<QuoteLineItem>();
            List<Bien_Asegurado__c> bienesAsegurados = [
                SELECT Asset__c, Marca__c, Modelo__c, Anio__c, Version__c, Uso_Comercial__c, X0KM__c, 
                Rastreador__c, GNC__c, Suma_Asegurada_GNC__c, Accesorio__c, Tipo_de_Accesorio__c, 
                Suma_Asegurada_Accesorio__c, Numero_de_Motor__c, Numero_de_Chasis__c, Product__c,
                Patente__c, Numero_Adherente__c, Apellido_y_Nombres__c,  Fecha_de_Alta__c, Fecha_de_Nacimiento__c,
                Grupo_Adherente__c, Tipo_y_Numero_de_Documento__c
                FROM Bien_Asegurado__c
                WHERE Asset__c = :assetId
            ];
            
            if(asset.Ramo__c == 'Automotor'){
                Bien_Asegurado__c auto = bienesAsegurados[0];
                
                QuoteLineItem qli = new QuoteLineItem();
                qli.QuoteId = presupuesto.Id;
                qli.Quantity = 1;
                qli.UnitPrice = pbe.UnitPrice;
                qli.PricebookEntryId = pbe.id;
                
                qli.Marca__c = auto.Marca__c;
                qli.Modelo__c = auto.modelo__c;
                qli.Anio__c = auto.anio__c;
                qli.Version__c = auto.version__c;
                qli.Uso_Comercial__c = auto.Uso_Comercial__c;
                qli.X0KM__c = auto.X0KM__c;
                qli.Rastreador__c = auto.rastreador__c;
                qli.GNC__c = auto.gnc__c;
                if(qli.GNC__c){
                    qli.Suma_Asegurada_GNC__c = auto.Suma_Asegurada_GNC__c;
                }
                qli.Accesorio__c = auto.accesorio__c;
                if(qli.Accesorio__c){
                    qli.Tipo_de_Accesorio__c = auto.Tipo_de_Accesorio__c;
                    qli.Suma_Asegurada_Accesorio__c = auto.Suma_Asegurada_Accesorio__c;
                }
                qli.Numero_de_Chasis__c = String.valueOf(auto.Numero_de_Chasis__c);
                qli.Numero_de_Motor__c = String.valueOf(auto.Numero_de_Motor__c);
                qli.Patente__c = auto.Patente__c;
                
                qlis.add(qli);
            }else if(asset.Ramo__c == 'Vida'){
                for(Bien_Asegurado__c empleado : bienesAsegurados){
                    QuoteLineItem qli = new QuoteLineItem();
                    qli.QuoteId = presupuesto.Id;
                    qli.Quantity = 1;
                    qli.UnitPrice = pbe.UnitPrice;
                    qli.PricebookEntryId = pbe.id;
                    
                    qli.Numero_Adherente__c = empleado.Numero_Adherente__c;
                    qli.Apellido_y_Nombres__c = empleado.Apellido_y_Nombres__c;
                    qli.Fecha_de_Alta__c = empleado.Fecha_de_Alta__c;
                    qli.Fecha_de_Nacimiento__c = empleado.Fecha_de_Nacimiento__c;
                    qli.Grupo_Adherente__c = empleado.Grupo_Adherente__c;
                    qli.Tipo_y_Numero_de_Documento__c = empleado.Tipo_y_Numero_de_Documento__c;
                    
                    qlis.add(qli);
                }
            }
            
            database.insert(qlis);
            
            result.oppId = opp.Id;            
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
        }
        
        @AuraEnabled
        public boolean hasError {get;set;}
        
        @AuraEnabled
        public List<String> errors {get;set;}
        
        @AuraEnabled
        public Id oppId {get;set;}
        
    }
}