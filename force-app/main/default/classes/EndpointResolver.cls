public inherited sharing class EndpointResolver {

    //Podria ser un metodo en una clase como "endpointresolver" o CredencialMetadataHelper
    public static Credencial__mdt getEndpoint (String preproductionMetadataDevname, String productionMetadataDevname){
        Boolean isSandbox = [
			SELECT isSandbox
			FROM Organization
		].IsSandbox;

        String metadataDeveloperName = preproductionMetadataDevname;

        if ( ! isSandbox ) { //Si estamos en un entorno productivo seteamos la metadata de produccion acorde a la compania del usuario
            metadataDeveloperName = productionMetadataDevname;
        }

        List<Credencial__mdt> credenciales = [
            SELECT Url__c, clave__c, User__c, DeveloperName
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

        if(String.isBlank(credencial.Url__c)){
            throw new Exceptions.UrlConnectionDoesNotExistException('URL de Conexion inexistente, por favor comuniquese con un administrador.');
        }

        return credencial;
    }

}