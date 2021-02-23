public with sharing class SCApi {
    public SCApi() {

    }

    public Wrapper getDataFromAPI(){
        Wrapper result = new Wrapper();

        try{

            Credencial__mdt credencial = [
                SELECT ID, User__c, Clave__c, Url__c
                FROM Credencial__mdt
                WHERE Label = 'SC UAT'
            ];

            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c);
            req.setMethod('GET');
            req.setTimeout(16000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            req.setBody(setBody());

            Http h = new Http();
            system.debug(req);
            system.debug(req.getEndpoint());
            system.debug(req.getBody());
            HttpResponse res = h.send(req);
            system.debug(res);
            system.debug(res.getBody());
            
            if(res.getStatusCode() == 200){
                //result.response = PEYPEDatosAPIResponse.parse(res.getBody());
                //system.debug('result.response: ' + result.response);
            }else if(res.getStatusCode() == 404){
                result.hasError = true;
                result.errors.add('Servicio no disponible. Intente mas tarde.');
            }else{
                result.hasError = true;
                result.errors.add('Error al realizar la consulta, revise los datos ingresados.');
            }
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage());
        }

        return result;
    }

    public String setBody(){

        SCApiRequest request = new SCApiRequest();
        request.ProducerCode = '05-006604';
        request.StartDate = '2020-11-30T15:14:22.049Z';
        request.Age = 0;
        request.PostalCodeRiskLocation = 2000;
        request.StateRiskLocation = 'AR_19';
        request.PolicyTermCode = 'HalfYear';
        request.PaymentFees = '6';
        request.CommercialAlternative = 0;
        request.PaymentMethodCode = 'creditcard';
        
        SCApiRequest.Vehiculo vehiculo = new SCApiRequest.Vehiculo();
        vehiculo.CodigoInfoAuto = '120506';
        vehiculo.Year = 2018;
        vehiculo.StatedAmount = 586000;
        vehiculo.Usage = 'P';
        vehiculo.AutomaticAdjust = '5';
        vehiculo.AccesoryAmount = 0;
        vehiculo.HasGPS = false;
        vehiculo.Category = 'Car';
        vehiculo.FuelType = 'NAF';
        vehiculo.Origen = 'N';

        request.Vehiculo = vehiculo;

        SCApiRequest.Versiones version = new SCApiRequest.Versiones();
        version.CA7Product = 'CA7_C';

        SCApiRequest.Versiones version2 = new SCApiRequest.Versiones();
        version2.CA7Product = 'CA7_D';

        SCApiRequest.Versiones version3 = new SCApiRequest.Versiones();
        version3.CA7Product = 'CA7_CM';

        request.Versiones = new List<SCApiRequest.Versiones>{version, version2, version3};

        SCApiRequest.TypeOfContracting  TypeOfContracting = new SCApiRequest.TypeOfContracting();
        TypeOfContracting.Code = 'CA7Reporting';

        request.TypeOfContracting = TypeOfContracting;

        request.Nuevo = true;
        request.OfficialIDType = 'Ext_DNI96';
        request.TaxID = '17364238';
        request.Gender = 'F';

        return JSON.serialize(request);
    }

    //Wrapper
    public class Wrapper{
        public Wrapper(){
            this.hasError = false;
            this.errors = new List<String>();
        }

        @AuraEnabled
        public boolean hasError;

        @AuraEnabled
        public List<String> errors;

        //@AuraEnabled
        //public PEYPEDatosAPIResponse response;
    }
}