public with sharing class PEYPEDatosAPIResponseCUIT {

	public class Row_Z {
		public String cuit {get;set;} 
		public String estitot {get;set;} 
		public String cantemp {get;set;} 

		public Row_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cuit') {
							cuit = parser.getText();
						} else if (text == 'estitot') {
							estitot = parser.getText();
						} else if (text == 'cantemp') {
							cantemp = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_Y {
		public String cuit {get;set;} 
		public String razon {get;set;} 
		public String direccion {get;set;} 
		public String altura {get;set;} 
		public String localidad {get;set;} 
		public String cp {get;set;} 
		public String provincia {get;set;} 

		public Row_Y(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cuit') {
							cuit = parser.getText();
						} else if (text == 'razon') {
							razon = parser.getText();
						} else if (text == 'direccion') {
							direccion = parser.getText();
						} else if (text == 'altura') {
							altura = parser.getText();
						} else if (text == 'localidad') {
							localidad = parser.getText();
						} else if (text == 'cp') {
							cp = parser.getText();
						} else if (text == 'provincia') {
							provincia = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_Y consuming unrecognized property: '+text);
							consumeObject(parser);
						}
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
							System.debug(LoggingLevel.WARN, 'Existencia_Fisica_ consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Existencia {
		public Row_Y row {get;set;} 

		public Existencia(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_Y(parser);
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
		public String cuit {get;set;} 
		public String apenom {get;set;} 
		public String doc {get;set;} 
		public String fecha_nac {get;set;} 
		public String edad {get;set;} 
		public String sexo {get;set;} 
		public String calle {get;set;} 
		public String nro {get;set;} 
		public String cp {get;set;} 
		public String localidad {get;set;} 
		public String provincia {get;set;} 
		public String pi {get;set;} 
		public String cuit_empleador {get;set;} 
		public String razon_social_empleador {get;set;} 
		public String piso {get;set;} 

		public Row(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cuit') {
							cuit = parser.getText();
						} else if (text == 'apenom') {
							apenom = parser.getText();
						} else if (text == 'doc') {
							doc = parser.getText();
						} else if (text == 'fecha_nac') {
							fecha_nac = parser.getText();
						} else if (text == 'edad') {
							edad = parser.getText();
						} else if (text == 'sexo') {
							sexo = parser.getText();
						} else if (text == 'calle') {
							calle = parser.getText();
						} else if (text == 'nro') {
							nro = parser.getText();
						} else if (text == 'cp') {
							cp = parser.getText();
						} else if (text == 'localidad') {
							localidad = parser.getText();
						} else if (text == 'provincia') {
							provincia = parser.getText();
						} else if (text == 'pi') {
							pi = parser.getText();
						} else if (text == 'cuit_empleador') {
							cuit_empleador = parser.getText();
						} else if (text == 'razon_social_empleador') {
							razon_social_empleador = parser.getText();
						} else if (text == 'piso') {
							piso = parser.getText();
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
		public Validacion Validacion {get;set;} 
		public Existencia Existencia {get;set;} 

		public RESULTADO(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Existencia_Fisica_') {
							Existencia_Fisica = new Existencia_Fisica(parser);
						} else if (text == 'Validacion') {
							Validacion = new Validacion(parser);
						} else if (text == 'Validacion') {
							Validacion = new Validacion(parser);
						} else if (text == 'Existencia') {
							Existencia = new Existencia(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RESULTADO consuming unrecognized property: '+text);
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
							System.debug(LoggingLevel.WARN, 'Validacion_ consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public RESULTADO RESULTADO {get;set;} 

	public PEYPEDatosAPIResponseCUIT(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'RESULTADO') {
						RESULTADO = new RESULTADO(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'PEYPEDatosAPIResponseCUIT consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static PEYPEDatosAPIResponseCUIT parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PEYPEDatosAPIResponseCUIT(parser);
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