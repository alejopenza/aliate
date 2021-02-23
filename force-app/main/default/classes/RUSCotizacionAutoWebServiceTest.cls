@IsTest
public with sharing class RUSCotizacionAutoWebServiceTest {

    static final String ENDPOINT = [ SELECT isSandbox FROM Organization ].IsSandbox ? 'https://sandbox.sis.rus.com.ar/api-rus/cotizaciones/autos' : 'https://sis.rus.com.ar/api-rus/cotizaciones/autos';

    static final String RESPONSE_CODE_409 = CalloutResponseFactory.RUS_COTIZAR_AUTO_409_RESPONSE;

    static final String RESPONSE_CODE_403 = CalloutResponseFactory.RUS_COTIZAR_AUTO_403_RESPONSE;

    static final String RESPONSE_CODE_404 = CalloutResponseFactory.RUS_COTIZAR_AUTO_404_RESPONSE;

    static final String GOOD_RESPONSE = CalloutResponseFactory.RUS_COTIZAR_AUTO_GOOD_RESPONSE;

    @IsTest
    private static void GoodResponseTest(){
        //Setup(Given)
        RUSCotizacionAutoWebService wsSUT = new RUSCotizacionAutoWebService();

        RUSCotizacionAutoRequest.Vehiculo auto = new RUSCotizacionAutoRequest.Vehiculo();
        auto.anio = '2020' ;
		auto.controlSatelital = 'NO';
		auto.cpLocalidadGuarda = 3260;
		auto.gnc = 'NO';
		auto.modeloVehiculo = 88047;
		auto.rastreadorSatelital = 'NO';
		auto.rastreoACargoRUS = 'NO';
		auto.sumaAseguradaAccesorios = 0;
		auto.sumaAseguradaGnc = 0;
		//auto.sumaAseguradaVehiculo = '1300000';
		auto.uso = 'PARTICULAR';

        RUSCotizacionAutoRequest request = new RUSCotizacionAutoRequest();
        request.codigoProductor = 10080;
        request.codigoSolicitante = 10080;
        request.codigoTipoInteres = 'VEHICULO';
        request.condicionFiscal = 'EX';
        request.cuotas = 3;
        request.numeroSolicitud = 1;
        request.tipoVigencia = 'ANUAL';
        request.vigenciaDesde = '2020-02-18';
        request.vigenciaHasta = '2021-02-18';
        request.vehiculos = new List<RUSCotizacionAutoRequest.Vehiculo> { auto };

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(GOOD_RESPONSE)
            .withStatusCode(200)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.cotizar(request, 'ABC_123_token');
        Test.stopTest();

        //Test(Then)
        System.assertEquals(true, result, 'Tiene que cotizar,hubo un error en el parseo!!');
    }


    @IsTest
    private static void resourceNotFoundErrorTest(){
        //Setup(Given)
        RUSCotizacionAutoWebService wsSUT = new RUSCotizacionAutoWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(RESPONSE_CODE_404)
            .withStatusCode(404)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.cotizar(new RUSCotizacionAutoRequest(), 'ABC_123_token');
        Test.stopTest();

        //Test(Then)
        System.assertEquals(false, result, 'No tiene que cotizar, por un error de conexion!');
        System.assertEquals('El recurso al que desea acceder no fue encontrado.', wsSUT.serviceResponse.message, 'No es el mensaje de error esperado!');
    }

    @IsTest
    private static void unathorizedErrorTest(){
        //Setup(Given)
        RUSCotizacionAutoWebService wsSUT = new RUSCotizacionAutoWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(RESPONSE_CODE_403)
            .withStatusCode(403)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.cotizar(new RUSCotizacionAutoRequest(), 'ABC_123_token');
        Test.stopTest();

        //Test(Then)
        System.assertEquals(false, result, 'No tiene que cotizar, por un error de conexion!');
        System.assertEquals('No posee autorización para acceder al resurso.', wsSUT.serviceResponse.message, 'No es el mensaje de error esperado!');
    }

    @IsTest
    private static void badConnectionErrorTest(){
        //Setup(Given)
        RUSCotizacionAutoWebService wsSUT = new RUSCotizacionAutoWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(RESPONSE_CODE_409)
            .withStatusCode(409)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.cotizar(new RUSCotizacionAutoRequest(), 'ABC_123_token');
        Test.stopTest();

        //Test(Then)
        System.assertEquals(false, result, 'No tiene que cotizar, por un error de conexion!');
        System.assertEquals('Error de conexion.', wsSUT.serviceResponse.message, 'No es el mensaje de error esperado!');
    }

    @IsTest
    private static void networkConnectionErrorTest(){
        //Setup(Given)
        RUSCotizacionAutoWebService wsSUT = new RUSCotizacionAutoWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .simulateNetworkError()
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.cotizar(new RUSCotizacionAutoRequest(), 'ABC_123_token');
        Test.stopTest();

        //Test(Then)
        System.assertEquals(false, result, 'No tiene que cotizar, por un error de conexion!');
    }
}