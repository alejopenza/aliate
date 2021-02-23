public without sharing class SancorCrearPolizaWebService {

    public Response serviceResponse { get; private set; }

    public SancorCrearPolizaWebService() {
        this.serviceResponse = new Response();
    }

    public Boolean emitir (EmisionAPIRequest polizaAEmitir, Map<String, String> autenticacion, Enumerator.Ramo ramo, Enumerator.Producto producto) {
        this.serviceResponse.hasError = false;

        if ( ! this.isAuthenticated(autenticacion) ) {
            return ! this.serviceResponse.hasError;
        }

        String body = '';

        try {
            body = this.createBody(polizaAEmitir, ramo, producto);
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            this.serviceResponse.hasError = true;
            this.serviceResponse.message = 'Error al crear el request: '+ex.getTypeName() +'-'+ ex.getMessage();
        }

        if ( ! this.serviceResponse.hasError ) {
            WSParameter bodyParameter = new WSParameter('body', body , true, false);
            WSParameter[] headers = new List<WSParameter> {
                new WSParameter('Authorization', (autenticacion.get('TokenType')+' '+autenticacion.get('Token')), false, false),
                new WSParameter('Content-Type', 'text/xml', false, false),
                new WSParameter('Content-Length', String.valueOf(body.length()), false, false)
            };

            String endpoint = EndpointResolver.getEndpoint('Sancor_PolicyIssuanceSvc_Preproduccion', 'Sancor_PolicyIssuanceSvc_Produccion').Url__c;

            RestWS webServiceCaller = new RestWS(endpoint, 'POST' , null, bodyParameter, headers);

            this.serviceResponse = (Response) webServiceCaller.invoke(this.serviceResponse);
        }

        return ! this.serviceResponse.hasError;
    }

    @TestVisible
    private String createBody(EmisionAPIRequest cotizacion,  Enumerator.Ramo ramo, Enumerator.Producto producto){
        // Valores Fijos
        Map<String,String> hardcodedValuesByName =
            new Map<String,String> {
                'porcentajeDescuento' => '99',
                'moneda' => '1',
                'policyId' => '0',
                'otraDireccion' => 'true',
                'direccionParticular' => 'false'
            };

        String body =
        '<soapenv:Envelope xmlns:col="http://gruposancorseguros.com/ents/SOI/Collections/" xmlns:ent="http://gruposancorseguros.com/ents/SOI/Entities/" xmlns:p1="http://www.w3.org/2001/XMLSchema-instance" xmlns:pol="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        +   '<soapenv:Header />'
        +   '<soapenv:Body>'
        +       '<pol:CreateSinglePolicy>'
        +           '<pol:request xmlns:con="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">'
        +               '<con:CertificateData>'
        +                   this.createAditionalCoverTag(cotizacion.informacionCertificado.adicionales)
        +                   '<con:BillableClientRoleId>'+cotizacion.informacionCertificado.clienteFacturable+'</con:BillableClientRoleId>'
        +                   this.createBranchDataTag(cotizacion.informacionCertificado, hardcodedValuesByName, producto, ramo)
        +                   this.createClientTag(cotizacion.informacionCertificado.clientes);

        if(String.isNotBlank(cotizacion.informacionCertificado.comentarios)){
            body += '<con:Comments>'+cotizacion.informacionCertificado.comentarios+'</con:Comments>';
        } else {
            body += '<con:Comments/>';
        }

        body +=              '<con:CoverModuleCode>'+cotizacion.informacionCertificado.codigoModulo+'</con:CoverModuleCode>'
        +                    '<con:Covers xsi:nil="true"/>'
        +                    this.createDebitDataTag(cotizacion.informacionCertificado.pago, cotizacion.informacionCertificado.codigoPago)
        +                    '<con:DebitTypeId>'+cotizacion.informacionCertificado.codigoPago+'</con:DebitTypeId>'
        +                    this.createElectronicDispatchTag(cotizacion.informacionCertificado.infoEnvioDigital)
        +                    this.createInsuredBasicCapitalsTag(cotizacion.informacionCertificado.capitalesAsegurados)
        +                    this.createInsuredGoodTag(cotizacion.informacionCertificado.bienesAsegurados)
        +                    '<con:IsEmission xsi:nil="true"/>'
        +                    '<con:PaymentFrequencyId>'+cotizacion.informacionCertificado.codigoFrecuenciaPago+'</con:PaymentFrequencyId>'
        +                    '<con:PolicyId>'+hardcodedValuesByName.get('policyId')+'</con:PolicyId>'
        +                    '<con:Quota>'+cotizacion.informacionCertificado.cuotas+'</con:Quota>' // todo tiene que ser cero si estano lleva cuotas
        +                    '<con:Quotation xsi:nil="true"/>'
        +                    this.createRiskAddressTag(cotizacion.informacionCertificado.direccionRiesgo)
        +                    '<con:Since>'+cotizacion.informacionCertificado.vigenciaDesde.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss')+'</con:Since>'
        +                    this.createOperatoriaEspecialTag(cotizacion.informacionCertificado.infoOperatoriaEspecial)
        +                    this.createDescuentosEspecialesTag(cotizacion.informacionCertificado.infoDescuentosEspeciales)
        +                    '<con:Thru>'+cotizacion.informacionCertificado.vigenciaHasta.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss')+'</con:Thru>'
        +                '</con:CertificateData>'
        +                '<con:CurrencyId>'+hardcodedValuesByName.get('moneda')+'</con:CurrencyId>'
        +                '<con:OrganizerNumber>'+cotizacion.numeroOrganizador+'</con:OrganizerNumber>'
        +                '<con:ProducerNumber>'+cotizacion.numeroProductor+'</con:ProducerNumber>'
        +                '<con:ProductId>'+cotizacion.codigoProducto+'</con:ProductId>'
        +                '<con:RenewalTypeId>'+cotizacion.tipoRenovacionPoliza+'</con:RenewalTypeId>';

        if( cotizacion.codigoGrupoEstadistico != null ){
            body += '<con:StatisticCodeIds>'+cotizacion.codigoGrupoEstadistico+'</con:StatisticCodeIds>';
        } else {
            body += '<con:StatisticCodeIds>0</con:StatisticCodeIds>';
        }

        body +=      '</pol:request>'
        +        '</pol:CreateSinglePolicy>'
        +    '</soapenv:Body>'
        +'</soapenv:Envelope>';

        return body;
    }

    private String createInsuredGoodTag (List<EmisionAPIRequest.InfoBienAsegurado> bienesAsegurados) {
        String insuredGoodsTag = '<con:InsuredGoods xsi:nil="true"/>';

        if ( bienesAsegurados != null && ! bienesAsegurados.isEmpty() ) {
            insuredGoodsTag += '<con:InsuredGood>';

            for (EmisionAPIRequest.InfoBienAsegurado bienAsegurado : bienesAsegurados) {
                insuredGoodsTag += '<ent:InsuredBasicCapitals>'
                    +    '<ent:Description>'+bienAsegurado.descripcion+'</ent:Description>'
                    +    '<ent:InsurableGoodId>'+bienAsegurado.codigoBienAsegurado+'</ent:InsurableGoodId>'
                    +    '<ent:InsuredAmount>'+bienAsegurado.importeAsegurado+'</ent:InsuredAmount>'
                    +'</ent:InsuredGood>';

            }
            insuredGoodsTag += '<con:InsuredGoods>';
        }

        return insuredGoodsTag;
    }

    private String createInsuredBasicCapitalsTag (List<EmisionAPIRequest.InfoCapitalAsegurado> capitalesAsegurados) {
        String insuredBasicCapitalsTag = '<con:InsuredBasicCapitals xsi:nil="true"/>';

        if ( capitalesAsegurados != null && ! capitalesAsegurados.isEmpty() ) {
            insuredBasicCapitalsTag += '<con:InsuredBasicCapitals>';

            for (EmisionAPIRequest.InfoCapitalAsegurado capitalAsegurado : capitalesAsegurados) {
                insuredBasicCapitalsTag += '<ent:InsuredBasicCapitals>'
                    +    '<ent:BasicInsuredCapital>'+capitalAsegurado.codigoCapital+'</ent:BasicInsuredCapital>'
                    +    '<ent:Capital>'+capitalAsegurado.importe+'</ent:Capital>'
                    +'</ent:InsuredBasicCapitals>';

            }
            insuredBasicCapitalsTag += '<con:InsuredBasicCapitals>';
        }

        return insuredBasicCapitalsTag;
    }

    private String createAditionalCoverTag(List<EmisionAPIRequest.Adicional> adicionales) {
        String aditionalCoversTag = '';

        if ( adicionales != null && ! adicionales.isEmpty() ) {
            aditionalCoversTag += '<con:AdditionalCoverInformation>';

            for (EmisionAPIRequest.Adicional adicional : adicionales) {
                aditionalCoversTag += '<ent:AdditionalCoverInformation>'
                    +    '<ent:Capital>'+adicional.capital+'</ent:Capital>'
                    +    '<ent:Description>'+adicional.descripcion+'</ent:Description>'
                    +    '<ent:FullOptionDescription>'+adicional.descripcionCompleta+'</ent:FullOptionDescription>'
                    +    '<ent:Id>'+adicional.codigoAdicional+'</ent:Id>'
                    +    '<ent:IsObligatorySelection>'+adicional.adicionalObligatorio+'</ent:IsObligatorySelection>'
                    +    '<ent:IsSelected>'+adicional.seleccionado+'</ent:IsSelected>'
                    +    '<ent:OptionDescription>'+adicional.descripcionOpcion+'</ent:OptionDescription>'
                    +    '<ent:OptionId>'+adicional.codigoOpcion+'</ent:OptionId>'
                    +'</ent:AdditionalCoverInformation>';

            }
            aditionalCoversTag += '<con:AdditionalCoverInformation>';
        }
        return aditionalCoversTag;
    }

    private String createRiskAddressTag(EmisionAPIRequest.InfoDireccionRiesgo direccionDelRiesgo){
        String riskAddresTag = '<con:RiskAddress xsi:nil="true"/>';

        if ( direccionDelRiesgo != null ) {
            riskAddresTag = '<con:RiskAddress>';

            if ( direccionDelRiesgo.puntoCardinal != null ) {
                riskAddresTag += '<ent:CardPoint>'+direccionDelRiesgo.puntoCardinal+'</ent:CardPoint>';
            }

            riskAddresTag += '<ent:City>'
            +                    '<ent:CityId>'+direccionDelRiesgo.codigoCiudad+'</ent:CityId>'
            +                    '<ent:ZipCode>'+direccionDelRiesgo.codigoPostal+'</ent:ZipCode>'
            +                '</ent:City>';

            if ( direccionDelRiesgo.kilometros != null ) {
                riskAddresTag += '<ent:Kilometers>'+direccionDelRiesgo.kilometros+'</ent:Kilometers>';
            }

            if ( String.isNotBlank(direccionDelRiesgo.calle) ) {
                riskAddresTag += '<ent:Street>'+direccionDelRiesgo.calle+'</ent:Street>';
            }

            riskAddresTag += '</con:RiskAddress>';
        }

        return riskAddresTag;
    }

    private String createElectronicDispatchTag(EmisionAPIRequest.InfoEnvioDigital envioDigital){
        String envioDigitalTag = '<con:ElectronicDispatchInformation xsi:nil="true" />';

        If ( envioDigital != null ) {
            envioDigitalTag ='<con:ElectronicDispatchInformation>'
                +   '<ent:ElectronicDispatchEmail>'+envioDigital.emailEnvio+'</ent:ElectronicDispatchEmail>'
                +   '<ent:IsElectronicallyDispatched>'+envioDigital.envioElectronico+'</ent:IsElectronicallyDispatched>'
                +'</con:ElectronicDispatchInformation>';
        }

        return envioDigitalTag;
    }

    private String createBranchDataTag(EmisionAPIRequest.InfoCertificado certificado, Map<String,String> hardcodedValuesByName, Enumerator.Producto producto, Enumerator.Ramo ramo){
        String branchDataTag = this.getMethodName(producto, ramo);
        String branchTagBody = '<con:BranchData xsi:type="con:'+branchDataTag+'">';

        switch on ramo {
            when AUTOMOTOR {
                branchTagBody += this.fillAutomotorTags(certificado, hardcodedValuesByName);
            } when else {
                branchTagBody += this.fillAccidentesPersonalesTags(certificado, hardcodedValuesByName);
            }
        }

        branchTagBody += '</con:BranchData>';

        return branchTagBody;
    }

    private String fillAccidentesPersonalesTags(EmisionAPIRequest.InfoCertificado certificado, Map<String,String> hardcodedValuesByName){
        String apTags = '';

        apTags ='<con:ActivityTypeId>'+certificado.infoRamo.codActividad+'</con:ActivityTypeId>'
        +   '<con:AssistanceMedicalPharmaceuticalCapitalTypeId>'+certificado.infoRamo.codAsistenciaMedicaFarmaceutica+'</con:AssistanceMedicalPharmaceuticalCapitalTypeId>'
        +   '<con:ClassificationActivityTypeId>'+certificado.infoRamo.codClasificacion+'</con:ClassificationActivityTypeId>'
        +   '<con:ClientAddress>'
        +       '<ent:Street>'+certificado.infoRamo.direccion+'</ent:Street>'
        +   '</con:ClientAddress>'
        +   '<con:DeathAndDisabilityCapitalTypeId>'+certificado.infoRamo.codCapitalMuerteInvalidez+'</con:DeathAndDisabilityCapitalTypeId>'
        +   '<con:DeathGrants>'+certificado.infoRamo.subsidioPorMuerte+'</con:DeathGrants>'
        +   '<con:DeathGrantsCapital>'+certificado.infoRamo.capitalMuerte+'</con:DeathGrantsCapital>'
        +   '<con:GoodHealth>'+certificado.infoRamo.buenaSalud+'</con:GoodHealth>'
        +   '<con:HasOtherAddress>'+hardcodedValuesByName.get('otraDireccion')+'</con:HasOtherAddress>'
        +   '<con:LeftHanded>'+certificado.infoRamo.zurdo+'</con:LeftHanded>'
        +   '<con:ParticularAddress>'+hardcodedValuesByName.get('direccionParticular')+'</con:ParticularAddress>'
        +   '<con:TaskClassificationActivityTypeId>'+certificado.infoRamo.codTarea+'</con:TaskClassificationActivityTypeId>';

        return apTags;
    }

    private String fillAutomotorTags(EmisionAPIRequest.InfoCertificado certificado, Map<String,String> hardcodedValuesByName){
        String vehicleTags = '';

        if( certificado.InfoRamo.porcentajeAjuste != null ){
            vehicleTags += '<con:AutomaticAdjustPercentage>'+certificado.InfoRamo.porcentajeAjuste+'</con:AutomaticAdjustPercentage>';
        } else {
            vehicleTags += '<con:AutomaticAdjustPercentage xsi:nil="true"/>';
        }

        if( certificado.InfoRamo.codigoTransportaCombustible != null ){
            vehicleTags += '<con:FuelTransportId>'+certificado.InfoRamo.codigoTransportaCombustible+'</con:FuelTransportId>';
        } else {
            vehicleTags += '<con:FuelTransportId xsi:nil="true"/>';
        }

        vehicleTags += '<con:PercentDiscount>'+hardcodedValuesByName.get('porcentajeDescuento')+'</con:PercentDiscount>'
        +       '<con:ScoringInformation>'
        +           '<ent:DriverLessThan25Years>'+certificado.infoRamo.conductorMenorDe25+'</ent:DriverLessThan25Years>'
        +           '<ent:MoreThan25000PerYear>'+certificado.infoRamo.masDe25KmPorAnio+'</ent:MoreThan25000PerYear>'
        +           '<ent:StorageInGarage>'+certificado.infoRamo.guardaEnGarage+'</ent:StorageInGarage>'
        +       '</con:ScoringInformation>'
        +       this.createVehicleTag(certificado.infoRamo.vehiculo);

        return vehicleTags;
    }

    private String createOperatoriaEspecialTag (EmisionAPIRequest.InfoOperatoriaEspecial operatoria){
        String operatoriaTag = '<con:SpecialOperative/>';

        if( operatoria != null){
            operatoriaTag = '<con:SpecialOperative>'
            +   '<BanckId>'+operatoria.codigoBanco+'</BanckId>'
            +   '<Contract>'+operatoria.numeroContrato+'</Contract>'
            +   '<EffectContract>'+operatoria.fechaEfectivaContrato.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</EffectContract>'
            +   '<ExpirContract>'+operatoria.fechaVencimientoContrato.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</ExpirContract>'
            +   '<ExpirFirstQuota>'+operatoria.fechaVencimientoPrimeraCuota.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</ExpirFirstQuota>'
            +   '<IdOperation>'+operatoria.idOperacion+'</IdOperation>'
            +   '<Quota>'+operatoria.cantidadCoutas+'</Quota>'
            +'</con:SpecialOperative>';
        }

        return operatoriaTag;
    }

    private String createDescuentosEspecialesTag (List<EmisionAPIRequest.InfoDescuentoEspecial> descuentos){
        String descuentosTag = '<con:SurchargeDiscounts/>';

        if( descuentos != null && ! descuentos.isEmpty() ){
            descuentosTag = '<con:SurchargeDiscounts>';

            for (EmisionAPIRequest.InfoDescuentoEspecial descuento : descuentos) {
                descuentosTag += '<SurchargeDiscount xmlns="http://gruposancorseguros.com/ents/SOI/Entities/">';

                if ( descuento.porcentaje == null ) {
                    descuentosTag += '<Amount>'+descuento.importe+'</Amount>';
                }
                if( descuento.importe == null ){
                    descuentosTag += '<Rate>'+descuento.porcentaje+'</Rate>';
                }

                descuentosTag += '<SurchargeDiscountId>'+descuento.codigoDescuento+'</SurchargeDiscountId>'
                +   '</SurchargeDiscount>';
            }

            descuentosTag += '</con:SurchargeDiscounts>';
        }
        return descuentosTag;
    }

    private String createDebitDataTag ( EmisionAPIRequest.InfoPago infoPago, Integer tipoPago){
        String debitoDataTag = '';

        switch on tipoPago {
            when 1 { // 1: Debito Bancario
                debitoDataTag =
                    '<con:DebitData xsi:type="ent:AccountDebitDebit">' // todo falta type debito
                    +   '<ent:AccountNumber>'+infoPago.numeroCuentaDebito+'</ent:AccountNumber>'
                    +   '<ent:AccountTypeId>'+infoPago.tipoCuentaDebito+'</ent:AccountTypeId>'
                    +   '<ent:BankAgencyId>'+infoPago.codigoAgenciaSucursal+'</ent:BankAgencyId>'
                    +   '<ent:BankId>'+infoPago.codigoBanco+'</ent:BankId>'
                    +'</con:DebitData>';
            } when 2 { // 2: Tarjeta de Credito
                debitoDataTag =
                    '<con:DebitData xsi:type="ent:CreditCardDebit">'
                    +   '<ent:CreditCardExpiration>'+infoPago.fechaVencimientoTarjeta.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</ent:CreditCardExpiration>'
                    +   '<ent:CreditCardId>'+infoPago.codigoMarcaTarjeta+'</ent:CreditCardId>'
                    +   '<ent:CreditCardNumber>'+infoPago.numeroTarjeta+'</ent:CreditCardNumber>'
                    +'</con:DebitData>';
            } when 4 { // 4: CBU
                debitoDataTag =
                    '<con:DebitData xsi:type="q1:CbuDebit">'
                    +   '<ent:CbuAccount>'+infoPago.cuentaCBU+'</ent:CbuAccount>'
                    +   '<ent:BankAgencyId>'+infoPago.codigoAgenciaSucursal+'</ent:BankAgencyId>'
                    +   '<ent:BankId>'+infoPago.codigoBanco+'</ent:BankId>'
                    +'</con:DebitData>';
            } when else { // 0: Efectivo
                debitoDataTag = '<con:DebitData/>';
            }
        }
        return debitoDataTag;
    }

    private String createClientTag ( List<EmisionAPIRequest.InfoCliente> clientes){
        String clientsTag = '<con:Clients/>';

        if( ! clientes.isEmpty() ){
            clientsTag = '<con:Clients>';

            for (EmisionAPIRequest.InfoCliente cliente : clientes) {
                clientsTag += '<col:KeyValuePairOfClientRoleIdsClient>'
                +   '<col:key>'+cliente.tipoRol+'</col:key>'
                +   '<col:value>';

                if ( cliente.codigoAreaTelefono  != null ) { // Estos ifs podrian ser un metodo generico
                    clientsTag += '<ent:AreaCode>'+cliente.codigoAreaTelefono+'</ent:AreaCode>';
                } else {
                    clientsTag += '<ent:AreaCode xsi:nil="true"/>';
                }

                clientsTag += '<ent:BirthDate>'+cliente.fechaNacimiento.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</ent:BirthDate>';

                if ( String.isNotBlank(cliente.lugarNacimiento) ) {
                    clientsTag += '<ent:BirthPlaceCityDescription>'+cliente.lugarNacimiento+'</ent:BirthPlaceCityDescription>';
                } else {
                    clientsTag += '<ent:BirthPlaceCityDescription xsi:nil="true"/>';
                }

                if ( cliente.codigoCiudad != null ) {
                    clientsTag += '<ent:CityId>'+cliente.codigoCiudad+'</ent:CityId>';
                } else {
                    clientsTag += '<ent:CityId xsi:nil="true"/>';
                }

                if ( String.isNotBlank(cliente.cuit_cuil) ) {
                    clientsTag += '<ent:code>'+cliente.cuit_cuil+'</ent:code>';
                } else {
                    clientsTag += '<ent:Code xsi:nil="true"/>';
                }

                if (String.isNotBlank(cliente.numeroDocumento)) {
                    clientsTag += '<ent:DocumentNumber>'+cliente.numeroDocumento+'</ent:DocumentNumber>';
                }

                clientsTag += '<ent:DocumentType>'+cliente.tipoDocumento+'</ent:DocumentType>';

                if ( String.isNotBlank(cliente.email) ) {
                    clientsTag += '<ent:Email>'+cliente.email+'</ent:Email>';
                } else {
                    clientsTag += '<ent:Email xsi:nil="true"/>';
                }

                if ( String.isNotBlank(cliente.nombre) ) {
                    clientsTag += '<ent:FirstName>'+cliente.nombre+'</ent:FirstName>';
                } else {
                    clientsTag += '<ent:FirstName/>';
                }

                if ( cliente.genero != null ) {
                    clientsTag += '<ent:GenderId>'+cliente.genero+'</ent:GenderId>';
                }

                clientsTag += '<ent:IvaConditionId>'+cliente.codigoCondicionIVA+'</ent:IvaConditionId>';

                if ( String.isNotBlank(cliente.apellido) ) {
                    clientsTag += '<ent:LastName>'+cliente.apellido+'</ent:LastName>';
                } else {
                    clientsTag += '<ent:LastName/>';
                }

                if ( cliente.codigoActividadPrincipal != null ) {
                    clientsTag += '<ent:MainActivityCode>'+cliente.codigoActividadPrincipal+'</ent:MainActivityCode>';
                }

                if ( cliente.codigoEstadoCivil != null ) {
                    clientsTag += '<ent:MaritalStatusId>'+cliente.codigoEstadoCivil+'</ent:MaritalStatusId>';
                }

                if (String.isNotBlank(cliente.telefono)) {
                    clientsTag += '<ent:PhoneNumber>'+cliente.telefono+'</ent:PhoneNumber>';
                } else {
                    clientsTag += '<ent:PhoneNumber xsi:nil="true"/>';
                }

                if (cliente.categoriaMonotributo != null) {
                    clientsTag += '<ent:SingleTaxCategoryId>'+cliente.categoriaMonotributo+'</ent:SingleTaxCategoryId>';
                } else {
                    clientsTag += '<ent:SingleTaxCategoryId xsi:nil="true"/>';
                }

                if (String.isNotBlank(cliente.calle)) {
                    clientsTag += '<ent:Street>'+cliente.calle+'</ent:Street>';
                } else {
                    clientsTag += '<ent:Street xsi:nil="true"/>';
                }

                clientsTag +=  '<ent:ZipCode>'+cliente.codigoPostal+'</ent:ZipCode>';

                clientsTag += '</col:value>'
                +   '</col:KeyValuePairOfClientRoleIdsClient>';
            }
            clientsTag += '</con:Clients>';
        }

        return clientsTag;
    }

    private String createVehicleTag ( EmisionAPIRequest.vehiculo vehiculo){
        return '<con:Vehicle>'
        +       '<ent:Chassis>'+vehiculo.numeroChasis+'</ent:Chassis>'
        +       this.createEquipmentGNCTag(vehiculo.equipoGnc)
        +       '<ent:License>'+vehiculo.licencia+'</ent:License>'
        +       '<ent:Motor>'+vehiculo.numeroMotor+'</ent:Motor>'
        +       '<ent:MustHaveTrackSystem>'+vehiculo.tieneQueColocarRastreoSatelital+'</ent:MustHaveTrackSystem>'
        +       this.createPreviousInspectionTag(vehiculo.inspeccionPrevia)
        +       '<ent:VehicleModelCode>'+vehiculo.codigoModeloInfoAuto+'</ent:VehicleModelCode>'
        +       '<ent:VehicleUseId>'+vehiculo.codigoUso+'</ent:VehicleUseId>'
        +       '<ent:VehicleValue>'+vehiculo.valor+'</ent:VehicleValue>'
        +       '<ent:VehicleYear>'+vehiculo.anio+'</ent:VehicleYear>'
        +       '<ent:ZeroKmValue>'+vehiculo.esCeroKilometro+'</ent:ZeroKmValue>'
        +   '</con:Vehicle>';
    }

    private String createEquipmentGNCTag ( EmisionAPIRequest.EquipoGNC equipoGNC){
        String equipmentGNCTag = '<ent:GncEquipment/>';

        if (equipoGNC != null) {
            equipmentGNCTag =
                '<ent:GncEquipment>'
                +   '<ent:CylinderBrand_1>'+equipoGnc.marcaCilindro1+'</ent:CylinderBrand_1>'
                +   '<ent:CylinderNumber_1>'+equipoGnc.numeroCilindro1+'</ent:CylinderNumber_1>';
                if( String.isNotBlank(equipoGnc.marcaCilindro2) && String.isNotBlank(equipoGnc.numeroCilindro2) ) {
                    equipmentGNCTag +=
                        '<ent:CylinderBrand_2>'+equipoGnc.marcaCilindro2+'</ent:CylinderBrand_2>'
                       +'<ent:CylinderNumber_2>'+equipoGnc.numeroCilindro2+'</ent:CylinderNumber_2>';
                }
                if( String.isNotBlank(equipoGnc.marcaCilindro3) && String.isNotBlank(equipoGnc.numeroCilindro3) ) {
                    equipmentGNCTag +=
                        '<ent:CylinderBrand_3>'+equipoGnc.marcaCilindro3+'</ent:CylinderBrand_3>'
                       +'<ent:CylinderNumber_3>'+equipoGnc.numeroCilindro3+'</ent:CylinderNumber_3>';
                }
                if( String.isNotBlank(equipoGnc.marcaCilindro4) && String.isNotBlank(equipoGnc.numeroCilindro4) ) {
                    equipmentGNCTag +=
                        '<ent:CylinderBrand_4>'+equipoGnc.marcaCilindro4+'</ent:CylinderBrand_4>'
                       +'<ent:CylinderNumber_4>'+equipoGnc.numeroCilindro4+'</ent:CylinderNumber_4>';
                }
            equipmentGNCTag +=
                    '<ent:EquipmentValue>'+equipoGnc.valor+'</ent:EquipmentValue>'
                +   '<ent:RegulatorBrand>'+equipoGnc.marcaRegulador+'</ent:RegulatorBrand>'
                +   '<ent:RegulatorNumber>'+equipoGnc.numeroRegulador+'</ent:RegulatorNumber>'
                +'</ent:GncEquipment>';
        }
        return equipmentGNCTag;
    }

    private String createPreviousInspectionTag ( EmisionAPIRequest.InspeccionPrevia inspeccion){
        String previousInspectionTag = '';

        if (inspeccion != null) {
            previousInspectionTag = '<ent:PreviousInspection>';

            if(String.isBlank(inspeccion.comentario)){
                previousInspectionTag += '<ent:Comments xsi:nil="true"/>';
            } else {
                previousInspectionTag += '<ent:Comments>'+inspeccion.comentario+'</ent:Comments>';
            }

            previousInspectionTag += this.createFilesAttachedTag(inspeccion.archivosAdjuntos);
            previousInspectionTag +=
                        '<ent:FuelTypeId>'+inspeccion.codigoTipoCombustible+'</ent:FuelTypeId>'
                +       '<ent:GeneralAspectId>'+inspeccion.codigoAspectoGeneral+'</ent:GeneralAspectId>'
                +       '<ent:GlassResultId>'+inspeccion.codigoEstadoCristales+'</ent:GlassResultId>'
                +       '<ent:InspectionDate>'+inspeccion.fecha.formatGMT('YYYY-MM-dd\'T\'HH:mm:ss')+'</ent:InspectionDate>';

            if ( inspeccion.codigoResultado == null ) {
                previousInspectionTag += '<ent:InspectionResultId>'+inspeccion.codigoResultado+'</ent:InspectionResultId>';
            } else {
                previousInspectionTag += '<ent:InspectionResultId xsi:nil="true"/>';
            }

            previousInspectionTag += '<ent:Kilometrage>'+inspeccion.kilometraje+'</ent:Kilometrage>'
                +       '<ent:PaintAspectId>'+inspeccion.codigoEstadoPintura+'</ent:PaintAspectId>'
                +       '<ent:PaintTypeId>'+inspeccion.codigoTipoPintura+'</ent:PaintTypeId>'
                +       '<ent:SheetMetalAspectId>'+inspeccion.codigoAspectoChapa+'</ent:SheetMetalAspectId>'
                +       '<ent:TiresAspectId>'+inspeccion.codigoEstadoNeumatico+'</ent:TiresAspectId>'
                +       '<ent:UpholsteryAspectId>'+inspeccion.codigoEstadoTapizado+'</ent:UpholsteryAspectId>'
                +       '<ent:UpholsteryColorId>'+inspeccion.codigoColorTapizado+'</ent:UpholsteryColorId>';

                if ( inspeccion.codigoTipoTapizado == null ) {
                    previousInspectionTag += '<ent:UpholsteryTypeId>'+inspeccion.codigoTipoTapizado+'</ent:UpholsteryTypeId>';
                } else {
                    previousInspectionTag += '<ent:UpholsteryTypeId xsi:nil="true"/>';
                }

                previousInspectionTag += '<ent:VehicleColor>'+inspeccion.colorVehiculo+'</ent:VehicleColor>'
                +       '<ent:WheelTypeId>'+inspeccion.codigoTipoLlantas+'</ent:WheelTypeId>'
                +'</ent:PreviousInspection>';
        }
        return previousInspectionTag;
    }

    private String createFilesAttachedTag ( List<EmisionAPIRequest.ArchivoAdjunto> archivosAdjuntos){
        String filesAttachedTag = '<ent:FilesAttached/>';

        if( !archivosAdjuntos.isEmpty() ){
            filesAttachedTag = '<ent:FilesAttached>';
            for (EmisionAPIRequest.ArchivoAdjunto archivos : archivosAdjuntos) {
                filesAttachedTag +=
                    '<ent:FileAttachment>'
                    +   '<ent:Content>'+archivos.contenido+'</ent:Content>'
                    +   '<ent:Name>'+archivos.nombre+'</ent:Name>'
                    +'</ent:FileAttachment>';
            }
            filesAttachedTag += '</ent:FilesAttached>';
        }

        return filesAttachedTag;
    }

    private String getMethodName(Enumerator.Producto producto, Enumerator.Ramo ramo){
        String methodname = '';

        switch on ramo {
            when AUTOMOTOR {
                methodname = 'AutomotiveBranchData';
            } when ACCIDENTE_PERSONALES {
                switch on producto {
                    when AP_24HS_MODULADO {
                        methodname = 'PersonalAccidents24HsAPBranchData';
                    } when AP_INTEGRO_MAX {
                        methodname = 'IntegralAPBranchData';
                    } when AP_OCASION_TRABAJO {
                        methodname = 'OcationOfWorkAPBranchData';
                    }
                }
            }
        }
        return methodname;
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

        public EmisionAPIResponse polizaEmitida { get; set; }
        public String faultString { get; private set; }
        public String faultCode { get; private set; }
        public Boolean validationError { get; set; }
        public String validationMessage { get; set; }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde un http 2XX */
        public override void processResponse(HttpResponse response) {
            this.polizaEmitida = new EmisionAPIResponse();
            String bodyString = response.getBody();

            Dom.XmlNode validationErrorNode = XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/Errors' );
            if( validationErrorNode != null ){
                this.processValidationResponse( validationErrorNode );
            } else {
                this.processGoodResponse(bodyString);
            }
        }
        private void processValidationResponse(Dom.XmlNode validationError){
            this.validationError = true;
            List<String> errors = new List<String>();

            for (Dom.XmlNode child : validationError.getChildElements()) {
                errors.add(child.getText());
            }
            this.validationMessage = String.join(errors, '\n');
        }

        private void processGoodResponse(String bodyString){
            polizaEmitida.ramoId =
            Integer.valueOf(
                XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/BranchId' ).getText()
            );
            polizaEmitida.numeroCertificado =
                Integer.valueOf(
                    XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/CertificatNumber' ).getText()
                );
            polizaEmitida.numeroTramiteInterno =
                XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/ManagementNumber' ).getText();
            polizaEmitida.estadoDeTramite =
                XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/ManagementStatus' ).getText();
            polizaEmitida.numeroOficialPoliza =
                Integer.valueOf(
                    XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/OfficialNumber' ).getText()
                );
            polizaEmitida.numeroSancorPoliza =
                Integer.valueOf(
                    XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/ReferenceNumber' ).getText()
                );

            polizaEmitida.recibo =
                this.createRecibos(
                    XMLParser.getNode( bodyString, 'Body/CreateSinglePolicyResponse/CreateSinglePolicyResult/Receipt' )
                );
        }

        private EmisionAPIResponse.Recibo createRecibos(Dom.XmlNode reciboDom){
            EmisionAPIResponse.Recibo recibo = new EmisionAPIResponse.Recibo();
            recibo.numero = Integer.valueOf(XMLParser.getNode( reciboDom, 'Number').getText());

            EmisionAPIResponse.Detalle detalle;
            for (Dom.XmlNode detalleDom : XMLParser.getNode( reciboDom, 'Detail').getChildElements()) {
                detalle = new EmisionAPIResponse.Detalle();
                detalle.descripcion = XMLParser.getNode( detalleDom, 'Description').getText();
                detalle.premio = Decimal.valueOf(XMLParser.getNode( detalleDom, 'Premium').getText());
                detalle.premioSegunFormaDePago = Decimal.valueOf(XMLParser.getNode( detalleDom, 'PremiumAccordingPayForm').getText());
                recibo.detalles.add(detalle);
            }
            return recibo;
        }

        public override void processErrorResponse( HttpResponse response ){
            String bodyString = response.getBody();

            if ( XMLParser.getNode( bodyString, 'Body/Fault' ) != null ) {

                this.faultCode = XMLParser.getNode( bodyString, 'Body/Fault/faultcode' ).getText();

                this.faultString = XMLParser.getNode( bodyString, 'Body/Fault/faultstring' ).getText();
            }
        }
    }

}

