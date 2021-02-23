@IsTest
public class PEYPEDatosApiResponseTest {

	static testMethod void testParse() {
		String json = '{\"RESULTADO\": {'+
		'    \"Existencia\": {\"row\": {'+
		'        \"cuit\": 30694303451,'+
		'        \"altura\": 1860,'+
		'        \"direccion\": \"MARIO E ARRUABARRENA\",'+
		'        \"localidad\": \"CERRO DE LAS ROSAS\",'+
		'        \"provincia\": \"CORDOBA\",'+
		'        \"cp\": 5009,'+
		'        \"razon\": \"BDP S.A.\"'+
		'    }},'+
		'    \"Validacion\": {\"row\": {'+
		'        \"estitot\": 2.545971,'+
		'        \"cuit\": 30694303451,'+
		'        \"cantemp\": 6'+
		'    }}'+
		'}}';
		PEYPEDatosApiResponse r = PEYPEDatosApiResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApiResponse.Row_Z objRow_Z = new PEYPEDatosApiResponse.Row_Z(System.JSON.createParser(json));
		System.assert(objRow_Z != null);
		System.assert(objRow_Z.estitot == null);
		System.assert(objRow_Z.cuit == null);
		System.assert(objRow_Z.cantemp == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApiResponse objJSON2Apex = new PEYPEDatosApiResponse(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.RESULTADO == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApiResponse.Existencia objExistencia = new PEYPEDatosApiResponse.Existencia(System.JSON.createParser(json));
		System.assert(objExistencia != null);
		System.assert(objExistencia.row == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApiResponse.Row objRow = new PEYPEDatosApiResponse.Row(System.JSON.createParser(json));
		System.assert(objRow != null);
		System.assert(objRow.cuit == null);
		System.assert(objRow.altura == null);
		System.assert(objRow.direccion == null);
		System.assert(objRow.localidad == null);
		System.assert(objRow.provincia == null);
		System.assert(objRow.cp == null);
		System.assert(objRow.razon == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApiResponse.Validacion objValidacion = new PEYPEDatosApiResponse.Validacion(System.JSON.createParser(json));
		System.assert(objValidacion != null);
		System.assert(objValidacion.row == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApiResponse.RESULTADO objRESULTADO = new PEYPEDatosApiResponse.RESULTADO(System.JSON.createParser(json));
		System.assert(objRESULTADO != null);
		System.assert(objRESULTADO.Existencia == null);
		System.assert(objRESULTADO.Validacion == null);
	}
}