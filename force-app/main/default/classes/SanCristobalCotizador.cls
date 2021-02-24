public with sharing class SanCristobalCotizador {

    public static CotizadorController.Wrapper doSanCristobalCallout(CotizadorController.Wrapper result, 
                                                                    CotizadorController.Auto auto, 
                                                                    CotizadorController.Cliente cliente){
        system.debug('doSanCristobalCallout()');

        SCApiQuote api = new SCApiQuote();
        SCApiQuote.Wrapper response = api.getDataFromAPI(auto, cliente);
        system.debug('response: ' + response);

        if(!response.hasError){

            Integer i=0;
            Map<String, String> coberturasSC = new Map<String, String>();
            for(AllValidProductOffering__c avp : [
                SELECT ID, Code__c, Description__c
                FROM AllValidProductOffering__c
            ]){
                coberturasSC.put(avp.Code__c, avp.Description__c);
            }

            for(SanCristobalCotizacionResponse.Summaries summary : response.response.Summaries){
                //CotizadorController.CotizacionSanCristobal cotizacion = new CotizadorController.CotizacionSanCristobal();
                CotizadorController.CotizacionSancor cotizacion = new CotizadorController.CotizacionSancor();
                cotizacion.aseguradora = 'SAN CRISTOBAL';
                
                cotizacion.descripcionCorta = coberturasSC.get(auto.codigosDeModuloDeCoberturasSC[i]);
                
                cotizacion.ivaMensual = summary.Summary.Taxes.Amount;
                cotizacion.ivaTotal = summary.Summary.Taxes.Amount;
                
                cotizacion.premioMensual = summary.Summary.NetPremium.Amount;
                cotizacion.premioTotal = summary.Summary.NetPremium.Amount;

                cotizacion.policyPeriodId = summary.Summary.PolicyPeriodId;
                cotizacion.BranchNumber = summary.Summary.BranchNumber;
                if(!summary.UWIssues.isEmpty()){
                    if(summary.UWIssues[0] != null){
                        if(summary.UWIssues[0].BlockingPoint != null){
                            cotizacion.blockingPoint = summary.UWIssues[0].BlockingPoint.Code;
                        }
                    }
                }

                result.cotizacionesSanCristobal.add(cotizacion);
                i++;
            }
        }else{
            result.hasError = true;
            if(response.errorResponse != null){
                for(SanCristobalCotizadorResAutoErro.Messages errorMsg : response.errorResponse.Messages){
                    result.errors.add(errorMsg.Description);
                }
            }else{
                result.errors.add('Time Out!');
            }
        }

        return result;
    }

    public static CotizadorController.Wrapper doSave(CotizadorController.Wrapper result, 
                                                    CotizadorController.Auto auto, 
                                                    List<CotizadorController.CotizacionSancor> cotizaciones, 
                                                    Opportunity opp){
        system.debug('doSave(): ' + result + ' ' + auto + ' ' + cotizaciones + ' ' + opp);

        result = doSaveInSFDC(result, cotizaciones, auto, opp);

        return result;
    }

    public static CotizadorController.Wrapper doSaveInSFDC(CotizadorController.Wrapper result, List<CotizadorController.CotizacionSancor> cotizaciones, CotizadorController.Auto auto, Opportunity opp){
        try{

            opp.policyPeriodId__c = cotizaciones[0].policyPeriodId;

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
                WHERE Product2.Name LIKE '%San Cristobal%'
                LIMIT 1
            ];

            for(CotizadorController.CotizacionSancor cotizacion : cotizaciones){

                //QUOTE
                Quote quote = new Quote();
                quote.Name = 'SAN CRISTOBAL';
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