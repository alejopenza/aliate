//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class SCSetAsDraftResponse {

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
	
	public Boolean HasError {get;set;} 
	public Boolean HasWarning {get;set;} 
	public Boolean HasInformation {get;set;} 
	public List<Messages> Messages {get;set;} 

	public SCSetAsDraftResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'HasError') {
						HasError = parser.getBooleanValue();
					} else if (text == 'HasWarning') {
						HasWarning = parser.getBooleanValue();
					} else if (text == 'HasInformation') {
						HasInformation = parser.getBooleanValue();
					} else if (text == 'Messages') {
						Messages = arrayOfMessages(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCSetAsDraftResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static SCSetAsDraftResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCSetAsDraftResponse(parser);
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