public without sharing class SancorCotizarVehiculoWebService {

    public Response serviceResponse { get; private set; }

    public SancorCotizarVehiculoWebService() {
        this.serviceResponse = new Response();
    }

    public Boolean cotizarVehiculo (CotizadorAPIRequest vehiculoACotizar, Map<String, String> autenticacion) {
        return this.cotizarVehiculo(vehiculoACotizar, autenticacion, Enumerator.Producto.AUTO);
    }

    public Boolean cotizarVehiculo (CotizadorAPIRequest vehiculoACotizar, Map<String, String> autenticacion, Enumerator.Producto producto) {
        this.serviceResponse.hasError = false;

        if ( ! this.isAuthenticated(autenticacion) || ( producto == Enumerator.Producto.AUTO && ! this.requiredFieldsFilled(vehiculoACotizar) ) ) {
            return ! this.serviceResponse.hasError;
        }

        String body = '';

        try {
            body = this.createBody(vehiculoACotizar, producto);
        } catch (Exception ex) {
            this.serviceResponse.hasError = true;
            this.serviceResponse.message = 'Error al crear el request: '+ex.getTypeName() +'-'+ ex.getMessage();
        }

        if ( ! this.serviceResponse.hasError ) {
            WSParameter bodyParameter = new WSParameter('body', body , true, false);
            WSParameter[] headers = new List<WSParameter> {
            	new WSParameter('TokenType', autenticacion.get('TokenType'), false, false),
            	new WSParameter('Token', autenticacion.get('Token'), false, false),
                new WSParameter('User', autenticacion.get('User'), false, false),
                new WSParameter('Content-Type', 'application/x-www-form-urlencoded', false, false)
            };

            String endpoint = EndpointResolver.getEndpoint('Sancor_PriceSvc_Preproduccion', 'Sancor_PriceSvc_Produccion').Url__c;

            RestWS webServiceCaller = new RestWS(endpoint, 'POST' , null, bodyParameter, headers);

            System.debug('REQUEST: '+webServiceCaller.request.getBody().unescapeXml());

            this.serviceResponse = (Response) webServiceCaller.invoke(this.serviceResponse);

            System.debug('RESPONSE: '+this.serviceResponse.response?.getBody().unescapeXml());
        }

        return ! this.serviceResponse.hasError;
    }

    @TestVisible
    private String createBody(CotizadorAPIRequest vehiculoACotizar, Enumerator.Producto producto){
        //Valores Fijos
        String codProducto = (producto == Enumerator.Producto.AUTO) ? '24' : '863'; // 14: Automotor - 863 = Moto
        String moneda = '1'; // "Operacion Normal"

        String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:a="http://GrupoSancorSeguros/xsd/entity/PriceTypes" xmlns:b="http://GrupoSancorSeguros/xsd/entity/CommonTypes" xmlns:c="http://GrupoSancorSeguros/xsd/entity/IntermediaryTypes" xmlns:d="http://GrupoSancorSeguros/xsd/entity/VehicleTypes" xmlns:e="http://GrupoSancorSeguros/xsd/entity/ProductTypes" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';

        if(producto == Enumerator.Producto.MOTO){
            body +='<soapenv:Header>'
                +      '<Action xmlns="http://schemas.microsoft.com/ws/2005/05/addressing/none" soapenv:mustUnderstand="1">http://GrupoSancorSeguros/wsdl/service/PriceSvc/NewVehicle</Action>'
                +   '</soapenv:Header>';
        } else {
            body += '<soapenv:Header />';
        }

        /*body +='<soapenv:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        +        '<NewVehicle_Rq xmlns="http://GrupoSancorSeguros/xsd/service/PriceSvcMsg">'
        +            '<Price>'
        +                '<a:City>'
        +                    '<b:Id>'+vehiculoACotizar.ciudadId+'</b:Id>'
        +                '</a:City>'
        +                '<a:DocumentNumber>'+vehiculoACotizar.numeroDeDocumento+'</a:DocumentNumber>'
        +                '<a:Document>'
        +                    '<b:Type>'+vehiculoACotizar.tipoDeDocumento+'</b:Type>'
        +                '</a:Document>'
        +                '<a:IsJuridicPerson>'+(vehiculoACotizar.personaJuridica ? 1 : 0)+'</a:IsJuridicPerson>';*/
        
        body +='<soapenv:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        +        '<NewVehicle_Rq xmlns="http://GrupoSancorSeguros/xsd/service/PriceSvcMsg">'
        +            '<Price>'
        +                '<a:City>'
        +                    '<b:Id>'+vehiculoACotizar.ciudadId+'</b:Id>'
        +                '</a:City>';
        
        if(vehiculoACotizar.numeroDeDocumentoDouble == null){
            body += '<a:DocumentNumber>'+vehiculoACotizar.numeroDeDocumento+'</a:DocumentNumber>';
        }else{
            body += '<a:DocumentNumber>'+vehiculoACotizar.numeroDeDocumentoDouble.longValue()+'</a:DocumentNumber>';
        }
                        
		body +=          '<a:Document>'
        +                    '<b:Type>'+vehiculoACotizar.tipoDeDocumento+'</b:Type>'
        +                '</a:Document>'
        +                '<a:IsJuridicPerson>'+(vehiculoACotizar.personaJuridica ? 1 : 0)+'</a:IsJuridicPerson>';

        if(! vehiculoACotizar.codigosDeModuloDeCoberturas.isEmpty()){
            body += '<a:CoverModuleCodes>'+String.join(vehiculoACotizar.codigosDeModuloDeCoberturas,',')+'</a:CoverModuleCodes>';
        } else {
            body += '<a:CoverModuleCodes />';
        }

        body += '<a:Currency>'
            +       '<b:Id>'+moneda+'</b:Id>'
            +   '</a:Currency>';

        if ( vehiculoACotizar.descuentos != null && ! vehiculoACotizar.descuentos.isEmpty() ) {
            body += '<a:DiscountCustomizations>';
            for (CotizadorAPIRequest.Descuento descuento : vehiculoACotizar.descuentos) {
                body += '<a:DiscountCustomization>'
                    +       '<a:DiscountNumber>'+descuento.codigoDeDescuento+'</a:DiscountNumber>'
                    +       '<a:Rate>'+descuento.porcentaje+'</a:Rate>'
                    +   '</a:DiscountCustomization>';
            }
            body += '</a:DiscountCustomizations>';
        } else {
            body += '<a:DiscountCustomizations />';
        }

        body += '<a:EffectDate>'+vehiculoACotizar.fechaEfectiva.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</a:EffectDate>'
        +                '<a:InsuredGood>'+vehiculoACotizar.bienAsegurado+'</a:InsuredGood>'
        +                '<a:IvaCondition>'
        +                    '<b:Id>'+vehiculoACotizar.condicionAnteIVA+'</b:Id>'
        +                '</a:IvaCondition>'
        +                '<a:Intermediary>'
        +                    '<c:Code>'+vehiculoACotizar.numeroProductor+'</c:Code>'
        +                    '<c:Supervisor>'+vehiculoACotizar.numeroOrganizacion+'</c:Supervisor>';

        if(vehiculoACotizar.grupoEstadistico != null){
            body += '<c:StatisticCode>'+String.valueOf(vehiculoACotizar.grupoEstadistico)+'</c:StatisticCode>';
        } else {
            body += '<c:StatisticCode>0</c:StatisticCode>';
        }

        body +=          '</a:Intermediary>'
        +                '<a:PeriodOfValidity>'
        +                    '<b:Id>'+vehiculoACotizar.periodoDeValidez+'</b:Id>'
        +                '</a:PeriodOfValidity>'
        +                '<a:Frequency>'
        +                    '<b:Id>'+vehiculoACotizar.frecuenciaDePago+'</b:Id>'
        +                '</a:Frequency>'
        +                '<a:Fee>'
        +                    '<b:Id>'+vehiculoACotizar.cuotas+'</b:Id>'
        +                '</a:Fee>'
        +                '<a:Product>'
        +                    '<e:Id>'+codProducto+'</e:Id>'
        +                '</a:Product>'
        +                '<a:Zone>'
        +                    '<b:ZipCode>'+vehiculoACotizar.codigoPostal+'</b:ZipCode>'
        +                '</a:Zone>'
        +                '<a:Vehicle>'
        +                    '<d:Code>'+vehiculoACotizar.vehiculo.codigo+'</d:Code>'
        +                    '<d:Year>'+vehiculoACotizar.vehiculo.anio+'</d:Year>'
        +                    '<d:Value>'
        +                        '<d:Capital>'+vehiculoACotizar.vehiculo.valor+'</d:Capital>'
        +                    '</d:Value>'
        +                    '<d:Use>'
        +                        '<b:Id>'+vehiculoACotizar.vehiculo.uso+'</b:Id>'
        +                    '</d:Use>';

        if (producto == Enumerator.Producto.AUTO) {
            body += '<d:GNCInformation>'
            +           '<d:GNCValue>'+vehiculoACotizar.vehiculo.valorEquipoGNC+'</d:GNCValue>'
            +           '<d:HasGNC>'+(vehiculoACotizar.vehiculo.tieneGNC ? 1 : 0)+'</d:HasGNC>'
            +      '</d:GNCInformation>'
            +      '<d:HasAuxiliaryTires>'+vehiculoACotizar.vehiculo.poseeRuedaDeAuxilio+'</d:HasAuxiliaryTires>';
        }
        
        body += '<d:IsOkm>'+vehiculoACotizar.vehiculo.es0KM+'</d:IsOkm>'
        +   '</a:Vehicle>';

        if(! vehiculoACotizar.scoring.isEmpty()){
            body += '<a:ScoringOptions>';
            for (CotizadorAPIRequest.Scoring scoring : vehiculoACotizar.scoring) {
                body += '<a:ScoringOption>'
                    +       '<a:ScoringTypeId>'+scoring.tipoId+'</a:ScoringTypeId>'
                    +       '<a:SelectedOptionId>'+scoring.opcionId+'</a:SelectedOptionId>'
                    +   '</a:ScoringOption>';
            }
            body += '</a:ScoringOptions>';
        }/* else {
            body += '<a:ScoringOptions/>';
        }*/

        body +=     '</Price>'
        +        '</NewVehicle_Rq>'
        +    '</soapenv:Body>'
        +'</soapenv:Envelope>';

        return body;
    }

    private Boolean isAuthenticated(Map<String,String> autenticacion){
        Boolean isAthenticated = ! autenticacion.isEmpty()
            && autenticacion.containsKey('User')
            && autenticacion.containsKey('TokenType')
            && autenticacion.containsKey('Token');

        if(! isAthenticated ){
            this.serviceResponse.hasError = true;
            this.serviceResponse.message = 'No se recibieron Credenciales.';
        }
        return isAthenticated;
    }

    /*
    *OBSERVATION: Esto podria estar en el wrapper directamente y devolver una lista de mensajes de error para formatear. Segun la necesidad de separar el consern*/
    private Boolean requiredFieldsFilled(CotizadorAPIRequest vehiculoACotizar){
        Boolean hasError = false;
        List<String> fieldsNotFilled = new List<String>();

        if(! vehiculoACotizar.hasPersonaJuridicaFilled()){
            hasError |= true;
            fieldsNotFilled.add('Persona Juridica');
        }

        if(! vehiculoACotizar.hasNumeroProductorFilled()){
            hasError |= true;
            fieldsNotFilled.add('Numero Productor');
        }

        if(! vehiculoACotizar.hasNumeroOrganizacionFilled()){
            hasError |= true;
            fieldsNotFilled.add('Numero Organizacion');
        }

        if(! vehiculoACotizar.hasPeriodoValidezFilled()){
            hasError |= true;
            fieldsNotFilled.add('Periodo de Validez');
        }

        if(! vehiculoACotizar.hasFrecuenciaDePagoFilled()){
            hasError |= true;
            fieldsNotFilled.add('Frecuencia de Pago');
        }

        if(! vehiculoACotizar.hasCodigoPostalFilled()){
            hasError |= true;
            fieldsNotFilled.add('Codigo Postal');
        }

        if(! vehiculoACotizar.hasVehiculoFilled()){
            hasError |= true;
            fieldsNotFilled.add('Datos del Vehiculo');
        } else {
            if(! vehiculoACotizar.vehiculo.hasCodigoFilled()){
                hasError |= true;
                fieldsNotFilled.add('Codigo del Vehiculo');
            }

            if(! vehiculoACotizar.vehiculo.hasAnioFilled()){
                hasError |= true;
                fieldsNotFilled.add('Año del Vehiculo');
            }

            if(! vehiculoACotizar.vehiculo.hasUsoFilled()){
                hasError |= true;
                fieldsNotFilled.add('Uso del Vehiculo');
            }
        }

        if(vehiculoACotizar.hasScoringFilled()){
            for ( CotizadorAPIRequest.Scoring scoring : vehiculoACotizar.scoring ) {
                if ( ! scoring.hasTipoIdFilled() || ! scoring.hasOpcionIdFilled()){
                    hasError |= true;
                    fieldsNotFilled.add('Falta datos de scoring');
                    break;
                }
            }
        }

        if(hasError){
            this.serviceResponse.hasError = hasError;
            this.serviceResponse.message = 'Faltan los siguientes campos requeridos: ' + String.join(fieldsNotFilled,',');
            System.debug(this.serviceResponse.message);
        }

        return ! hasError;
    }

    public class Response extends WSResult  {

        public CotizadorAPIResponse cotizacion { get; set; }
        public String faultString { get; private set; }
        public String faultCode { get; private set; }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde un http 2XX */
        public override void processResponse(HttpResponse response) {
            String bodyString = response.getBody();

            this.cotizacion = new CotizadorAPIResponse();
            this.cotizacion.planes = this.createPlans( XMLParser.getNode( bodyString, 'Body/NewVehicle_Rs/Plans' ) );
            this.cotizacion.idCotizacionRelacion =
                Integer.valueOf(
                    XMLParser.getNode(bodyString, 'Body/NewVehicle_Rs/Price/RelationQuotationId' ).getText()
                );
            this.cotizacion.idCotizacion =
                Integer.valueOf( XMLParser.getNode( bodyString, 'Body/NewVehicle_Rs/Price/QuotationId' ).getText() );
        }

        private List<CotizadorAPIResponse.Plan> createPlans(Dom.XmlNode bodyPlansString){
            List<CotizadorAPIResponse.Plan> planes = new List<CotizadorAPIResponse.Plan>();

            CotizadorAPIResponse.Plan currentPlan;
            for (Dom.XmlNode plan : bodyPlansString.getChildElements()) {
                currentPlan = new CotizadorAPIResponse.Plan();
                currentPlan.moduloCodigo = Integer.valueOf(XMLParser.getNode(plan, 'Module')?.getText());
                currentPlan.clienteDescripcion = XMLParser.getNode(plan, 'ClientDescr')?.getText();
                currentPlan.descripcionLarga = XMLParser.getNode(plan, 'LongDescr')?.getText();
                currentPlan.descripcionCorta = XMLParser.getNode(plan, 'ShortDescr')?.getText();
                currentPlan.mensajeInformativo = XMLParser.getNode(plan, 'MsgModule')?.getText();
                currentPlan.premioMensual = Decimal.valueOf(XMLParser.getNode(plan, 'PremiumMonthly')?.getText());
                currentPlan.premioTotal = Decimal.valueOf(XMLParser.getNode(plan, 'Premium')?.getText());
                currentPlan.cotizacionExitosa = Boolean.valueOf(XMLParser.getNode(plan, 'Success')?.getText());
                currentPlan.resultadoValidacion = XMLParser.getNode(plan, 'ValidationResults')?.getText();
                currentPlan.fueraDeNorma = Boolean.valueOf(XMLParser.getNode(plan, 'OutStandard')?.getText());
                currentPlan.poseeEquipoDeRastreo = Boolean.valueOf(XMLParser.getNode(plan, 'HasTrackingEquipment')?.getText());
                // currentPlan.poseeTelematica = Boolean.valueOf(XMLParser.getNode(plan, 'HasTelematic').getText());  //OBS: Actualmente no se utiliza
                currentPlan.valuacionDelVechiculo = Decimal.valueOf(XMLParser.getNode(plan, 'VehicleValuation')?.getText());
                currentPlan.idPrecios = Integer.valueOf(XMLParser.getNode(plan, 'PricingId')?.getText());
                currentPlan.idPreciosAPF = this.getIntegerValue(XMLParser.getNode(plan, 'PricingIdAPF')?.getText());
                currentPlan.ivaMensual = Decimal.valueOf(XMLParser.getNode(plan, 'TaxBases/TaxBase/IvaMonthly')?.getText());
                currentPlan.ivaTotal = Decimal.valueOf(XMLParser.getNode(plan, 'TaxBases/TaxBase/Iva')?.getText());
                currentPlan.primaPuraMensual = Decimal.valueOf(XMLParser.getNode(plan, 'PrimaTotal/PurePremiumMonthlyTotal')?.getText());
                currentPlan.PrimaPuraTotal = Decimal.valueOf(XMLParser.getNode(plan, 'PrimaTotal/PurePremiumTotal')?.getText());
                currentPlan.sumasAseguradas = this.createSumasAseguradas(XMLParser.getNode(plan, 'Results'));
                // currentPlan.calculosAdicionales = this.createCalculosAdicionales(XMLParser.getNode(plan, 'AdditionalsCalculationResult'));  //OBS: Actualmente no se utiliza
                planes.add(currentPlan);
            }
            return planes;
        }

        private List<CotizadorAPIResponse.SumaAsegurada> createSumasAseguradas(Dom.XmlNode bodyPlansString){
            List<CotizadorAPIResponse.SumaAsegurada> sumas = new List<CotizadorAPIResponse.SumaAsegurada>();

            CotizadorAPIResponse.SumaAsegurada sumaActual;
            Dom.XmlNode capital;
            Dom.XmlNode descripcion;
            Dom.XmlNode detalle;
            Dom.XmlNode detalleCodigo;
            Dom.XmlNode primaPuraMensual;
            Dom.XmlNode primaPuraTotal;
            Dom.XmlNode detalleTipo;
            for (Dom.XmlNode suma : bodyPlansString.getChildElements()) {
                capital = XMLParser.getNode(suma, 'Capital');
                descripcion = XMLParser.getNode(suma, 'Description');
                detalle = XMLParser.getNode(suma, 'Detail');
                detalleCodigo = XMLParser.getNode(suma, 'DetailInt');
                primaPuraMensual = XMLParser.getNode(suma, 'PurePremiumMonthly');
                primaPuraTotal = XMLParser.getNode(suma, 'PurePremium');
                detalleTipo = XMLParser.getNode(suma, 'DetailType');

                if( capital != null && descripcion != null && detalle != null && detalleCodigo != null && primaPuraMensual != null && primaPuraTotal != null && detalleTipo != null){
                    sumaActual = new CotizadorAPIResponse.SumaAsegurada();
                    sumaActual.capital = Decimal.valueOf(XMLParser.getNode(suma, 'Capital')?.getText());
                    sumaActual.descripcion = XMLParser.getNode(suma, 'Description')?.getText();
                    sumaActual.detalle = XMLParser.getNode(suma, 'Detail')?.getText();
                    sumaActual.detalleCodigo = Integer.valueOf(XMLParser.getNode(suma, 'DetailInt')?.getText());
                    sumaActual.primaPuraMensual = Decimal.valueOf(XMLParser.getNode(suma, 'PurePremiumMonthly')?.getText());
                    sumaActual.primaPuraTotal = Decimal.valueOf(XMLParser.getNode(suma, 'PurePremium')?.getText());
                    sumaActual.detalleTipo = XMLParser.getNode(suma, 'DetailType')?.getText();
                    sumas.add(sumaActual);
                }
            }

            return sumas;
        }

        private Integer getIntegerValue(String value){
            return String.isBlank(value) ? null : Integer.valueOf(value);
        }

        public override void processErrorResponse( HttpResponse response ){
            String bodyString = response.getBody();

            if ( XMLParser.getNode( bodyString, 'Body/Fault' ) != null ) {

                this.faultCode = XMLParser.getNode( bodyString, 'Body/Fault/faultcode' ).getText();

                this.faultString = XMLParser.getNode( bodyString, 'Body/Fault/faultstring' ).getText();
            }
        }
    }

    //OBS: metodo deprecado por que no se utiliza de momento los tagas de calculos adicionales.
    // private List<CotizadorAPIResponse.CalculosAdicionales> createCalculosAdicionales(Dom.XmlNode bodyPlansString){
    //     List<CotizadorAPIResponse.CalculosAdicionales> adicionales = new List<CotizadorAPIResponse.CalculosAdicionales>();

    //     CotizadorAPIResponse.CalculosAdicionales adicionalActual;
    //     for (Dom.XmlNode adicional : bodyPlansString.getChildElements()) {
    //         adicionalActual = new CotizadorAPIResponse.CalculosAdicionales();
    //         adicionalActual.baseCalculoAdicional = Decimal.valueOf(XMLParser.getNode(adicional, 'AdditionalsCalculationBase').getText());
    //         adicionales.add(adicionalActual);
    //     }

    //     return adicionales;
    // }
}

