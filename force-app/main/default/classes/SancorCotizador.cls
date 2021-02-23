public with sharing class SancorCotizador {
    public SancorCotizador() {

    }

    public static CotizadorController.Wrapper doSancorCallout(CotizadorController.Wrapper result, CotizadorController.Auto auto, CotizadorController.Cliente cliente){
        system.debug('doSancorCallout(): ' + auto);
        
        //TOKEN
        SancorAutenticacionWebService wsSut = new SancorAutenticacionWebService();
        Boolean res = wsSut.getToken();
        system.debug('token res: ' + res + ' - ' + wsSut.accessToken);

        //REQUEST
        //MOCK
        //CotizadorAPIRequest request = doSancorCreateMockRequest(auto, cliente);
        
        //FINAL
        CotizadorAPIRequest request = doSancorCreateRequest(auto, cliente);
        
        //CALLOUT
        SancorCotizarVehiculoWebService ws = new SancorCotizarVehiculoWebService();

        Boolean connectionResult =
            ws.cotizarVehiculo(
                request,
                new Map<String,String>{
                    'TokenType' => wsSut.tokenType,
                    'User' => wsSut.user,
                    'Token' => wsSut.idToken
                },
                Enumerator.Producto.AUTO
            );
        system.debug('connectionResult: ' + connectionResult);

        if(connectionResult){
            CotizadorAPIResponse cotizacionWS = ws.serviceResponse.cotizacion;
            system.debug('cotizacionWS: ' + cotizacionWS);

            for(CotizadorAPIResponse.Plan plan : cotizacionWS.planes){
                system.debug('plan: ' + plan);
                CotizadorController.CotizacionSancor nuevaCotizacion = new CotizadorController.CotizacionSancor();
                nuevaCotizacion.aseguradora = 'SANCOR';
                nuevaCotizacion.descripcionCorta = plan.descripcionCorta;
                nuevaCotizacion.ivaMensual = plan.ivaMensual;
                nuevaCotizacion.ivaTotal = plan.ivaTotal;
                nuevaCotizacion.premioMensual = plan.premioMensual;
                nuevaCotizacion.premioTotal = plan.premioTotal;

                for(CotizadorAPIResponse.SumaAsegurada sumaAsegurada : plan.sumasAseguradas){
                    CotizadorController.CotizacionSancorSumaAsegurada nuevaSuma = new CotizadorController.CotizacionSancorSumaAsegurada();
                    nuevaSuma.capital = sumaAsegurada.capital;
                    nuevaSuma.descripcion = sumaAsegurada.descripcion;
                    nuevaSuma.detalleTipo = sumaAsegurada.detalleTipo;
                    nuevasuma.primaPuraMensual = sumaAsegurada.primaPuraMensual;
                    nuevasuma.primaPuraTotal = sumaAsegurada.primaPuraTotal;
                    nuevaCotizacion.sumasAseguradas.add(nuevaSuma);
                }

                result.cotizacionesSancor.add(nuevaCotizacion);
            }
        }else{
            result.hasError = true;
            if(ws.serviceResponse.faultString != null){
                result.errors.add(ws.serviceResponse.faultString);
            }else{
                result.errors.add('Error inesperado.');
            }
        }

        return result;
    }

    public static CotizadorAPIRequest doSancorCreateRequest(CotizadorController.Auto auto, CotizadorController.Cliente cliente){
        system.debug('doSancorCreateRequest() ');
        system.debug('Auto: ' + auto);
        system.debug('cliente: ' + cliente);

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        
        //Vehiculo
        CotizadorAPIRequest.Vehiculo vehiculo = new CotizadorAPIRequest.Vehiculo();
        vehiculo.codigo = '0' + auto.version; // se obtiene de la integracion con infoauto
        vehiculo.anio = auto.anio; // 2013;
        if(auto.sumaAsegurada != null){
            vehiculo.valor = auto.sumaAsegurada; // 0;
        }else{
            vehiculo.valor = 0;
        }
        vehiculo.uso = auto.uso ? 4 : 2; // 2;
        vehiculo.tieneGNC = auto.gnc; // false;
        if(auto.sumaAseguradaGNC != null){
            vehiculo.valorEquipoGNC = auto.sumaAseguradaGNC;
        }else{
            vehiculo.valorEquipoGNC = 0;
        }
        vehiculo.poseeRuedaDeAuxilio = false;
        vehiculo.es0KM = auto.km; // false;
        request.vehiculo = vehiculo;

        if(auto.tipoAccesorio != null){
            request.bienAsegurado = Integer.valueOf(auto.tipoAccesorio); // 0;
        }else{
            request.bienAsegurado = 0;
        }
        
        //Cliente
        request.codigoPostal = cliente.Codigo_Postal; //2300;
        //request.numeroDeDocumento = Integer.valueOf(cliente.Numero_de_Documento); // 12599862;
        request.condicionAnteIVA = cliente.condicionAnteIVA; // 4;
        switch on cliente.tipoDeDocumento { // 'D';
            when 'DNI'{
                request.tipoDeDocumento = 'D';
                request.numeroDeDocumento = Integer.valueOf(cliente.Numero_de_Documento); // 12599862;
            }

            when 'CUIT'{
                request.tipoDeDocumento = 'J';
                request.numeroDeDocumentoDouble = Double.valueOf(cliente.Numero_de_Documento); // 12599862;
            }

            when 'LC'{
                request.tipoDeDocumento = 'C';
            }

            when 'LE'{
                request.tipoDeDocumento = 'L';
            }

            when 'CI'{
                request.tipoDeDocumento = 'I';
            }

            when else{ }
        }
        if(cliente.es_empleador != null){
            request.personaJuridica = cliente.es_empleador; // false;
        }else{
            request.personaJuridica = false;
        }
        
        //Ciudad
        request.ciudadId = 0; //1157; // victor paso parametria excel. deberiamos tener parametrizado en un objeto debido a la cantidad de registros todo eso en sfdc para poder obtener  el valor del id ciudad en base al codigo postal que devuevle peype deberia estar en la solapa de datos de cliente preview y no olvidar tener un trigger para cuando a mano se modifica el CP deberian ser picklists de provincia y localidad
        
        //Coberturas
        List<Integer> codigos = new List<Integer>();
        for(String codigo : auto.codigosDeModuloDeCoberturas){
            codigos.add(Integer.valueOf(codigo));
        }
        request.codigosDeModuloDeCoberturas = codigos; // new List<Integer>{5};
        request.descuentos = new List<CotizadorAPIRequest.Descuento>{ };
        
        //Cotizacion
        request.fechaEfectiva = DateTime.newInstance(
            Date.today().year(),
            Date.today().month(),
            Date.today().day(),
            0,
            0,
            0
        );// DateTime.newInstance(2018,10,29,0,0,0);
        request.periodoDeValidez = auto.periodoDeValidez; //1;
        request.frecuenciaDePago = auto.frecuenciaPago; //5;
        if(request.frecuenciaDePago == 5 || request.periodoDeValidez == 1) {
            request.cuotas = 0;
        }else{
            request.cuotas = auto.cuota; //0;
        }
        request.numeroProductor = 212505; // va a ser un valor en la account (partner account) que sea del broker
        request.numeroOrganizacion = 150766; //150766; // va a ser el numero de organizacion de aliate
        
        //Scoring
        CotizadorAPIRequest.Scoring scoring0 = new CotizadorAPIRequest.Scoring();
        scoring0.tipoId = 3;
        scoring0.opcionId = 1;
        /// Guarda Garage: id 3; 1 - SI  2 - NO 

        CotizadorAPIRequest.Scoring scoring1 = new CotizadorAPIRequest.Scoring();
        scoring1.tipoId = 7;
        scoring1.opcionId = 2;
        // La Edad de los conductores es Menor a 25 años: 7; 1 - SI  2 - NO

        CotizadorAPIRequest.Scoring scoring3 = new CotizadorAPIRequest.Scoring();
        scoring3.tipoId = 8;
        scoring3.opcionId = 1;
        // kms Anuales Recorridos: 8; 1 - Hasta 25.000 2 - Mayor a 25.000
        
        //request.scoring = new List<CotizadorAPIRequest.Scoring>{ scoring0, scoring1, scoring3 };
        request.scoring = new List<CotizadorAPIRequest.Scoring>{ }; //viaja la lista vacia porque no es necesario

        return request;
    }

    public static CotizadorAPIRequest doSancorCreateMockRequest(CotizadorController.Auto auto, CotizadorController.Cliente cliente){
        system.debug('doSancorCreateRequest() ');

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        
        //Vehiculo
        CotizadorAPIRequest.Vehiculo vehiculo = new CotizadorAPIRequest.Vehiculo();
        vehiculo.codigo = '0180517'; // se obtiene de la integracion con infoauto
        vehiculo.anio = 2013;
        vehiculo.valor = 0;
        vehiculo.uso = 2;
        vehiculo.tieneGNC = false;
        vehiculo.valorEquipoGNC = 0;
        vehiculo.poseeRuedaDeAuxilio = false;
        vehiculo.es0KM = false;
        request.vehiculo = vehiculo;

        request.bienAsegurado = 0;
        
        //Cliente
        request.codigoPostal = 2300;
        request.numeroDeDocumento = 12599862;
        request.condicionAnteIVA = 4;
        request.tipoDeDocumento = 'D';
        request.personaJuridica = false;
        
        //Ciudad
        request.ciudadId = 1157; // victor paso parametria excel. deberiamos tener parametrizado en un objeto debido a la cantidad de registros todo eso en sfdc para poder obtener  el valor del id ciudad en base al codigo postal que devuevle peype deberia estar en la solapa de datos de cliente preview y no olvidar tener un trigger para cuando a mano se modifica el CP deberian ser picklists de provincia y localidad
        
        //Coberturas
        request.codigosDeModuloDeCoberturas = new List<Integer>{5};
        request.descuentos = new List<CotizadorAPIRequest.Descuento>{ };
        
        //Cotizacion
        request.fechaEfectiva = DateTime.newInstance(2018,10,29,0,0,0);
        request.periodoDeValidez = 1;
        request.frecuenciaDePago = 5;
        request.cuotas = 0;
        request.numeroProductor = 212505; // va a ser un valor en la account (partner account) que sea del broker
        request.numeroOrganizacion = 150766; //150766; // va a ser el numero de organizacion de aliate
        
        //Scoring
        CotizadorAPIRequest.Scoring scoring0 = new CotizadorAPIRequest.Scoring();
        scoring0.tipoId = 3;
        scoring0.opcionId = 1;
        /// Guarda Garage: id 3; 1 - SI  2 - NO 

        CotizadorAPIRequest.Scoring scoring1 = new CotizadorAPIRequest.Scoring();
        scoring1.tipoId = 7;
        scoring1.opcionId = 2;
        // La Edad de los conductores es Menor a 25 años: 7; 1 - SI  2 - NO

        CotizadorAPIRequest.Scoring scoring3 = new CotizadorAPIRequest.Scoring();
        scoring3.tipoId = 8;
        scoring3.opcionId = 1;
        // kms Anuales Recorridos: 8; 1 - Hasta 25.000 2 - Mayor a 25.000
        
        //request.scoring = new List<CotizadorAPIRequest.Scoring>{ scoring0, scoring1, scoring3 };
        request.scoring = new List<CotizadorAPIRequest.Scoring>{ }; //viaja la lista vacia porque no es necesario

        return request;
    }

    public static CotizadorController.Wrapper doSave(CotizadorController.Wrapper result, 
                                                    CotizadorController.Auto auto, 
                                                    List<CotizadorController.CotizacionSancor> cotizaciones, 
                                                    Opportunity opp){
        
        try{

            Id recordTypeAutomotorId = [
                SELECT ID
                FROM RecordType
                WHERE DeveloperName = 'AUTOMOTOR'
                AND SobjectType = 'Quote'
            ].Id;

            List<Quote> quotes = new List<Quote>();
            List<QuoteLineItem> qlis = new List<QuoteLineItem>();

            PriceBookEntry pbe = [
                SELECT ID, PriceBook2Id
                FROM PriceBookEntry
                WHERE Product2.Name LIKE '%SANCOR%'
                LIMIT 1
            ];

            for(CotizadorController.CotizacionSancor cotizacion : cotizaciones){

                //QUOTE
                Quote quote = new Quote();
                quote.Name = 'SANCOR';
                quote.OpportunityId = opp.Id;
                quote.Status = 'Presented';
                quote.RecordTypeId = recordTypeAutomotorId;
                
                //todo reveer esto
                quote.Pricebook2Id = pbe.PriceBook2Id;
                quotes.add(quote);

                //QLI
                QuoteLineItem qli = new QuoteLineItem();
                qli.Quantity = 1;
                qli.UnitPrice = cotizacion.premioMensual;
                
                //todo reveer esto
                qli.PricebookEntryId = pbe.Id;
                
                qli.Marca__c = auto.marca;
                qli.Modelo__c = auto.modelo;
                qli.Anio__c = auto.anio;
                qli.Version__c = auto.version;
                qli.Uso_Comercial__c = auto.uso;
                qli.X0KM__c = auto.km;
                qli.Rastreador__c = auto.rastreador;
                qli.GNC__c = auto.gnc;
                if(qli.GNC__c){
                    qli.Suma_Asegurada_GNC__c = auto.sumaAseguradaGNC;    
                }
                qli.Accesorio__c = auto.accesorio;
                if(qli.Accesorio__c){
                    qli.Tipo_de_Accesorio__c = auto.tipoAccesorio;
                    qli.Suma_Asegurada_Accesorio__c = auto.sumaAseguradaAccesorio;    
                }
                
                qlis.add(qli);
            }

            database.insert(quotes);
            for(Integer i = 0 ; i < quotes.size(); i++){
                qlis[i].quoteId = quotes[i].Id;
            }
            database.insert(qlis);

            result.returnId = opp.Id;
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

}