/**
 * RESPUESTA OK
    <NS1:Envelope xmlns:NS1="http://schemas.xmlsoap.org/soap/envelope/">
    <NS1:Header>
        <NS2:responseHeader xmlns:NS2="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
            <messageId>58be9274-596a-11ea-a09b-ac14162e0000</messageId>
        </NS2:responseHeader>
    </NS1:Header>
    <NS1:Body>
        <NS3:CreateSinglePolicyResponse xmlns:NS3="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/">
            <NS3:CreateSinglePolicyResult>
                <NS4:BranchId xmlns:NS4="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">200</NS4:BranchId>
                <NS5:CertificatNumber xmlns:NS5="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">0</NS5:CertificatNumber>
                <NS6:ManagementNumber xmlns:NS6="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">0102000000000252129246</NS6:ManagementNumber>
                <NS7:ManagementStatus xmlns:NS7="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">Emitida</NS7:ManagementStatus>
                <NS8:OfficialNumber xmlns:NS8="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">9006707</NS8:OfficialNumber>
                <NS9:Receipt xmlns:NS9="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">
                <NS10:Detail xmlns:NS10="http://gruposancorseguros.com/ents/SOI/Entities/">
                    <NS10:ReceiptDetail>
                        <NS10:Description>Prima</NS10:Description>
                        <NS10:Premium>23838.30</NS10:Premium>
                        <NS10:PremiumAccordingPayForm>1986.53</NS10:PremiumAccordingPayForm>
                    </NS10:ReceiptDetail>
                    <NS10:ReceiptDetail>
                        <NS10:Description>Impuesto a los Sellos</NS10:Description>
                        <NS10:Premium>178.79</NS10:Premium>
                        <NS10:PremiumAccordingPayForm>14.90</NS10:PremiumAccordingPayForm>
                    </NS10:ReceiptDetail>
                    <NS10:ReceiptDetail>
                        <NS10:Description>Iva General</NS10:Description>
                        <NS10:Premium>5006.04</NS10:Premium>
                        <NS10:PremiumAccordingPayForm>417.17</NS10:PremiumAccordingPayForm>
                    </NS10:ReceiptDetail>
                    <NS10:ReceiptDetail>
                        <NS10:Description>Tasas e Impuestos</NS10:Description>
                        <NS10:Premium>524.43</NS10:Premium>
                        <NS10:PremiumAccordingPayForm>43.71</NS10:PremiumAccordingPayForm>
                    </NS10:ReceiptDetail>
                    <NS10:ReceiptDetail>
                        <NS10:Description>Capital Social</NS10:Description>
                        <NS10:Premium>2145.45</NS10:Premium>
                        <NS10:PremiumAccordingPayForm>178.69</NS10:PremiumAccordingPayForm>
                    </NS10:ReceiptDetail>
                </NS10:Detail>
                <NS11:Number xmlns:NS11="http://gruposancorseguros.com/ents/SOI/Entities/">392939859</NS11:Number>
                </NS9:Receipt>
                <NS12:ReferenceNumber xmlns:NS12="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">7444958</NS12:ReferenceNumber>
            </NS3:CreateSinglePolicyResult>
        </NS3:CreateSinglePolicyResponse>
    </NS1:Body>
    </NS1:Envelope>
 */

 /**
  * RESPUESTA ERROR
    <NS1:Envelope xmlns:NS1="http://schemas.xmlsoap.org/soap/envelope/">
    <NS1:Header>
        <NS2:responseHeader xmlns:NS2="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
            <messageId>17d60d40-596b-11ea-a09b-ac14162e0000</messageId>
        </NS2:responseHeader>
    </NS1:Header>
    <NS1:Body>
        <NS3:CreateSinglePolicyResponse xmlns:NS3="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/">
            <NS3:CreateSinglePolicyResult>
                <NS4:Errors xmlns:NS4="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">
                <NS5:string xmlns:NS5="http://gruposancorseguros.com/ents/SOI/Collections/">736122 - Verificar. Fuera de Normas de Selección de Riesgo sin indicar Inspección Previa. (Código: 736122)</NS5:string>
                <NS6:string xmlns:NS6="http://gruposancorseguros.com/ents/SOI/Collections/">768332 - El descuento por modelo se aplica solo para unidades dentro de norma. (Código: 768332)</NS6:string>
                <NS7:string xmlns:NS7="http://gruposancorseguros.com/ents/SOI/Collections/">767095 - Valor convenido. (Código: 767095)</NS7:string>
                <NS8:string xmlns:NS8="http://gruposancorseguros.com/ents/SOI/Collections/">768330 - Vehículo fuera de normas de selección de riesgo. Ver Tipo, Clase o Antigüedad. (Código: 768330)</NS8:string>
                </NS4:Errors>
            </NS3:CreateSinglePolicyResult>
        </NS3:CreateSinglePolicyResponse>
    </NS1:Body>
    </NS1:Envelope>
*/

