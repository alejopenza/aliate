@isTest
private class SancorCrearPolizaWebServiceTest {

    static final String EMISION_ENDPOINT = [ SELECT isSandbox FROM Organization ].IsSandbox ? 'https://external-pre-ws.gruposancorseguros.com/Ssa/Channel/PolicyIssuanceSvc' : 'https://external-pro-ws.gruposancorseguros.com/Ssa/Channel/PolicyIssuanceSvc';

    static final String MOCK_RESPONSE = CalloutResponseFactory.SANCOR_EMISION_RESPONSE;
    static final String VALIDATION_ERROR_RESPONSE = CalloutResponseFactory.SANCOR_EMISION_VALIDATION_ERROR_RESPONSE;
    static final String INTERNAL_SERVER_ERROR_RESPONSE = CalloutResponseFactory.SANCOR_INTERNAL_SERVER_MOCK_RESPONSE;

    @isTest
    private static void ifCreateAnAPIssueBody_IsCreatedAsExpected() {
        // Test data setup
        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        EmisionAPIRequest.infoRamo ramo = new EmisionAPIRequest.infoRamo();
        ramo.codAsistenciaMedicaFarmaceutica = 754;
        ramo.codActividad = 9;
        ramo.codClasificacion = 45;
        ramo.direccion = 'avelino diaz 2141';
        ramo.codCapitalMuerteInvalidez = 306;
        ramo.subsidioPorMuerte = true;
        ramo.capitalMuerte = 92812;
        ramo.buenaSalud = false;
        ramo.zurdo = false;
        ramo.codTarea = 164;

        EmisionAPIRequest.InfoEnvioDigital envioDigital = new EmisionAPIRequest.InfoEnvioDigital();
        envioDigital.emailEnvio = 'algo@algo.com';
        envioDigital.envioElectronico = true;

        EmisionAPIRequest.InfoCliente cliente = new EmisionAPIRequest.InfoCliente();
        cliente.tipoRol = 1;
        cliente.codigoAreaTelefono = 11;
        cliente.fechaNacimiento = Datetime.newInstanceGmt(1998, 6, 30, 0, 0, 0);
        cliente.codigoCiudad = 30001;
        cliente.numeroDocumento = '33222111';
        cliente.tipoDocumento = 'D';
        cliente.email = 'algo@algo.com';
        cliente.nombre = 'Jorge';
        cliente.apellido = 'Apellido';
        cliente.codigoCondicionIVA = 4;
        cliente.telefono = '44443333';
        cliente.calle = 'Su calle 2141';
        cliente.codigoPostal = 1401;

        EmisionAPIRequest.InfoCliente cliente2 = new EmisionAPIRequest.InfoCliente();
        cliente2.tipoRol = 2;
        cliente2.codigoAreaTelefono = 11;
        cliente2.fechaNacimiento = Datetime.newInstanceGmt(1998, 6, 30, 0, 0, 0);
        cliente2.codigoCiudad = 30001;
        cliente2.numeroDocumento = '33222111';
        cliente2.tipoDocumento = 'D';
        cliente2.email = 'algo@algo.com';
        cliente2.nombre = 'Jorge';
        cliente2.apellido = 'Apellido';
        cliente2.codigoCondicionIVA = 4;
        cliente2.telefono = '44443333';
        cliente2.calle = 'Su calle 2141';
        cliente2.codigoPostal = 1401;

        EmisionAPIRequest.InfoCliente cliente3 = new EmisionAPIRequest.InfoCliente();
        cliente3.tipoRol = 17;
        cliente3.fechaNacimiento = Datetime.newInstanceGmt(1986, 1, 1, 0, 0, 0);
        cliente3.numeroDocumento = '99999';
        cliente3.tipoDocumento = 'Q';
        cliente3.codigoCondicionIVA = 4;
        cliente3.codigoPostal = 0;

        EmisionAPIRequest.InfoDireccionRiesgo direccionRiesgo = new EmisionAPIRequest.InfoDireccionRiesgo();
        direccionRiesgo.codigoCiudad = 30001;
        direccionRiesgo.codigoPostal = 1401;

        EmisionAPIRequest.InfoCertificado infoCertificado = new EmisionAPIRequest.InfoCertificado();
        infoCertificado.clienteFacturable = 1;
        infoCertificado.comentarios = null;
        infoCertificado.codigoModulo = 0;
        infoCertificado.codigoPago = 0;
        infoCertificado.codigoFrecuenciaPago = 7;
        infoCertificado.infoRamo = ramo;
        infoCertificado.cuotas = 1;
        infoCertificado.vigenciaDesde = Datetime.newInstanceGmt(2020, 12, 29, 0, 0, 0);
        infoCertificado.vigenciaHasta = Datetime.newInstanceGmt(2021, 1, 29, 0, 0, 0);
        infoCertificado.clientes = new List<EmisionAPIRequest.InfoCliente> { cliente, cliente2, cliente3 };
        infoCertificado.direccionRiesgo = direccionRiesgo;

        EmisionAPIRequest request = new EmisionAPIRequest();
        request.informacionCertificado = infoCertificado;
        request.numeroOrganizador = 150113;
        request.numeroProductor = 208829;
        request.codigoProducto = 555;
        request.tipoRenovacionPoliza = 1;
        request.codigoGrupoEstadistico = 1440;

        // Actual test
        Test.startTest();
        String bodyString = wsSut.createBody(request, Enumerator.Ramo.ACCIDENTE_PERSONALES, Enumerator.Producto.AP_24HS_MODULADO);
        Test.stopTest();

        // Asserts
        System.assertEquals(AP_EXPECTED_REQUEST_BODY, bodyString, 'No genero el string body como se espera, revisar el parseo');
    }

