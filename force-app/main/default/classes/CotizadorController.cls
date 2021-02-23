public without sharing class CotizadorController {

    //PEYPE
    @AuraEnabled
    public static Wrapper doCallout1(String numero, String sexo, String typeSelected){
        system.debug('doCallout1(): ' + numero + ' ' + sexo + ' ' + typeSelected);
        Wrapper result = new Wrapper();
        
        try{

            //CLIENTE
            if(typeSelected == 'CUIT'){
                result = PEYPEDatosAPIFinal.doCUITCallout(result, numero);
            }else if(typeSelected == 'DNI'){
                result = PEYPEDatosAPIFinal.doDNICallout(result, numero, sexo);
            }
            result.cliente.tipoDeDocumento = typeSelected;
            result.cliente.genero = sexo;
            result.cliente.condicionAnteIVA = Integer.valueOf(PEYPEDatosAPIFinal.getCondicionAnteIVA(result));
        }catch(Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }
        
        return result;
    }

    @AuraEnabled
    public static Wrapper doSave1(String cliente, String auto, String cotizaciones){
        system.debug('doSave1(): ' + cliente + ' ' + auto + ' ' + cotizaciones);

        Wrapper result = new Wrapper();

        Savepoint sp = Database.setSavepoint();
        try{

            //CLIENTE
            Cliente client = (Cliente) JSON.deserialize(cliente, Cliente.class);
            List<Account> clients = [
                SELECT ID, Name
                FROM Account
                WHERE Numero_de_Documento__c = :client.Numero_de_Documento
            ];
            
            Account clientFromDB;
            if(clients.size() > 1){
                //todo ver cuando hay mas de un cliente con el mismo dni (traerme el sexo tb ?)
            }else if(clients.size() == 0){
                clientFromDB = new Account();
                clientFromDB.RecordTypeId = [
                    SELECT ID
                    FROM RecordType
                    WHERE DeveloperName = 'Asegurado'
                ].Id;

                // todo se hace el cut del name y apellido para evitar la excepcion de nombre muy largo.
                if ( 'CUIT'.equalsIgnoreCase(client.tipoDeDocumento) && String.isNotBlank(client.nombre) && client.nombre.length() > 40 ){
                    clientFromDB.FirstName = (String.isNotBlank(client.nombre) && client.nombre.length() > 40) ? client.nombre.substring(0, 40) : client.nombre;
                    clientFromDB.LastName = client.nombre.substring(40, client.nombre.length());
                } else {
                    clientFromDB.FirstName = (String.isNotBlank(client.nombre) && client.nombre.length() > 40) ? client.nombre.substring(0, 40) : client.nombre;
                    clientFromDB.LastName = (String.isNotBlank(client.apellido) && client.apellido.length() > 40) ? client.apellido.substring(0, 40) : client.apellido;
                }

                clientFromDB.Numero_de_Documento__c = client.Numero_de_Documento;
                clientFromDB.codigo_postal__c = client.codigo_postal;
                database.insert(clientFromDB);
            }else{
                clientFromDB = clients[0];
            }
            system.debug('client: ' + clientFromDB);
            
            //AUTO
            Auto car = (Auto) JSON.deserialize(auto, Auto.class);
            
            //AUTOMOTOR
            //COTIZACION
            Opportunity cotizacion = new Opportunity();
            cotizacion.Name = clientFromDB.Name + ' - AUTOMOVIL';
            cotizacion.AccountId = clientFromDB.Id;
            cotizacion.StageName = 'Proposal'; //todo ver esto
            cotizacion.Ramo__c = 'Automotor';
            cotizacion.LeadSource = 'Partner';
            cotizacion.recordTypeId = [
                SELECT ID
                FROM RecordType
                WHERE DeveloperName = 'Cotizacion'
            ].Id;
            cotizacion.CloseDate = system.today().addDays(30);

            cotizacion.Ajuste_Automatico__c = car.ajuste;
            //cotizacion.Pricebook2Id = pbes[0].PriceBook2Id;
            database.insert(cotizacion);

            //SANCOR
            List<CotizacionSancor> cotizacionesSancor = (List<CotizacionSancor>) JSON.deserialize(cotizaciones, List<CotizacionSancor>.class);
            result = SancorCotizador.doSave(result, car, cotizacionesSancor, cotizacion);

        }catch(Exception e){
            Database.rollback(sp);
            
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            
            result.hasError = true;
            result.errors.add(e.getMessage() + ' ' + e.getStackTraceString());
            
            ErrorHelper.LogError(e);
        }

        return result;
    }
    
    public static void sendEmail(Auto auto, List<QuoteLineItem> qlis, Quote presupuesto, Cliente cliente){
        
        List<Id> qlisIds = new List<Id>();
        for(QuoteLineItem qli : qlis){
            qlisIds.add(qli.Id);
        }
        
        qlis = [
            SELECT ID, Aseguradora__c, TotalPrice, Product2.Tipo_de_Cobertura__c
            FROM QuoteLineItem
            WHERE Id IN :qlisIds
        ];
        
        String tipoCobertura = qlis[0].Product2.Tipo_de_Cobertura__c;
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.subject = 'Aliate - Cotizacion';
        message.setToAddresses(new List<String> {cliente.email});
        
        String body = '';
        body+= 'SR.: ' + cliente.nombre + ' ' + cliente.apellido + '<br>';
        body+= 'Por medio de la presente hacemos llegar nuestra cotizacion solicitada.' + '<br>';
        body+= 'Fecha: ' + system.today().format() + '<br>';
        body+= 'DNI/CUIT: ' + cliente.Numero_de_Documento + '<br>';
        body+= 'VEHICULO: ' + auto.marca + ' ' + auto.modelo + '<br>';
        body+= 'Codigo Postal: ' + cliente.codigo_postal + '<br>';
        
        body+= '<table>';
        
        body+='<tr>';
        body+='<th></th>';
        for(QuoteLineItem qli : qlis){
            body+='<th>' + qli.Aseguradora__c + '</th>';    
        }
        body+='</tr>';
        
        body+='<tr>';
        body+='<th>COBERTURA</th>';
        for(QuoteLineItem qli : qlis){
            body+='<th>' + 'CUOTA' + '</th>';    
        }
        body+='</tr>';
        
        body+='<tr>';
        body+='<td>' + tipoCobertura + '</td>';
        for(QuoteLineItem qli : qlis){
            body+='<td>' + qli.TotalPrice + '</td>';
        }
        body+='</tr>';
        
        body+='</table>';
        
        message.setHtmlBody(body);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
    }
    
    //WRAPPERS
    public class Wrapper{
        public Wrapper(){
            this.hasError = false;
            this.errors = new List<String>();
            this.cotizacionesSancor = new List<CotizacionSancor>();
            //this.cotizaciones_vida = new List<Cotizacion>();
            this.modulosCoberturas = new List<Modulo_Cobertura__mdt>();
            this.modulosCoberturasSC = new List<AllValidProductOffering__c>();
            this.periodosDeValidez = new List<Periodo_Validez__mdt>();
            this.frecuenciaPagos = new List<Frecuencia_Pago__mdt>();
            this.marcasIA = new Map<Integer, String>();
            this.modelosIA = new Map<Integer, String>();
            this.versionesIA = new Map<Integer, String>();
            this.nomina = new List<NominaItem>();
            this.cliente = new cliente();
        }
        
        @AuraEnabled
        public boolean hasError {get;set;}
        
        @AuraEnabled
        public List<String> errors {get;set;}

        @AuraEnabled
        public Map<Integer, String> marcasIA {get;set;}

        @AuraEnabled
        public Map<Integer, String> modelosIA {get;set;}

        @AuraEnabled
        public Map<Integer, String> versionesIA {get;set;}
        
        @AuraEnabled
        public Cliente cliente {get;set;}
        
        @AuraEnabled
        public List<CotizacionSancor> cotizacionesSancor {get;set;}

        @AuraEnabled
        public List<CotizacionSanCristobal> cotizacionesSanCristobal {get;set;}
        
        @AuraEnabled
        public Id returnId {get;set;}

        @AuraEnabled
        public List<NominaItem> nomina {get;set;}
        
        @AuraEnabled
        public Opportunity cotizacion {get;set;}
        
        @AuraEnabled
        public List<Quote> presupuestos {get;set;}
        
        @AuraEnabled
        public Auto auto {get;set;}

        @AuraEnabled
        public List<Modulo_Cobertura__mdt> modulosCoberturas {get;set;}

        @AuraEnabled
        public List<AllValidProductOffering__c> modulosCoberturasSC {get;set;}

        @AuraEnabled
        public List<Tipo_Accesorio__mdt> tiposDeAccesorios {get;set;}

        @AuraEnabled
        public List<Periodo_Validez__mdt> periodosDeValidez {get;set;}

        @AuraEnabled
        public List<Frecuencia_Pago__mdt> frecuenciaPagos {get;set;}
        
    }

    public class CotizacionSanCristobal{
        public CotizacionSanCristobal(){

        }

        @AuraEnabled
        public String aseguradora {get;set;}

        @AuraEnabled
        public String descripcion {get;set;}

        @AuraEnabled
        public Decimal ivaMensual {get;set;}

        @AuraEnabled
        public Decimal ivaTotal {get;set;}

        @AuraEnabled
        public Decimal premioMensual {get;set;}

        @AuraEnabled
        public Decimal premioTotal {get;set;}
        
    }

    public class CotizacionSancor{
        
        public CotizacionSancor(){
            this.sumasAseguradas = new List<CotizacionSancorSumaAsegurada>();
        }

        @AuraEnabled
        public String aseguradora {get;set;}

        @AuraEnabled
        public String descripcionCorta {get;set;}

        @AuraEnabled
        public Decimal ivaMensual {get;set;}

        @AuraEnabled
        public Decimal ivaTotal {get;set;}

        @AuraEnabled
        public Decimal premioMensual {get;set;}

        @AuraEnabled
        public Decimal premioTotal {get;set;}

        @AuraEnabled
        public List<CotizacionSancorSumaAsegurada> sumasAseguradas {get;set;}
        
    }

    public class CotizacionSancorSumaAsegurada{
        public CotizacionSancorSumaAsegurada(){}

        @AuraEnabled
        public Decimal capital {get;set;}

        @AuraEnabled
        public String descripcion {get;set;}

        @AuraEnabled
        public String detalleTipo {get;set;}

        @AuraEnabled
        public Decimal primaPuraMensual {get;set;}

        @AuraEnabled
        public Decimal primaPuraTotal {get;set;}

    }
    
    public class Cliente{
        
        public Cliente(){
            
        }
        
        @AuraEnabled
        public String nombre {get;set;}
        
        @AuraEnabled
        public String apellido {get;set;}
        
        @AuraEnabled
        public String email {get;set;}
        
        @AuraEnabled
        public String Numero_de_Documento {get;set;}
        
        @AuraEnabled
        public Integer Codigo_Postal {get;set;}
        
        @AuraEnabled
        public boolean es_empleador {get;set;}

        @AuraEnabled
        public String tipoDeDocumento {get;set;}

        @AuraEnabled
        public Integer condicionAnteIVA {get;set;}

        @AuraEnabled
        public String genero {get;set;}

        @AuraEnabled
        public String fecha_nacimiento {get;set;}
        
        @AuraEnabled
        public String estado {get;set;}

    }
    
    public class Cotizacion_Cliente{
        
        public Cotizacion_Cliente(){
            
        }
        
        @AuraEnabled
        public String aseguradora {get;set;}
        
        @AuraEnabled
        public String cobertura {get;set;}
        
    }
    
    public class MedioDePago{
        public MedioDePago(){}
        
        @AuraEnabled
        public String medioDePago {get;set;}
        
        @AuraEnabled
        public Decimal numeroMedioDePago {get;set;}
        
        @AuraEnabled
        public String nombreMedioDePago {get;set;}
        
    }
    
    public class Auto{
        
        public Auto(){

        }

        @AuraEnabled
        public List<String> marcas {get;set;}
        
        @AuraEnabled
        public List<String> modelos {get;set;}
        
        @AuraEnabled
        public List<Integer> anios {get;set;}
        
        @AuraEnabled
        public List<String> versiones {get;set;}
        
        @AuraEnabled
        public List<Decimal> ajustes {get;set;}
        
        @AuraEnabled
        public List<String> tiposDeCobertura {get;set;}

        @AuraEnabled
        public List<String> tiposDeCoberturaSC {get;set;}
        
        @AuraEnabled
        public String patente {get;set;}
        
        @AuraEnabled
        public Integer nroMotor {get;set;}
        
        @AuraEnabled
        public Integer nroChasis {get;set;}
        
        @AuraEnabled
        public String marca {get;set;}
        
        @AuraEnabled
        public String modelo {get;set;}
        
        @AuraEnabled
        public Integer anio {get;set;}
        
        @AuraEnabled
        public String version {get;set;}
        
        @AuraEnabled
        public boolean uso {get;set;}
        
        @AuraEnabled
        public boolean gnc {get;set;}
        
        @AuraEnabled
        public Integer sumaAseguradaGNC {get;set;}
        
        @AuraEnabled
        public boolean km {get;set;}
        
        @AuraEnabled
        public boolean rastreador {get;set;}
        
        @AuraEnabled
        public Decimal ajuste {get;set;}
        
        @AuraEnabled
        public Boolean accesorio {get;set;}
        
        @AuraEnabled
        public String tipoAccesorio {get;set;}
        
        @AuraEnabled
        public Decimal sumaAseguradaAccesorio {get;set;}
        
        @AuraEnabled
        public String tipoDeCobertura {get;set;}

        @AuraEnabled
        public String tipoDeCoberturaSC {get;set;}

        @AuraEnabled
        public Integer sumaAsegurada {get;set;}

        @AuraEnabled
        public List<String> codigosDeModuloDeCoberturas {get;set;}

        @AuraEnabled
        public List<String> codigosDeModuloDeCoberturasSC {get;set;}

        @AuraEnabled
        public Integer periodoDeValidez {get;set;}

        @AuraEnabled
        public Integer frecuenciaPago {get;set;}

        @AuraEnabled
        public Integer cuota {get;set;}

        @AuraEnabled
        public String categoria {get;set;} //added
        
        @AuraEnabled
        public String medioDePago {get;set;} //added
    }

    public class NominaItem{

        @AuraEnabled
        public Integer cuit_empleador {get;set;}

        @AuraEnabled
        public String calle {get;set;}

        @AuraEnabled
        public Integer dpto {get;set;}

        @AuraEnabled
        public String apenom {get;set;}

        @AuraEnabled
        public Integer nro {get;set;}

        @AuraEnabled
        public String ocupacion {get;set;}

        @AuraEnabled
        public String provincia {get;set;}

        @AuraEnabled
        public Integer edad {get;set;}

        @AuraEnabled
        public Integer cp {get;set;}

        @AuraEnabled
        public String fecha_nac {get;set;}

        @AuraEnabled
        public Integer cuit {get;set;}

        @AuraEnabled
        public Integer doc {get;set;}

        @AuraEnabled
        public String pi {get;set;}

        @AuraEnabled
        public String localidad {get;set;}

        @AuraEnabled
        public String sexo {get;set;}

        @AuraEnabled
        public String razon_social_empleador {get;set;}

    }
    
}