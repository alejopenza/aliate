public class SCAccidentesPersonalesEmisionReq {

	public String PolicyPeriodId {get;set;} 
	public Object CBU {get;set;} 
	public Object CreditCardNumber {get;set;} 
	public PaymentEntity PaymentEntity {get;set;} 
	public Address Address {get;set;} 

	public SCAccidentesPersonalesEmisionReq(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'PolicyPeriodId') {
						PolicyPeriodId = parser.getText();
					} else if (text == 'CBU') {
						CBU = parser.readValueAs(Object.class);
					} else if (text == 'CreditCardNumber') {
						CreditCardNumber = parser.readValueAs(Object.class);
					} else if (text == 'PaymentEntity') {
						PaymentEntity = new PaymentEntity(parser);
					} else if (text == 'Address') {
						Address = new Address(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCAccidentesPersonalesEmisionReq consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Address {
		public String policyPeriodID {get;set;} 
		public Boolean updateLinkedAddresses {get;set;} 
		public String AddressLine1 {get;set;} 
		public String AddressLine2 {get;set;} 
		public String AddressLine3 {get;set;} 
		public AddressType AddressType {get;set;} 
		public Object Block {get;set;} 
		public String City {get;set;} 
		public AddressType Country {get;set;} 
		public String County {get;set;} 
		public Object Description {get;set;} 
		public String DisplayText {get;set;} 
		public Boolean PolicyAddress {get;set;} 
		public String PostalCode {get;set;} 
		public Boolean PrimaryAddress {get;set;} 
		public String PublicID {get;set;} 
		public AddressType State {get;set;} 
		public String StreetNumber {get;set;} 

		public Address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'policyPeriodID') {
							policyPeriodID = parser.getText();
						} else if (text == 'updateLinkedAddresses') {
							updateLinkedAddresses = parser.getBooleanValue();
						} else if (text == 'AddressLine1') {
							AddressLine1 = parser.getText();
						} else if (text == 'AddressLine2') {
							AddressLine2 = parser.getText();
						} else if (text == 'AddressLine3') {
							AddressLine3 = parser.getText();
						} else if (text == 'AddressType') {
							AddressType = new AddressType(parser);
						} else if (text == 'Block') {
							Block = parser.readValueAs(Object.class);
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'Country') {
							Country = new AddressType(parser);
						} else if (text == 'County') {
							County = parser.getText();
						} else if (text == 'Description') {
							Description = parser.readValueAs(Object.class);
						} else if (text == 'DisplayText') {
							DisplayText = parser.getText();
						} else if (text == 'PolicyAddress') {
							PolicyAddress = parser.getBooleanValue();
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'PrimaryAddress') {
							PrimaryAddress = parser.getBooleanValue();
						} else if (text == 'PublicID') {
							PublicID = parser.getText();
						} else if (text == 'State') {
							State = new AddressType(parser);
						} else if (text == 'StreetNumber') {
							StreetNumber = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class AddressType {
		public String Code {get;set;} 
		public String Description {get;set;} 

		public AddressType(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AddressType consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PaymentEntity {
		public Object Code {get;set;} 
		public Object Description {get;set;} 

		public PaymentEntity(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.readValueAs(Object.class);
						} else if (text == 'Description') {
							Description = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'PaymentEntity consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SCAccidentesPersonalesEmisionReq parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCAccidentesPersonalesEmisionReq(parser);
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