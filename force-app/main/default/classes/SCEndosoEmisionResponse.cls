public class SCEndosoEmisionResponse {

	public class Messages {
		public String NombreServicio {get;set;} 
		public String VersionServicio {get;set;} 
		public String Description {get;set;} 
		public String MessageBeautiful {get;set;} 
		public String StackTrace {get;set;} 
		public Integer ErrorLevel {get;set;} 

		public Messages(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'NombreServicio') {
							NombreServicio = parser.getText();
						} else if (text == 'VersionServicio') {
							VersionServicio = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'MessageBeautiful') {
							MessageBeautiful = parser.getText();
						} else if (text == 'StackTrace') {
							StackTrace = parser.getText();
						} else if (text == 'ErrorLevel') {
							ErrorLevel = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Messages consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Object Response {get;set;} 
	public Boolean HasError {get;set;} 
	public Boolean HasWarning {get;set;} 
	public Boolean HasInformation {get;set;} 
	public List<Messages> Messages {get;set;} 

	public SCEndosoEmisionResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Response') {
						Response = parser.readValueAs(Object.class);
					} else if (text == 'HasError') {
						HasError = parser.getBooleanValue();
					} else if (text == 'HasWarning') {
						HasWarning = parser.getBooleanValue();
					} else if (text == 'HasInformation') {
						HasInformation = parser.getBooleanValue();
					} else if (text == 'Messages') {
						Messages = arrayOfMessages(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoEmisionResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static SCEndosoEmisionResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoEmisionResponse(parser);
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
	
    private static List<Messages> arrayOfMessages(System.JSONParser p) {
        List<Messages> res = new List<Messages>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Messages(p));
        }
        return res;
    }

}