/**
 * REQUEST AP

    <?xml version="1.0" encoding="UTF-8"?>
    <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:col="http://gruposancorseguros.com/ents/SOI/Collections/" xmlns:con="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/" xmlns:ent="http://gruposancorseguros.com/ents/SOI/Entities/" xmlns:req="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <env:Body>
        <req:CreateSinglePolicy>
            <req:request>
                <con:CertificateData>
                <con:BillableClientRoleId>1</con:BillableClientRoleId>
                <con:BranchData xsi:type="con:OcationOfWorkAPBranchData">
                    <con:ActivityTypeId>9</con:ActivityTypeId>
                    <con:AssistanceMedicalPharmaceuticalCapitalTypeId>754</con:AssistanceMedicalPharmaceuticalCapitalTypeId>
                    <con:ClassificationActivityTypeId>45</con:ClassificationActivityTypeId>
                    <con:ClientAddress>
                        <ent:Street>avelino diaz 2141</ent:Street>
                    </con:ClientAddress>
                    <con:DeathAndDisabilityCapitalTypeId>306</con:DeathAndDisabilityCapitalTypeId>
                    <con:DeathGrants>true</con:DeathGrants>
                    <con:DeathGrantsCapital>92812</con:DeathGrantsCapital>
                    <con:GoodHealth>false</con:GoodHealth>
                    <con:HasOtherAddress>true</con:HasOtherAddress>
                    <con:LeftHanded>false</con:LeftHanded>
                    <con:ParticularAddress>false</con:ParticularAddress>
                    <con:TaskClassificationActivityTypeId>164</con:TaskClassificationActivityTypeId>
                </con:BranchData>
                <con:Clients>
                    <col:KeyValuePairOfClientRoleIdsClient>
                        <col:key>1</col:key>
                        <col:value>
                            <ent:AreaCode>11</ent:AreaCode>
                            <ent:BirthDate>1998-06-30T00:00:00</ent:BirthDate>
                            <ent:BirthPlaceCityDescription />
                            <ent:CityId>30001</ent:CityId>
                            <ent:DocumentNumber>33222111</ent:DocumentNumber>
                            <ent:DocumentType>D</ent:DocumentType>
                            <ent:Email>algo@algo.com</ent:Email>
                            <ent:FirstName>Jorge</ent:FirstName>
                            <ent:IvaConditionId>4</ent:IvaConditionId>
                            <ent:LastName>Apellido</ent:LastName>
                            <ent:PhoneNumber>44443333</ent:PhoneNumber>
                            <ent:Street>Su calle 2141</ent:Street>
                            <ent:ZipCode>1401</ent:ZipCode>
                        </col:value>
                    </col:KeyValuePairOfClientRoleIdsClient>
                    <col:KeyValuePairOfClientRoleIdsClient>
                        <col:key>2</col:key>
                        <col:value>
                            <ent:AreaCode>11</ent:AreaCode>
                            <ent:BirthDate>1998-06-30T00:00:00</ent:BirthDate>
                            <ent:BirthPlaceCityDescription />
                            <ent:CityId>30001</ent:CityId>
                            <ent:DocumentNumber>33222111</ent:DocumentNumber>
                            <ent:DocumentType>D</ent:DocumentType>
                            <ent:Email>algo@algo.com</ent:Email>
                            <ent:FirstName>Jorge</ent:FirstName>
                            <ent:IvaConditionId>4</ent:IvaConditionId>
                            <ent:LastName>Apellido</ent:LastName>
                            <ent:PhoneNumber>44443333</ent:PhoneNumber>
                            <ent:Street>Su calle 2141</ent:Street>
                            <ent:ZipCode>1401</ent:ZipCode>
                        </col:value>
                    </col:KeyValuePairOfClientRoleIdsClient>
                    <col:KeyValuePairOfClientRoleIdsClient>
                        <col:key>17</col:key>
                        <col:value>
                            <ent:AreaCode xsi:nil="true" />
                            <ent:BirthDate>1986-01-01T00:00:00</ent:BirthDate>
                            <ent:BirthPlaceCityDescription />
                            <ent:DocumentNumber>99999</ent:DocumentNumber>
                            <ent:DocumentType>Q</ent:DocumentType>
                            <ent:Email xsi:nil="true" />
                            <ent:FirstName />
                            <ent:IvaConditionId>4</ent:IvaConditionId>
                            <ent:LastName />
                            <ent:PhoneNumber xsi:nil="true" />
                            <ent:Street />
                            <ent:ZipCode>0</ent:ZipCode>
                        </col:value>
                    </col:KeyValuePairOfClientRoleIdsClient>
                </con:Clients>
                <con:CoverModuleCode>0</con:CoverModuleCode>
                <con:DebitTypeId>0</con:DebitTypeId>
                <con:ElectronicDispatchInformation xsi:nil="true" />
                <con:PaymentFrequencyId>7</con:PaymentFrequencyId>
                <con:PolicyId>0</con:PolicyId>
                <con:Quota>1</con:Quota>
                <con:Quotation />
                <con:RiskAddress>
                    <ent:City>
                        <ent:CityId>30001</ent:CityId>
                        <ent:ZipCode>1401</ent:ZipCode>
                    </ent:City>
                </con:RiskAddress>
                <con:Since>2020-12-29T00:00:00</con:Since>
                <con:Thru>2021-01-29T00:00:00</con:Thru>
                </con:CertificateData>
                <con:CurrencyId>1</con:CurrencyId>
                <con:OrganizerNumber>150113</con:OrganizerNumber>
                <con:ProducerNumber>208829</con:ProducerNumber>
                <con:ProductId>555</con:ProductId>
                <con:RenewalTypeId>1</con:RenewalTypeId>
                <con:StatisticCodeIds>1440</con:StatisticCodeIds>
            </req:request>
        </req:CreateSinglePolicy>
    </env:Body>
    </env:Envelope>
*/

