/**
 * Clase que se encarga de obtener el token de acceso para el consumo de los servicios de Rio Uruguay Seguros.
 */
public without sharing class RUSLoginWebService {

    public Response serviceResponse { get; private set; }

    public RUSLoginWebService() {
        this.serviceResponse = new Response();
    }

    public Boolean login() {
        this.serviceResponse.hasError = false;

        Credencial__mdt credenciales = EndpointResolver.getEndpoint('RUS_Login_Sandbox', 'RUS_Login_Produccion');

        String body = '';
        RUSLoginRequest request = new RUSLoginRequest();
        /* TODO: Hay que definir donde se guarda las claves del cliente
            Luego se podria hacer:
            'RUS_Login_Sandbox'.equalsIgnoreCase( credenciales.developername ) ? credenciales.user__c : userinfo.usuario
            'RUS_Login_Sandbox'.equalsIgnoreCase( credenciales.developername ) ? credenciales.clave__c : userinfo.clave
        */
        request.username = credenciales.user__c;
        request.password = credenciales.Clave__c;

        try {
            body = JSON.serialize(request);
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            this.serviceResponse.hasError = true;
            this.serviceResponse.message = 'Error al crear el request: '+ex.getTypeName() +'-'+ ex.getMessage();
        }

        if ( ! this.serviceResponse.hasError ) {
            WSParameter bodyParameter = new WSParameter('body', body , true, false);
            WSParameter[] headers = new List<WSParameter> {
                new WSParameter('Accept', 'application/json', false, false),
                new WSParameter('Content-Type', 'application/json', false, false),
                new WSParameter('Content-Length', String.valueOf(body.length()), false, false)
            };


            RestWS webServiceCaller = new RestWS(credenciales.Url__c, 'POST' , null, bodyParameter, null);

            this.serviceResponse = (Response) webServiceCaller.invoke(this.serviceResponse);
        }

        return ! this.serviceResponse.hasError;
    }

    public String getToken(){
        return this.serviceResponse.login.message;
    }

    public class Response extends WSResult  {

        public RUSLoginResponse login { get; set; }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde un http 2XX */
        public override void processResponse(HttpResponse response) {
            this.hasError = false;
            this.login = RUSLoginResponse.parse(response.getBody());
        }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde algo distinto a un Http 2XX */
        public override void processErrorResponse ( HttpResponse response ) {
            switch on response.getStatusCode() {
                when 400 {
                    this.hasError = true;
                    this.message = 'Las credenciales no cargadas.';
                } when 401,403,404 {
                    this.login = RUSLoginResponse.parse(response.getBody());
                    this.hasError = true;
                    this.message = login.message;
                } when else {
                    this.hasError = true;
                    this.message = 'Error desconocido, comuniquese Con Un Administrador.';
                }
            }

        }
    }
}