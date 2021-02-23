public class SCEndosoEmisionReq {

	public String jobNumber {get;set;} 
	public String BranchNumber {get;set;} 
	public Boolean warningsThrowException {get;set;} 

	public SCEndosoEmisionReq(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'jobNumber') {
						jobNumber = parser.getText();
					} else if (text == 'BranchNumber') {
						BranchNumber = parser.getText();
					} else if (text == 'warningsThrowException') {
						warningsThrowException = parser.getBooleanValue();
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoEmisionReq consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static SCEndosoEmisionReq parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoEmisionReq(parser);
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