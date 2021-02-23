public without sharing class SancorAutenticacionWebService {

    public String user { get; private set; }
    public String idToken { get; private set; }
    public String tokenType { get; private set; }
    public String accessToken { get; private set; }
    public String faultString { get; private set; }
    public String faultCode { get; private set; }

 //el response da un access token y un jwt para desencriptar donde figura el tiempo de duracion del token
    public SancorAutenticacionWebService() {
        this.tokenType = '';
        this.accessToken = '';
        this.idToken = '';
        this.faultString = '';
        this.faultCode = '';
        this.user = '';
    }

    public Boolean getToken(){
        try {
            Http httpSender = new Http();

            HttpRequest req = this.createRequest();

            HttpResponse res = httpSender.send(req);

            System.debug('RESPONSE: ' + res?.getBody().unescapeXml());

            return this.procesarRespuesta(res);

        } catch ( CalloutException e ) {
            System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getTypeName() + '\nMessage:' + e.getMessage() + '\nStack: ' + e.getStackTraceString());
            return false;
        }
    }

    private HttpRequest createRequest() {

        Credencial__mdt credencial = this.getCredentials();

        this.user = credencial.user__c;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(credencial.Url__c);
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(this.crearBody(credencial));

        System.debug('REQUEST: ' + req.getBody());

        return req;
    }

    private String crearBody(Credencial__mdt credencial) {
        // El user y pass junto con el guardado del token dependera del user que se logea.
        List<String> parametros = new List<String>{
            credencial.user__c, // Usuario  (Test: cbiolatto1)
            credencial.Clave__c, // Contraseña (Test: 'Tato1712')
            'IssuanceService', // Valor Fijo
            'Ceibo' // Valor Fijo
        };

        // TODO podria usarse la clase document.xmlnode para armar el request, habria que probarlo.
        String body =
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:req="http://gruposancorseguros.com/ents/SOI/SecuritySvc/GetToken/request">'
            +   '<soapenv:Header></soapenv:Header>'
            +   '<soapenv:Body>'
            +       '<req:getToken>'
            +           '<Credentials>'
            +               '<User>{0}</User>'
            +               '<Password>{1}</Password>'
            +               '<System>{2}</System>'
            +               '<Connection>{3}</Connection>'
            +           '</Credentials>'
            +       '</req:getToken>'
            +   '</soapenv:Body>'
            +'</soapenv:Envelope>';

        return String.format(body, parametros);
    }

    //Podria ser un metodo en una clase como "endpointresolver" o CredencialMetadataHelper
    private Credencial__mdt getCredentials (){
        Boolean isSandbox = [
			SELECT isSandbox
			FROM Organization
		].IsSandbox;

        String companyName = [
            SELECT CompanyName
            FROM User
            WHERE id = :UserInfo.getUserId()
        ].CompanyName;

        String metadataDeveloperName = 'Sancor_SecuritySvc_Preproduccion';

        if ( ! isSandbox ) { //Si estamos en un entorno productivo seteamos la metadata de produccion acorde a la compania del usuario
            metadataDeveloperName = companyName+'_Sancor_SecuritySvc_Produccion';
        }

        List<Credencial__mdt> credenciales = [
            SELECT Url__c, clave__c, User__c
            FROM Credencial__mdt
            WHERE DeveloperName = :metadataDeveloperName
        ];
        Credencial__mdt credencial;

        switch on credenciales.size() {
            when 1 {
                credencial = credenciales[0];
            } when 0 {
                throw new Exceptions.UrlConnectionDoesNotExistException('Credenciales y URL de Conexion inexistente, por favor comuniquese con un administrador.');
            } when else {
                throw new Exceptions.NoActiveUrlConnectionException('Existe mas de una Credencial y URL de Conexion, por favor comuniquese con un administrador.');
            }
        }

        return credencial;
    }

    /**
     * Procesa la respuesta del servicio de logeo y asigna los valores al service.
     * */
    private Boolean procesarRespuesta(HttpResponse respuesta){
        Boolean procesadoCorrectamente = false;
        Integer responseStatusCode = respuesta.getStatusCode();
        String responseStatus = respuesta.getStatus();
        String bodyString = respuesta.getBody();

        if(responseStatusCode >= 200 && responseStatusCode < 300){

            this.accessToken = XMLParser.getNode( bodyString, 'Body/getTokenResponse/Token/AccessToken' ).getText();

            this.idToken = XMLParser.getNode( bodyString, 'Body/getTokenResponse/Token/IdToken' ).getText();
            System.debug('token obtenido ' +this.idToken);
            this.tokenType = XMLParser.getNode( bodyString, 'Body/getTokenResponse/Token/TokenType' ).getText();

            procesadoCorrectamente = true;
        } else if ( responseStatusCode == 500 ) {

            this.procesarFault(bodyString);
        }

        return procesadoCorrectamente;
    }

    /**
     * Procesa el error del servicio y asigna los valores al service.
     * */
    private void procesarFault(String bodyString){
        if ( XMLParser.getNode( bodyString, 'Body/Fault' ) != null ) {

            this.faultCode = XMLParser.getNode( bodyString, 'Body/Fault/faultcode' ).getText();

            this.faultString = XMLParser.getNode( bodyString, 'Body/Fault/faultstring' ).getText();
        }
    }

}


/* Create the request envelope with XML node
DOM.Document doc = new DOM.Document();

String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
dom.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soapenv');
envelope.setNamespace('req', 'http://gruposancorseguros.com/ents/SOI/SecuritySvc/GetToken/request');
dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
dom.XmlNode getToken = body.addChildElement('req:getToken', null, null);
dom.XmlNode credentials = getToken.addChildElement('Credentials', null, null);
credentials.addChildElement('User', null , null).addTextNode('0');
credentials.addChildElement('Password', null , null).addTextNode('1');
credentials.addChildElement('System', null , null).addTextNode('2');
credentials.addChildElement('Connection', null , null).addTextNode('3');

System.debug(doc.toXmlString());
*/

