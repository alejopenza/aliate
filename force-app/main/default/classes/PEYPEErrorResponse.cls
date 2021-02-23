public class PEYPEErrorResponse {

	public RESULTADO RESULTADO {get;set;} 

	public PEYPEErrorResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'RESULTADO') {
						RESULTADO = new RESULTADO(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'PEYPEErrorResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class ERROR {
		public String descripcion_error {get;set;} 
		public Integer codigo_error {get;set;} 

		public ERROR(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'descripcion_error') {
							descripcion_error = parser.getText();
						} else if (text == 'codigo_error') {
							codigo_error = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'ERROR consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RESULTADO {
		public ERROR ERROR {get;set;} 

		public RESULTADO(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ERROR') {
							ERROR = new ERROR(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RESULTADO consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static PEYPEErrorResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PEYPEErrorResponse(parser);
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