public class SCEndosoCredito {

	public String CreditCardNumber {get;set;} 
	public PaymentEntity PaymentEntity {get;set;} 
	public PaymentEntity Method {get;set;} 

	public SCEndosoCredito(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'CreditCardNumber') {
						CreditCardNumber = parser.getText();
					} else if (text == 'PaymentEntity') {
						PaymentEntity = new PaymentEntity(parser);
					} else if (text == 'Method') {
						Method = new PaymentEntity(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoCredito consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class PaymentEntity {
		public String Code {get;set;} 
		public String Description {get;set;} 

		public PaymentEntity(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PaymentEntity consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SCEndosoCredito parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoCredito(parser);
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