/**
 * Servicio que se encarga de realizar una cotizacion del producto Accidentes Personales de la Compañia Sancor
 */
public without sharing class SancorCotizarAPWebService {

    public Response serviceResponse { get; private set; }

    public SancorCotizarAPWebService() {
        this.serviceResponse = new Response();
    }

    public Boolean cotizar (CotizadorAPIRequest cotizacion, Map<String, String> autenticacion, Enumerator.Producto apType) {
        this.serviceResponse.hasError = false;

        if ( ! this.isAuthenticated(autenticacion) ) {
            return ! this.serviceResponse.hasError;
        }

        String body = '';
        String method;

        try {
            method = this.getMethodName(apType);
            body = this.createBody(cotizacion, apType, method);
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            this.serviceResponse.hasError = true;
            this.serviceResponse.message = 'Error al crear el request: '+ex.getTypeName() +'-'+ ex.getMessage();
        }

        if ( ! this.serviceResponse.hasError ) {
            WSParameter bodyParameter = new WSParameter('body', body , true, false);
            WSParameter[] headers = new List<WSParameter> {
            	new WSParameter('TokenType', autenticacion.get('TokenType'), false, false),
            	new WSParameter('Token', autenticacion.get('Token'), false, false),
                new WSParameter('User', autenticacion.get('User'), false, false),
                new WSParameter('Content-Length', String.valueOf(body.length()), false, false)
            };

            String endpoint = EndpointResolver.getEndpoint('Sancor_PersonalAccidentSvc_Preproduccion', 'Sancor_PersonalAccidentSvc_Produccion').Url__c;

            RestWS webServiceCaller = new RestWS(endpoint, 'POST' , null, bodyParameter, headers);

            this.serviceResponse.methodName = method;
            this.serviceResponse = (Response) webServiceCaller.invoke(this.serviceResponse);
        }

        return ! this.serviceResponse.hasError;
    }

    @TestVisible
    private String createBody (CotizadorAPIRequest cotizacion, Enumerator.Producto productoACotizar, String method) {
        /* HARDCODED VALUES */
        String idRelacion = '0';
        String codCiudad = '0';
        String codMoneda = '1'; // Pesos
        String codCondicionIVA = '4'; // Consumidor Final
        String codOficina = '200';
        String codProducto = this.getProductCode(productoACotizar);
        String codPeriodoValidez = '1';
        String cantidadCuotas = '0';
        String idCotizacion  = '0';
        String actividadExtentaSellos = 'false';
        String codigoSumas = '0';

        String body = '<?xml version="1.0" encoding="UTF-8"?>'
        +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/'+method+'/request" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">'
        +    '<soapenv:Header />'
        +    '<soapenv:Body>'
        +        '<req:'+method+'Request>'
        +            '<RelationQuotationId>'+idRelacion+'</RelationQuotationId>'
        +            '<PolicyTypeId>'+cotizacion.codigoPolizaTipo+'</PolicyTypeId>'
        +            '<CityId>'+codCiudad+'</CityId>'
        +            '<ClientIdentify>'
        +                '<DocumentNumber>'+cotizacion.numeroDeDocumento+'</DocumentNumber>'
        +                '<DocumentType>'+cotizacion.tipoDeDocumento+'</DocumentType>'
        +            '</ClientIdentify>';

        if(cotizacion.codigosDeModuloDeCoberturas.isEmpty()){
            body += '<CoverModuleCode/>';
        } else {
            body += '<CoverModuleCode>'+String.join(cotizacion.codigosDeModuloDeCoberturas,',')+'</CoverModuleCode>';
        }

        body +=      '<CurrencyId>'+codMoneda+'</CurrencyId>'
        +            '<EffectDate>'+cotizacion.fechaEfectiva.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</EffectDate>'
        +            '<ExpirationDate>'+cotizacion.fechaExpiracion.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</ExpirationDate>'
        +            '<IvaConditionId>'+codCondicionIVA+'</IvaConditionId>'
        +            '<OfficeId>'+codOficina+'</OfficeId>'
        +            '<PaymentFrequencyId>'+cotizacion.frecuenciaDePago+'</PaymentFrequencyId>'
        +            '<OrganizerId>'+cotizacion.numeroOrganizacion+'</OrganizerId>'
        +            '<ProducerId>'+cotizacion.numeroProductor+'</ProducerId>'
        +            '<ProductId>'+codProducto+'</ProductId>'
        +            '<PeriodOfValidityId>'+codPeriodoValidez+'</PeriodOfValidityId>'
        +            '<FeeId>'+cotizacion.cuotas+'</FeeId>'
        +            '<QuotaQuantity>'+cantidadCuotas+'</QuotaQuantity>'
        +            '<QuotationId>'+idCotizacion+'</QuotationId>'
        +            '<RespectClientIvaCondition>'+cotizacion.respetarCondicionIVACliente+'</RespectClientIvaCondition>'
        +            '<SealExemptActivity>'+actividadExtentaSellos+'</SealExemptActivity>';

        if(cotizacion.grupoEstadistico != null){
            body += '<StatisticalCode>'+String.valueOf(cotizacion.grupoEstadistico)+'</StatisticalCode>';
        } else {
            body += '<StatisticalCode>0</StatisticalCode>';
        }

        body +=      '<ZipCode>'+cotizacion.codigoPostal+'</ZipCode>'
        +            '<PersonInsured>'
        +                '<Profession>'+cotizacion.personasAseguradas.codigoProfesion+'</Profession>'
        +                '<Classification>'+cotizacion.personasAseguradas.codigoClasificacion+'</Classification>';

        if(cotizacion.personasAseguradas.codigoTarea != null){
            body += '<Task>'+cotizacion.personasAseguradas.codigoTarea+'</Task>';
        }

        body += '<Rank>';

        for (CotizadorAPIRequest.RangoEtario rangoEtario : cotizacion.personasAseguradas.rangoEtario) {
            switch on rangoEtario.tipoDeRango {
                when EDAD_16_A_70 {
                    body += '<Rank16To70>'
                    +           '<Selected>'+rangoEtario.seleccionado+'</Selected>'
                    +           '<Quantity>'+rangoEtario.cantidadDePersonas+'</Quantity>'
                    +           loadSumas(rangoEtario.sumas, productoACotizar, codigoSumas)
                    +       '</Rank16To70>';
                }
                when EDAD_71_A_75 {
                    body += '<Rank71To75>'
                    +           '<Selected>'+rangoEtario.seleccionado+'</Selected>'
                    +           '<Quantity>'+rangoEtario.cantidadDePersonas+'</Quantity>'
                    +           loadSumas(rangoEtario.sumas, productoACotizar, codigoSumas)
                    +       '</Rank71To75>';
                }
                when else {
                    body += '<Rank76To800>'
                    +           '<Selected>'+rangoEtario.seleccionado+'</Selected>'
                    +           '<Quantity>'+rangoEtario.cantidadDePersonas+'</Quantity>'
                    +           loadSumas(rangoEtario.sumas, productoACotizar, codigoSumas)
                    +       '</Rank76To800>';
                }
            }
        }

        body += '</Rank>'
        +   '</PersonInsured>';

        if ( cotizacion.descuentos != null && ! cotizacion.descuentos.isEmpty() ) {
            body += '<DiscountCustomizations>';
            for (CotizadorAPIRequest.Descuento descuento : cotizacion.descuentos) {
                body += '<DiscountCustomization>'
                    +       '<DiscountNumber>'+descuento.codigoDeDescuento+'</DiscountNumber>'
                    +       '<Rate>'+descuento.porcentaje+'</Rate>'
                    +   '</DiscountCustomization>';
            }
            body += '</DiscountCustomizations>';
        } else {
            body += '<DiscountCustomizations />';
        }

        body += '</req:'+method+'Request>'
        +    '</soapenv:Body>'
        +'</soapenv:Envelope>';
        return body;
    }

    private String loadSumas(List<CotizadorAPIRequest.SumaAsegurada> sumas, Enumerator.Producto productoACotizar, String codigoSuma){
        Integer montoSuma = 0;
        String sumasBody = '';

        for (CotizadorAPIRequest.SumaAsegurada suma : sumas) {
            switch on suma.tipoDeSuma {
                when MUERTE {
                    sumasBody +=
                        '<DeathCoverAmount>'
                    +       '<Code>'+codigoSuma+'</Code>'
                    +       '<Value>'+ ( productoACotizar == Enumerator.Producto.AP_24HS_MODULADO ? montoSuma : suma.monto) +'</Value>'
                    +   '</DeathCoverAmount>';
                } when ASISTENCIA_MEDICA {
                    sumasBody +=
                        '<MedicalAssistanceAmount>'
                    +       '<Code>'+ codigoSuma +'</Code>'
                    +       '<Value>'+ suma.monto +'</Value>'
                    +   '</MedicalAssistanceAmount>';
                } when COSTOS_ENTIERRO {
                    sumasBody +=
                        '<BurialExpenses>'
                    +       '<Code>'+ codigoSuma +'</Code>'
                    +       '<Value>'+ suma.monto +'</Value>'
                    +   '</BurialExpenses>';
                } when INTERNACION_DIARIA {
                    sumasBody +=
                        '<DailyIncomeInternation>'
                    +       '<Code>'+ codigoSuma +'</Code>'
                    +       '<Value>'+ suma.monto +'</Value>'
                    +   '</DailyIncomeInternation>';
                } when SUBVENCION_MUERTE {
                    sumasBody +=
                        '<DeathGrant>'
                    +       '<Code>'+ codigoSuma +'</Code>'
                    +       '<Value>'+ suma.monto +'</Value>'
                    +   '</DeathGrant>';
                } when MONTO_FIJO {
                    sumasBody +=
                        '<FixAmount>'
                    +       '<Code>'+ codigoSuma +'</Code>'
                    +       '<Value>'+ suma.monto +'</Value>'
                    +   '</FixAmount>';
                }
            }
        }
        return sumasBody;
    }

    @TestVisible
    private String getMethodName(Enumerator.Producto productoACotizar){
        String methodName = '';

        switch on productoACotizar {
            when AP_24HS_MODULADO {
                methodName = 'NewAP24Modulate';
            } when AP_INTEGRO_MAX {
                methodName = 'NewIntegroMax';
            } when AP_OCASION_TRABAJO {
                methodName = 'NewOccasionOfWork';
            }
        }
        return methodName;
    }

    private String getProductCode(Enumerator.Producto productoACotizar){
        String productCode = '';

        switch on productoACotizar {
            when AP_24HS_MODULADO {
                productCode = '387';
            } when AP_INTEGRO_MAX {
                productCode = '711';
            } when AP_OCASION_TRABAJO {
                productCode = '555';
            }
        }
        return productCode;
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

    public class Response extends WSResult  {

        public CotizadorAPIResponse cotizacion { get; set; }
        public String methodName { get; set; }
        public String faultString { get; private set; }
        public String faultCode { get; private set; }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde un http 2XX */
        public override void processResponse(HttpResponse response) {
            this.cotizacion = new CotizadorAPIResponse();
            String bodyString = response.getBody();

            this.cotizacion.idCotizacionRelacion = Integer.valueOf( XMLParser.getNode( bodyString, 'Body/'+this.methodName+'Response/RelationQuotationId' ).getText() );

            this.processAgeRank(
                XMLParser.getNode( bodyString, 'Body/'+this.methodName+'Response/Rank16To70' ),
                Enumerator.RangoEtario.EDAD_16_A_70
            );
            this.processAgeRank(
                XMLParser.getNode( bodyString, 'Body/'+this.methodName+'Response/Rank71To75' ),
                Enumerator.RangoEtario.EDAD_71_A_75
            );
            this.processAgeRank(
                XMLParser.getNode( bodyString, 'Body/'+this.methodName+'Response/Rank76To800' ),
                Enumerator.RangoEtario.EDAD_76_A_80
            );
        }

        private void processAgeRank(Dom.xmlNode rankNode, Enumerator.RangoEtario ageRank) {
            if( rankNode != null ){
                CotizadorAPIResponse.Plan plan = new CotizadorAPIResponse.Plan();
                plan.cotizacionExitosa = Boolean.valueOf( XMLParser.getNode( rankNode, 'Success' ).getText() );
                plan.idPreciosValor = Integer.valueOf( XMLParser.getNode( rankNode, 'PricingId/KeyValuePairOflonglong/value' ).getText() );
                plan.premioMensual = Decimal.valueOf( XMLParser.getNode( rankNode, 'PremioMensual' ).getText() );
                plan.idCotizacion = Integer.valueOf( XMLParser.getNode( rankNode, 'QuotationId' ).getText() );
                plan.premioTotal = Decimal.valueOf( XMLParser.getNode( rankNode, 'PremioSegunVigencia' ).getText() );
                plan.ivaMensual = Decimal.valueOf( XMLParser.getNode( rankNode, 'BasesImponibles/TaxableBases/IvaMensual' ).getText() );
                plan.idPrecios = Integer.valueOf( XMLParser.getNode( rankNode, 'PricingId/KeyValuePairOflonglong/key' ).getText() );
                plan.ivaTotal = Decimal.valueOf( XMLParser.getNode( rankNode, 'BasesImponibles/TaxableBases/IvaSegunVigencia' ).getText() );
                plan.rango =  ageRank;

                CotizadorAPIResponse.Validacion validacion;
                for ( Dom.xmlNode resultadoValidacion : XMLParser.getNode( rankNode, 'ValidationResults' ).getChildElements() ) {
                    validacion = new CotizadorAPIResponse.Validacion();
                    validacion.mensajeDeError = XMLParser.getNode( resultadoValidacion, 'ErrorMessage' ).getText();
                    validacion.nivel = XMLParser.getNode( resultadoValidacion, 'Level' ).getText();
                    plan.validaciones.add(validacion);
                }

                CotizadorAPIResponse.SumaAsegurada suma;
                for ( Dom.xmlNode sumasCotizadas : XMLParser.getNode( rankNode, 'FinallyCalculationResult' ).getChildElements() ) {
                    suma = new CotizadorAPIResponse.SumaAsegurada();
                    suma.primaPuraMensual = Decimal.valueOf(XMLParser.getNode( sumasCotizadas, 'PrimaMensual' ).getText());
                    suma.primaPuraTotal = Decimal.valueOf(XMLParser.getNode( sumasCotizadas, 'PrimaSegunVigencia' ).getText());
                    suma.detalleCodigo = Integer.valueOf(XMLParser.getNode( sumasCotizadas, 'DetalleInt' ).getText());
                    suma.descripcion = XMLParser.getNode( sumasCotizadas, 'Descripcion' ).getText();
                    suma.detalleTipo = XMLParser.getNode( sumasCotizadas, 'TipoDetalle' ).getText();
                    suma.capital = Decimal.valueOf(XMLParser.getNode( sumasCotizadas, 'Capital' ).getText());
                    suma.detalle = XMLParser.getNode( sumasCotizadas, 'Detalle' ).getText();
                    plan.sumasAseguradas.add(suma);
                }
                this.cotizacion.planes.add(plan);
            }
        }

        public override void processErrorResponse ( HttpResponse response ) {
            String bodyString = response.getBody();

            if ( XMLParser.getNode( bodyString, 'Body/Fault' ) != null ) {

                this.faultCode = XMLParser.getNode( bodyString, 'Body/Fault/faultcode' ).getText();

                this.faultString = XMLParser.getNode( bodyString, 'Body/Fault/faultstring' ).getText();
            }
        }
    }
}

/**
 * RESPUESTA EXITOSA

<?xml version="1.0" encoding="UTF-8"?>
<NS1:Envelope xmlns:NS1="http://schemas.xmlsoap.org/soap/envelope/">
    <NS1:Header>
        <NS2:responseHeader xmlns:NS2="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
            <messageId>58759b56-67b4-11eb-b43a-ac14162e0000</messageId>
            <timestamp>2021-02-05T10:16:26.227392-03:00</timestamp>
            <responseStatus>
                <statusCode>Success</statusCode>
            </responseStatus>
        </NS2:responseHeader>
    </NS1:Header>
    <NS1:Body>
        <NS3:NewAP24ModulateResponse xmlns:NS3="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/NewAP24Modulate/response">
            <RelationQuotationId>0</RelationQuotationId>
            <Rank16To70>
                <BasesImponibles>
                    <TaxableBases>
                        <IvaMensual>287.22</IvaMensual>
                        <IvaSegunVigencia>3446.55</IvaSegunVigencia>
                    </TaxableBases>
                </BasesImponibles>
                <FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>700000</Capital>
                        <Descripcion>Muerte Accidental</Descripcion>
                        <Detalle>Prima</Detalle>
                        <DetalleInt>1</DetalleInt>
                        <PrimaMensual>40.06</PrimaMensual>
                        <PrimaSegunVigencia>480.69</PrimaSegunVigencia>
                        <TipoDetalle>Cobertura</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>700000</Capital>
                        <Descripcion>Invalidez Total y/o Parcial Permanente por Accidente</Descripcion>
                        <Detalle>Prima</Detalle>
                        <DetalleInt>2</DetalleInt>
                        <PrimaMensual>40.06</PrimaMensual>
                        <PrimaSegunVigencia>480.69</PrimaSegunVigencia>
                        <TipoDetalle>Cobertura</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>1</Capital>
                        <Descripcion>Llamando al Doctor</Descripcion>
                        <Detalle>Prima</Detalle>
                        <DetalleInt>15</DetalleInt>
                        <PrimaMensual>0.00</PrimaMensual>
                        <PrimaSegunVigencia>0.00</PrimaSegunVigencia>
                        <TipoDetalle>Cobertura</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>0</Capital>
                        <Descripcion>Recargo administrativo</Descripcion>
                        <Detalle>Prima</Detalle>
                        <DetalleInt>61</DetalleInt>
                        <PrimaMensual>11.62</PrimaMensual>
                        <PrimaSegunVigencia>139.40</PrimaSegunVigencia>
                        <TipoDetalle>RecargosComerciales</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>0</Capital>
                        <Descripcion>Fondo Acción Solidaria (FAS)</Descripcion>
                        <Detalle>Prima</Detalle>
                        <DetalleInt>62</DetalleInt>
                        <PrimaMensual>0.80</PrimaMensual>
                        <PrimaSegunVigencia>9.61</PrimaSegunVigencia>
                        <TipoDetalle>RecargosComerciales</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>0</Capital>
                        <Descripcion>Derecho de emisión</Descripcion>
                        <Detalle>Prima</Detalle>
                        <DetalleInt>63</DetalleInt>
                        <PrimaMensual>3.20</PrimaMensual>
                        <PrimaSegunVigencia>38.46</PrimaSegunVigencia>
                        <TipoDetalle>RecargosComerciales</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>0</Capital>
                        <Descripcion>Capital Social</Descripcion>
                        <Detalle>CapitalSocial</Detalle>
                        <DetalleInt>65</DetalleInt>
                        <PrimaMensual>8.87</PrimaMensual>
                        <PrimaSegunVigencia>103.40</PrimaSegunVigencia>
                        <TipoDetalle>RecargosComerciales</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>0</Capital>
                        <Descripcion>IVA General</Descripcion>
                        <Detalle>IvaGeneral</Detalle>
                        <DetalleInt>102</DetalleInt>
                        <PrimaMensual>20.10</PrimaMensual>
                        <PrimaSegunVigencia>241.26</PrimaSegunVigencia>
                        <TipoDetalle>Impuesto</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>0</Capital>
                        <Descripcion>Tasa Uniforme de SSN</Descripcion>
                        <Detalle>TasasImpuestos</Detalle>
                        <DetalleInt>106</DetalleInt>
                        <PrimaMensual>0.57</PrimaMensual>
                        <PrimaSegunVigencia>6.89</PrimaSegunVigencia>
                        <TipoDetalle>Impuesto</TipoDetalle>
                    </FinallyCalculationResult>
                    <FinallyCalculationResult>
                        <Capital>0</Capital>
                        <Descripcion>Impuesto a los sellos</Descripcion>
                        <Detalle>ImpuestoSellos</Detalle>
                        <DetalleInt>101</DetalleInt>
                        <PrimaMensual>0.72</PrimaMensual>
                        <PrimaSegunVigencia>8.62</PrimaSegunVigencia>
                        <TipoDetalle>Impuesto</TipoDetalle>
                    </FinallyCalculationResult>
                </FinallyCalculationResult>
                <PremioMensual>378.00</PremioMensual>
                <PremioSegunVigencia>4527.09</PremioSegunVigencia>
                <PricingId>
                    <KeyValuePairOflonglong>
                        <key>52556847</key>
                        <value>0</value>
                    </KeyValuePairOflonglong>
                </PricingId>
                <QuotationId>0</QuotationId>
                <Success>true</Success>
                <ValidationResults>
                    <ValidationResult>
                        <ErrorMessage>El grupo estadístico es inexistente o no aplica al intermediario.</ErrorMessage>
                        <Level>Warning</Level>
                        <MemberNames />
                    </ValidationResult>
                </ValidationResults>
            </Rank16To70>
        </NS3:NewAP24ModulateResponse>
    </NS1:Body>
</NS1:Envelope>
 */

/**
 * AP 24HS MODULADO REQUEST EXAMPLE

<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/NewAP24Modulate/request" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
    <soapenv:Header />
    <soapenv:Body>
        <req:NewAP24ModulateRequest>
            <RelationQuotationId>0</RelationQuotationId>
            <PolicyTypeId>1</PolicyTypeId>
            <CityId>0</CityId>
            <ClientIdentify>
                <DocumentNumber>0</DocumentNumber>
                <DocumentType>D</DocumentType>
            </ClientIdentify>
            <CoverModuleCode>18</CoverModuleCode>
            <CurrencyId>1</CurrencyId>
            <EffectDate>2020-09-02T00:00:00</EffectDate>
            <ExpirationDate>2021-09-02T00:00:00</ExpirationDate>
            <IvaConditionId>4</IvaConditionId>
            <OfficeId>200</OfficeId>
            <PaymentFrequencyId>5</PaymentFrequencyId>
            <OrganizerId>111111</OrganizerId>
            <ProducerId>222222</ProducerId>
            <ProductId>387</ProductId>
            <PeriodOfValidityId>1</PeriodOfValidityId>
            <FeeId>0</FeeId>
            <QuotaQuantity>0</QuotaQuantity>
            <QuotationId>0</QuotationId>
            <RespectClientIvaCondition>false</RespectClientIvaCondition>
            <SealExemptActivity>false</SealExemptActivity>
            <StatisticalCode>0</StatisticalCode>
            <ZipCode>2322</ZipCode>
            <PersonInsured>
                <Profession>9</Profession>
                <Classification>42</Classification>
                <Task>0</Task>
                <Rank>
                    <Rank16To70>
                        <Selected>true</Selected>
                        <Quantity>3</Quantity>
                        <DeathCoverAmount>
                            <Code>0</Code>
                            <Value>0</Value>
                        </DeathCoverAmount>
                    </Rank16To70>
                    <Rank71To75>
                        <Selected>false</Selected>
                        <Quantity>0</Quantity>
                        <DeathCoverAmount>
                            <Code>0</Code>
                            <Value>0</Value>
                        </DeathCoverAmount>
                    </Rank71To75>
                    <Rank76To800>
                        <Selected>false</Selected>
                        <Quantity>0</Quantity>
                        <DeathCoverAmount>
                            <Code>0</Code>
                            <Value>0</Value>
                        </DeathCoverAmount>
                    </Rank76To800>
                </Rank>
            </PersonInsured>
            <DiscountCustomizations>
                <DiscountCustomization>
                    <DiscountNumber>0</DiscountNumber>
                    <Rate>0</Rate>
                </DiscountCustomization>
            </DiscountCustomizations>
        </req:NewAP24ModulateRequest>
    </soapenv:Body>
</soapenv:Envelope>

 */

/** AP INTEGRO MAX REQUEST EXAMPLE

<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/NewIntegroMax/request" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
   <soapenv:Header />
   <soapenv:Body>
      <req:NewIntegroMaxRequest>
         <RelationQuotationId>0</RelationQuotationId>
         <PolicyTypeId>2</PolicyTypeId>
         <CityId>0</CityId>
         <ClientIdentify>
            <DocumentNumber>0</DocumentNumber>
            <DocumentType>D</DocumentType>
         </ClientIdentify>
         <CoverModuleCode>4</CoverModuleCode>
         <CurrencyId>1</CurrencyId>
         <EffectDate>2020-09-15T00:00:00</EffectDate>
         <ExpirationDate>2021-09-15T00:00:00</ExpirationDate>
         <IvaConditionId>4</IvaConditionId>
         <OfficeId>200</OfficeId>
         <PaymentFrequencyId>5</PaymentFrequencyId>
         <OrganizerId>111111</OrganizerId>
         <ProducerId>222222</ProducerId>
         <ProductId>711</ProductId>
         <PeriodOfValidityId>1</PeriodOfValidityId>
         <FeeId>0</FeeId>
         <QuotaQuantity>0</QuotaQuantity>
         <QuotationId>0</QuotationId>
         <RespectClientIvaCondition>false</RespectClientIvaCondition>
         <SealExemptActivity>false</SealExemptActivity>
         <StatisticalCode>0</StatisticalCode>
         <ZipCode>2322</ZipCode>
         <PersonInsured>
            <Profession>8</Profession>
            <Classification>20016</Classification>
            <Rank>
               <Rank16To70>
                  <Selected>true</Selected>
                  <Quantity>5</Quantity>
                  <DeathCoverAmount>
                     <Code>0</Code>
                     <Value>500000</Value>
                  </DeathCoverAmount>
                  <MedicalAssistanceAmount>
                     <Code>0</Code>
                     <Value>100000</Value>
                  </MedicalAssistanceAmount>
                  <BurialExpenses>
                     <Code>0</Code>
                     <Value>5000</Value>
                  </BurialExpenses>
                  <DailyIncomeInternation>
                     <Code>0</Code>
                     <Value>10000</Value>
                  </DailyIncomeInternation>
               </Rank16To70>
               <Rank71To75>
                  <Selected>false</Selected>
                  <Quantity>0</Quantity>
                  <DeathCoverAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DeathCoverAmount>
                  <MedicalAssistanceAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </MedicalAssistanceAmount>
                  <BurialExpenses>
                     <Code>0</Code>
                     <Value>0</Value>
                  </BurialExpenses>
                  <DailyIncomeInternation>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DailyIncomeInternation>
               </Rank71To75>
               <Rank76To800>
                  <Selected>false</Selected>
                  <Quantity>0</Quantity>
                  <DeathCoverAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DeathCoverAmount>
                  <MedicalAssistanceAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </MedicalAssistanceAmount>
                  <BurialExpenses>
                     <Code>0</Code>
                     <Value>0</Value>
                  </BurialExpenses>
                  <DailyIncomeInternation>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DailyIncomeInternation>
               </Rank76To800>
            </Rank>
         </PersonInsured>
         <DiscountCustomizations>
            <DiscountCustomization>
               <DiscountNumber>0</DiscountNumber>
               <Rate>0</Rate>
            </DiscountCustomization>
         </DiscountCustomizations>
      </req:NewIntegroMaxRequest>
   </soapenv:Body>
</soapenv:Envelope>
 */

 /** AP OCASION DE TRABAJO REQUEST EXAMPLE

<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/NewOccasionOfWork/request" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
   <soapenv:Header />
   <soapenv:Body>
      <req:NewOccasionOfWorkRequest>
         <RelationQuotationId>0</RelationQuotationId>
         <PolicyTypeId>1</PolicyTypeId>
         <CityId>0</CityId>
         <ClientIdentify>
            <DocumentNumber>0</DocumentNumber>
            <DocumentType>D</DocumentType>
         </ClientIdentify>
         <CoverModuleCode>1</CoverModuleCode>
         <CurrencyId>1</CurrencyId>
         <EffectDate>2020-09-15T00:00:00</EffectDate>
         <ExpirationDate>2021-09-15T00:00:00</ExpirationDate>
         <IvaConditionId>4</IvaConditionId>
         <OfficeId>200</OfficeId>
         <PaymentFrequencyId>5</PaymentFrequencyId>
         <OrganizerId>111111</OrganizerId>
         <ProducerId>222222</ProducerId>
         <ProductId>555</ProductId>
         <PeriodOfValidityId>1</PeriodOfValidityId>
         <FeeId>0</FeeId>
         <QuotaQuantity>0</QuotaQuantity>
         <QuotationId>0</QuotationId>
         <RespectClientIvaCondition>false</RespectClientIvaCondition>
         <SealExemptActivity>false</SealExemptActivity>
         <StatisticalCode>0</StatisticalCode>
         <ZipCode>2322</ZipCode>
         <PersonInsured>
            <Profession>8</Profession>
            <Classification>38</Classification>
            <Task>3</Task>
            <Rank>
               <Rank16To70>
                  <Selected>true</Selected>
                  <Quantity>2</Quantity>
                  <DeathCoverAmount>
                     <Code>0</Code>
                     <Value>1000000</Value>
                  </DeathCoverAmount>
                  <MedicalAssistanceAmount>
                     <Code>0</Code>
                     <Value>100000</Value>
                  </MedicalAssistanceAmount>
                  <DeathGrant>
                     <Code>0</Code>
                     <Value>20000</Value>
                  </DeathGrant>
                  <DailyIncomeInternation>
                     <Code>0</Code>
                     <Value>10000</Value>
                  </DailyIncomeInternation>
                  <FixAmount>
                     <Code>0</Code>
                     <Value>5000</Value>
                  </FixAmount>
               </Rank16To70>
               <Rank71To75>
                  <Selected>false</Selected>
                  <Quantity>0</Quantity>
                  <DeathCoverAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DeathCoverAmount>
                  <MedicalAssistanceAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </MedicalAssistanceAmount>
                  <DeathGrant>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DeathGrant>
                  <DailyIncomeInternation>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DailyIncomeInternation>
                  <FixAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </FixAmount>
               </Rank71To75>
               <Rank76To800>
                  <Selected>false</Selected>
                  <Quantity>0</Quantity>
                  <DeathCoverAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DeathCoverAmount>
                  <MedicalAssistanceAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </MedicalAssistanceAmount>
                  <DeathGrant>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DeathGrant>
                  <DailyIncomeInternation>
                     <Code>0</Code>
                     <Value>0</Value>
                  </DailyIncomeInternation>
                  <FixAmount>
                     <Code>0</Code>
                     <Value>0</Value>
                  </FixAmount>
               </Rank76To800>
            </Rank>
         </PersonInsured>
         <DiscountCustomizations>
            <DiscountCustomization>
               <DiscountNumber>0</DiscountNumber>
               <Rate>0</Rate>
            </DiscountCustomization>
         </DiscountCustomizations>
      </req:NewOccasionOfWorkRequest>
   </soapenv:Body>
</soapenv:Envelope>
  */