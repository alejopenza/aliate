/**
 * Servicio que se encarga de realizar una cotizacion de auto para Rio Uruguay Seguros.
 */
public without sharing class RUSCotizacionAutoWebService {

    public Response serviceResponse { get; private set; }

    public RUSCotizacionAutoWebService() {
        this.serviceResponse = new Response();
    }

    public Boolean cotizar(RUSCotizacionAutoRequest request, String token){
        this.serviceResponse.hasError = false;

        Credencial__mdt credenciales = EndpointResolver.getEndpoint('RUS_Cotizar_Auto_Sandbox', 'RUS_Login_Produccion');

        String body = '';

        try {
            body = JSON.serialize(request, true);
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            this.serviceResponse.hasError = true;
            this.serviceResponse.message = 'Error al crear el request: '+ex.getTypeName() +'-'+ ex.getMessage();
        }

        if ( ! this.serviceResponse.hasError ) {
            WSParameter bodyParameter = new WSParameter('body', body , true, false);
            WSParameter[] headers = new List<WSParameter> {
                new WSParameter('Accept', 'application/json', false, false),
                new WSParameter('Authorization', token, false, false),
                new WSParameter('Content-Length', String.valueOf(body.length()), false, false)
            };

            RestWS webServiceCaller = new RestWS(credenciales.Url__c, 'PUT' , null, bodyParameter, null);

            this.serviceResponse = (Response) webServiceCaller.invoke(this.serviceResponse);
        }

        return ! this.serviceResponse.hasError;
    }

    public class Response extends WSResult  {

        public RUSCotizacionAutoResponse cotizacion { get; private set; }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde un http 2XX */
        public override void processResponse(HttpResponse response) {
            this.hasError = false;
            this.cotizacion = RUSCotizacionAutoResponse.parse(response.getBody());
        }

        /** Este metodo se encarga de procesar la respuesta de servicio cuando el servicio responde algo distinto a un Http 2XX */
        public override void processErrorResponse ( HttpResponse response ) {
            this.hasError = true;
            this.cotizacion = RUSCotizacionAutoResponse.parse(response.getBody());

            switch on response.getStatusCode() {
                when 403 {
                    this.message = 'No posee autorización para acceder al resurso.';
                } when 404 {
                    this.message = 'El recurso al que desea acceder no fue encontrado.';
                } when 409{
                    this.message = 'Error de conexion.';
                } when else {
                    this.message = 'Error desconosido, por favor comuniquese un Administrador.';
                }
            }
        }
    }
}

/* 403 No posee autorización para acceder al resurso
{
  "timestamp": "2021-02-17T18:17:01.555+0000",
  "status": 403,
  "error": "Forbidden",
  "message": "Access Denied",
  "path": "/api-rus/cotizaciones/autos"
}
*/

/* 409
{
    "httpStatusCode": "CONFLICT",
    "code": "REST004",
    "errorCode": "SIS_ERROR_CONNECTION",
    "cause": "Error conectando con SIS.",
    "properties": {},
    "validationErrors": []
  }*/

/* 200 Respuesta OK
{
   "codigoProductor": 10080, // tiene que ser el codigo de la persona autenticada
   "codigoSolicitante": 10080, // tiene que ser el codigo de la persona autenticada
   "codigoTipoInteres": "VEHICULO",
   "condicionFiscal": "CF",
   "cuotas": 3,
   "numeroSolicitud": 2,
   "tipoVigencia": "ANUAL",
   "vehiculos": [
      {
         "anio": "2020",
         "controlSatelital": "NO",
         "cpLocalidadGuarda": 3260,
         "gnc": "NO",
         "localidadGuarda": "",
         "modeloVehiculo": 88047,
         "rastreadorSatelital": "",
         "rastreoACargoRUS": "NO",
         "sumaAseguradaAccesorios": 0,
         "sumaAseguradaGnc": 0,
         "sumaAseguradaVehiculo": "1300000",
         "uso": "PARTICULAR"
      }
   ],
   "vigenciaDesde": "2021-02-20",
   "vigenciaHasta": "2022-02-20"
}


*/