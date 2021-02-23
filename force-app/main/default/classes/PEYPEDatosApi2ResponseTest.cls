@IsTest
public class PEYPEDatosApi2ResponseTest {
    
	static testMethod void testParse() {
		String json = '{\"RESULTADO\": {\"Existencia_Fisica\": {\"row\": ['+
		'    {'+
		'        \"cuit_empleador\": 30694303451,'+
		'        \"calle\": \"FCOBURGES\",'+
		'        \"apenom\": \"ARTEAGA ORLANDO\",'+
		'        \"nro\": 441,'+
		'        \"ocupacion\": \"RELACION_DEPENDENCIA\",'+
		'        \"provincia\": \"CORDOBA\",'+
		'        \"edad\": 33,'+
		'        \"cp\": 5000,'+
		'        \"fecha_nac\": \"19/02/1987\",'+
		'        \"doc\": 32629657,'+
		'        \"pi\": \"R15\",'+
		'        \"localidad\": \"CORDOBA CAPITAL\",'+
		'        \"sexo\": \"M\",'+
		'        \"cuit_empleado\": 24326296577,'+
		'        \"razon_social_empleador\": \"BDP SA\"'+
		'    },'+
		'    {'+
		'        \"cuit_empleador\": 30694303451,'+
		'        \"calle\": \"RIO PRIMERO\",'+
		'        \"apenom\": \"AGUILAR MARIA DEL CARMEN\",'+
		'        \"nro\": 665,'+
		'        \"ocupacion\": \"RELACION_DEPENDENCIA\",'+
		'        \"provincia\": \"CORDOBA\",'+
		'        \"edad\": 48,'+
		'        \"cp\": 5000,'+
		'        \"fecha_nac\": \"20/03/1972\",'+
		'        \"doc\": 22566352,'+
		'        \"pi\": \"R11\",'+
		'        \"localidad\": \"CORDOBA\",'+
		'        \"sexo\": \"F\",'+
		'        \"cuit_empleado\": 27225663527,'+
		'        \"razon_social_empleador\": \"BDP SA\"'+
		'    },'+
		'    {'+
		'        \"piso\": 1,'+
		'        \"cuit_empleador\": 30694303451,'+
		'        \"calle\": \"ROLAND ROSS\",'+
		'        \"apenom\": \"FRONTERA VACA MARIA ROCIO\",'+
		'        \"nro\": 7856,'+
		'        \"ocupacion\": \"RELACION_DEPENDENCIA\",'+
		'        \"provincia\": \"CORDOBA\",'+
		'        \"edad\": 43,'+
		'        \"cp\": 5000,'+
		'        \"fecha_nac\": \"02/02/1977\",'+
		'        \"doc\": 25755477,'+
		'        \"pi\": \"R15\",'+
		'        \"localidad\": \"CORDOBA\",'+
		'        \"sexo\": \"F\",'+
		'        \"cuit_empleado\": 27257554770,'+
		'        \"razon_social_empleador\": \"BDP SA\"'+
		'    },'+
		'    {'+
		'        \"cuit_empleador\": 30694303451,'+
		'        \"calle\": \"PEDRO CHECHI\",'+
		'        \"apenom\": \"GOMEZ FRANCO MARIA LUCRECIA\",'+
		'        \"nro\": 5925,'+
		'        \"ocupacion\": \"RELACION_DEPENDENCIA\",'+
		'        \"provincia\": \"CORDOBA\",'+
		'        \"edad\": 30,'+
		'        \"cp\": 5000,'+
		'        \"fecha_nac\": \"09/07/1990\",'+
		'        \"doc\": 35062711,'+
		'        \"pi\": \"R14\",'+
		'        \"localidad\": \"CORDOBA\",'+
		'        \"sexo\": \"F\",'+
		'        \"cuit_empleado\": 27350627117,'+
		'        \"razon_social_empleador\": \"BDP SA\"'+
		'    },'+
		'    {'+
		'        \"cuit_empleador\": 30694303451,'+
		'        \"calle\": \"PELLEGRINI\",'+
		'        \"apenom\": \"SOLANS MARIA INES\",'+
		'        \"nro\": 488,'+
		'        \"ocupacion\": \"MONOTRIBUTO  RELACION_DEPENDENCIA\",'+
		'        \"provincia\": \"CORDOBA\",'+
		'        \"edad\": 28,'+
		'        \"cp\": 5152,'+
		'        \"fecha_nac\": \"16/05/1992\",'+
		'        \"doc\": 36120869,'+
		'        \"pi\": \"R16\",'+
		'        \"localidad\": \"VILLA CARLOS PA\",'+
		'        \"sexo\": \"F\",'+
		'        \"cuit_empleado\": 27361208698,'+
		'        \"razon_social_empleador\": \"BDP SA\"'+
		'    },'+
		'    {'+
		'        \"cuit_empleador\": 30694303451,'+
		'        \"calle\": \"ALMIRANTE BROWN\",'+
		'        \"apenom\": \"GONZALEZ GUADALUPE LUZ\",'+
		'        \"nro\": 1766,'+
		'        \"ocupacion\": \"RELACION_DEPENDENCIA\",'+
		'        \"provincia\": \"CORDOBA\",'+
		'        \"edad\": 29,'+
		'        \"cp\": 0,'+
		'        \"fecha_nac\": \"02/08/1991\",'+
		'        \"doc\": 36447855,'+
		'        \"pi\": \"R13\",'+
		'        \"localidad\": \"RIO TERCERO\",'+
		'        \"sexo\": \"F\",'+
		'        \"cuit_empleado\": 27364478556,'+
		'        \"razon_social_empleador\": \"BDP SA\"'+
		'    }'+
		']}}}';
		PEYPEDatosApi2Response r = PEYPEDatosApi2Response.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApi2Response objJSON2Apex = new PEYPEDatosApi2Response(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.RESULTADO == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApi2Response.Existencia_Fisica objExistencia_Fisica = new PEYPEDatosApi2Response.Existencia_Fisica(System.JSON.createParser(json));
		System.assert(objExistencia_Fisica != null);
		System.assert(objExistencia_Fisica.row == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApi2Response.Row objRow = new PEYPEDatosApi2Response.Row(System.JSON.createParser(json));
		System.assert(objRow != null);
		System.assert(objRow.cuit_empleador == null);
		System.assert(objRow.calle == null);
		System.assert(objRow.apenom == null);
		System.assert(objRow.nro == null);
		System.assert(objRow.ocupacion == null);
		System.assert(objRow.provincia == null);
		System.assert(objRow.edad == null);
		System.assert(objRow.cp == null);
		System.assert(objRow.fecha_nac == null);
		System.assert(objRow.doc == null);
		System.assert(objRow.pi == null);
		System.assert(objRow.localidad == null);
		System.assert(objRow.sexo == null);
		System.assert(objRow.cuit_empleado == null);
		System.assert(objRow.razon_social_empleador == null);
		System.assert(objRow.piso == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PEYPEDatosApi2Response.RESULTADO objRESULTADO = new PEYPEDatosApi2Response.RESULTADO(System.JSON.createParser(json));
		System.assert(objRESULTADO != null);
		System.assert(objRESULTADO.Existencia_Fisica == null);
	}
}