public class PEYPEDatosAPI2Response {
    
	public RESULTADO RESULTADO {get;set;} 

	public PEYPEDatosAPI2Response(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'RESULTADO') {
						RESULTADO = new RESULTADO(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Existencia_Fisica {
		public List<Row> row {get;set;} 

		public Existencia_Fisica(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = arrayOfRow(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Existencia_Fisica consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row {
		public Long cuit_empleador {get;set;} 
		public String calle {get;set;} 
		public String apenom {get;set;} 
		public Integer nro {get;set;} 
		public String ocupacion {get;set;} 
		public String provincia {get;set;} 
		public Integer edad {get;set;} 
		public Integer cp {get;set;} 
		public String fecha_nac {get;set;} 
		public Integer doc {get;set;} 
		public String pi {get;set;} 
		public String localidad {get;set;} 
		public String sexo {get;set;} 
		public Long cuit_empleado {get;set;} 
		public String razon_social_empleador {get;set;} 
		public Integer piso {get;set;} 

		public Row(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cuit_empleador') {
							cuit_empleador = parser.getLongValue();
						} else if (text == 'calle') {
							calle = parser.getText();
						} else if (text == 'apenom') {
							apenom = parser.getText();
						} else if (text == 'nro') {
							nro = parser.getIntegerValue();
						} else if (text == 'ocupacion') {
							ocupacion = parser.getText();
						} else if (text == 'provincia') {
							provincia = parser.getText();
						} else if (text == 'edad') {
							edad = parser.getIntegerValue();
						} else if (text == 'cp') {
							cp = parser.getIntegerValue();
						} else if (text == 'fecha_nac') {
							fecha_nac = parser.getText();
						} else if (text == 'doc') {
							doc = parser.getIntegerValue();
						} else if (text == 'pi') {
							pi = parser.getText();
						} else if (text == 'localidad') {
							localidad = parser.getText();
						} else if (text == 'sexo') {
							sexo = parser.getText();
						} else if (text == 'cuit_empleado') {
							cuit_empleado = parser.getLongValue();
						} else if (text == 'razon_social_empleador') {
							razon_social_empleador = parser.getText();
						} else if (text == 'piso') {
							piso = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Row consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RESULTADO {
		public Existencia_Fisica Existencia_Fisica {get;set;} 

		public RESULTADO(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Existencia_Fisica') {
							Existencia_Fisica = new Existencia_Fisica(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RESULTADO consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static PEYPEDatosAPI2Response parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PEYPEDatosAPI2Response(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

    private static List<Row> arrayOfRow(System.JSONParser p) {
        List<Row> res = new List<Row>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Row(p));
        }
        return res;
    }
}