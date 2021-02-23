public class SCSiniestroArchivosRequest {

	public class ClaimFiles {
		public String Name {get;set;} 
		public String Extension {get;set;} 
		public String Content {get;set;} 
		public String Usage {get;set;} 

		public ClaimFiles(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'Extension') {
							Extension = parser.getText();
						} else if (text == 'Content') {
							Content = parser.getText();
						} else if (text == 'Usage') {
							Usage = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ClaimFiles consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String ClaimNumber {get;set;} 
	public List<ClaimFiles> ClaimFiles {get;set;} 

	public SCSiniestroArchivosRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'ClaimNumber') {
						ClaimNumber = parser.getText();
					} else if (text == 'ClaimFiles') {
						ClaimFiles = arrayOfClaimFiles(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCSiniestroArchivosRequest consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static SCSiniestroArchivosRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCSiniestroArchivosRequest(parser);
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

    private static List<ClaimFiles> arrayOfClaimFiles(System.JSONParser p) {
        List<ClaimFiles> res = new List<ClaimFiles>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ClaimFiles(p));
        }
        return res;
    }
}