/**
 * REQUEST AUTOMOTOR (BASICO) SIN INSPECCION
    <soapenv:Envelope xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0" 
                    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                    xmlns:pol="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/" 
                    xmlns:col="http://gruposancorseguros.com/ents/SOI/Collections/" 
                    xmlns:ent="http://gruposancorseguros.com/ents/SOI/Entities/" 
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header/>
    <soapenv:Body>
        <pol:CreateSinglePolicy>
            <pol:request xmlns:con="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">
                <con:CertificateData>
                <con:BillableClientRoleId>1</con:BillableClientRoleId>
                <con:BranchData xsi:type="con:AutomotiveBranchData">
                    <con:AutomaticAdjustPercentage xsi:nil="true"/>
                    <con:FuelTransportId xsi:nil="true"/>
                    <con:PercentDiscount>99</con:PercentDiscount>
                    <con:ScoringInformation>
                        <ent:DriverLessThan25Years>false</ent:DriverLessThan25Years>
                        <ent:MoreThan25000PerYear>false</ent:MoreThan25000PerYear>
                        <ent:StorageInGarage>true</ent:StorageInGarage>
                    </con:ScoringInformation>
                    <con:Vehicle>
                        <ent:Chassis>CHASIS608CHASIS</ent:Chassis>
                            <ent:Chassis>12322222222D</ent:Chassis>
                            <ent:GncEquipment>
                            <ent:CylinderBrand_1>TUBOSI</ent:CylinderBrand_1>
                            <ent:CylinderNumber_1>456980</ent:CylinderNumber_1>
                            <ent:EquipmentValue>30000</ent:EquipmentValue>
                            <ent:RegulatorBrand>Regulator</ent:RegulatorBrand>
                            <ent:RegulatorNumber>123456</ent:RegulatorNumber>
                        </ent:GncEquipment>
                        <ent:License>BB608BB</ent:License>
                        <ent:Motor>MOTOR608MOTOR</ent:Motor>
                        <ent:MustHaveTrackSystem>false</ent:MustHaveTrackSystem>
                        <ent:VehicleModelCode>0320697</ent:VehicleModelCode>
                        <ent:VehicleUseId>2</ent:VehicleUseId>
                        <ent:VehicleValue>720000</ent:VehicleValue>
                        <ent:VehicleYear>2018</ent:VehicleYear>
                        <ent:ZeroKmValue>false</ent:ZeroKmValue>
                    </con:Vehicle>
                </con:BranchData>
                <con:Clients>
                    <col:KeyValuePairOfClientRoleIdsClient>
                        <col:key>2</col:key>
                        <col:value>
                            <ent:AreaCode>3493</ent:AreaCode>
                            <ent:BirthDate>1965-02-18T00:00:00</ent:BirthDate>
                            <ent:BirthPlaceCityDescription>Sunchales</ent:BirthPlaceCityDescription>
                            <ent:CityId>0</ent:CityId>
                            <ent:Code xsi:nil="true"/>
                            <ent:DocumentNumber>17235777</ent:DocumentNumber>
                            <ent:DocumentType>D</ent:DocumentType>
                            <ent:Email>algo@algo.com</ent:Email>
                            <ent:FirstName>Mario</ent:FirstName>
                            <ent:GenderId>2</ent:GenderId>
                            <ent:IvaConditionId>4</ent:IvaConditionId>
                            <ent:LastName>Apellido</ent:LastName>
                            <ent:MainActivityCode>10001</ent:MainActivityCode>
                            <ent:MaritalStatusId>1</ent:MaritalStatusId>
                            <ent:PhoneNumber>404040</ent:PhoneNumber>
                            <ent:SingleTaxCategoryId xsi:nil="true"/>
                            <ent:Street>Igualdad 1234</ent:Street>
                            <ent:ZipCode>2322</ent:ZipCode>
                        </col:value>
                    </col:KeyValuePairOfClientRoleIdsClient>
                </con:Clients>
                <con:Comments></con:Comments>
                <con:CoverModuleCode>12</con:CoverModuleCode>
                <con:Covers xsi:nil="true"/>
                <con:DebitData/>
                <con:DebitTypeId>0</con:DebitTypeId>
                <con:ElectronicDispatchInformation>
                    <ent:ElectronicDispatchEmail>algo@algo.com</ent:ElectronicDispatchEmail>
                    <ent:IsElectronicallyDispatched>true</ent:IsElectronicallyDispatched>
                </con:ElectronicDispatchInformation>
                <con:InsuredBasicCapitals xsi:nil="true"/>
                <con:InsuredGoods xsi:nil="true"/>
                <con:IsEmission xsi:nil="true"/>
                <con:PaymentFrequencyId>5</con:PaymentFrequencyId>
                <con:PolicyId>0</con:PolicyId>
                <con:Quota>0</con:Quota>
                <con:Quotation xsi:nil="true"/>
                <con:RiskAddress xsi:nil="true"/>
                <con:Since>2020-02-27T00:00:00</con:Since>
                <con:SpecialOperative/>
                <con:SurchargeDiscounts>
                <ent:SurchargeDiscount>
                <ent:Amount>0</ent:Amount>
                <ent:Rate>0</ent:Rate>
                <ent:SurchargeDiscountId>58</ent:SurchargeDiscountId>
                </ent:SurchargeDiscount>
                </ent:SurchargeDiscounts>
                <con:Thru>2021-02-27T00:00:00</con:Thru>
                </con:CertificateData>
                <con:CurrencyId>1</con:CurrencyId>
                <con:OrganizerNumber>111111</con:OrganizerNumber>
                <con:ProducerNumber>222222</con:ProducerNumber>
                <con:ProductId>24</con:ProductId>
                <con:RenewalTypeId>1</con:RenewalTypeId>
            </pol:request>
        </pol:CreateSinglePolicy>
    </soapenv:Body>
    </soapenv:Envelope>
*/

