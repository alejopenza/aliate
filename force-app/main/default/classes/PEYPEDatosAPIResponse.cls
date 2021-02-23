public class PEYPEDatosAPIResponse {

	public class Row_Z {
		public Double estitot {get;set;} 
		public Long cuit {get;set;} 
		public Integer cantemp {get;set;} 

		public Row_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'estitot') {
							estitot = parser.getDoubleValue();
						} else if (text == 'cuit') {
							cuit = parser.getLongValue();
						} else if (text == 'cantemp') {
							cantemp = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public RESULTADO RESULTADO {get;set;} 

	public PEYPEDatosAPIResponse(JSONParser parser) {
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
	
	public class Existencia {
		public Row row {get;set;} 

		public Existencia(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Existencia consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row {
		public Long cuit {get;set;} 
		public Integer altura {get;set;} 
		public String direccion {get;set;} 
		public String localidad {get;set;} 
		public String provincia {get;set;} 
		public Integer cp {get;set;} 
		public String razon {get;set;} 

		public Row(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cuit') {
							cuit = parser.getLongValue();
						} else if (text == 'altura') {
							altura = parser.getIntegerValue();
						} else if (text == 'direccion') {
							direccion = parser.getText();
						} else if (text == 'localidad') {
							localidad = parser.getText();
						} else if (text == 'provincia') {
							provincia = parser.getText();
						} else if (text == 'cp') {
							cp = parser.getIntegerValue();
						} else if (text == 'razon') {
							razon = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Validacion {
		public Row_Z row {get;set;} 

		public Validacion(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Validacion consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RESULTADO {
		public Existencia Existencia {get;set;} 
		public Validacion Validacion {get;set;} 

		public RESULTADO(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Existencia') {
							Existencia = new Existencia(parser);
						} else if (text == 'Validacion') {
							Validacion = new Validacion(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RESULTADO consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static PEYPEDatosAPIResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PEYPEDatosAPIResponse(parser);
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

}