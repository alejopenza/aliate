@isTest
private class SancorCotizarVehiculoWebServiceTest {

    static final String COTIZADOR_ENDPOINT = [ SELECT isSandbox FROM Organization ].IsSandbox ? 'https://external-pre-ws.gruposancorseguros.com/Ssa/Channel/PriceSvc' : 'https://external-pro-ws.gruposancorseguros.com/Ssa/Channel/PriceSvc';

    static final String MOCK_RESPONSE = CalloutResponseFactory.SANCOR_COTIZAR_AUTO_RESPONSE;

    @IsTest
    private static void ifQuoteVehicleInsurancePricesForABikeTheRequestBodyIsCreatedAsExpected(){
        //Setup(Given)
        SancorCotizarVehiculoWebService wsSut = new SancorCotizarVehiculoWebService();

        CotizadorAPIRequest.Descuento descuento0 = new CotizadorAPIRequest.Descuento();
        descuento0.codigoDeDescuento = 1;
        descuento0.porcentaje = 0;

        CotizadorAPIRequest.Descuento descuento1 = new CotizadorAPIRequest.Descuento();
        descuento1.codigoDeDescuento = 55;
        descuento1.porcentaje = 0;

        CotizadorAPIRequest.Descuento descuento2 = new CotizadorAPIRequest.Descuento();
        descuento2.codigoDeDescuento = 58;
        descuento2.porcentaje = 0;

        CotizadorAPIRequest.Descuento descuento3 = new CotizadorAPIRequest.Descuento();
        descuento3.codigoDeDescuento = 4;
        descuento3.porcentaje = 0;

        CotizadorAPIRequest.Vehiculo vehiculo = new CotizadorAPIRequest.Vehiculo();
        vehiculo.codigo = 'B600051';
        vehiculo.anio = 2017;
        vehiculo.valor = 0;
        vehiculo.uso = 2;
        vehiculo.es0KM = false;

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.descuentos = new List<CotizadorAPIRequest.Descuento>{ descuento0, descuento1, descuento2, descuento3 };
        request.ciudadId = 0;
        request.numeroDeDocumento = 0;
        request.tipoDeDocumento = 'D';
        request.personaJuridica = false;
        request.codigosDeModuloDeCoberturas = new List<Integer>();
        request.fechaEfectiva = DateTime.newInstanceGMT(2020,05,11,0,0,0);
        request.bienAsegurado = 0;
        request.condicionAnteIVA = 4;
        request.numeroProductor = 211748;
        request.numeroOrganizacion = 150532;
        request.periodoDeValidez = 1;
        request.frecuenciaDePago = 5;
        request.cuotas = 0;
        request.codigoPostal = 2000;
        request.vehiculo = vehiculo;
        request.scoring = new List<CotizadorAPIRequest.Scoring>();


        //Exercise(When)
        Test.startTest();
        String bodyString =
            wsSut.createBody(request, Enumerator.Producto.MOTO);
        Test.stopTest();

        System.debug(bodyString);
        System.debug(COTIZADOR_MOTO_EXPECTED_REQUEST);
        //Test(Then)
        System.assertEquals(COTIZADOR_MOTO_EXPECTED_REQUEST, bodyString, '');
    }

    @IsTest
    private static void ifDontHaveCredentialsKeys_returnFalseAndMessageError(){
        //Setup(Given)
        SancorCotizarVehiculoWebService wsSut = new SancorCotizarVehiculoWebService();

        CotizadorAPIRequest request = new CotizadorAPIRequest();

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizarVehiculo(
                request,
                new Map<String,String>{ },
                Enumerator.Producto.AUTO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! conectionResult, 'No tiene que indicar que conecto correctamente, por que faltan credenciales.');
        System.assert(wsSut.serviceResponse.hasError, 'Tiene que indicar que hubo error.');
        System.assertEquals(
            'No se recibieron Credenciales.',
            wsSut.serviceResponse.message,
            'Tiene que indicar que faltan las credenciales.'
        );
    }

    @IsTest
    private static void ifDontHaveVehicleRequiredFieldsCompleted_returnFalseAndMessageError(){
        //Setup(Given)
        SancorCotizarVehiculoWebService wsSut = new SancorCotizarVehiculoWebService();

        CotizadorAPIRequest request = createRequest();
        request.vehiculo = new CotizadorAPIRequest.Vehiculo();
        request.scoring = new List<CotizadorAPIRequest.Scoring>{ new CotizadorAPIRequest.Scoring() };

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizarVehiculo(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AUTO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! conectionResult, 'No tiene que indicar que conecto correctamente, por que hay un fallo de red.');
        System.assert(wsSut.serviceResponse.hasError, 'Tiene que indicar que hubo error.');
        System.assertEquals(
            'Faltan los siguientes campos requeridos: Codigo del Vehiculo,Año del Vehiculo,Uso del Vehiculo,Falta datos de scoring',
            wsSut.serviceResponse.message,
            'Tiene que indicar que faltan campos requeridos del vehiculo'
        );
    }

