@IsTest
private with sharing class RUSLoginWebServiceTest {

    static final String ENDPOINT = [ SELECT isSandbox FROM Organization ].IsSandbox ? 'https://sandbox.sis.rus.com.ar/api-rus/login/token' : 'https://sis.rus.com.ar/api-rus/login/token';

    static final String MOCK_RESPONSE = CalloutResponseFactory.RUS_LOGIN_GOOD_RESPONSE;

    static final String NO_CREDENTIALS_RESPONSE = CalloutResponseFactory.RUS_LOGIN_401_RESPONSE;

    static final String EXPECTED_TOKEN = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzMzA0NzAyMy93cyxUR1QtMjAtMGN1cGh6aHJsWkJjcFNnV3hZaGgyZ1A1VzJvbXJuWVYyMnJZRWowZU9LNGt2NW9jSTEtY2FzIn0.x8TfOdpIWFk2DX5sqHMljFjmfv-83QRESvNb8En5taM4HxKZYHjBZ_Igukj7rKe0nwK1qmvkeuEqykjgqCyKYA';

    @IsTest
    private static void ifGetAnstatusCodeGreatherThan300GetAMessage(){
        //Setup(Given)
        RUSLoginWebService wsSUT = new RUSLoginWebService();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody('')
            .withStatusCode(500)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.login();
        Test.stopTest();

        //Test(Then)
        System.assert(! result, 'Tiene que indicar que el servicio devolvio un error!');
        System.assert(wsSUT.serviceResponse.hasError, 'Tiene que indicar que hubo error !');
        System.assertEquals('Error desconocido, comuniquese Con Un Administrador.', wsSUT.serviceResponse.message, 'Tiene que informar mensaje de crenciales no cargadas');
    }

    @IsTest
    private static void ifCredentialsAreNotLoadedGetAnErrorResponse(){
        //Setup(Given)
        RUSLoginWebService wsSUT = new RUSLoginWebService();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody('')
            .withStatusCode(400)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.login();
        Test.stopTest();

        //Test(Then)
        System.assert(! result, 'Tiene que indicar que el servicio devolvio un error!');
        System.assert(wsSUT.serviceResponse.hasError, 'Tiene que indicar que hubo error !');
        System.assertEquals('Las credenciales no cargadas.', wsSUT.serviceResponse.message, 'Tiene que informar mensaje de crenciales no cargadas');
    }

    @IsTest
    private static void shouldBeGetAnErrorMessageIfTheConnectionWithTheServiceGetAn4XX(){
        //Setup(Given)
        RUSLoginWebService wsSUT = new RUSLoginWebService();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(NO_CREDENTIALS_RESPONSE)
            .withStatusCode(401)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.login();
        Test.stopTest();

        //Test(Then)
        System.assert(! result, 'Tiene que indicar que el servicio devolvio un error!');
        System.assert(wsSUT.serviceResponse.hasError, 'Tiene que indicar que hubo error !');
        System.assertNotEquals(EXPECTED_TOKEN, wsSUT.getToken(), 'No tiene que tener el token');
        System.assertEquals('Usuario/password incorrecta', wsSUT.serviceResponse.message, 'Tiene que informar mensaje de crenciales no cargadas');
    }

    @IsTest
    private static void shouldBeGetTokenIfTheConectionWithTheApiIsSuccesfull(){
        //Setup(Given)
        RUSLoginWebService wsSUT = new RUSLoginWebService();

        XHttpCalloutMock mock = new XHttpCalloutMock();
        mock.buildResponse()
            .withBody(MOCK_RESPONSE)
            .withStatusCode(200)
            .addForAddress(ENDPOINT);

        Test.setMock(HttpCalloutMock.class, mock);

        //Exercise(When)
        Test.startTest();
        Boolean result = wsSUT.login();
        Test.stopTest();

        //Test(Then)
        System.assert(result, 'Tiene que indicar que el servicio opero correctamente!');
        System.assert(! wsSUT.serviceResponse.hasError, 'Tiene que indicar que no hubo error !');
        System.assertEquals(EXPECTED_TOKEN, wsSUT.getToken(), 'No dio el token!');
    }
}