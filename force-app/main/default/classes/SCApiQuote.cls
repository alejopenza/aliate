public with sharing class SCApiQuote {

    public enum TermCode {Ext_Trimester, HalfYear, Annual}

    public Wrapper getDataFromAPI(CotizadorController.Auto auto, CotizadorController.Cliente cliente){
        Wrapper result = new Wrapper();

        try{

            Credencial__mdt credencial = getCredencialInfo();

            HttpRequest req = new HttpRequest();
            req.setEndpoint(credencial.Url__c);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('content-type','application/Json');
            req.setHeader('USERNAME', credencial.User__c);
            req.setHeader('PASS', credencial.Clave__c);
            
            //MOCK
            //req.setBody(setMockBody());
            
            //FINAL
            req.setBody(setBody(auto, cliente));

            Http h = new Http();

            system.debug('Request: ' + req.getBody());
            HttpResponse res = h.send(req);
            system.debug('Response: ' + res.getBody());

            if(res.getStatusCode() == 200){
                if(!res.getBody().contains('"HasError":true')){
                    system.debug('entro al success');
                    //Success
                    result.response = SanCristobalCotizacionResponse.parse(res.getBody());
                }else{
                    system.debug('entro al error');
                    //Error
                    result.hasError = true;
                    result.errorResponse = SanCristobalCotizadorResAutoErro.parse(res.getBody());
                }

            }else if(res.getStatusCode() == 404){
                result.hasError = true;
                result.errors.add('Servicio no disponible. Intente mas tarde.');
            }else{
                result.hasError = true;
                result.errors.add('Error al realizar la consulta, revise los datos ingresados.');
                throw new Exceptions.NoActiveUrlConnectionException('Error al realizar la consulta');
            }
            
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
        }

        return result;
    }

    public static Credencial__mdt getCredencialInfo(){
        
        Credencial__mdt credencial = [
            SELECT ID, User__c, Clave__c, Url__c
            FROM Credencial__mdt
            WHERE Label = 'SC_Quote'
        ];

        return credencial;
    }

    public String setBody(CotizadorController.Auto auto, CotizadorController.Cliente cliente){

        SanCristobalCotizadorRequestAuto request = new SanCristobalCotizadorRequestAuto();
        
        SanCristobalCotizadorRequestAuto.Account acc = new SanCristobalCotizadorRequestAuto.Account();
        acc.AccountNumber = null;
        
        SanCristobalCotizadorRequestAuto.AccountHolderContact ahc = new SanCristobalCotizadorRequestAuto.AccountHolderContact();
        
        SanCristobalCotizadorRequestAuto.EntityPerson ep = new SanCristobalCotizadorRequestAuto.EntityPerson();
        
        SanCristobalCotizadorRequestAuto.PrimaryAddress pa = new SanCristobalCotizadorRequestAuto.PrimaryAddress();
        
        system.debug('cliente: ' + cliente);

        ep.FirstName = cliente.nombre;
        ep.LastName = cliente.apellido;

        if (cliente.genero == 'MASCULINO'){
            ep.Gender = 'M';
        } else {
            ep.Gender = 'F';
        } //'M'; //cliente.genero;

        if (cliente.fecha_nacimiento != null) {
            ep.DateOfBirth = cliente.fecha_nacimiento;
            ep.DateOfBirthSpecified = true;
        } else {
            ep.DateOfBirth = null;
            ep.DateOfBirthSpecified = false;
        }

        ahc.EntityPerson = ep;
        if (cliente.tipoDeDocumento == 'DNI') {
            ahc.OfficialIDType = 'Ext_DNI96';
        } else if (cliente.tipoDeDocumento == 'CUIT') {
            ahc.OfficialIDType = 'Ext_CUIT80';
        }
        //ahc.OfficialIDType = cliente.tipoDeDocumento;// 'Ext_DNI96';
        
        pa.PostalCode = cliente.Codigo_Postal;
        system.debug('cliente.codigo_provincia: ' + cliente.Codigo_Provincia);
        pa.State = cliente.Codigo_Provincia; //'AR_19'; //cliente.estado; //'AR_19'; //cliente.estado
        ahc.Subtype = 'Person';
        ahc.TaxID = '42539623';// cliente.Numero_de_Documento;

        SanCristobalCotizadorRequestAuto.EntityCompany ec = new SanCristobalCotizadorRequestAuto.EntityCompany();
        ec.Ext_ActivityStartDate = '2019-02-27T14:47:48.817Z';
        ec.Ext_ActivityStartDateSpecified = true;
		
        ahc.PrimaryAddress = pa;
        ahc.EntityCompany = ec;

        acc.AccountHolderContact = ahc;

        SanCristobalCotizadorRequestAuto.PrimaryAddress pl = new SanCristobalCotizadorRequestAuto.PrimaryAddress();
        pl.PostalCode = cliente.Codigo_Postal;
        pl.State = cliente.Codigo_Provincia; //'AR_19';

        acc.PrimaryLocation = pl;

        acc.ProducerCode = '03-005343';

        request.Account = acc;

        request.StartDate = system.now().format('yyyy-MM-dd HH:mm:ss');
        request.StartDate = request.StartDate.replace(' ', 'T');
        request.StartDate = request.StartDate + '.249Z';
        request.PostalCodeRiskLocation = String.valueOf(cliente.Codigo_Postal);

        request.PaymentFees = auto.frecuenciaPago; //6;
        system.debug('auto.periodoDeValidez: ' + auto.periodoDeValidez);
        if (auto.periodoDeValidez == 3) {
            request.PolicyTermCode = String.valueOf(TermCode.Ext_Trimester);
        } else if (auto.periodoDeValidez == 6) {
            request.PolicyTermCode = String.valueOf(TermCode.HalfYear);
        } else if (auto.periodoDeValidez == 12) {
            request.PolicyTermCode = String.valueOf(TermCode.Annual);
        }else{
            request.PolicyTermCode = 'HalfYear';
            request.PaymentFees = 6;
        }

        request.CommercialAlternative = '0';
        request.PaymentMethodCode = 'responsive'; //auto.medioDePago; //CHEQUEAR
        request.CurrencyCode = 'ars';

        SanCristobalCotizadorRequestAuto.Vehiculos vehiculo = new SanCristobalCotizadorRequestAuto.Vehiculos();
        vehiculo.CodigoInfoAuto = auto.version;
        vehiculo.Year = auto.anio;
        vehiculo.Is0Km = auto.km;
        //vehiculo.HasGPS = false;
        //vehiculo.CUITAcreedorPrendario = '30-68588847-1';
        vehiculo.StatedAmount = auto.sumaAsegurada;
        if(auto.uso){
            vehiculo.Usage = 'Comercial';
        }else{
            vehiculo.Usage = 'Personal';
        }

        if(auto.ajuste != null){
            vehiculo.AutomaticAdjust = String.valueOf(auto.ajuste);
        }else{
            vehiculo.AutomaticAdjust = '0';
        }
        vehiculo.Category = 'Car';
        
        if(auto.sumaAseguradaAccesorio != null){
            vehiculo.AccesoryAmount = Integer.valueOf(auto.sumaAseguradaAccesorio);
        }else{
            vehiculo.AccesoryAmount = 0;
        }

        request.Vehiculos.add(vehiculo);
       
        for (Integer i = 0 ; i < auto.codigosDeModuloDeCoberturasSC.size(); i++) {
            SanCristobalCotizadorRequestAuto.Versiones version = new SanCristobalCotizadorRequestAuto.Versiones();
            version.CA7Product = auto.codigosDeModuloDeCoberturasSC[i];
            request.Versiones.add(version);
        }
        System.debug('Versiones: ' + request.Versiones);
        System.debug('Requiem: ' + request);
        return JSON.serialize(request);

    }

    public String setMockBody(){

        String JSONContent = '{"Account": {"AccountNumber": null,"AccountHolderContact": {"EntityPerson": {"FirstName":"Guillermo", "Gender":"M","LastName":"Arias","DateOfBirth": "1987-01-04T14:47:48.817Z","DateOfBirthSpecified": true},"OfficialIDType": "Ext_DNI96","PrimaryAddress": {"PostalCode": 2000,"State": "AR_19"},"Subtype": "Person","TaxID": "42539623","EntityCompany": {"Ext_ActivityStartDate": "2019-02-27T14:47:48.817Z","Ext_ActivityStartDateSpecified": true}},"OriginationDate": "2019-02-27T14:47:48.817Z","OriginationDateSpecified": true,"PrimaryLocation": {"PostalCode": 2000,"State": "AR_19"},"ProducerCode": "03-005343"},"StartDate": "2020-09-11T17:37:36.249Z","PostalCodeRiskLocation": "2000","PolicyTermCode": "HalfYear","PaymentFees": 6,"CommercialAlternative": "0","PaymentMethodCode": "responsive","CurrencyCode": "ars","Vehiculos": [{"CodigoInfoAuto": "120506","Year": 2018,"Is0Km":false,"HasGPS": false,"CUITAcreedorPrendario": "30-68588847-1","StatedAmount": 1090000,"Usage": "Personal","AutomaticAdjust": "20","Category": "Car","AccesoryAmount": 0}],"Versiones": [{"CA7Product": "CA7_C"}]}';
        JSONParser parser = JSON.createParser(JSONContent);
        SCResponse request = new SCResponse(parser);

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

        @AuraEnabled
        public SCResponse auto;

        @AuraEnabled
        public SanCristobalCotizadorResAutoErro errorResponse;

        @AuraEnabled
        public SanCristobalCotizacionResponse response;

    }
}

