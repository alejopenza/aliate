public inherited sharing class OrbisReportesWebService {
    public Response serviceResponse { get; private set; }

    public OrbisReportesWebService() {
        this.serviceResponse = new Response();
    }

    public Boolean cotizar (CotizadorAPIRequest cotizacion, Map<String, String> autenticacion) {
        this.serviceResponse.hasError = false;

        if ( ! this.isAuthenticated(autenticacion) ) {
            return ! this.serviceResponse.hasError;
        }

        String body = '';

        try {
            body = this.createBody(cotizacion);
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

            String endpoint = EndpointResolver.getEndpoint('Orbis_Reportes', 'Orbis_Reportes').Url__c;

            RestWS webServiceCaller = new RestWS(endpoint, 'POST' , null, bodyParameter, headers);

            this.serviceResponse = (Response) webServiceCaller.invoke(this.serviceResponse);
        }

        return ! this.serviceResponse.hasError;
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

    private String createBody (CotizadorAPIRequest cotizacion) {
        //TODO falta obtener los valores reales que deberán pasarse en el body para cotizar
        String body = 
        '<?xml version="1.0" encoding="utf-8"?>'
        +'<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">'
        +  '<soap12:Body>'
        +    '<AUTOS_ListPolizas xmlns="http://tempuri.org/">'
        +      '<doc_in>xml</doc_in>'
        +    '</AUTOS_ListPolizas>'
        +  '</soap12:Body>'
        +'</soap12:Envelope>';
        
        return body;
    }

    public class Response extends WSResult  {

        public String faultString { get; private set; }
        public String faultCode { get; private set; }
        public Boolean validationError { get; set; }
        public String validationMessage { get; set; }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde un http 2XX */
        public override void processResponse (HttpResponse response) { /*TO DO*/  }

        public override void processErrorResponse ( HttpResponse response ) { /*TO DO*/ }
    }
}