    @IsTest
    private static void ifHaveAServerError_returnFalseAndFaultMessages(){
        //Setup(Given)

        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();
        EmisionAPIRequest request = createIssuanceRequest();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Error')
            .withStatusCode(500)
            .withBody(INTERNAL_SERVER_ERROR_RESPONSE)
            .addForAddress(EMISION_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.emitir(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Ramo.AUTOMOTOR,
                null
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
    private static void ifHaveAServerValidationError_returnTrueButWithAFlagOfValidationError(){
        //Setup(Given)
        String expectedValidationMessage = '- La Denominación/Razón Social no coincide con la registrada en AFIP. La Razón Social/Denominación ingresada es MERCADO MARIO y la registrada en AFIP es FUCHS OSVALDO ABRAHAM para el Número de Documento 33505050\n736122 - Verificar. Fuera de Normas de Selección de Riesgo sin indicar Inspección Previa. (Código: 736122)\n768332 - El descuento por modelo se aplica solo para unidades dentro de norma. (Código: 768332)\n767095 - Valor convenido. (Código: 767095)\n768330 - Vehículo fuera de normas de selección de riesgo. Ver Tipo, Clase o Antigüedad. (Código: 768330)';

        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        EmisionAPIRequest request = createIssuanceRequest();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Successfull')
            .withBody(VALIDATION_ERROR_RESPONSE)
            .addForAddress(EMISION_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.emitir(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Ramo.AUTOMOTOR,
                null
            );
        Test.stopTest();

        //Test(Then)
        System.assertEquals(null, wsSut.serviceResponse.message, 'No tiene que tener mensaje de error de conexion');
        System.assert(! wsSut.serviceResponse.hasError, 'Tiene que indicar que no hubo error.');
        System.assert(conectionResult, 'Tiene que indicar que conecto correctamente con el servidor');
        System.assert(
            wsSut.serviceResponse.validationError,
            'Tiene que indicar que hubo un error de validacion en Sancor'
        );
        System.assertEquals(
            expectedValidationMessage,
            wsSut.serviceResponse.validationMessage,
            'Debe indicar que hay error de afip'
        );
    }

    @IsTest
    private static void ifDontHaveCredentialsKeys_returnFalseAndMessageError(){
        //Setup(Given)
        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        //Exercise(When)
        Test.startTest();
        Boolean conectionResult =
            wsSut.emitir(new EmisionAPIRequest(), new Map<String,String>{}, Enumerator.Ramo.AUTOMOTOR, null);
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
    private static void shouldBeAbleToDoAEmisionWithCBUDebit_AndGetSucess(){
        //Setup(Given)
        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        EmisionAPIRequest.InfoPago infoPago = new EmisionAPIRequest.InfoPago();
        infoPago.cuentaCBU = '152356743423342';
        infoPago.codigoAgenciaSucursal = 11;
        infoPago.codigoBanco = 23;

        EmisionAPIRequest.InspeccionPrevia inspeccion = new EmisionAPIRequest.InspeccionPrevia();
        inspeccion.codigoTipoCombustible = 1;
        inspeccion.codigoAspectoGeneral = 2;
        inspeccion.codigoEstadoCristales = 2;
        inspeccion.fecha = System.today().addDays(-15);
        inspeccion.kilometraje = 20;
        inspeccion.codigoEstadoPintura = 2;
        inspeccion.codigoTipoPintura = 2;
        inspeccion.codigoAspectoChapa = 2;
        inspeccion.codigoEstadoNeumatico = 2;
        inspeccion.codigoEstadoTapizado = 2;
        inspeccion.codigoColorTapizado = 9;
        inspeccion.colorVehiculo = 'Negro';
        inspeccion.codigoTipoLlantas = 2;

        EmisionAPIRequest request = createIssuanceRequest();
        request.informacionCertificado.pago = infoPago;
        request.informacionCertificado.codigoPago = 4; // Debito Por CBU
        request.informacionCertificado.infoRamo.vehiculo.inspeccionPrevia = inspeccion;

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Successfull')
            .withBody(MOCK_RESPONSE)
            .addForAddress(EMISION_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean resultWS =
            wsSut.emitir(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Ramo.AUTOMOTOR,
                null
            );
        Test.stopTest();

        //Test(Then)
        System.assert(resultWS, 'No completo la emision! Revisar el metodo Emitir');
    }

    @IsTest
    private static void shouldBeAbleToDoAEmisionWithDebitBank_AndGetSucess(){
        //Setup(Given)
        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        EmisionAPIRequest.InfoPago infoPago = new EmisionAPIRequest.InfoPago();
        infoPago.numeroCuentaDebito = '152356743423342';
        infoPago.tipoCuentaDebito = 2;
        infoPago.codigoAgenciaSucursal = 11;
        infoPago.codigoBanco = 23;

        EmisionAPIRequest.InspeccionPrevia inspeccion = new EmisionAPIRequest.InspeccionPrevia();
        inspeccion.codigoTipoCombustible = 1;
        inspeccion.codigoAspectoGeneral = 2;
        inspeccion.codigoEstadoCristales = 2;
        inspeccion.fecha = System.today().addDays(-15);
        inspeccion.kilometraje = 20;
        inspeccion.codigoEstadoPintura = 2;
        inspeccion.codigoTipoPintura = 2;
        inspeccion.codigoAspectoChapa = 2;
        inspeccion.codigoEstadoNeumatico = 2;
        inspeccion.codigoEstadoTapizado = 2;
        inspeccion.codigoColorTapizado = 9;
        inspeccion.colorVehiculo = 'Negro';
        inspeccion.codigoTipoLlantas = 2;

        EmisionAPIRequest request = createIssuanceRequest();
        request.informacionCertificado.pago = infoPago;
        request.informacionCertificado.codigoPago = 1; // Debito bancario
        request.informacionCertificado.infoRamo.vehiculo.inspeccionPrevia = inspeccion;

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Successfull')
            .withBody(MOCK_RESPONSE)
            .addForAddress(EMISION_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean resultWS =
            wsSut.emitir(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Ramo.AUTOMOTOR,
                null
            );
        Test.stopTest();

        //Test(Then)
        System.assert(resultWS, 'No completo la emision! Revisar el metodo Emitir');
    }

    @IsTest
    private static void shouldBeAbleToDoAEmisionConInspeccion_AndGetSucess(){
        //Setup(Given)
        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        EmisionAPIRequest.InfoOperatoriaEspecial operatoriaEspecial = new EmisionAPIRequest.InfoOperatoriaEspecial();
        operatoriaEspecial.codigoBanco = 15;
        operatoriaEspecial.numeroContrato = '124536';
        operatoriaEspecial.fechaEfectivaContrato = System.now();
        operatoriaEspecial.fechaVencimientoContrato = System.now().addYears(1);
        operatoriaEspecial.fechaVencimientoPrimeraCuota = System.now().addMonths(1);
        operatoriaEspecial.idOperacion = '1a45236ae';
        operatoriaEspecial.cantidadCoutas = 6;

        EmisionAPIRequest.InfoDescuentoEspecial descuentos = new EmisionAPIRequest.InfoDescuentoEspecial();
        descuentos.porcentaje = 99;
        descuentos.codigoDescuento = 1;

        EmisionAPIRequest.InfoDescuentoEspecial descuentos1 = new EmisionAPIRequest.InfoDescuentoEspecial();
        descuentos1.importe = 1000;
        descuentos1.codigoDescuento = 2;

        EmisionAPIRequest.InfoPago infoPago = new EmisionAPIRequest.InfoPago();
        infoPago.fechaVencimientoTarjeta = System.today().addYears(4);
        infoPago.codigoMarcaTarjeta = 11;
        infopago.numeroTarjeta = '5547301673828233';

        EmisionAPIRequest.ArchivoAdjunto archivo = new EmisionAPIRequest.ArchivoAdjunto();
        archivo.nombre = 'auto2.jpg';
        archivo.contenido = 'LzlqLzRBQVFTa5az0=';

        EmisionAPIRequest.InspeccionPrevia inspeccion = new EmisionAPIRequest.InspeccionPrevia();
        inspeccion.comentario = 'Todo OK';
        inspeccion.codigoTipoCombustible = 1;
        inspeccion.codigoAspectoGeneral = 2;
        inspeccion.codigoEstadoCristales = 2;
        inspeccion.fecha = System.today().addDays(-15);
        inspeccion.codigoResultado = 2;
        inspeccion.kilometraje = 20;
        inspeccion.codigoEstadoPintura = 2;
        inspeccion.codigoTipoPintura = 2;
        inspeccion.codigoAspectoChapa = 2;
        inspeccion.codigoEstadoNeumatico = 2;
        inspeccion.codigoEstadoTapizado = 2;
        inspeccion.codigoColorTapizado = 9;
        inspeccion.codigoTipoTapizado = 2;
        inspeccion.colorVehiculo = 'Negro';
        inspeccion.codigoTipoLlantas = 2;
        inspeccion.archivosAdjuntos = new List<EmisionAPIRequest.ArchivoAdjunto>{ archivo };

        EmisionAPIRequest request = createIssuanceRequest();
        request.informacionCertificado.InfoRamo.porcentajeAjuste = 10;
        request.informacionCertificado.InfoRamo.codigoTransportaCombustible = 0;
        request.informacionCertificado.comentarios = 'Esto es un test';
        request.informacionCertificado.infoOperatoriaEspecial = operatoriaEspecial;
        request.informacionCertificado.infoDescuentosEspeciales = new List<EmisionAPIRequest.InfoDescuentoEspecial>{ descuentos, descuentos1};
        request.informacionCertificado.pago = infoPago;
        request.informacionCertificado.codigoPago = 2; // Tarjeta de credito
        request.informacionCertificado.clientes[0].cuit_cuil = '20334020552';
        request.informacionCertificado.clientes[0].categoriaMonotributo = 1;
        request.informacionCertificado.infoRamo.vehiculo.equipoGnc.marcaCilindro2 = 'ABA2';
        request.informacionCertificado.infoRamo.vehiculo.equipoGnc.numeroCilindro2 = '123456';
        request.informacionCertificado.infoRamo.vehiculo.equipoGnc.marcaCilindro3 = 'ABA3';
        request.informacionCertificado.infoRamo.vehiculo.equipoGnc.numeroCilindro3 = '123456';
        request.informacionCertificado.infoRamo.vehiculo.equipoGnc.marcaCilindro4 = 'ABA5';
        request.informacionCertificado.infoRamo.vehiculo.equipoGnc.numeroCilindro4 = '123456';
        request.informacionCertificado.infoRamo.vehiculo.inspeccionPrevia = inspeccion;

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Successfull')
            .withBody(MOCK_RESPONSE)
            .addForAddress(EMISION_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean resultWS =
            wsSut.emitir(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Ramo.AUTOMOTOR,
                null
            );
        Test.stopTest();

        //Test(Then)
        System.assert(resultWS, 'No completo la emision! Revisar el metodo Emitir');
    }

    @IsTest
    private static void shouldBeAbleToDoAEmiSion_AndGetSucess(){
        //Setup(Given)
        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        EmisionAPIRequest request = createIssuanceRequest();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withStatus('Successfull')
            .withBody(MOCK_RESPONSE)
            .addForAddress(EMISION_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean resultWS =
            wsSut.emitir(
                request,
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Ramo.AUTOMOTOR,
                null
            );
        Test.stopTest();

        //Test(Then)
        System.assert(resultWS, 'No completo la emision! Revisar el metodo Emitir');
        System.assertEquals(200, wsSut.serviceResponse.polizaEmitida.ramoId,'');
        System.assertEquals(0, wsSut.serviceResponse.polizaEmitida.numeroCertificado,'');
        System.assertEquals('0102000000000252129246', wsSut.serviceResponse.polizaEmitida.numeroTramiteInterno,'');
        System.assertEquals('Emitida', wsSut.serviceResponse.polizaEmitida.estadoDeTramite,'');
        System.assertEquals(9006707, wsSut.serviceResponse.polizaEmitida.numeroOficialPoliza,'');
        System.assertEquals(7444958, wsSut.serviceResponse.polizaEmitida.numeroSancorPoliza,'');

        EmisionAPIResponse.Recibo recibo = wsSut.serviceResponse.polizaEmitida.recibo;
        System.assertEquals(392939859, recibo.numero,'');

        List<EmisionAPIResponse.Detalle> detalles = recibo.detalles;
        System.assertEquals('Prima', detalles[0].descripcion, '');
        System.assertEquals(23838.30, detalles[0].premio, '');
        System.assertEquals(1986.53, detalles[0].premioSegunFormaDePago, '');

        System.assertEquals('Impuesto a los Sellos', detalles[1].descripcion, '');
        System.assertEquals(178.79, detalles[1].premio, '');
        System.assertEquals(14.90, detalles[1].premioSegunFormaDePago, '');

        System.assertEquals('Iva General', detalles[2].descripcion, '');
        System.assertEquals(5006.04, detalles[2].premio, '');
        System.assertEquals(417.17, detalles[2].premioSegunFormaDePago, '');

        System.assertEquals('Tasas e Impuestos', detalles[3].descripcion, '');
        System.assertEquals(524.43, detalles[3].premio, '');
        System.assertEquals(43.71, detalles[3].premioSegunFormaDePago, '');

        System.assertEquals('Capital Social', detalles[4].descripcion, '');
        System.assertEquals(2145.45, detalles[4].premio, '');
        System.assertEquals(178.69, detalles[4].premioSegunFormaDePago, '');
    }

    @IsTest
    private static void shouldBeGetFalseWhenGetANetworkConnectionError(){
        //Setup(Given)
        SancorCrearPolizaWebService wsSut = new SancorCrearPolizaWebService();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse().simulateNetworkError().addForAddress(EMISION_ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean resultWS =
            wsSut.emitir(
                new EmisionAPIRequest(),
                new Map<String,String>{
                    'TokenType' => 'Bearer',
                    'User' => 'Test 1',
                    'Token' => 'a23452fsg123sadasd_saraza'
                },
                Enumerator.Ramo.AUTOMOTOR,
                null
            );
        Test.stopTest();

        //Test(Then)
        System.assert(! resultWS, 'No tiene que completar por que no hubo un error de conexion');
        System.assert(wsSut.serviceResponse.hasError, 'Hubo un error por lo que tiene que estar en true');
    }

    private static EmisionAPIRequest createIssuanceRequest(){
        EmisionAPIRequest.EquipoGNC gnc = new EmisionAPIRequest.EquipoGNC();
        gnc.marcaCilindro1 = 'TUBOS';
        gnc.numeroCilindro1 = '456980';
        gnc.marcaCilindro2 = '';
        gnc.numeroCilindro2 = '';
        gnc.marcaCilindro3 = '';
        gnc.numeroCilindro3 = '';
        gnc.marcaCilindro4 = '';
        gnc.numeroCilindro4 = '';
        gnc.valor = 3000;
        gnc.marcaRegulador = 'Regulator';
        gnc.numeroRegulador = '123456';

        EmisionAPIRequest.Vehiculo vehiculo = new EmisionAPIRequest.Vehiculo();
        vehiculo.numeroChasis = 'CHASIS608CHASIS';
        vehiculo.licencia = 'BB608BB'; //patente
        vehiculo.numeroMotor = 'MOTOR608MOTOR';
        vehiculo.tieneQueColocarRastreoSatelital = false;
        vehiculo.codigoModeloInfoAuto = '0320697';
        vehiculo.codigoUso =2;
        vehiculo.valor = 720000;
        vehiculo.anio = 2018;
        vehiculo.esCeroKilometro = false;
        vehiculo.equipoGnc = gnc;
        vehiculo.inspeccionPrevia = null;

        EmisionAPIRequest.infoRamo ramo = new EmisionAPIRequest.infoRamo();
        ramo.porcentajeAjuste = null;
        ramo.codigoTransportaCombustible = null;
        ramo.conductorMenorDe25 = false;
        ramo.masDe25KmPorAnio = false;
        ramo.guardaEnGarage = true;
        ramo.vehiculo = vehiculo;

        EmisionAPIRequest.InfoEnvioDigital envioDigital = new EmisionAPIRequest.InfoEnvioDigital();
        envioDigital.emailEnvio = 'algo@algo.com';
        envioDigital.envioElectronico = true;

        EmisionAPIRequest.InfoCliente cliente = new EmisionAPIRequest.InfoCliente();
        cliente.tipoRol = 2;
        cliente.codigoAreaTelefono = 3493;
        cliente.fechaNacimiento = System.today().addYears(-23);
        cliente.lugarNacimiento = 'Sunchales';
        cliente.codigoCiudad = 0;
        cliente.cuit_cuil = null;
        cliente.numeroDocumento = '17235777';
        cliente.tipoDocumento = 'D';
        cliente.email = 'algo@algo.com';
        cliente.nombre = 'Mario';
        cliente.apellido = 'Apellido';
        cliente.genero = 2;
        cliente.codigoCondicionIVA = 4;
        cliente.codigoActividadPrincipal = 1001;
        cliente.codigoEstadoCivil = 1;
        cliente.telefono = '404040';
        cliente.categoriaMonotributo = null;
        cliente.calle = 'Igualdad 1234';
        cliente.codigoPostal = 2322;

        EmisionAPIRequest.InfoCertificado infoCertificado = new EmisionAPIRequest.InfoCertificado();
        infoCertificado.clienteFacturable = 1;
        infoCertificado.comentarios = null;
        infoCertificado.codigoModulo = 12;
        infoCertificado.codigoPago = 0;
        infoCertificado.codigoFrecuenciaPago = 5;
        infoCertificado.cuotas = 0;
        infoCertificado.vigenciaDesde = System.now();
        infoCertificado.vigenciaHasta = System.now().addYears(1);
        infoCertificado.coberturas = new List<EmisionAPIRequest.InfoCobertura>();
        infoCertificado.pago = null;
        infoCertificado.infoEnvioDigital = envioDigital;
        infoCertificado.infoRamo = ramo;
        infoCertificado.infoOperatoriaEspecial = null;
        infoCertificado.infoDescuentosEspeciales = new List<EmisionAPIRequest.InfoDescuentoEspecial>{};
        infoCertificado.clientes = new List<EmisionAPIRequest.InfoCliente> { cliente };

        EmisionAPIRequest request = new EmisionAPIRequest();
        request.informacionCertificado = infoCertificado;
        request.numeroOrganizador = 111111;
        request.numeroProductor = 222222;
        request.codigoProducto = 24;
        request.tipoRenovacionPoliza = 1;
        request.codigoGrupoEstadistico = 0;

        return request;
    }

    static final String AP_EXPECTED_REQUEST_BODY = '<soapenv:Envelope xmlns:col="http://gruposancorseguros.com/ents/SOI/Collections/" xmlns:ent="http://gruposancorseguros.com/ents/SOI/Entities/" xmlns:p1="http://www.w3.org/2001/XMLSchema-instance" xmlns:pol="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://gruposancorseguros.com/ents/SOI/Commons/v1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        +   '<soapenv:Header />'
        +   '<soapenv:Body>'
        +       '<pol:CreateSinglePolicy>'
        +           '<pol:request xmlns:con="http://gruposancorseguros.com/ents/SOI/PolicyIssuanceSvc/Contract/">'
        +            '<con:CertificateData>'
        +            '<con:BillableClientRoleId>1</con:BillableClientRoleId>'
        +            '<con:BranchData xsi:type="con:PersonalAccidents24HsAPBranchData">'
        +                '<con:ActivityTypeId>9</con:ActivityTypeId>'
        +                '<con:AssistanceMedicalPharmaceuticalCapitalTypeId>754</con:AssistanceMedicalPharmaceuticalCapitalTypeId>'
        +                '<con:ClassificationActivityTypeId>45</con:ClassificationActivityTypeId>'
        +                '<con:ClientAddress>'
        +                    '<ent:Street>avelino diaz 2141</ent:Street>'
        +                '</con:ClientAddress>'
        +                '<con:DeathAndDisabilityCapitalTypeId>306</con:DeathAndDisabilityCapitalTypeId>'
        +                '<con:DeathGrants>true</con:DeathGrants>'
        +                '<con:DeathGrantsCapital>92812</con:DeathGrantsCapital>'
        +                '<con:GoodHealth>false</con:GoodHealth>'
        +                '<con:HasOtherAddress>true</con:HasOtherAddress>'
        +                '<con:LeftHanded>false</con:LeftHanded>'
        +                '<con:ParticularAddress>false</con:ParticularAddress>'
        +                '<con:TaskClassificationActivityTypeId>164</con:TaskClassificationActivityTypeId>'
        +            '</con:BranchData>'
        +            '<con:Clients>'
        +                '<col:KeyValuePairOfClientRoleIdsClient>'
        +                    '<col:key>1</col:key>'
        +                    '<col:value>'
        +                        '<ent:AreaCode>11</ent:AreaCode>'
        +                        '<ent:BirthDate>1998-06-30T00:00:00</ent:BirthDate>'
        +                        '<ent:BirthPlaceCityDescription xsi:nil="true"/>'
        +                        '<ent:CityId>30001</ent:CityId>'
        +                        '<ent:Code xsi:nil="true"/>'
        +                        '<ent:DocumentNumber>33222111</ent:DocumentNumber>'
        +                        '<ent:DocumentType>D</ent:DocumentType>'
        +                        '<ent:Email>algo@algo.com</ent:Email>'
        +                        '<ent:FirstName>Jorge</ent:FirstName>'
        +                        '<ent:IvaConditionId>4</ent:IvaConditionId>'
        +                        '<ent:LastName>Apellido</ent:LastName>'
        +                        '<ent:PhoneNumber>44443333</ent:PhoneNumber>'
        +                        '<ent:SingleTaxCategoryId xsi:nil="true"/>'
        +                        '<ent:Street>Su calle 2141</ent:Street>'
        +                        '<ent:ZipCode>1401</ent:ZipCode>'
        +                    '</col:value>'
        +                '</col:KeyValuePairOfClientRoleIdsClient>'
        +                '<col:KeyValuePairOfClientRoleIdsClient>'
        +                    '<col:key>2</col:key>'
        +                    '<col:value>'
        +                        '<ent:AreaCode>11</ent:AreaCode>'
        +                        '<ent:BirthDate>1998-06-30T00:00:00</ent:BirthDate>'
        +                        '<ent:BirthPlaceCityDescription xsi:nil="true"/>'
        +                        '<ent:CityId>30001</ent:CityId>'
        +                        '<ent:Code xsi:nil="true"/>'
        +                        '<ent:DocumentNumber>33222111</ent:DocumentNumber>'
        +                        '<ent:DocumentType>D</ent:DocumentType>'
        +                        '<ent:Email>algo@algo.com</ent:Email>'
        +                        '<ent:FirstName>Jorge</ent:FirstName>'
        +                        '<ent:IvaConditionId>4</ent:IvaConditionId>'
        +                        '<ent:LastName>Apellido</ent:LastName>'
        +                        '<ent:PhoneNumber>44443333</ent:PhoneNumber>'
        +                        '<ent:SingleTaxCategoryId xsi:nil="true"/>'
        +                        '<ent:Street>Su calle 2141</ent:Street>'
        +                        '<ent:ZipCode>1401</ent:ZipCode>'
        +                    '</col:value>'
        +                '</col:KeyValuePairOfClientRoleIdsClient>'
        +                '<col:KeyValuePairOfClientRoleIdsClient>'
        +                    '<col:key>17</col:key>'
        +                    '<col:value>'
        +                        '<ent:AreaCode xsi:nil="true"/>'
        +                        '<ent:BirthDate>1986-01-01T00:00:00</ent:BirthDate>'
        +                        '<ent:BirthPlaceCityDescription xsi:nil="true"/>'
        +                        '<ent:CityId xsi:nil="true"/>'
        +                        '<ent:Code xsi:nil="true"/>'
        +                        '<ent:DocumentNumber>99999</ent:DocumentNumber>'
        +                        '<ent:DocumentType>Q</ent:DocumentType>'
        +                        '<ent:Email xsi:nil="true"/>'
        +                        '<ent:FirstName/>'
        +                        '<ent:IvaConditionId>4</ent:IvaConditionId>'
        +                        '<ent:LastName/>'
        +                        '<ent:PhoneNumber xsi:nil="true"/>'
        +                        '<ent:SingleTaxCategoryId xsi:nil="true"/>'
        +                        '<ent:Street xsi:nil="true"/>'
        +                        '<ent:ZipCode>0</ent:ZipCode>'
        +                    '</col:value>'
        +                '</col:KeyValuePairOfClientRoleIdsClient>'
        +            '</con:Clients>'
        +            '<con:Comments/>'
        +            '<con:CoverModuleCode>0</con:CoverModuleCode>'
        +            '<con:Covers xsi:nil="true"/>'
        +            '<con:DebitData/>'
        +            '<con:DebitTypeId>0</con:DebitTypeId>'
        +            '<con:ElectronicDispatchInformation xsi:nil="true" />'
        +            '<con:InsuredBasicCapitals xsi:nil="true"/>'
        +            '<con:InsuredGoods xsi:nil="true"/>'
        +            '<con:IsEmission xsi:nil="true"/>'
        +            '<con:PaymentFrequencyId>7</con:PaymentFrequencyId>'
        +            '<con:PolicyId>0</con:PolicyId>'
        +            '<con:Quota>1</con:Quota>'
        +            '<con:Quotation xsi:nil="true"/>'
        +            '<con:RiskAddress>'
        +                '<ent:City>'
        +                    '<ent:CityId>30001</ent:CityId>'
        +                    '<ent:ZipCode>1401</ent:ZipCode>'
        +                '</ent:City>'
        +            '</con:RiskAddress>'
        +            '<con:Since>2020-12-29T00:00:00</con:Since>'
        +            '<con:SpecialOperative/>'
        +            '<con:SurchargeDiscounts/>'
        +            '<con:Thru>2021-01-29T00:00:00</con:Thru>'
        +            '</con:CertificateData>'
        +            '<con:CurrencyId>1</con:CurrencyId>'
        +            '<con:OrganizerNumber>150113</con:OrganizerNumber>'
        +            '<con:ProducerNumber>208829</con:ProducerNumber>'
        +            '<con:ProductId>555</con:ProductId>'
        +            '<con:RenewalTypeId>1</con:RenewalTypeId>'
        +            '<con:StatisticCodeIds>1440</con:StatisticCodeIds>'
        +        '</pol:request>'
        +    '</pol:CreateSinglePolicy>'
        +'</soapenv:Body>'
        +'</soapenv:Envelope>';
}