/**
 * REQUEST CON INSPECCION
    <soapenv:Envelope
    xmlns:p1="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ent="http://gruposancorseguros.com/ents/SOI/Entities/"
    xmlns:col="http://gruposancorseguros.com/ents/SOI/Collections/"
    xmlns:pol="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/"
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
    <soapenv:Header/>
    <soapenv:Body>
        <pol:CreateSinglePolicy>
            <pol:request xmlns:con="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">
                <con:CertificateData>
                <con:BillableClientRoleId>1</con:BillableClientRoleId>
                <con:BranchData xsi:type="con:AutomotiveBranchData">
                    <con:PercentDiscount>99</con:PercentDiscount>
                    <con:ScoringInformation>
                        <ent:DriverLessThan25Years>false</ent:DriverLessThan25Years>
                        <ent:MoreThan25000PerYear>false</ent:MoreThan25000PerYear>
                        <ent:StorageInGarage>true</ent:StorageInGarage>
                    </con:ScoringInformation>
                    <con:Vehicle>
                        <ent:Chassis>5ccTsfgr6g54sdg683301</ent:Chassis>
                        <ent:Chassis>12322222222D</ent:Chassis>
                        <ent:GncEquipment>
                            <ent:CylinderBrand_1>TUBOSI</ent:CylinderBrand_1>
                            <ent:CylinderNumber_1>456980</ent:CylinderNumber_1>
                            <ent:EquipmentValue>30000</ent:EquipmentValue>
                            <ent:RegulatorBrand>Regulator</ent:RegulatorBrand>
                            <ent:RegulatorNumber>123456</ent:RegulatorNumber>
                        </ent:GncEquipment>
                        <ent:License>HT581QZ</ent:License>
                        <ent:Motor>4mmCtC75sdrr54459</ent:Motor>
                        <ent:MustHaveTrackSystem>false</ent:MustHaveTrackSystem>
                        <ent:PreviousInspection>
                            <ent:Comments xsi:nil="true"/>
                            <ent:FilesAttached>
                            <ent:FileAttachment>
                                <ent:Content>LzlqLzRBQVFTa5az0=</ent:Content>
                                <ent:Name>auto2.jpg</ent:Name>
                            </ent:FileAttachment>
                            </ent:FilesAttached>
                            <ent:FuelTypeId>1</ent:FuelTypeId>
                            <ent:GeneralAspectId>2</ent:GeneralAspectId>
                            <ent:GlassResultId>SinProblemas</ent:GlassResultId>
                            <ent:InspectionDate>2017-01-02T00:00:00</ent:InspectionDate>
                            <ent:InspectionResultId xsi:nil="true"/>
                            <ent:Kilometrage>20</ent:Kilometrage>
                            <ent:PaintAspectId>2</ent:PaintAspectId>
                            <ent:PaintTypeId>2</ent:PaintTypeId>
                            <ent:SheetMetalAspectId>2</ent:SheetMetalAspectId>
                            <ent:TiresAspectId>2</ent:TiresAspectId>
                            <ent:UpholsteryAspectId>2</ent:UpholsteryAspectId>
                            <ent:UpholsteryColorId>9</ent:UpholsteryColorId>
                            <ent:UpholsteryTypeId xsi:nil="true"/>
                            <ent:VehicleColor>Negro</ent:VehicleColor>
                            <ent:WheelTypeId>2</ent:WheelTypeId>
                        </ent:PreviousInspection>
                        <ent:VehicleModelCode>0120546</ent:VehicleModelCode>
                        <ent:VehicleUseId>2</ent:VehicleUseId>
                        <ent:VehicleValue>5985000</ent:VehicleValue>
                        <ent:VehicleYear>2020</ent:VehicleYear>
                        <ent:ZeroKmValue>false</ent:ZeroKmValue>
                    </con:Vehicle>
                </con:BranchData>
                <con:Clients>
                    <col:KeyValuePairOfClientRoleIdsClient>
                        <col:key>2</col:key>
                        <col:value>
                            <ent:AreaCode>223</ent:AreaCode>
                            <ent:BirthDate>1991-01-06T00:00:00</ent:BirthDate>
                            <ent:BirthPlaceCityDescription>Mar Del Plata</ent:BirthPlaceCityDescription>
                            <ent:CityId>15815</ent:CityId>
                            <ent:DocumentNumber>35860103</ent:DocumentNumber>
                            <ent:DocumentType>D</ent:DocumentType>
                            <ent:Email>admin@admin.com</ent:Email>
                            <ent:FirstName>Luciano</ent:FirstName>
                            <ent:GenderId>2</ent:GenderId>
                            <ent:IvaConditionId>4</ent:IvaConditionId>
                            <ent:LastName>De Antoni</ent:LastName>
                            <ent:MainActivityCode>0</ent:MainActivityCode>
                            <ent:PhoneNumber>5449544</ent:PhoneNumber>
                            <ent:Street>Tucuman 1123</ent:Street>
                            <ent:ZipCode>7600</ent:ZipCode>
                        </col:value>
                    </col:KeyValuePairOfClientRoleIdsClient>
                </con:Clients>
                <con:Comments/>
                <con:CoverModuleCode>14</con:CoverModuleCode>
                <con:DebitData xsi:type="ent:CreditCardDebit">
                    <ent:CreditCardExpiration>2025-02-01T03:00:00Z</ent:CreditCardExpiration>
                    <ent:CreditCardId>5</ent:CreditCardId>
                    <ent:CreditCardNumber>4158473368388675</ent:CreditCardNumber>
                </con:DebitData>
                <con:DebitTypeId>2</con:DebitTypeId>
                <con:ElectronicDispatchInformation>
                    <ent:ElectronicDispatchEmail>admin@admin.com</ent:ElectronicDispatchEmail>
                    <ent:IsElectronicallyDispatched>false</ent:IsElectronicallyDispatched>
                </con:ElectronicDispatchInformation>
                <con:InsuredBasicCapitals xsi:nil="true"/>
                <con:InsuredGoods xsi:nil="true"/>
                <con:PaymentFrequencyId>5</con:PaymentFrequencyId>
                <con:Quota>0</con:Quota>
                <con:Since>2020-06-05T00:00:00</con:Since>
                <con:SurchargeDiscounts>
                    <SurchargeDiscount xmlns="http://gruposancorseguros.com/ents/SOI/Entities/">
                        <Rate>0</Rate>
                        <SurchargeDiscountId>58</SurchargeDiscountId>
                    </SurchargeDiscount>
                </con:SurchargeDiscounts>
                <con:Thru>2021-06-05T00:00:00</con:Thru>
                </con:CertificateData>
                <con:CurrencyId>1</con:CurrencyId>
                <con:OrganizerNumber>150532</con:OrganizerNumber>
                <con:ProducerNumber>211748</con:ProducerNumber>
                <con:ProductId>24</con:ProductId>
                <con:RenewalTypeId>1</con:RenewalTypeId>
            </pol:request>
        </pol:CreateSinglePolicy>
    </soapenv:Body>
    </soapenv:Envelope>
*/

/**
 * 200 con error de validacion de campo
    <?xml version="1.0" encoding="UTF-8"?>
    <NS1:Envelope xmlns:NS1="http://schemas.xmlsoap.org/soap/envelope/">
        <NS1:Header>
            <NS2:responseHeader xmlns:NS2="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
                <messageId>c1739a68-59cc-11eb-9717-ac1416b90000</messageId>
            </NS2:responseHeader>
        </NS1:Header>
        <NS1:Body>
            <NS3:CreateSinglePolicyResponse xmlns:NS3="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/">
                <NS3:CreateSinglePolicyResult>
                    <NS4:Errors xmlns:NS4="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">
                        <NS5:string xmlns:NS5="http://gruposancorseguros.com/ents/SOI/Collections/">- La Denominación/Razón Social no coincide con la registrada en AFIP. La Razón Social/Denominación ingresada es MERCADO MARIO y la registrada en AFIP es FUCHS OSVALDO ABRAHAM para el Número de Documento 33505050</NS5:string>
                    </NS4:Errors>
                </NS3:CreateSinglePolicyResult>
            </NS3:CreateSinglePolicyResponse>
        </NS1:Body>
    </NS1:Envelope>
*/