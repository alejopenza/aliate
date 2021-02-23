@isTest
private class SancorAutenticacionWebServiceTest {

    @IsTest
    private static void obtenerToken_siLaRespuestaEsCorrecta_RetornaVerdadero(){
        //Setup(Given)
        SancorAutenticacionWebService wsSut = new SancorAutenticacionWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse().withBody(MOCK_RESPONSE).withStatusCode(200).withPathToMethodNameXML('getTokenResponse').addForAddress('https://external-pre-ws.gruposancorseguros.com:443/Ssa/SecuritySvc');

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSut.getToken();
        Test.stopTest();

        //Test(Then)
        System.assert(result, 'Tiene que haberse conectado correctamente, revisar getToken');
        System.assertEquals( '', wsSut.faultString, 'Fue una comunicacion exitosa, no tiene que haber un "Fault".');
        System.assertEquals( '', wsSut.faultCode, 'Fue una comunicacion exitosa, no tiene que haber un "Fault".');
        System.assertEquals( ACCESS_TOKEN, wsSut.accessToken, 'Tiene que existir accessToken, revisar el mock y el metodo ProcesarRespuesta');
        System.assertEquals( ID_TOKEN, wsSut.idToken, 'Tiene que existir idToken, revisar el mock y el metodo ProcesarRespuesta');
        System.assertEquals( TOKEN_TYPE, wsSut.tokenType, 'Tiene que existir tokenType, revisar el mock y el metodo ProcesarRespuesta');
    }

    @IsTest
    private static void siHayUnErrorDeServicio_RetornaFalso(){
        //Setup(Given)
        SancorAutenticacionWebService wsSut = new SancorAutenticacionWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse().simulateNetworkError().addForAddress('https://external-pre-ws.gruposancorseguros.com:443/Ssa/SecuritySvc');
        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSut.getToken();
        Test.stopTest();

        //Test(Then)
        System.assert(! result, 'hubo un error de conexion, tiene que fallar. Revisar "Procesar Respuesta"');
    }

    @IsTest
    private static void siHayUnErrorDelServidorOUnEstadoDistintoA200_RetornaFalso(){
        //Setup(Given)
        SancorAutenticacionWebService wsSut = new SancorAutenticacionWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(INTERNAL_SERVER_MOCK_RESPONSE)
            .withPathToMethodNameXML('Error')
            .withStatusCode(500)
            .withPathToMethodNameXML('getTokenResponse')
            .addForAddress('https://external-pre-ws.gruposancorseguros.com:443/Ssa/SecuritySvc');

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSut.getToken();
        Test.stopTest();

        //Test(Then)
        System.assert(! result, 'hubo un error de conexion, tiene que fallar. Revisar "Procesar Respuesta"');
        System.assertEquals( 'Internal Error', wsSut.faultString, 'Fue un error del servidor, tiene que haber procesado el "Fault".');
        System.assertEquals( 'env:Client', wsSut.faultCode, 'Fue un error del servidor, tiene que haber procesado el "Fault".');
        System.assertEquals( '', wsSut.accessToken, 'No tiene que existir accessToken');
        System.assertEquals( '', wsSut.idToken, 'No tiene que existir idToken');
        System.assertEquals( '', wsSut.tokenType, 'No tiene que existir tokenType');
    }

    @IsTest
    private static void siHayUnProblemaConLasCredenciales_RetornaFalso(){
        //Setup(Given)
        SancorAutenticacionWebService wsSut = new SancorAutenticacionWebService();
        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(BAD_CREDENTIALS_MOCK_RESPONSE)
            .withPathToMethodNameXML('Internal Server Error')
            .withStatusCode(500)
            .withPathToMethodNameXML('getTokenResponse')
            .addForAddress('https://external-pre-ws.gruposancorseguros.com:443/Ssa/SecuritySvc');

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSut.getToken();
        Test.stopTest();

        //Test(Then)
        System.assert(! result, 'hubo un error de credenciales, tiene que fallar. Revisar "Procesar Respuesta"');
        System.assertEquals( 'Proporcione datos de autenticación válidos', wsSut.faultString, 'Fue un error del servidor, tiene que haber procesado el "Fault".');
        System.assertEquals( 's:Server', wsSut.faultCode, 'Fue un error del servidor, tiene que haber procesado el "Fault".');
        System.assertEquals( '', wsSut.accessToken, 'No tiene que existir accessToken');
        System.assertEquals( '', wsSut.idToken, 'No tiene que existir idToken');
        System.assertEquals( '', wsSut.tokenType, 'No tiene que existir tokenType');
    }

    static final String ACCESS_TOKEN = CalloutResponseFactory.SANCOR_ACCESS_TOKEN;

    static final String ID_TOKEN = CalloutResponseFactory.SANCOR_ID_TOKEN;

    static final String TOKEN_TYPE = CalloutResponseFactory.SANCOR_TOKEN_TYPE;

    static final String MOCK_RESPONSE = CalloutResponseFactory.SANCOR_GET_TOKEN_RESPONSE;

    static final String INTERNAL_SERVER_MOCK_RESPONSE = CalloutResponseFactory.SANCOR_INTERNAL_SERVER_MOCK_RESPONSE;

    static final String BAD_CREDENTIALS_MOCK_RESPONSE = CalloutResponseFactory.SANCOR_GET_TOKEN_BAD_CREDENTIALS_RESPONSE;

    static final String EMPTY_MOCK_RESPONSE = CalloutResponseFactory.SANCOR_GET_TOKEN_EMPTY_RESPONSE;
}