/**
 * REQUEST EXAMPLE: AUTOMOTOR

    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:a="http://GrupoSancorSeguros/xsd/entity/PriceTypes" xmlns:b="http://GrupoSancorSeguros/xsd/entity/CommonTypes" xmlns:c="http://GrupoSancorSeguros/xsd/entity/IntermediaryTypes" xmlns:e="http://GrupoSancorSeguros/xsd/entity/ProductTypes" xmlns:d="http://GrupoSancorSeguros/xsd/entity/VehicleTypes" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
        <soapenv:Header/>
        <soapenv:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <NewVehicle_Rq xmlns="http://GrupoSancorSeguros/xsd/service/PriceSvcMsg">
                <Price>
                    <a:City>
                    <b:Id>1157</b:Id>
                    </a:City>
                    <a:DocumentNumber>12599862</a:DocumentNumber>
                    <a:Document>
                    <b:Type>D</b:Type>
                    </a:Document>
                    <a:IsJuridicPerson>0</a:IsJuridicPerson>
                    <a:CoverModuleCodes/>
                    <a:Currency>
                    <b:Id>1</b:Id>
                    </a:Currency>
                    <a:DiscountCustomizations>
                    <a:DiscountCustomization>
                        <a:DiscountNumber>1</a:DiscountNumber>
                        <a:Rate>99</a:Rate>
                    </a:DiscountCustomization>
                    <a:DiscountCustomization>
                        <a:DiscountNumber>58</a:DiscountNumber>
                        <a:Rate>0</a:Rate>
                    </a:DiscountCustomization>
                    <a:DiscountCustomization>
                        <a:DiscountNumber>4</a:DiscountNumber>
                        <a:Rate>0</a:Rate>
                    </a:DiscountCustomization>
                    </a:DiscountCustomizations>
                    <a:EffectDate>2018-10-29T00:00:00</a:EffectDate>
                    <a:InsuredGood>0</a:InsuredGood>
                    <a:IvaCondition>
                    <b:Id>4</b:Id>
                    </a:IvaCondition>
                    <a:Intermediary>
                    <c:Code>212505</c:Code>
                    <c:Supervisor>150766</c:Supervisor>
                    <!--<c:StatisticCode></c:StatisticCode>-->
                    </a:Intermediary>
                    <a:PeriodOfValidity>
                    <b:Id>1</b:Id>
                    </a:PeriodOfValidity>
                    <a:Frequency>
                    <b:Id>5</b:Id>
                    </a:Frequency>
                    <a:Fee>
                    <b:Id>0</b:Id>
                    </a:Fee>
                    <a:Product>
                    <e:Id>24</e:Id>
                    </a:Product>
                    <a:Zone>
                    <b:ZipCode>2300</b:ZipCode>
                    </a:Zone>
                    <a:Vehicle>
                    <d:Code>0180517</d:Code>
                    <d:Year>2013</d:Year>
                    <d:Value>
                        <d:Capital>0</d:Capital>
                    </d:Value>
                    <d:Use>
                        <b:Id>2</b:Id>
                    </d:Use>
                    <d:GNCInformation>
                        <d:GNCValue>0</d:GNCValue>
                        <d:HasGNC>0</d:HasGNC>
                    </d:GNCInformation>
                    <!--<d:HasAuxiliaryTires></d:HasAuxiliaryTires>-->
                    <d:IsOkm>false</d:IsOkm>
                    </a:Vehicle>
                    <a:ScoringOptions>
                    <a:ScoringOption>
                        <a:ScoringTypeId>3</a:ScoringTypeId>
                        <a:SelectedOptionId>1</a:SelectedOptionId>
                    </a:ScoringOption>
                    <a:ScoringOption>
                        <a:ScoringTypeId>7</a:ScoringTypeId>
                        <a:SelectedOptionId>2</a:SelectedOptionId>
                    </a:ScoringOption>
                    <a:ScoringOption>
                        <a:ScoringTypeId>8</a:ScoringTypeId>
                        <a:SelectedOptionId>1</a:SelectedOptionId>
                    </a:ScoringOption>
                    </a:ScoringOptions>
                </Price>
            </NewVehicle_Rq>
        </soapenv:Body>
   </soapenv:Envelope>
 */


