public inherited sharing class OrbisCotizarWebService {
    public Response serviceResponse { get; private set; }

    public OrbisCotizarWebService() {
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

            String endpoint = EndpointResolver.getEndpoint('Orbis_Cotizar', 'Orbis_Cotizar').Url__c;

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
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
        + '<soapenv:Header/>'
        + '<soapenv:Body>'
        +    '<tem:AUTOS_Cotizar>'
        +       '<!--Optional:-->'
        +       '<tem:doc_in>'
        +          '<auto>'
        +              '<asegurado>'
        +                  '<persona>F</persona>'
        +                  '<iva>CF</iva>'
        +                  '<pagoMedioElectronico>S</pagoMedioElectronico>'
        +              '</asegurado>'
        +              '<bien>'
        +                  '<anofab>2021</anofab>'
        +                  '<cerokm>N</cerokm>'
        +                  '<codpostal>7600</codpostal>'
        +                  '<grupouso>PAR</grupouso>'
        +                  '<marca>45</marca>'
        +                  '<modelo>366</modelo>'
        +                  '<rastreo>N</rastreo>'
        +                  '<suma>0</suma>'
        +                  '<uso>3058</uso>'
        +              '</bien>'
        +              '<usuario>'
        +                  '<fecha>18022021</fecha>'
        +                  '<pass>6101300001_ORBIS_6894</pass>'
        +                  '<plan>01</plan>'
        +                  '<usa>6113001</usa>'
        +                  '<vendedor>6101300001</vendedor>'
        +                  '<vigencia>Q</vigencia>'
        +              '</usuario>'
        +          '</auto>'
        +       '</tem:doc_in>'
        +    '</tem:AUTOS_Cotizar>'
        + '</soapenv:Body>'
        + '</soapenv:Envelope>';
        
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