    @IsTest
    private static void ifDontHaveRequiredFieldsCompleted_returnFalseAndMessageError(){
        //Setup(Given)
        SancorCotizarVehiculoWebService wsSut = new SancorCotizarVehiculoWebService();

        CotizadorAPIRequest request = new CotizadorAPIRequest();

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizarVehiculo(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AUTO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! conectionResult, 'No tiene que indicar que conecto correctamente, por que hay un fallo de red.');
        System.assert(wsSut.serviceResponse.hasError, 'Tiene que indicar que hubo error.');
        System.assertEquals(
            'Faltan los siguientes campos requeridos: Persona Juridica,Numero Productor,Numero Organizacion,Periodo de Validez,Frecuencia de Pago,Codigo Postal,Datos del Vehiculo',
            wsSut.serviceResponse.message,
            'Tiene que indicar que faltan todos los campos requeridos.'
        );
    }

    @IsTest
    private static void ifHasANetworkConnectionError_ReturnFalse(){
        //Setup(Given)
        SancorCotizarVehiculoWebService wsSut = new SancorCotizarVehiculoWebService();

        CotizadorAPIRequest request = createRequest();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse().simulateNetworkError().addForAddress(COTIZADOR_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizarVehiculo(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AUTO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! conectionResult, 'No tiene que indicar que conecto correctamente, por que no se completaron los campos requeridos.');
    }

    @IsTest
    private static void ifCanQuoteVehicleInsurancePricesWithSpecificModulesAndStaticCodeAndWithoutDiscounts_ReturnTrue(){
        //Setup(Given)
        SancorCotizarVehiculoWebService wsSut = new SancorCotizarVehiculoWebService();

        CotizadorAPIRequest request = createRequest();
        request.codigosDeModuloDeCoberturas = new List<Integer>{ 1,2 };
        request.grupoEstadistico = 12467;
        request.descuentos = new List<CotizadorAPIRequest.Descuento>();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()// Cotizar Vehiculo
            .withStatus('Successfull')
            .withBody(MOCK_RESPONSE)
            .addForAddress(COTIZADOR_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizarVehiculo(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AUTO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(conectionResult, 'Tiene que indicar True por que conecto correctamente.');
        System.assert(! wsSut.serviceResponse.hasError, 'No tiene que marcar que hay error, revisar la respuesta del servicio y el processResponse');
        System.assertNotEquals(null, wsSut.serviceResponse.request, 'Se tiene que guardar el request al hacer la llamada');
        System.assertNotEquals(null, wsSut.serviceResponse.response, 'Se tiene que guardar el response al hacer la llamada');
        System.assertEquals(null, wsSut.serviceResponse.message, 'No tiene que figurar ningun mensaje');
    }

    @IsTest
    private static void ifCanQuoteVehicleInsurancePrices_ReturnTrue(){
        //Setup(Given)
        SancorCotizarVehiculoWebService wsSut = new SancorCotizarVehiculoWebService();

        CotizadorAPIRequest request = createRequest();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()// Cotizar Vehiculo
            .withStatus('Successfull')
            .withBody(MOCK_RESPONSE)
            .addForAddress(COTIZADOR_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizarVehiculo(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AUTO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(conectionResult, 'Tiene que indicar True por que conecto correctamente.');
        System.assert(! wsSut.serviceResponse.hasError, 'No tiene que marcar que hay error, revisar la respuesta del servicio y el processResponse');
        System.assertNotEquals(null, wsSut.serviceResponse.request, 'Se tiene que guardar el request al hacer la llamada');
        System.assertNotEquals(null, wsSut.serviceResponse.response, 'Se tiene que guardar el response al hacer la llamada');
        System.assertEquals(null, wsSut.serviceResponse.message, 'No tiene que figurar ningun mensaje');

        CotizadorAPIResponse cotizacion = wsSut.serviceResponse.cotizacion;

        System.assertNotEquals(-1, cotizacion.idCotizacion, 'No tiene que ser -1 por que se proceso la respuesta');
        System.assertEquals(413740035, cotizacion.idCotizacion, 'Tiene que tener distinto a -1 por que se proceso la respuesta');
        System.assertNotEquals(-1, cotizacion.idCotizacionRelacion, 'No tiene que ser -1 por que se proceso la respuesta');
        System.assertEquals(5072201, cotizacion.idCotizacionRelacion, 'Tiene que tener distinto a -1 por que se proceso la respuesta');
        System.assertEquals(2, cotizacion.planes.size(), 'Tiene que tener planes procesados!');

        System.assertEquals(9, cotizacion.planes[0].moduloCodigo,'');
        System.assertEquals('',cotizacion.planes[0].clienteDescripcion,'');
        System.assertEquals('Auto Todo Riesgo 9 (c/deduc. $ 10000 c/Asistencia)', cotizacion.planes[0].descripcionLarga, '');
        System.assertEquals('Auto Todo Riesgo 9', cotizacion.planes[0].descripcionCorta, '');
        System.assertEquals('Las coberturas Auto Max 6, Auto Premium Max y las distintas alternativa de Todo Riesgo son solo informativas y quedarán sujetas a la inspección, solicitud de fotos o a la determinación que defina el análisis previo del área de suscripción.', cotizacion.planes[0].mensajeInformativo, '');
        System.assertEquals(2385.00, cotizacion.planes[0].premioMensual, '');
        System.assertEquals(28630.80, cotizacion.planes[0].premioTotal, '');
        System.assertEquals(true, cotizacion.planes[0].cotizacionExitosa, '');
        System.assertEquals('', cotizacion.planes[0].resultadoValidacion, '');
        System.assertEquals(true, cotizacion.planes[0].fueraDeNorma, '');
        System.assertEquals(false, cotizacion.planes[0].poseeEquipoDeRastreo, '');
        System.assertEquals(262000, cotizacion.planes[0].valuacionDelVechiculo, '');
        System.assertEquals(52474682, cotizacion.planes[0].idPrecios, '');
        System.assertEquals(52474676, cotizacion.planes[0].idPreciosAPF, '');
        System.assertEquals(1797.28, cotizacion.planes[0].ivaMensual, '');
        System.assertEquals(21567.34, cotizacion.planes[0].ivaTotal, '');
        System.assertEquals(1781.81, cotizacion.planes[0].primaPuraMensual, '');
        System.assertEquals(21381.70, cotizacion.planes[0].PrimaPuraTotal, '');
        System.assertEquals(2, cotizacion.planes[0].sumasAseguradas.size(), '');

        System.assertEquals(10180000, cotizacion.planes[0].sumasAseguradas[0].capital, '');
        System.assertEquals('Resp. Civil: Daños a cosas no transportadas de terceras personas.', cotizacion.planes[0].sumasAseguradas[0].descripcion, '');
        System.assertEquals('Prima', cotizacion.planes[0].sumasAseguradas[0].detalle, '');
        System.assertEquals(1, cotizacion.planes[0].sumasAseguradas[0].detalleCodigo, '');
        System.assertEquals(25.29, cotizacion.planes[0].sumasAseguradas[0].primaPuraMensual, '');
        System.assertEquals(303.53, cotizacion.planes[0].sumasAseguradas[0].primaPuraTotal, '');
        System.assertEquals('Cobertura', cotizacion.planes[0].sumasAseguradas[0].detalleTipo, '');
    }

    private static CotizadorAPIRequest createRequest(){
        CotizadorAPIRequest.Descuento descuento0 = new CotizadorAPIRequest.Descuento();
        descuento0.codigoDeDescuento = 1;
        descuento0.porcentaje = 99;

        CotizadorAPIRequest.Descuento descuento1 = new CotizadorAPIRequest.Descuento();
        descuento1.codigoDeDescuento = 58;
        descuento1.porcentaje = 0;

        CotizadorAPIRequest.Descuento descuento2 = new CotizadorAPIRequest.Descuento();
        descuento2.codigoDeDescuento = 4;
        descuento2.porcentaje = 0;

        CotizadorAPIRequest.Scoring scoring0 = new CotizadorAPIRequest.Scoring();
        scoring0.tipoId = 3;
        scoring0.opcionId = 1;

        CotizadorAPIRequest.Scoring scoring1 = new CotizadorAPIRequest.Scoring();
        scoring1.tipoId = 7;
        scoring1.opcionId = 2;

        CotizadorAPIRequest.Scoring scoring3 = new CotizadorAPIRequest.Scoring();
        scoring3.tipoId = 8;
        scoring3.opcionId = 1;

        CotizadorAPIRequest.Vehiculo vehiculo = new CotizadorAPIRequest.Vehiculo();
        vehiculo.codigo = '0180517';
        vehiculo.anio = 2013;
        vehiculo.valor = 0;
        vehiculo.uso = 2;
        vehiculo.tieneGNC = false;
        vehiculo.valorEquipoGNC = 0;
        vehiculo.poseeRuedaDeAuxilio = false;
        vehiculo.es0KM = false;

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.ciudadId = 1157;
        request.numeroDeDocumento = 12599862;
        request.tipoDeDocumento = 'D';
        request.personaJuridica = false;
        request.codigosDeModuloDeCoberturas = new List<Integer>();
        request.descuentos = new List<CotizadorAPIRequest.Descuento>{ descuento0, descuento1, descuento2 };
        request.fechaEfectiva = DateTime.newInstance(29,10,2018,0,0,0);
        request.bienAsegurado = 0;
        request.condicionAnteIVA = 4;
        request.numeroProductor = 212505;
        request.numeroOrganizacion = 150766;
        request.periodoDeValidez = 1;
        request.frecuenciaDePago = 5;
        request.cuotas = 0;
        request.codigoPostal = 2300;
        request.vehiculo = vehiculo;
        request.scoring = new List<CotizadorAPIRequest.Scoring>{ scoring0, scoring1, scoring3 };
        return request;
    }

    static final String COTIZADOR_MOTO_EXPECTED_REQUEST = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:a="http://GrupoSancorSeguros/xsd/entity/PriceTypes" xmlns:b="http://GrupoSancorSeguros/xsd/entity/CommonTypes" xmlns:c="http://GrupoSancorSeguros/xsd/entity/IntermediaryTypes" xmlns:d="http://GrupoSancorSeguros/xsd/entity/VehicleTypes" xmlns:e="http://GrupoSancorSeguros/xsd/entity/ProductTypes" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">'
        +   '<soapenv:Header>'
        +      '<Action xmlns="http://schemas.microsoft.com/ws/2005/05/addressing/none" soapenv:mustUnderstand="1">http://GrupoSancorSeguros/wsdl/service/PriceSvc/NewVehicle</Action>'
        +   '</soapenv:Header>'
        +   '<soapenv:Body xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        +      '<NewVehicle_Rq xmlns="http://GrupoSancorSeguros/xsd/service/PriceSvcMsg">'
        +         '<Price>'
        +            '<a:City>'
        +               '<b:Id>0</b:Id>'
        +            '</a:City>'
        +            '<a:DocumentNumber>0</a:DocumentNumber>'
        +            '<a:Document>'
        +               '<b:Type>D</b:Type>'
        +            '</a:Document>'
        +            '<a:IsJuridicPerson>0</a:IsJuridicPerson>'
        +            '<a:CoverModuleCodes />'
        +            '<a:Currency>'
        +               '<b:Id>1</b:Id>'
        +            '</a:Currency>'
        +            '<a:DiscountCustomizations>'
        +               '<a:DiscountCustomization>'
        +                  '<a:DiscountNumber>1</a:DiscountNumber>'
        +                  '<a:Rate>0</a:Rate>'
        +               '</a:DiscountCustomization>'
        +               '<a:DiscountCustomization>'
        +                  '<a:DiscountNumber>55</a:DiscountNumber>'
        +                  '<a:Rate>0</a:Rate>'
        +               '</a:DiscountCustomization>'
        +               '<a:DiscountCustomization>'
        +                  '<a:DiscountNumber>58</a:DiscountNumber>'
        +                  '<a:Rate>0</a:Rate>'
        +               '</a:DiscountCustomization>'
        +               '<a:DiscountCustomization>'
        +                  '<a:DiscountNumber>4</a:DiscountNumber>'
        +                  '<a:Rate>0</a:Rate>'
        +               '</a:DiscountCustomization>'
        +            '</a:DiscountCustomizations>'
        +            '<a:EffectDate>2020-05-11T00:00:00</a:EffectDate>'
        +            '<a:InsuredGood>0</a:InsuredGood>'
        +            '<a:IvaCondition>'
        +               '<b:Id>4</b:Id>'
        +            '</a:IvaCondition>'
        +            '<a:Intermediary>'
        +               '<c:Code>211748</c:Code>'
        +               '<c:Supervisor>150532</c:Supervisor>'
        +               '<c:StatisticCode>0</c:StatisticCode>'
        +            '</a:Intermediary>'
        +            '<a:PeriodOfValidity>'
        +               '<b:Id>1</b:Id>'
        +            '</a:PeriodOfValidity>'
        +            '<a:Frequency>'
        +               '<b:Id>5</b:Id>'
        +            '</a:Frequency>'
        +            '<a:Fee>'
        +               '<b:Id>0</b:Id>'
        +            '</a:Fee>'
        +            '<a:Product>'
        +               '<e:Id>863</e:Id>'
        +            '</a:Product>'
        +            '<a:Zone>'
        +               '<b:ZipCode>2000</b:ZipCode>'
        +            '</a:Zone>'
        +            '<a:Vehicle>'
        +               '<d:Code>B600051</d:Code>'
        +               '<d:Year>2017</d:Year>'
        +               '<d:Value>'
        +                  '<d:Capital>0</d:Capital>'
        +               '</d:Value>'
        +               '<d:Use>'
        +                  '<b:Id>2</b:Id>'
        +               '</d:Use>'
        +               '<d:IsOkm>false</d:IsOkm>'
        +            '</a:Vehicle>'
        +         '</Price>'
        +      '</NewVehicle_Rq>'
        +   '</soapenv:Body>'
        +'</soapenv:Envelope>';
}