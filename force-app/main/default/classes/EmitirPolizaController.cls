public without sharing class EmitirPolizaController {

    /**Realiza los procesos necesarios para levantar el componente de emision de poliza correctamente,*/
    @AuraEnabled
    public static CotizadorController.Wrapper initEmitirPolizaLauncher(Id recordId){
        system.debug('initEmitirPolizaLauncher: ' + recordId);
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();

        //DEMO
        try{
            Opportunity opp = [
                SELECT id, StageName
                FROM Opportunity
                WHERE id = :recordId
            ];

            result.cotizacion = opp;

            result.presupuestos = [
                SELECT ID, Status, OpportunityId,
                (
                    SELECT Id, product2.Name, Product2Id, Product2.RecordType.DeveloperName
                    FROM QuoteLineItems
                )
                FROM Quote
                WHERE OpportunityId = :recordId
            ];
        }catch(Exception e){
            system.debug(e.getMessage());

            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());

            ErrorHelper.LogError(e);
        }

        return result;
    }

    /** Emite una poliza  */
    @AuraEnabled
    public static CotizadorController.Wrapper emitirPoliza(
            Id recordId,
            List<Quote> presupuestos,
            String medioDePago,
            String origenDePago,
            String numeroTarjetaCredito,
            String nombreTarjetaCredito ,
            String CBU,
            Integer nroMotor,
            Integer nroChasis,
            Integer mesVencimientoTarjetaCredito,
            Integer anioVencimientoTarjetaCredito,
        	String patente
        ){

        system.debug('emitirPoliza: ' + recordId + ' ' + presupuestos);
        CotizadorController.Wrapper result = new CotizadorController.Wrapper();
        
        Savepoint sp = Database.setSavepoint();

        //DEMO
        try{
            
            //REMOVE QLIS
            List<Id> quoteIds = new List<Id>();
            for(Quote presupuesto : presupuestos){
                quoteIds.add(presupuesto.Id);
            }
            
            Id quoteId;
            List<Id> toDelete = new List<Id>();
            for(QuoteLineItem item : [
                SELECT ID, Product2Id, QuoteId
                FROM QuoteLineItem
                WHERE QuoteId IN :quoteIds
            ]){
                if(item.Product2Id != recordId){
                    toDelete.add(item.QuoteId);
                }else{
                    quoteId = item.QuoteId;
                }
            }

            List<Quote> quotesToDelete = [
                SELECT ID
                FROM Quote
                WHERE ID IN :toDelete
            ];
            database.delete(quotesToDelete);
            
            Quote presupuestoSeleccionado = [
                SELECT ID, Status, OpportunityId, 
                Opportunity.RecordType.DeveloperName, RecordType.Name
                FROM Quote
                WHERE ID = :quoteId
            ];
            
            //QUOTE
            presupuestoSeleccionado.Status = 'Approved';
            database.update(presupuestoSeleccionado);
            
            //QLI
            List<QuoteLineItem> qlis = [
                SELECT ID, TotalPrice,
                Marca__c, Modelo__c, Version__c, Anio__c,
                X0KM__c, Uso_Comercial__c, Rastreador__c,
                GNC__c, Suma_Asegurada_GNC__c, Accesorio__c,
                Tipo_de_Accesorio__c, Suma_Asegurada_Accesorio__c,
                Product2.Tipo_De_Cobertura__c, Product2Id,
                Product2.Recordtype.DeveloperName, Product2.Name,
                Numero_Adherente__c, Apellido_y_Nombres__c, Tipo_y_Numero_de_Documento__c, 
                Fecha_de_Nacimiento__c, Fecha_de_Alta__c, Grupo_Adherente__c
                FROM QuoteLineItem
                WHERE QuoteId = :presupuestoSeleccionado.Id
            ];
            
            //OPP
            Opportunity cotizacion = [
                SELECT ID, StageName, ajuste_automatico__c,Medio_de_Pago__c,
                Numero_de_Tarjeta_de_Credito__c,Nombre_de_Tarjeta_de_Credito__c
                FROM Opportunity
                WHERE Id = :presupuestoSeleccionado.OpportunityId
            ];
            cotizacion.StageName = 'Closed Won';
            database.update(cotizacion);
            
            //OLI
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = presupuestoSeleccionado.OpportunityId;
            oli.Product2Id = recordId;
            oli.Quantity = 1;
            oli.TotalPrice = qlis[0].TotalPrice; //todo ver esto ya que para vida el total price q onda?
            database.insert(oli);
            
            //ASSET
            Asset newAsset = new Asset();
            newAsset.AccountId = [
                SELECT AccountId
                FROM Opportunity
                WHERE Id = :presupuestoSeleccionado.OpportunityId
            ].AccountId;
            newAsset.Name = qlis[0].product2.Name;
            newAsset.Tipo_de_Cobertura__c = qlis[0].Product2.Tipo_De_Cobertura__c;
            newAsset.Oportunidad__c = presupuestoSeleccionado.OpportunityId;
            newAsset.ajuste_automatico__c = cotizacion.ajuste_automatico__c;
            newAsset.product2Id = oli.product2Id;
            newAsset.Medio_de_Pago__c = medioDePago;
            newAsset.Status = 'En Progreso';

            switch on newAsset.Medio_de_Pago__c.toUpperCase() {
                when 'DEBITO AUTOMATICO' {
                    newAsset.Numero_de_Tarjeta_de_Credito__c = numeroTarjetaCredito;
                }
                when 'TARJETA DE CREDITO' {
                    newAsset.Origen_de_Pago__c = origenDePago;
                    newAsset.Nombre_de_Tarjeta_de_Credito__c = nombreTarjetaCredito;
                    newAsset.Numero_de_Tarjeta_de_Credito__c = numeroTarjetaCredito;
                    newAsset.Fecha_de_Vencimiento__c = String.format('{0}/{1}', new List<Integer>{mesVencimientoTarjetaCredito, anioVencimientoTarjetaCredito});
                }
                when else { }
            }

            // TODO se usa provisoriamente  esta forma de diferenciarlos, habria que hacerlo mejor.
            switch on qlis[0].Product2.RecordType.DeveloperName.toUpperCase() {
                when 'VIDA' {
                    newAsset.Ramo__c = 'Vida';
                }
                when 'VEHICULO' {
                    newAsset.Ramo__c = 'Automotor';
                }
                when else { }
            }
            
            database.insert(newAsset);
            
            //BIENES ASEGURADOS
            List<Bien_Asegurado__c> bienesAsegurados = new List<Bien_Asegurado__c>();
            if(qlis[0].Product2.RecordType.DeveloperName == 'Vehiculo'){
                
                Bien_Asegurado__c bienAsegurado = new Bien_Asegurado__c();
                bienAsegurado.RecordTypeId = [
                    SELECT ID
                    FROM RecordType
                    WHERE DeveloperName = 'Automotor'
                    AND SobjectType = 'Bien_Asegurado__c'
                ].Id;
                bienAsegurado.Asset__c = newAsset.Id;

                bienAsegurado.Marca__c = qlis[0].Marca__c;
                bienAsegurado.Modelo__c = qlis[0].Modelo__c;
                bienAsegurado.Anio__c = qlis[0].Anio__c;
                bienAsegurado.Version__c = qlis[0].Version__c;
                bienAsegurado.Uso_Comercial__c = qlis[0].Uso_Comercial__c;
                bienAsegurado.X0KM__c = qlis[0].X0KM__c;
                bienAsegurado.Rastreador__c = qlis[0].Rastreador__c;
                bienAsegurado.GNC__c = qlis[0].GNC__c;
                if(bienAsegurado.GNC__c){
                    bienAsegurado.Suma_Asegurada_GNC__c = qlis[0].Suma_Asegurada_GNC__c;
                }
                bienAsegurado.Accesorio__c = qlis[0].Accesorio__c;
                if(bienAsegurado.Accesorio__c){
                    bienAsegurado.Tipo_de_Accesorio__c = qlis[0].Tipo_de_Accesorio__c;
                    bienAsegurado.Suma_Asegurada_Accesorio__c = qlis[0].Suma_Asegurada_Accesorio__c;
                }
                bienAsegurado.Numero_de_Chasis__c = nroChasis;
                bienAsegurado.Numero_de_Motor__c = nroMotor;
                bienAsegurado.Product__c = qlis[0].Product2Id;
                bienAsegurado.Patente__c = patente;
                
                bienesAsegurados.add(bienAsegurado);
                
            }else if(qlis[0].Product2.RecordType.DeveloperName == 'Vida'){
                Id rtId = [
                    SELECT ID
                    FROM RecordType
                    WHERE DeveloperName = 'Vida'
                    AND SobjectType = 'Bien_Asegurado__c'
                ].Id;
            
                for(QuoteLineItem qli : qlis){

                    Bien_Asegurado__c bienAsegurado = new Bien_Asegurado__c();
                    bienAsegurado.RecordTypeId = rtId;
                    bienAsegurado.Asset__c = newAsset.Id;
                    bienAsegurado.Product__c = qli.Product2Id;

                    bienAsegurado.Numero_Adherente__c = qli.Numero_Adherente__c;
                    bienAsegurado.Apellido_y_Nombres__c = qli.Apellido_y_Nombres__c;
                    bienAsegurado.Tipo_y_Numero_de_Documento__c = qli.Tipo_y_Numero_de_Documento__c;
                    bienAsegurado.Fecha_de_Nacimiento__c = qli.Fecha_de_Nacimiento__c;
                    bienAsegurado.Fecha_de_Alta__c = qli.Fecha_de_Alta__c;
                    bienAsegurado.Grupo_Adherente__c = qli.Grupo_Adherente__c;

                    bienesAsegurados.add(bienAsegurado);
                }

            }

            database.insert(bienesAsegurados);
            result.returnId = newAsset.Id;

            //todo envio del pdf
            
        }catch(Exception e){
            Database.rollback(sp);
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }
}