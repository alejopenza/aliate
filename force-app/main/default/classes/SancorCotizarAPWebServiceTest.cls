@isTest
private class SancorCotizarAPWebServiceTest {

    static final String COTIZADOR_ENDPOINT = [ SELECT isSandbox FROM Organization ].IsSandbox ? 'https://external-pre-ws.gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc' : 'https://external-pro-ws.gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc';
    static final String INTERNAL_SERVER_ERROR_RESPONSE = CalloutResponseFactory.SANCOR_INTERNAL_SERVER_MOCK_RESPONSE;
    static final String COTIZADOR_AP_RESPONSE = CalloutResponseFactory.SANCOR_ACCIDENTES_PERSONALES_RESPONSE;

    @IsTest
    private static void shoulBeAbleToConsumeTheServiceAndGetAGoodResponse(){
        //Setup(Given)
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest.Descuento descuento = new CotizadorAPIRequest.Descuento();
        descuento.codigoDeDescuento = 0;
        descuento.porcentaje = 0;

        CotizadorAPIRequest.SumaAsegurada sumaMuerte76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte76a80.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte76a80.monto = 0;

        CotizadorAPIRequest.RangoEtario rango76a80 = new CotizadorAPIRequest.RangoEtario();
        rango76a80.tipoDeRango = Enumerator.RangoEtario.EDAD_76_A_80;
        rango76a80.seleccionado = false;
        rango76a80.cantidadDePersonas = 0;
        rango76a80.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte76a80 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte71a75.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte71a75.monto = 0;

        CotizadorAPIRequest.RangoEtario rango71a75 = new CotizadorAPIRequest.RangoEtario();
        rango71a75.tipoDeRango = Enumerator.RangoEtario.EDAD_71_A_75;
        rango71a75.seleccionado = false;
        rango71a75.cantidadDePersonas = 0;
        rango71a75.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte71a75 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte16a17.tipoDeSuma = Enumerator.SumaTipo.MUERTE;

        CotizadorAPIRequest.RangoEtario rango16a70 = new CotizadorAPIRequest.RangoEtario();
        rango16a70.tipoDeRango = Enumerator.RangoEtario.EDAD_16_A_70;
        rango16a70.seleccionado = true;
        rango16a70.cantidadDePersonas = 3;
        rango16a70.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte16a17 };