/** GOOD RESPONSE EXAMPLE

<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    <soapenv:Body>
        <nspm:NewVehicle_Rs xmlns:nspm="http://GrupoSancorSeguros/xsd/service/PriceSvcMsg" xmlns:nsc="http://GrupoSancorSeguros/xsd/entity/CommonTypes" xmlns:nspl="http://GrupoSancorSeguros/xsd/entity/PlanTypes" xmlns:nsv="http://GrupoSancorSeguros/xsd/entity/VehicleTypes">
            <nspm:Plans>
                <nspm:Plan>
                    <nspl:Results>
                        <nspl:Result>
                            <nspl:Capital>10180000</nspl:Capital>
                            <nspl:Description>Resp. Civil: Daños a cosas no transportadas de terceras personas.</nspl:Description>
                            <nspl:Detail>Prima</nspl:Detail>
                            <nspl:DetailInt>1</nspl:DetailInt>
                            <nspl:PurePremiumMonthly>25.29</nspl:PurePremiumMonthly>
                            <nspl:PurePremium>303.53</nspl:PurePremium>
                            <nspl:DetailType>Cobertura</nspl:DetailType>
                        </nspl:Result>
                        <nspl:Result>
                            <nspl:Capital>10000000</nspl:Capital>
                            <nspl:Description>Resp. Civil: Lesiones y/o muerte de terceras personas transportadas.</nspl:Description>
                            <nspl:Detail>Prima</nspl:Detail>
                            <nspl:DetailInt>3</nspl:DetailInt>
                            <nspl:PurePremiumMonthly>3.15</nspl:PurePremiumMonthly>
                            <nspl:PurePremium>37.80</nspl:PurePremium>
                            <nspl:DetailType>Cobertura</nspl:DetailType>
                        </nspl:Result>
                        <nspl:Result />
                    </nspl:Results>
                    <nspl:Module>9</nspl:Module>
                    <nspl:ClientDescr />
                    <nspl:LongDescr>Auto Todo Riesgo 9 (c/deduc. $ 10000 c/Asistencia)</nspl:LongDescr>
                    <nspl:ShortDescr>Auto Todo Riesgo 9</nspl:ShortDescr>
                    <nspl:MsgModule>Las coberturas Auto Max 6, Auto Premium Max y las distintas alternativa de Todo Riesgo son solo informativas y quedarán sujetas a la inspección, solicitud de fotos o a la determinación que defina el análisis previo del área de suscripción.</nspl:MsgModule>
                    <nspl:PremiumMonthly>2385.00</nspl:PremiumMonthly>
                    <nspl:Premium>28630.80</nspl:Premium>
                    <NS6:Success xmlns:NS6="http://GrupoSancorSeguros/xsd/entity/PlanTypes">true</NS6:Success>
                    <nspl:ValidationResults />
                    <nspl:OutStandard xmlns:NS53="http://GrupoSancorSeguros/xsd/entity/CommonTypes">true</nspl:OutStandard>
                    <nspl:HasTrackingEquipment xmlns:NS51="http://GrupoSancorSeguros/xsd/entity/CommonTypes">false</nspl:HasTrackingEquipment>
                    <NS10:HasTelematic xmlns:NS10="http://GrupoSancorSeguros/xsd/entity/PlanTypes">false</NS10:HasTelematic>
                    <nspl:VehicleValuation>262000</nspl:VehicleValuation>
                    <nspl:AdditionalsCalculationResult>
                        <nspl:AdditionalsCalculationBase />
                    </nspl:AdditionalsCalculationResult>
                    <NS8:PricingId xmlns:NS8="http://GrupoSancorSeguros/xsd/entity/PlanTypes">52474682</NS8:PricingId>
                    <nspl:PricingIdAPF>52474676</nspl:PricingIdAPF>
                    <nspl:TaxBases>
                        <nspl:TaxBase>
                            <nspl:IvaMonthly>1797.28</nspl:IvaMonthly>
                            <nspl:Iva>21567.34</nspl:Iva>
                        </nspl:TaxBase>
                    </nspl:TaxBases>
                    <nspl:PrimaTotal>
                        <nspl:PurePremiumMonthlyTotal>1781.81</nspl:PurePremiumMonthlyTotal>
                        <nspl:PurePremiumTotal>21381.70</nspl:PurePremiumTotal>
                    </nspl:PrimaTotal>
                </nspm:Plan>
                <nspm:Plan>
                    <nspl:Results>
                        <nspl:Result>
                            <nspl:Capital>10180000</nspl:Capital>
                            <nspl:Description>Resp. Civil: Daños a cosas no transportadas de terceras personas.</nspl:Description>
                            <nspl:Detail>Prima</nspl:Detail>
                            <nspl:DetailInt>1</nspl:DetailInt>
                            <nspl:PurePremiumMonthly>25.29</nspl:PurePremiumMonthly>
                            <nspl:PurePremium>303.53</nspl:PurePremium>
                            <nspl:DetailType>Cobertura</nspl:DetailType>
                        </nspl:Result>
                        <nspl:Result>
                            <nspl:Capital>10000000</nspl:Capital>
                            <nspl:Description>Resp. Civil: Lesiones y/o muerte de terceras personas transportadas.</nspl:Description>
                            <nspl:Detail>Prima</nspl:Detail>
                            <nspl:DetailInt>3</nspl:DetailInt>
                            <nspl:PurePremiumMonthly>3.15</nspl:PurePremiumMonthly>
                            <nspl:PurePremium>37.80</nspl:PurePremium>
                            <nspl:DetailType>Cobertura</nspl:DetailType>
                        </nspl:Result>
                        <nspl:Result />
                    </nspl:Results>
                    <nspl:Module>7</nspl:Module>
                    <nspl:ClientDescr />
                    <nspl:LongDescr>Auto Todo Riesgo 8 (c/deduc. $ 5000 c/Asistencia)</nspl:LongDescr>
                    <nspl:ShortDescr>Auto Todo Riesgo 8</nspl:ShortDescr>
                    <nspl:MsgModule>Las coberturas Auto Max 6, Auto Premium Max y las distintas alternativa de Todo Riesgo son solo informativas y quedarán sujetas a la inspección, solicitud de fotos o a la determinación que defina el análisis previo del área de suscripción.</nspl:MsgModule>
                    <nspl:PremiumMonthly>1026.00</nspl:PremiumMonthly>
                    <nspl:Premium>12319.81</nspl:Premium>
                    <NS6:Success xmlns:NS6="http://GrupoSancorSeguros/xsd/entity/PlanTypes">true</NS6:Success>
                    <nspl:ValidationResults />
                    <nspl:OutStandard xmlns:NS53="http://GrupoSancorSeguros/xsd/entity/CommonTypes">true</nspl:OutStandard>
                    <nspl:HasTrackingEquipment xmlns:NS51="http://GrupoSancorSeguros/xsd/entity/CommonTypes">false</nspl:HasTrackingEquipment>
                    <NS10:HasTelematic xmlns:NS10="http://GrupoSancorSeguros/xsd/entity/PlanTypes">false</NS10:HasTelematic>
                    <nspl:VehicleValuation>262000</nspl:VehicleValuation>
                    <nspl:AdditionalsCalculationResult>
                        <nspl:AdditionalsCalculationBase />
                    </nspl:AdditionalsCalculationResult>
                    <NS8:PricingId xmlns:NS8="http://GrupoSancorSeguros/xsd/entity/PlanTypes">52474678</NS8:PricingId>
                    <nspl:PricingIdAPF>52474676</nspl:PricingIdAPF>
                    <nspl:TaxBases>
                        <nspl:TaxBase>
                            <nspl:IvaMonthly>774.52</nspl:IvaMonthly>
                            <nspl:Iva>9294.21</nspl:Iva>
                        </nspl:TaxBase>
                    </nspl:TaxBases>
                    <nspl:PrimaTotal>
                        <nspl:PurePremiumMonthlyTotal>759.05</nspl:PurePremiumMonthlyTotal>
                        <nspl:PurePremiumTotal>9108.56</nspl:PurePremiumTotal>
                    </nspl:PrimaTotal>
                </nspm:Plan>
            </nspm:Plans>
            <nspm:Price>
                <NS1:RelationQuotationId xmlns:NS1="http://GrupoSancorSeguros/xsd/entity/PriceTypes">5072201</NS1:RelationQuotationId>
                <NS2:QuotationId xmlns:NS2="http://GrupoSancorSeguros/xsd/entity/PriceTypes">413740035</NS2:QuotationId>
            </nspm:Price>
            <nspm:Result>
                <nsc:ErrorCode>SOA-GSS-0000</nsc:ErrorCode>
                <nsc:ErrorMsg>Success</nsc:ErrorMsg>
            </nspm:Result>
        </nspm:NewVehicle_Rs>
    </soapenv:Body>
</soapenv:Envelope>

 */