/* Good Response
Status = Succesfull
StatusCode = 200

<NS1:Envelope xmlns:NS1="http://schemas.xmlsoap.org/soap/envelope/">
    <NS1:Header>
        <NS2:responseHeader xmlns:NS2="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
            <messageId>28949f62-99cf-11ea-ba0a-ac14162e0000</messageId>
            <timestamp>2020-05-19T09:49:22.362769-03:00</timestamp>
            <responseStatus>
            <statusCode>Success</statusCode>
            </responseStatus>
        </NS2:responseHeader>
    </NS1:Header>
        <NS1:Body>
            <NS3:getTokenResponse xmlns:NS3="http://gruposancorseguros.com/ents/SOI/SecuritySvc/GetToken/response">
                <Token>
                    <AccessToken>Bjsz9vvbAqhkfmUtWW-60LOSJMwZX40W</AccessToken>
                    <IdToken>eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6ImNiaW9sYXR0bzEiLCJuYW1lIjoiQ3Jpc3RpYW4gQmlvbGF0dG8iLCJ0eXBlIjo4LCJ1cG4iOiJjYmlvbGF0dG8xQFByb2R1Y3RvckEuY2VpYm8uc2FuY29yc2VndXJvcy5jb20iLCJvZmZpY2VJZCI6MTAwLCJtdXN0Q2hhbmdlUGFzc3dvcmQiOmZhbHNlLCJwaWN0dXJlIjoiaHR0cHM6Ly9zLmdyYXZhdGFyLmNvbS9hdmF0YXIvMWVjZmM4MDFjNDU1ZGUxOGE3MzU2NTVmODkwYWM2NjI_cz00ODAmcj1wZyZkPWh0dHBzJTNBJTJGJTJGY2RuLmF1dGgwLmNvbSUyRmF2YXRhcnMlMkZjYi5wbmciLCJjbGllbnRJRCI6IkpPc2R0MGFnajVEMU5ucXVBNnpXWmFPZzVHRVpaZ1VQIiwidXBkYXRlZF9hdCI6IjIwMjAtMDUtMTlUMTI6NDk6MjIuNTA0WiIsInVzZXJfaWQiOiJhdXRoMHwxNTIyMSIsImlkZW50aXRpZXMiOlt7InVzZXJfaWQiOjE1MjIxLCJwcm92aWRlciI6ImF1dGgwIiwiY29ubmVjdGlvbiI6IkNlaWJvIiwiaXNTb2NpYWwiOmZhbHNlfV0sImNyZWF0ZWRfYXQiOiIyMDIwLTAxLTAzVDExOjA4OjA3LjMzOFoiLCJpc3MiOiJodHRwczovL2xvZ2luLWRldi5ncnVwb3NhbmNvcnNlZ3Vyb3MuY29tLyIsInN1YiI6ImF1dGgwfDE1MjIxIiwiYXVkIjoiSk9zZHQwYWdqNUQxTm5xdUE2eldaYU9nNUdFWlpnVVAiLCJpYXQiOjE1ODk4OTI1NjIsImV4cCI6MTU5NzY2ODU2Mn0.ytK08REwwFVNSeH0y40tqyBlHysJkFo4QMqcM2mNnT0</IdToken>
                    <TokenType>Bearer</TokenType>
                </Token>
                <Result>
                    <ErrorCode>SOA-GSS-0000</ErrorCode>
                    <ErrorMsg>Success</ErrorMsg>
                </Result>
            </NS3:getTokenResponse>
        </NS1:Body>
    </NS1:Envelope>
*/

/* Invalid Credentials
Status = Internal Server Error
StatusCode = 500

<?xml version="1.0" encoding="UTF-8"?>
<NS1:Envelope xmlns:NS1="http://schemas.xmlsoap.org/soap/envelope/">
   <NS1:Header>
      <NS2:responseHeader xmlns:NS2="http://gruposancorseguros.com/ents/SOI/Commons/v1.0">
         <messageId>6bc502ec-4927-11eb-8f23-ac1416b90000</messageId>
         <timestamp>2020-12-28T13:12:04.424725-03:00</timestamp>
         <responseStatus>
            <statusCode>GeneralException</statusCode>
         </responseStatus>
      </NS2:responseHeader>
   </NS1:Header>
   <NS1:Body>
      <NS1:Fault>
         <faultcode xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">s:Server</faultcode>
         <faultstring>Proporcione datos de autenticación válidos</faultstring>
         <detail>
            <NS3:businessFault xmlns:NS3="http://gruposancorseguros.com/ents/SOI/Err/v1.0">
               <errorDetails>
                  <errorDetail>
                     <errorCode>100</errorCode>
                     <errorType>GeneralException</errorType>
                     <errorDesc>Access is denied due to invalid credentials</errorDesc>
                  </errorDetail>
               </errorDetails>
            </NS3:businessFault>
         </detail>
      </NS1:Fault>
   </NS1:Body>
</NS1:Envelope>
*/

/* Error
Status = Error
StatusCode = 500

<?xml version='1.0' ?>
<env:Envelope xmlns:env='http://schemas.xmlsoap.org/soap/envelope/'>
    <env:Body>
        <env:Fault>
            <faultcode>env:Client</faultcode>
            <faultstring>Internal Error</faultstring>
        </env:Fault>
    </env:Body>
</env:Envelope>
*/