        CotizadorAPIRequest.PersonaAsegurada personasAseguradas = new CotizadorAPIRequest.PersonaAsegurada();
        personasAseguradas.codigoProfesion = 9;
        personasAseguradas.codigoClasificacion = 42;
        personasAseguradas.codigoTarea = 0;
        personasAseguradas.rangoEtario = new List<CotizadorAPIRequest.RangoEtario>{
            rango16a70, rango71a75, rango76a80
        };

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.numeroDeDocumento = 0;
        request.tipoDeDocumento = 'D';
        request.ciudadId = 0;
        request.codigoPostal = 2322;
        request.codigosDeModuloDeCoberturas = new List<Integer> { 18 };
        request.condicionAnteIVA = 4;
        request.frecuenciaDePago= 5;
        request.descuentos = new List<CotizadorAPIRequest.Descuento> { descuento };
        request.numeroOrganizacion = 111111;
        request.numeroProductor = 222222;
        request.grupoEstadistico = 0;
        request.periodoDeValidez = 1;
        request.cuotas = 0;
        request.fechaEfectiva = DateTime.newInstanceGmt(2020, 9, 02, 0, 0, 0);
        request.codigoPolizaTipo = 1;
        request.fechaExpiracion = DateTime.newInstanceGmt(2021, 9, 02, 0, 0, 0);
        request.personasAseguradas = personasAseguradas;
        request.respetarCondicionIVACliente = false;

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Succesfull')
            .withStatusCode(200)
            .withBody(COTIZADOR_AP_RESPONSE)
            .addForAddress(COTIZADOR_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
        wsSut.cotizar (
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AP_24HS_MODULADO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(conectionResult, 'Tiene que indicar que la conexion fue exitosa');
        System.assert(! wsSut.serviceResponse.hasError, 'No tiene que haber un error.');
        System.assertEquals(null, wsSut.serviceResponse.message, 'No tiene que tener mensaje de error.');
        System.assertNotEquals(null, wsSut.serviceResponse.cotizacion, 'Tiene que tener una cotizacion.');

        CotizadorAPIResponse cotizacion = wsSut.serviceResponse.cotizacion;
        System.assertEquals(0, cotizacion.idCotizacionRelacion);
        System.assertEquals(1, cotizacion.planes.size());

        CotizadorAPIResponse.Plan planCotizado = cotizacion.planes[0];
        System.assertEquals(Enumerator.RangoEtario.EDAD_16_A_70, planCotizado.rango);
        System.assertEquals(287.22, planCotizado.ivaMensual);
        System.assertEquals(3446.55, planCotizado.ivaTotal);
        System.assertEquals(378.00, planCotizado.premioMensual);
        System.assertEquals(4527.09, planCotizado.premioTotal);
        System.assertEquals(true, planCotizado.cotizacionExitosa);
        System.assertEquals(52556847, planCotizado.idPrecios);
        System.assertEquals(0, planCotizado.idPreciosValor);
        System.assertNotEquals(0, planCotizado.sumasAseguradas.size());

        CotizadorAPIResponse.SumaAsegurada suma = planCotizado.sumasAseguradas[0];
        System.assertEquals(700000, suma.capital);
        System.assertEquals('Muerte Accidental', suma.descripcion);
        System.assertEquals('Prima', suma.detalle);
        System.assertEquals(1, suma.detalleCodigo);
        System.assertEquals(40.06, suma.primaPuraMensual);
        System.assertEquals(480.69, suma.primaPuraTotal);
        System.assertEquals('Cobertura', suma.detalleTipo);

        // <ValidationResults>
        //     <ValidationResult>
        //         <ErrorMessage>El grupo estadístico es inexistente o no aplica al intermediario.</ErrorMessage>
        //         <Level>Warning</Level>
        //         <MemberNames />
        //     </ValidationResult>
        // </ValidationResults>
    }

    @IsTest
    private static void ifHaveAServerError_returnFalseAndFaultMessages(){
        //Setup(Given)
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest.Descuento descuento = new CotizadorAPIRequest.Descuento();
        descuento.codigoDeDescuento = 0;
        descuento.porcentaje = 0;

        CotizadorAPIRequest.SumaAsegurada sumaMuerte76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte76a80.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte76a80.monto = 0;

        CotizadorAPIRequest.RangoEtario rango76a80 = new CotizadorAPIRequest.RangoEtario();
        rango76a80.tipoDeRango = Enumerator.RangoEtario.EDAD_76_A_80;
        rango76a80.seleccionado = false;
        rango76a80.cantidadDePersonas = 0;
        rango76a80.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte76a80 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte71a75.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte71a75.monto = 0;

        CotizadorAPIRequest.RangoEtario rango71a75 = new CotizadorAPIRequest.RangoEtario();
        rango71a75.tipoDeRango = Enumerator.RangoEtario.EDAD_71_A_75;
        rango71a75.seleccionado = false;
        rango71a75.cantidadDePersonas = 0;
        rango71a75.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte71a75 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte16a17.tipoDeSuma = Enumerator.SumaTipo.MUERTE;

        CotizadorAPIRequest.RangoEtario rango16a70 = new CotizadorAPIRequest.RangoEtario();
        rango16a70.tipoDeRango = Enumerator.RangoEtario.EDAD_16_A_70;
        rango16a70.seleccionado = true;
        rango16a70.cantidadDePersonas = 3;
        rango16a70.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte16a17 };

        CotizadorAPIRequest.PersonaAsegurada personasAseguradas = new CotizadorAPIRequest.PersonaAsegurada();
        personasAseguradas.codigoProfesion = 9;
        personasAseguradas.codigoClasificacion = 42;
        personasAseguradas.codigoTarea = 0;
        personasAseguradas.rangoEtario = new List<CotizadorAPIRequest.RangoEtario>{
            rango16a70, rango71a75, rango76a80
        };

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.numeroDeDocumento = 0;
        request.tipoDeDocumento = 'D';
        request.ciudadId = 0;
        request.codigoPostal = 2322;
        request.codigosDeModuloDeCoberturas = new List<Integer> { 18 };
        request.condicionAnteIVA = 4;
        request.frecuenciaDePago= 5;
        request.descuentos = new List<CotizadorAPIRequest.Descuento> { descuento };
        request.numeroOrganizacion = 111111;
        request.numeroProductor = 222222;
        request.grupoEstadistico = 0;
        request.periodoDeValidez = 1;
        request.cuotas = 0;
        request.fechaEfectiva = DateTime.newInstanceGmt(2020, 9, 02, 0, 0, 0);
        request.codigoPolizaTipo = 1;
        request.fechaExpiracion = DateTime.newInstanceGmt(2021, 9, 02, 0, 0, 0);
        request.personasAseguradas = personasAseguradas;
        request.respetarCondicionIVACliente = false;

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Error')
            .withStatusCode(500)
            .withBody(INTERNAL_SERVER_ERROR_RESPONSE)
            .addForAddress(COTIZADOR_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
        wsSut.cotizar (
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AP_24HS_MODULADO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! conectionResult, 'Tiene que indicar que hubo un error en procesar el request');
        System.assert(wsSut.serviceResponse.hasError, 'Tiene que indicar que no hubo error.');
        System.assertEquals(null, wsSut.serviceResponse.message, 'No tiene que tener mensaje de error de conexion');
        System.assertEquals(
            'env:Client',
            wsSut.serviceResponse.faultCode,
            'No cargo el codigo de error'
        );
        System.assertEquals(
            'Internal Error',
            wsSut.serviceResponse.faultString,
            'Debe indicar que hay error de afip'
        );
    }

    @IsTest
    private static void ifDontHaveCredentialsKeys_returnFalseAndMessageError(){
        //Setup(Given)
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest request = new CotizadorAPIRequest();

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizar (
                  request,
                  new Map<String,String>(),
                  Enumerator.Producto.AP_24HS_MODULADO
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

    @isTest
    private static void ifCreateAPOcasionTrabajoBody_IsCreatedCorrectly() {
        // Test data setup
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest.SumaAsegurada sumaMuerte76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte76a80.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte76a80.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaAsistencia76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaAsistencia76a80.tipoDeSuma = Enumerator.SumaTipo.ASISTENCIA_MEDICA;
        sumaAsistencia76a80.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaSubencion76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaSubencion76a80.tipoDeSuma = Enumerator.SumaTipo.SUBVENCION_MUERTE;
        sumaSubencion76a80.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaInternacion76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaInternacion76a80.tipoDeSuma = Enumerator.SumaTipo.INTERNACION_DIARIA;
        sumaInternacion76a80.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaFijo76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaFijo76a80.tipoDeSuma = Enumerator.SumaTipo.MONTO_FIJO;
        sumaFijo76a80.monto = 0;

        CotizadorAPIRequest.RangoEtario rango76a80 = new CotizadorAPIRequest.RangoEtario();
        rango76a80.tipoDeRango = Enumerator.RangoEtario.EDAD_76_A_80;
        rango76a80.seleccionado = false;
        rango76a80.cantidadDePersonas = 0;
        rango76a80.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{
            sumaMuerte76a80, sumaAsistencia76a80, sumaSubencion76a80, sumaInternacion76a80, sumaFijo76a80
        };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte71a75.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte71a75.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaAsistencia71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaAsistencia71a75.tipoDeSuma = Enumerator.SumaTipo.ASISTENCIA_MEDICA;
        sumaAsistencia71a75.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaSubencion71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaSubencion71a75.tipoDeSuma = Enumerator.SumaTipo.SUBVENCION_MUERTE;
        sumaSubencion71a75.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaInternacion71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaInternacion71a75.tipoDeSuma = Enumerator.SumaTipo.INTERNACION_DIARIA;
        sumaInternacion71a75.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaFijo71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaFijo71a75.tipoDeSuma = Enumerator.SumaTipo.MONTO_FIJO;
        sumaFijo71a75.monto = 0;

        CotizadorAPIRequest.RangoEtario rango71a75 = new CotizadorAPIRequest.RangoEtario();
        rango71a75.tipoDeRango = Enumerator.RangoEtario.EDAD_71_A_75;
        rango71a75.seleccionado = false;
        rango71a75.cantidadDePersonas = 0;
        rango71a75.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{
            sumaMuerte71a75, sumaAsistencia71a75, sumaSubencion71a75, sumaInternacion71a75, sumaFijo71a75
        };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte16a17.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte16a17.monto = 1000000;
        CotizadorAPIRequest.SumaAsegurada sumaAsistencia16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaAsistencia16a17.tipoDeSuma = Enumerator.SumaTipo.ASISTENCIA_MEDICA;
        sumaAsistencia16a17.monto = 100000;
        CotizadorAPIRequest.SumaAsegurada sumaSubencion16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaSubencion16a17.tipoDeSuma = Enumerator.SumaTipo.SUBVENCION_MUERTE;
        sumaSubencion16a17.monto = 20000;
        CotizadorAPIRequest.SumaAsegurada sumaInternacion16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaInternacion16a17.tipoDeSuma = Enumerator.SumaTipo.INTERNACION_DIARIA;
        sumaInternacion16a17.monto = 10000;
        CotizadorAPIRequest.SumaAsegurada sumaFijo16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaFijo16a17.tipoDeSuma = Enumerator.SumaTipo.MONTO_FIJO;
        sumaFijo16a17.monto = 5000;

        CotizadorAPIRequest.RangoEtario rango16a70 = new CotizadorAPIRequest.RangoEtario();
        rango16a70.tipoDeRango = Enumerator.RangoEtario.EDAD_16_A_70;
        rango16a70.seleccionado = true;
        rango16a70.cantidadDePersonas = 2;
        rango16a70.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{
            sumaMuerte16a17, sumaAsistencia16a17, sumaSubencion16a17, sumaInternacion16a17, sumaFijo16a17
        };

        CotizadorAPIRequest.PersonaAsegurada personasAseguradas = new CotizadorAPIRequest.PersonaAsegurada();
        personasAseguradas.codigoProfesion = 8;
        personasAseguradas.codigoClasificacion = 38;
        personasAseguradas.codigoTarea = 3;
        personasAseguradas.rangoEtario = new List<CotizadorAPIRequest.RangoEtario>{
            rango16a70, rango71a75, rango76a80
        };

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.numeroDeDocumento = 0;
        request.tipoDeDocumento = 'D';
        request.ciudadId = 0;
        request.codigoPostal = 2322;
        request.codigosDeModuloDeCoberturas = new List<Integer> { 1 };
        request.condicionAnteIVA = 4;
        request.frecuenciaDePago= 5;
        request.descuentos = new List<CotizadorAPIRequest.Descuento>();
        request.numeroOrganizacion = 111111;
        request.numeroProductor = 222222;
        request.periodoDeValidez = 1;
        request.cuotas = 0;
        request.fechaEfectiva = DateTime.newInstanceGmt(2020, 9, 15, 0, 0, 0);
        request.codigoPolizaTipo = 1;
        request.fechaExpiracion = DateTime.newInstanceGmt(2021, 9, 15, 0, 0, 0);
        request.personasAseguradas = personasAseguradas;
        request.respetarCondicionIVACliente = false;

        // Actual test
        Test.startTest();
        String bodyString = wsSut.createBody(request, Enumerator.Producto.AP_OCASION_TRABAJO,wsSut.getMethodName(Enumerator.Producto.AP_OCASION_TRABAJO));
        Test.stopTest();

        // Asserts
        System.debug(AP_OCASION_TRABAJO_EXPECTED_REQUEST_BODY);
        System.debug(bodyString);
        System.assertEquals(AP_OCASION_TRABAJO_EXPECTED_REQUEST_BODY, bodyString, 'No genero el string body como se espera, revisar el parseo');
    }

    @isTest
    private static void ifCreateAPIntegroBody_IsCreatedCorrectly() {
        // Test data setup
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest.Descuento descuento = new CotizadorAPIRequest.Descuento();
        descuento.codigoDeDescuento = 0;
        descuento.porcentaje = 0;

        CotizadorAPIRequest.SumaAsegurada sumaMuerte76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte76a80.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte76a80.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaAsistencia76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaAsistencia76a80.tipoDeSuma = Enumerator.SumaTipo.ASISTENCIA_MEDICA;
        sumaAsistencia76a80.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaEntierro76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaEntierro76a80.tipoDeSuma = Enumerator.SumaTipo.COSTOS_ENTIERRO;
        sumaEntierro76a80.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaInternacion76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaInternacion76a80.tipoDeSuma = Enumerator.SumaTipo.INTERNACION_DIARIA;
        sumaInternacion76a80.monto = 0;

        CotizadorAPIRequest.RangoEtario rango76a80 = new CotizadorAPIRequest.RangoEtario();
        rango76a80.tipoDeRango = Enumerator.RangoEtario.EDAD_76_A_80;
        rango76a80.seleccionado = false;
        rango76a80.cantidadDePersonas = 0;
        rango76a80.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{
            sumaMuerte76a80, sumaAsistencia76a80, sumaEntierro76a80, sumaInternacion76a80
        };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte71a75.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte71a75.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaAsistencia71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaAsistencia71a75.tipoDeSuma = Enumerator.SumaTipo.ASISTENCIA_MEDICA;
        sumaAsistencia71a75.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaEntierro71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaEntierro71a75.tipoDeSuma = Enumerator.SumaTipo.COSTOS_ENTIERRO;
        sumaEntierro71a75.monto = 0;
        CotizadorAPIRequest.SumaAsegurada sumaInternacion71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaInternacion71a75.tipoDeSuma = Enumerator.SumaTipo.INTERNACION_DIARIA;
        sumaInternacion71a75.monto = 0;

        CotizadorAPIRequest.RangoEtario rango71a75 = new CotizadorAPIRequest.RangoEtario();
        rango71a75.tipoDeRango = Enumerator.RangoEtario.EDAD_71_A_75;
        rango71a75.seleccionado = false;
        rango71a75.cantidadDePersonas = 0;
        rango71a75.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{
            sumaMuerte71a75, sumaAsistencia71a75, sumaEntierro71a75, sumaInternacion71a75
        };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte16a17.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte16a17.monto = 500000;
        CotizadorAPIRequest.SumaAsegurada sumaAsistencia16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaAsistencia16a17.tipoDeSuma = Enumerator.SumaTipo.ASISTENCIA_MEDICA;
        sumaAsistencia16a17.monto = 100000;
        CotizadorAPIRequest.SumaAsegurada sumaEntierro16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaEntierro16a17.tipoDeSuma = Enumerator.SumaTipo.COSTOS_ENTIERRO;
        sumaEntierro16a17.monto = 5000;
        CotizadorAPIRequest.SumaAsegurada sumaInternacion16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaInternacion16a17.tipoDeSuma = Enumerator.SumaTipo.INTERNACION_DIARIA;
        sumaInternacion16a17.monto = 10000;

        CotizadorAPIRequest.RangoEtario rango16a70 = new CotizadorAPIRequest.RangoEtario();
        rango16a70.tipoDeRango = Enumerator.RangoEtario.EDAD_16_A_70;
        rango16a70.seleccionado = true;
        rango16a70.cantidadDePersonas = 5;
        rango16a70.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{
            sumaMuerte16a17, sumaAsistencia16a17, sumaEntierro16a17, sumaInternacion16a17
        };

        CotizadorAPIRequest.PersonaAsegurada personasAseguradas = new CotizadorAPIRequest.PersonaAsegurada();
        personasAseguradas.codigoProfesion = 8;
        personasAseguradas.codigoClasificacion = 20016;
        personasAseguradas.rangoEtario = new List<CotizadorAPIRequest.RangoEtario>{
            rango16a70, rango71a75, rango76a80
        };

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.numeroDeDocumento = 0;
        request.tipoDeDocumento = 'D';
        request.ciudadId = 0;
        request.codigoPostal = 2322;
        request.codigosDeModuloDeCoberturas = new List<Integer> { 4 };
        request.condicionAnteIVA = 4;
        request.frecuenciaDePago= 5;
        request.descuentos = new List<CotizadorAPIRequest.Descuento> { descuento };
        request.numeroOrganizacion = 111111;
        request.numeroProductor = 222222;
        request.grupoEstadistico = 0;
        request.periodoDeValidez = 1;
        request.cuotas = 0;
        request.fechaEfectiva = DateTime.newInstanceGmt(2020, 9, 15, 0, 0, 0);
        request.codigoPolizaTipo = 2;
        request.fechaExpiracion = DateTime.newInstanceGmt(2021, 9, 15, 0, 0, 0);
        request.personasAseguradas = personasAseguradas;
        request.respetarCondicionIVACliente = false;

        // Actual test
        Test.startTest();
        String bodyString = wsSut.createBody(request, Enumerator.Producto.AP_INTEGRO_MAX,wsSut.getMethodName(Enumerator.Producto.AP_INTEGRO_MAX));
        Test.stopTest();

        // Asserts
        System.assertEquals(AP_INTEGRO_MAX_EXPECTED_REQUEST_BODY, bodyString, 'No genero el string body como se espera, revisar el parseo');
    }

    @isTest
    private static void ifCreateAP24Body_IsCreatedCorrectly() {
        // Test data setup
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest.Descuento descuento = new CotizadorAPIRequest.Descuento();
        descuento.codigoDeDescuento = 0;
        descuento.porcentaje = 0;

        CotizadorAPIRequest.SumaAsegurada sumaMuerte76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte76a80.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte76a80.monto = 0;

        CotizadorAPIRequest.RangoEtario rango76a80 = new CotizadorAPIRequest.RangoEtario();
        rango76a80.tipoDeRango = Enumerator.RangoEtario.EDAD_76_A_80;
        rango76a80.seleccionado = false;
        rango76a80.cantidadDePersonas = 0;
        rango76a80.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte76a80 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte71a75.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte71a75.monto = 0;

        CotizadorAPIRequest.RangoEtario rango71a75 = new CotizadorAPIRequest.RangoEtario();
        rango71a75.tipoDeRango = Enumerator.RangoEtario.EDAD_71_A_75;
        rango71a75.seleccionado = false;
        rango71a75.cantidadDePersonas = 0;
        rango71a75.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte71a75 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte16a17.tipoDeSuma = Enumerator.SumaTipo.MUERTE;

        CotizadorAPIRequest.RangoEtario rango16a70 = new CotizadorAPIRequest.RangoEtario();
        rango16a70.tipoDeRango = Enumerator.RangoEtario.EDAD_16_A_70;
        rango16a70.seleccionado = true;
        rango16a70.cantidadDePersonas = 3;
        rango16a70.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte16a17 };

        CotizadorAPIRequest.PersonaAsegurada personasAseguradas = new CotizadorAPIRequest.PersonaAsegurada();
        personasAseguradas.codigoProfesion = 9;
        personasAseguradas.codigoClasificacion = 42;
        personasAseguradas.codigoTarea = 0;
        personasAseguradas.rangoEtario = new List<CotizadorAPIRequest.RangoEtario>{
            rango16a70, rango71a75, rango76a80
        };

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.numeroDeDocumento = 0;
        request.tipoDeDocumento = 'D';
        request.ciudadId = 0;
        request.codigoPostal = 2322;
        request.codigosDeModuloDeCoberturas = new List<Integer> { 18 };
        request.condicionAnteIVA = 4;
        request.frecuenciaDePago= 5;
        request.descuentos = new List<CotizadorAPIRequest.Descuento> { descuento };
        request.numeroOrganizacion = 111111;
        request.numeroProductor = 222222;
        request.grupoEstadistico = 0;
        request.periodoDeValidez = 1;
        request.cuotas = 0;
        request.fechaEfectiva = DateTime.newInstanceGmt(2020, 9, 02, 0, 0, 0);
        request.codigoPolizaTipo = 1;
        request.fechaExpiracion = DateTime.newInstanceGmt(2021, 9, 02, 0, 0, 0);
        request.personasAseguradas = personasAseguradas;
        request.respetarCondicionIVACliente = false;

        // Actual test
        Test.startTest();
        String bodyString = wsSut.createBody(request, Enumerator.Producto.AP_24HS_MODULADO,wsSut.getMethodName(Enumerator.Producto.AP_24HS_MODULADO));
        Test.stopTest();

        // Asserts
        System.assertEquals(AP_24_EXPECTED_REQUEST_BODY, bodyString, 'No genero el string body como se espera, revisar el parseo');
    }

    @IsTest
    private static void ifHasABodyCreationError_ReturnFalse(){
        //Setup(Given)
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest request = new CotizadorAPIRequest();

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizar (
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AP_24HS_MODULADO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! conectionResult, 'No tiene que indicar que hubo un error al armar el body.');
        System.assert(wsSut.serviceResponse.hasError, 'Tiene que ser True ya que no se pudo armar el request por una excepcion');
        System.assert(wsSut.serviceResponse.message.containsIgnoreCase('Error al crear el request: '), 'Tiene que contener el mensaje de error al armar el request.');
    }

    @IsTest
    private static void ifHasANetworkConnectionError_ReturnFalse(){
        //Setup(Given)
        SancorCotizarAPWebService wsSut = new SancorCotizarAPWebService();

        CotizadorAPIRequest.Descuento descuento = new CotizadorAPIRequest.Descuento();
        descuento.codigoDeDescuento = 0;
        descuento.porcentaje = 0;

        CotizadorAPIRequest.SumaAsegurada sumaMuerte76a80 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte76a80.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte76a80.monto = 0;

        CotizadorAPIRequest.RangoEtario rango76a80 = new CotizadorAPIRequest.RangoEtario();
        rango76a80.tipoDeRango = Enumerator.RangoEtario.EDAD_76_A_80;
        rango76a80.seleccionado = false;
        rango76a80.cantidadDePersonas = 0;
        rango76a80.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte76a80 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte71a75 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte71a75.tipoDeSuma = Enumerator.SumaTipo.MUERTE;
        sumaMuerte71a75.monto = 0;

        CotizadorAPIRequest.RangoEtario rango71a75 = new CotizadorAPIRequest.RangoEtario();
        rango71a75.tipoDeRango = Enumerator.RangoEtario.EDAD_71_A_75;
        rango71a75.seleccionado = false;
        rango71a75.cantidadDePersonas = 0;
        rango71a75.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte71a75 };

        CotizadorAPIRequest.SumaAsegurada sumaMuerte16a17 = new CotizadorAPIRequest.SumaAsegurada();
        sumaMuerte16a17.tipoDeSuma = Enumerator.SumaTipo.MUERTE;

        CotizadorAPIRequest.RangoEtario rango16a70 = new CotizadorAPIRequest.RangoEtario();
        rango16a70.tipoDeRango = Enumerator.RangoEtario.EDAD_16_A_70;
        rango16a70.seleccionado = true;
        rango16a70.cantidadDePersonas = 3;
        rango16a70.sumas = new List<CotizadorAPIRequest.SumaAsegurada>{ sumaMuerte16a17 };

        CotizadorAPIRequest.PersonaAsegurada personasAseguradas = new CotizadorAPIRequest.PersonaAsegurada();
        personasAseguradas.codigoProfesion = 9;
        personasAseguradas.codigoClasificacion = 42;
        personasAseguradas.codigoTarea = 0;
        personasAseguradas.rangoEtario = new List<CotizadorAPIRequest.RangoEtario>{
            rango16a70, rango71a75, rango76a80
        };

        CotizadorAPIRequest request = new CotizadorAPIRequest();
        request.numeroDeDocumento = 0;
        request.tipoDeDocumento = 'D';
        request.ciudadId = 0;
        request.codigoPostal = 2322;
        request.codigosDeModuloDeCoberturas = new List<Integer> { 18 };
        request.condicionAnteIVA = 4;
        request.frecuenciaDePago= 5;
        request.descuentos = new List<CotizadorAPIRequest.Descuento> { descuento };
        request.numeroOrganizacion = 111111;
        request.numeroProductor = 222222;
        request.grupoEstadistico = 0;
        request.periodoDeValidez = 1;
        request.cuotas = 0;
        request.fechaEfectiva = DateTime.newInstanceGmt(2020, 9, 02, 0, 0, 0);
        request.codigoPolizaTipo = 1;
        request.fechaExpiracion = DateTime.newInstanceGmt(2021, 9, 02, 0, 0, 0);
        request.personasAseguradas = personasAseguradas;
        request.respetarCondicionIVACliente = false;

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse().simulateNetworkError().addForAddress(COTIZADOR_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.cotizar (
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Producto.AP_24HS_MODULADO
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! conectionResult, 'No tiene que indicar que conecto correctamente, por que no se completaron los campos requeridos.');
    }

    static final String AP_24_EXPECTED_REQUEST_BODY = '<?xml version="1.0" encoding="UTF-8"?>'
        +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/NewAP24Modulate/request" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">'
        +    '<soapenv:Header />'
        +    '<soapenv:Body>'
        +        '<req:NewAP24ModulateRequest>'
        +            '<RelationQuotationId>0</RelationQuotationId>'
        +            '<PolicyTypeId>1</PolicyTypeId>'
        +            '<CityId>0</CityId>'
        +            '<ClientIdentify>'
        +                '<DocumentNumber>0</DocumentNumber>'
        +                '<DocumentType>D</DocumentType>'
        +            '</ClientIdentify>'
        +            '<CoverModuleCode>18</CoverModuleCode>'
        +            '<CurrencyId>1</CurrencyId>'
        +            '<EffectDate>2020-09-02T00:00:00</EffectDate>'
        +            '<ExpirationDate>2021-09-02T00:00:00</ExpirationDate>'
        +            '<IvaConditionId>4</IvaConditionId>'
        +            '<OfficeId>200</OfficeId>'
        +            '<PaymentFrequencyId>5</PaymentFrequencyId>'
        +            '<OrganizerId>111111</OrganizerId>'
        +            '<ProducerId>222222</ProducerId>'
        +            '<ProductId>387</ProductId>'
        +            '<PeriodOfValidityId>1</PeriodOfValidityId>'
        +            '<FeeId>0</FeeId>'
        +            '<QuotaQuantity>0</QuotaQuantity>'
        +            '<QuotationId>0</QuotationId>'
        +            '<RespectClientIvaCondition>false</RespectClientIvaCondition>'
        +            '<SealExemptActivity>false</SealExemptActivity>'
        +            '<StatisticalCode>0</StatisticalCode>'
        +            '<ZipCode>2322</ZipCode>'
        +            '<PersonInsured>'
        +                '<Profession>9</Profession>'
        +                '<Classification>42</Classification>'
        +                '<Task>0</Task>'
        +                '<Rank>'
        +                    '<Rank16To70>'
        +                        '<Selected>true</Selected>'
        +                        '<Quantity>3</Quantity>'
        +                        '<DeathCoverAmount>'
        +                            '<Code>0</Code>'
        +                            '<Value>0</Value>'
        +                        '</DeathCoverAmount>'
        +                    '</Rank16To70>'
        +                    '<Rank71To75>'
        +                        '<Selected>false</Selected>'
        +                        '<Quantity>0</Quantity>'
        +                        '<DeathCoverAmount>'
        +                            '<Code>0</Code>'
        +                            '<Value>0</Value>'
        +                        '</DeathCoverAmount>'
        +                    '</Rank71To75>'
        +                    '<Rank76To800>'
        +                        '<Selected>false</Selected>'
        +                        '<Quantity>0</Quantity>'
        +                        '<DeathCoverAmount>'
        +                            '<Code>0</Code>'
        +                            '<Value>0</Value>'
        +                        '</DeathCoverAmount>'
        +                    '</Rank76To800>'
        +                '</Rank>'
        +                '</PersonInsured>'
        +                '<DiscountCustomizations>'
        +                '<DiscountCustomization>'
        +                    '<DiscountNumber>0</DiscountNumber>'
        +                    '<Rate>0</Rate>'
        +                '</DiscountCustomization>'
        +            '</DiscountCustomizations>'
        +        '</req:NewAP24ModulateRequest>'
        +    '</soapenv:Body>'
        +'</soapenv:Envelope>';

    static final String AP_INTEGRO_MAX_EXPECTED_REQUEST_BODY = '<?xml version="1.0" encoding="UTF-8"?>'
        +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/NewIntegroMax/request" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">'
        +   '<soapenv:Header />'
        +   '<soapenv:Body>'
        +      '<req:NewIntegroMaxRequest>'
        +         '<RelationQuotationId>0</RelationQuotationId>'
        +         '<PolicyTypeId>2</PolicyTypeId>'
        +         '<CityId>0</CityId>'
        +         '<ClientIdentify>'
        +            '<DocumentNumber>0</DocumentNumber>'
        +            '<DocumentType>D</DocumentType>'
        +         '</ClientIdentify>'
        +         '<CoverModuleCode>4</CoverModuleCode>'
        +         '<CurrencyId>1</CurrencyId>'
        +         '<EffectDate>2020-09-15T00:00:00</EffectDate>'
        +         '<ExpirationDate>2021-09-15T00:00:00</ExpirationDate>'
        +         '<IvaConditionId>4</IvaConditionId>'
        +         '<OfficeId>200</OfficeId>'
        +         '<PaymentFrequencyId>5</PaymentFrequencyId>'
        +         '<OrganizerId>111111</OrganizerId>'
        +         '<ProducerId>222222</ProducerId>'
        +         '<ProductId>711</ProductId>'
        +         '<PeriodOfValidityId>1</PeriodOfValidityId>'
        +         '<FeeId>0</FeeId>'
        +         '<QuotaQuantity>0</QuotaQuantity>'
        +         '<QuotationId>0</QuotationId>'
        +         '<RespectClientIvaCondition>false</RespectClientIvaCondition>'
        +         '<SealExemptActivity>false</SealExemptActivity>'
        +         '<StatisticalCode>0</StatisticalCode>'
        +         '<ZipCode>2322</ZipCode>'
        +         '<PersonInsured>'
        +            '<Profession>8</Profession>'
        +            '<Classification>20016</Classification>'
        +            '<Rank>'
        +               '<Rank16To70>'
        +                  '<Selected>true</Selected>'
        +                  '<Quantity>5</Quantity>'
        +                  '<DeathCoverAmount>'
        +                     '<Code>0</Code>'
        +                     '<Value>500000</Value>'
        +                  '</DeathCoverAmount>'
        +                  '<MedicalAssistanceAmount>'
        +                     '<Code>0</Code>'
        +                     '<Value>100000</Value>'
        +                  '</MedicalAssistanceAmount>'
        +                  '<BurialExpenses>'
        +                     '<Code>0</Code>'
        +                     '<Value>5000</Value>'
        +                  '</BurialExpenses>'
        +                  '<DailyIncomeInternation>'
        +                     '<Code>0</Code>'
        +                     '<Value>10000</Value>'
        +                  '</DailyIncomeInternation>'
        +               '</Rank16To70>'
        +               '<Rank71To75>'
        +                  '<Selected>false</Selected>'
        +                  '<Quantity>0</Quantity>'
        +                  '<DeathCoverAmount>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</DeathCoverAmount>'
        +                  '<MedicalAssistanceAmount>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</MedicalAssistanceAmount>'
        +                  '<BurialExpenses>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</BurialExpenses>'
        +                  '<DailyIncomeInternation>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</DailyIncomeInternation>'
        +               '</Rank71To75>'
        +               '<Rank76To800>'
        +                  '<Selected>false</Selected>'
        +                  '<Quantity>0</Quantity>'
        +                  '<DeathCoverAmount>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</DeathCoverAmount>'
        +                  '<MedicalAssistanceAmount>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</MedicalAssistanceAmount>'
        +                  '<BurialExpenses>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</BurialExpenses>'
        +                  '<DailyIncomeInternation>'
        +                     '<Code>0</Code>'
        +                     '<Value>0</Value>'
        +                  '</DailyIncomeInternation>'
        +               '</Rank76To800>'
        +            '</Rank>'
        +         '</PersonInsured>'
        +         '<DiscountCustomizations>'
        +            '<DiscountCustomization>'
        +               '<DiscountNumber>0</DiscountNumber>'
        +               '<Rate>0</Rate>'
        +            '</DiscountCustomization>'
        +         '</DiscountCustomizations>'
        +      '</req:NewIntegroMaxRequest>'
        +   '</soapenv:Body>'
        +'</soapenv:Envelope>';

    static final String AP_OCASION_TRABAJO_EXPECTED_REQUEST_BODY = '<?xml version="1.0" encoding="UTF-8"?>'
         +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/Ssa/Channel/PersonalAccidentSvc/NewOccasionOfWork/request" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">'
         +  '<soapenv:Header />'
         +  '<soapenv:Body>'
         +     '<req:NewOccasionOfWorkRequest>'
         +        '<RelationQuotationId>0</RelationQuotationId>'
         +        '<PolicyTypeId>1</PolicyTypeId>'
         +        '<CityId>0</CityId>'
         +        '<ClientIdentify>'
         +           '<DocumentNumber>0</DocumentNumber>'
         +           '<DocumentType>D</DocumentType>'
         +        '</ClientIdentify>'
         +        '<CoverModuleCode>1</CoverModuleCode>'
         +        '<CurrencyId>1</CurrencyId>'
         +        '<EffectDate>2020-09-15T00:00:00</EffectDate>'
         +        '<ExpirationDate>2021-09-15T00:00:00</ExpirationDate>'
         +        '<IvaConditionId>4</IvaConditionId>'
         +        '<OfficeId>200</OfficeId>'
         +        '<PaymentFrequencyId>5</PaymentFrequencyId>'
         +        '<OrganizerId>111111</OrganizerId>'
         +        '<ProducerId>222222</ProducerId>'
         +        '<ProductId>555</ProductId>'
         +        '<PeriodOfValidityId>1</PeriodOfValidityId>'
         +        '<FeeId>0</FeeId>'
         +        '<QuotaQuantity>0</QuotaQuantity>'
         +        '<QuotationId>0</QuotationId>'
         +        '<RespectClientIvaCondition>false</RespectClientIvaCondition>'
         +        '<SealExemptActivity>false</SealExemptActivity>'
         +        '<StatisticalCode>0</StatisticalCode>'
         +        '<ZipCode>2322</ZipCode>'
         +        '<PersonInsured>'
         +           '<Profession>8</Profession>'
         +           '<Classification>38</Classification>'
         +           '<Task>3</Task>'
         +           '<Rank>'
         +              '<Rank16To70>'
         +                 '<Selected>true</Selected>'
         +                 '<Quantity>2</Quantity>'
         +                 '<DeathCoverAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>1000000</Value>'
         +                 '</DeathCoverAmount>'
         +                 '<MedicalAssistanceAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>100000</Value>'
         +                 '</MedicalAssistanceAmount>'
         +                 '<DeathGrant>'
         +                    '<Code>0</Code>'
         +                    '<Value>20000</Value>'
         +                 '</DeathGrant>'
         +                 '<DailyIncomeInternation>'
         +                    '<Code>0</Code>'
         +                    '<Value>10000</Value>'
         +                 '</DailyIncomeInternation>'
         +                 '<FixAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>5000</Value>'
         +                 '</FixAmount>'
         +              '</Rank16To70>'
         +              '<Rank71To75>'
         +                 '<Selected>false</Selected>'
         +                 '<Quantity>0</Quantity>'
         +                 '<DeathCoverAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</DeathCoverAmount>'
         +                 '<MedicalAssistanceAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</MedicalAssistanceAmount>'
         +                 '<DeathGrant>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</DeathGrant>'
         +                 '<DailyIncomeInternation>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</DailyIncomeInternation>'
         +                 '<FixAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</FixAmount>'
         +              '</Rank71To75>'
         +              '<Rank76To800>'
         +                 '<Selected>false</Selected>'
         +                 '<Quantity>0</Quantity>'
         +                 '<DeathCoverAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</DeathCoverAmount>'
         +                 '<MedicalAssistanceAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</MedicalAssistanceAmount>'
         +                 '<DeathGrant>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</DeathGrant>'
         +                 '<DailyIncomeInternation>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</DailyIncomeInternation>'
         +                 '<FixAmount>'
         +                    '<Code>0</Code>'
         +                    '<Value>0</Value>'
         +                 '</FixAmount>'
         +              '</Rank76To800>'
         +           '</Rank>'
         +        '</PersonInsured>'
         +        '<DiscountCustomizations />'
         +     '</req:NewOccasionOfWorkRequest>'
         +  '</soapenv:Body>'
         +'</soapenv:Envelope>';
}