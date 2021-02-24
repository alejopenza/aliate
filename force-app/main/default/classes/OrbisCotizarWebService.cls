public inherited sharing class OrbisCotizarWebService {
    public Response serviceResponse { get; private set; }

    public OrbisCotizarWebService() {
        this.serviceResponse = new Response();
    }

    public Boolean cotizar (CotizadorController.Auto auto, CotizadorController.Cliente cliente, Map<String, String> autenticacion) {
        this.serviceResponse.hasError = false;
        /*
        if ( ! this.isAuthenticated(autenticacion) ) {
            return ! this.serviceResponse.hasError;
        }
        */
        String body = '';

        try {
            body = this.createBody(auto, cliente);
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            this.serviceResponse.hasError = true;
            this.serviceResponse.message = 'Error al crear el request: '+ex.getTypeName() +'-'+ ex.getMessage();
        }

        if ( ! this.serviceResponse.hasError ) {
            WSParameter bodyParameter = new WSParameter('body', body , true, false);
            
            WSParameter[] headers = new List<WSParameter> {
                //new WSParameter('Authorization', (autenticacion.get('TokenType')+' '+autenticacion.get('Token')), false, false),
                new WSParameter('Content-Type', 'text/xml', false, false),
                new WSParameter('Content-Length', String.valueOf(body.length()), false, false)
            };
            
            String endpoint = EndpointResolver.getEndpoint('Orbis_Cotizar', 'Orbis_Cotizar').Url__c;

            RestWS webServiceCaller = new RestWS(endpoint, 'POST' , null, bodyParameter);

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

    private String createBody (CotizadorController.Auto auto, CotizadorController.Cliente cliente) {

        String tipoCliente = ((cliente.tipoDeDocumento == 'DNI') ? 'F' : 'J');
        String is0km = (auto.km) ? 'S' : 'N';
        String grupoUso = (auto.uso ? 'COM' : 'PAR');

        String dia = String.valueOf(System.today().day());
        if (Integer.valueOf(dia) < 10) {
            dia = '0' + dia;
        }
        String mes = String.valueOf(System.today().month());
        if (Integer.valueOf(mes) < 10) {
            mes = '0' + mes;
        }        
        String anio = String.valueOf(System.today().year());

        String fecha = dia + mes + anio;

        System.debug('Fecha: ' + fecha);

        String vigencia = '';
        if (auto.periodoDeValidez == 3) {
            vigencia = 'T';
        } else if (auto.periodoDeValidez == 4) {
            vigencia = 'Q';
        } else if (auto.periodoDeValidez == 6) {
            vigencia = 'S'; //por el momento, no cotiza con este periodo
        } else if (auto.periodoDeValidez == 12) {
            vigencia = 'A'; //por el momento, no cotiza con este periodo
        }

        String body = 
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
        + '<soapenv:Header/>'
        + '<soapenv:Body>'
        +    '<tem:AUTOS_Cotizar>'
        +       '<!--Optional:-->'
        +       '<tem:doc_in>'
        +          '<auto>'
        +              '<asegurado>'
        +                  '<persona>'+ tipoCliente + '</persona>'
        +                  '<iva>CF</iva>'
        //+                  '<pagoMedioElectronico>S</pagoMedioElectronico>'
        +              '</asegurado>'
        +              '<bien>'
        +                  '<anofab>' + auto.anio + '</anofab>'
        +                  '<cerokm>' + is0km + '</cerokm>'
        +                  '<codpostal>' + cliente.Codigo_Postal +'</codpostal>'
        +                  '<grupouso>'+ grupoUso +'</grupouso>'
        +                  '<marca>45</marca>'
        +                  '<modelo>366</modelo>'
        +                  '<rastreo>N</rastreo>'
        +                  '<suma>0</suma>'
        +                  '<uso>3058</uso>'
        +              '</bien>'
        +              '<usuario>'
        +                  '<fecha>23022021</fecha>'
        +                  '<pass>6101300001_ORBIS_6894</pass>'
        +                  '<plan>01</plan>'
        +                  '<usa>6113001</usa>'
        +                  '<vendedor>6101300001</vendedor>'
        +                  '<vigencia>'+ vigencia + '</vigencia>'
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