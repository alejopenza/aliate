public class SCEndosoEfectivo {

	public class Method {
		public String Code {get;set;} 
		public String Description {get;set;} 

		public Method(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Method consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Method Method {get;set;} 

	public SCEndosoEfectivo(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Method') {
						Method = new Method(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoEfectivo consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static SCEndosoEfectivo parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoEfectivo(parser);
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