/*

//Vehiculo
CotizadorAPIRequest.Vehiculo vehiculo = new CotizadorAPIRequest.Vehiculo();
vehiculo.codigo = '0180517'; // se obtiene de la integracion con infoauto
vehiculo.anio = 2013;
vehiculo.valor = 0;
vehiculo.uso = 2;
vehiculo.tieneGNC = false;
vehiculo.valorEquipoGNC = 0;
vehiculo.poseeRuedaDeAuxilio = false;
vehiculo.es0KM = false;
request.vehiculo = vehiculo;

    request.bienAsegurado = 0;

    //Cliente
    request.codigoPostal = 2300;
    request.numeroDeDocumento = 12599862;
    request.condicionAnteIVA = 4;
    request.tipoDeDocumento = 'D';
    request.personaJuridica = false;

    //Ciudad
    request.ciudadId = 1157; // victor paso parametria excel. deberiamos tener parametrizado en un objeto debido a la cantidad de registros todo eso en sfdc para poder obtener  el valor del id ciudad en base al codigo postal que devuevle peype deberia estar en la solapa de datos de cliente preview y no olvidar tener un trigger para cuando a mano se modifica el CP deberian ser picklists de provincia y localidad

    //Coberturas
    request.codigosDeModuloDeCoberturas = new List<Integer>{5};
    request.descuentos = new List<CotizadorAPIRequest.Descuento>{ };

    //Cotizacion
    request.fechaEfectiva = DateTime.newInstance(2018,10,29,0,0,0);
    request.periodoDeValidez = 1;
    request.frecuenciaDePago = 5;
    request.cuotas = 0;
    request.numeroProductor = 212505; // va a ser un valor en la account (partner account) que sea del broker
    request.numeroOrganizacion = 150766; //150766; // va a ser el numero de organizacion de aliate

    //Scoring
    CotizadorAPIRequest.Scoring scoring0 = new CotizadorAPIRequest.Scoring();
    scoring0.tipoId = 3;
    scoring0.opcionId = 1;
    /// Guarda Garage: id 3; 1 - SI  2 - NO 

    CotizadorAPIRequest.Scoring scoring1 = new CotizadorAPIRequest.Scoring();
    scoring1.tipoId = 7;
    scoring1.opcionId = 2;
    // La Edad de los conductores es Menor a 25 años: 7; 1 - SI  2 - NO

    CotizadorAPIRequest.Scoring scoring3 = new CotizadorAPIRequest.Scoring();
    scoring3.tipoId = 8;
    scoring3.opcionId = 1;
    // kms Anuales Recorridos: 8; 1 - Hasta 25.000 2 - Mayor a 25.000

    //request.scoring = new List<CotizadorAPIRequest.Scoring>{ scoring0, scoring1, scoring3 };
    request.scoring = new List<CotizadorAPIRequest.Scoring>{ }; //viaja la lista vacia porque no es necesario

*/