public class EnviarEndosoController {
    
    @AuraEnabled
    public static Wrapper doInit(Id oppId){
        system.debug('doInit: ' + oppId);
        Wrapper result = new Wrapper();
        
        try{
            //TODO callout
            
            Opportunity opp = [
                SELECT ID, AccountId, StageName, Ramo__c, 
                Ajuste_Automatico__c, Tipo_de_Cobertura__c,
                Medio_de_Pago__c
                FROM Opportunity
                WHERE Id = :oppId
            ];
            
            Asset poliza = [
                SELECT ID, Name
                FROM Asset
                WHERE Oportunidad__c = :oppId
                AND RecordType.DeveloperName = 'Poliza'
            ];
            
            Id endosoId = [
                SELECT ID
                FROM Recordtype
                WHERE DeveloperName = 'Endoso'
                AND SobjectType = 'Asset'
            ].Id;
            
            Asset endoso = new Asset();
            endoso.Name = 'ENDOSO ' + poliza.Name;
            endoso.ParentId = poliza.Id;
            endoso.AccountId = opp.AccountId;
            endoso.RecordTypeId = endosoId;
            endoso.Ramo__c = opp.Ramo__c;
            endoso.Status = 'Enviada';
            endoso.Ajuste_Automatico__c = opp.Ajuste_Automatico__c;
            endoso.Tipo_de_Cobertura__c = opp.Tipo_de_Cobertura__c;
            endoso.Medio_de_Pago__c = opp.Medio_de_Pago__c;
            switch on endoso.Medio_de_Pago__c.toUpperCase() {
                when 'DEBITO AUTOMATICO' {
                    endoso.Numero_de_Tarjeta_de_Credito__c = opp.Numero_de_Tarjeta_de_Credito__c;
                }
                when 'TARJETA DE CREDITO' {
                    endoso.Nombre_de_Tarjeta_de_Credito__c = opp.Nombre_de_Tarjeta_de_Credito__c;
                    endoso.Numero_de_Tarjeta_de_Credito__c = opp.Numero_de_Tarjeta_de_Credito__c;
                }
                when else { }
            }
            endoso.Oportunidad__c = opp.Id;
            endoso.Product2Id = [
                SELECT Product2Id
                FROM PriceBookEntry
                WHERE Name = :poliza.Name
            ].Product2Id;
            database.insert(endoso);
            
            opp.StageName = 'Closed Won';
            database.update(opp);
            
            Id rtId = [
                SELECT ID
                FROM RecordType
                WHERE DeveloperName = :opp.Ramo__c
                AND SobjectType = 'Bien_Asegurado__c'
            ].Id;
            
            Quote presupuesto = [
                SELECT ID
                FROM Quote
                WHERE OpportunityId = :oppId
            ];
            
            List<Bien_Asegurado__c> bienesAsegurados = new List<Bien_Asegurado__c>();
            for(QuoteLineItem qli : [
                SELECT Marca__c, Modelo__c, Anio__c, Version__c, Uso_Comercial__c, X0KM__c, 
                Rastreador__c, GNC__c, Suma_Asegurada_GNC__c, Accesorio__c, Suma_Asegurada_Accesorio__c, 
                Tipo_de_Accesorio__c, Numero_de_Chasis__c, Numero_de_Motor__c, Patente__c, Numero_Adherente__c, 
                Apellido_y_Nombres__c, Tipo_y_Numero_de_Documento__c, Fecha_de_Nacimiento__c, Fecha_de_Alta__c, 
                Grupo_Adherente__c, Product2Id 
                FROM QuoteLineItem
                WHERE QuoteId = :presupuesto.Id
            ]){
                Bien_Asegurado__c bienAsegurado = new Bien_Asegurado__c();
                bienAsegurado.RecordTypeId = rtId;
                bienAsegurado.Asset__c = endoso.Id;
                bienAsegurado.Product__c = qli.Product2Id;
                if(opp.Ramo__c == 'Vida'){
                    bienAsegurado.Numero_Adherente__c = qli.Numero_Adherente__c;
                    bienAsegurado.Apellido_y_Nombres__c = qli.Apellido_y_Nombres__c;
                    bienAsegurado.Grupo_Adherente__c = qli.Grupo_Adherente__c;
                    bienAsegurado.Fecha_de_Alta__c = qli.Fecha_de_Alta__c;
                    bienAsegurado.Fecha_de_Nacimiento__c = qli.Fecha_de_Nacimiento__c;
                    bienAsegurado.Tipo_y_Numero_de_Documento__c = qli.Tipo_y_Numero_de_Documento__c;
                    
                }else if(opp.Ramo__c == 'Automotor'){
                    bienAsegurado.Patente__c = qli.Patente__c;
                    bienAsegurado.Numero_de_Chasis__c = Decimal.valueOf(qli.Numero_de_Chasis__c);
                    bienAsegurado.Numero_de_Motor__c = Decimal.valueOf(qli.Numero_de_Motor__c);
                    bienAsegurado.Anio__c = qli.Anio__c;
                    bienAsegurado.Marca__c = qli.Marca__c;
                    bienAsegurado.Modelo__c = qli.Modelo__c;
                    bienAsegurado.Version__c = qli.Version__c;
                    bienAsegurado.X0KM__c = qli.X0KM__c;
                    bienAsegurado.Uso_Comercial__c = qli.Uso_Comercial__c;
                    bienAsegurado.Rastreador__c = qli.Rastreador__c;
                    
                    bienAsegurado.Accesorio__c = qli.Accesorio__c;
                    if(bienAsegurado.Accesorio__c){
                        bienAsegurado.Tipo_de_Accesorio__c = qli.Tipo_de_Accesorio__c;
                        bienAsegurado.Suma_Asegurada_Accesorio__c = qli.Suma_Asegurada_Accesorio__c;
                    }
                    
                    bienAsegurado.GNC__c = qli.GNC__c;
                    if(bienAsegurado.GNC__c){
                        bienAsegurado.Suma_Asegurada_GNC__c = qli.Suma_Asegurada_GNC__c;
                    }
                }
                bienesAsegurados.add(bienAsegurado);
            }
            database.insert(bienesAsegurados);
            
            result.endosoId = endoso.Id;
            
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
        public Id endosoId {get;set;}
        
    }
}