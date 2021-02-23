@isTest
global with sharing class PEYPEDatosAPI2Mock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
		res.SetBody('{"RESULTADO": {"Existencia_Fisica": {"row": [    {        "cuit_empleador": 30694303451,        "calle": "FCOBURGES",        "apenom": "ARTEAGA ORLANDO",        "nro": 441,        "ocupacion": "RELACION_DEPENDENCIA",        "provincia": "CORDOBA",        "edad": 33,        "cp": 5000,        "fecha_nac": "19/02/1987",        "doc": 32629657,        "pi": "R15",        "localidad": "CORDOBA CAPITAL",        "sexo": "M",        "cuit_empleado": 24326296577,        "razon_social_empleador": "BDP SA"    },    {        "cuit_empleador": 30694303451,        "calle": "RIO PRIMERO",        "apenom": "AGUILAR MARIA DEL CARMEN",        "nro": 665,        "ocupacion": "RELACION_DEPENDENCIA",        "provincia": "CORDOBA",        "edad": 48,        "cp": 5000,        "fecha_nac": "20/03/1972",        "doc": 22566352,        "pi": "R11",        "localidad": "CORDOBA",        "sexo": "F",        "cuit_empleado": 27225663527,        "razon_social_empleador": "BDP SA"    },    {        "piso": 1,        "cuit_empleador": 30694303451,        "calle": "ROLAND ROSS",        "apenom": "FRONTERA VACA MARIA ROCIO",        "nro": 7856,        "ocupacion": "RELACION_DEPENDENCIA",        "provincia": "CORDOBA",        "edad": 43,        "cp": 5000,        "fecha_nac": "02/02/1977",        "doc": 25755477,        "pi": "R15",        "localidad": "CORDOBA",        "sexo": "F",        "cuit_empleado": 27257554770,        "razon_social_empleador": "BDP SA"    },    {        "cuit_empleador": 30694303451,        "calle": "PEDRO CHECHI",        "apenom": "GOMEZ FRANCO MARIA LUCRECIA",        "nro": 5925,        "ocupacion": "RELACION_DEPENDENCIA",        "provincia": "CORDOBA",        "edad": 30,        "cp": 5000,        "fecha_nac": "09/07/1990",        "doc": 35062711,        "pi": "R14",        "localidad": "CORDOBA",        "sexo": "F",        "cuit_empleado": 27350627117,        "razon_social_empleador": "BDP SA"    },    {        "cuit_empleador": 30694303451,        "calle": "PELLEGRINI",        "apenom": "SOLANS MARIA INES",        "nro": 488,        "ocupacion": "MONOTRIBUTO  RELACION_DEPENDENCIA",        "provincia": "CORDOBA",        "edad": 28,        "cp": 5152,        "fecha_nac": "16/05/1992",        "doc": 36120869,        "pi": "R16",        "localidad": "VILLA CARLOS PA",        "sexo": "F",        "cuit_empleado": 27361208698,        "razon_social_empleador": "BDP SA"    },    {        "cuit_empleador": 30694303451,        "calle": "ALMIRANTE BROWN",        "apenom": "GONZALEZ GUADALUPE LUZ",        "nro": 1766,        "ocupacion": "RELACION_DEPENDENCIA",        "provincia": "CORDOBA",        "edad": 29,        "cp": 0,        "fecha_nac": "02/08/1991",        "doc": 36447855,        "pi": "R13",        "localidad": "RIO TERCERO",        "sexo": "F",        "cuit_empleado": 27364478556,        "razon_social_empleador": "BDP SA"    }]}}}');
        res.setStatusCode(200);
        return res;
    }
}