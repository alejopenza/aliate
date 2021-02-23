public class SCAccidentesPersonalesRequest {

	public class Account {
		public AccountHolderContact AccountHolderContact {get;set;} 
		public String OriginationDate {get;set;} 
		public Boolean OriginationDateSpecified {get;set;} 
		public PrimaryLocation PrimaryLocation {get;set;} 
		public String ProducerCode {get;set;} 

		public Account(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AccountHolderContact') {
							AccountHolderContact = new AccountHolderContact(parser);
						} else if (text == 'OriginationDate') {
							OriginationDate = parser.getText();
						} else if (text == 'OriginationDateSpecified') {
							OriginationDateSpecified = parser.getBooleanValue();
						} else if (text == 'PrimaryLocation') {
							PrimaryLocation = new PrimaryLocation(parser);
						} else if (text == 'ProducerCode') {
							ProducerCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Account consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PrimaryAddress {
		public String PostalCode {get;set;} 
		public String State {get;set;} 
		public String City {get;set;} 

		public PrimaryAddress(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'State') {
							State = parser.getText();
						} else if (text == 'City') {
							City = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PrimaryAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PrimaryLocation {
		public String PostalCode {get;set;} 
		public String State {get;set;} 

		public PrimaryLocation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'State') {
							State = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PrimaryLocation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class AccountHolderContact {
		public EntityCompany EntityCompany {get;set;} 
		public EntityPerson EntityPerson {get;set;} 
		public String OfficialIDType {get;set;} 
		public PrimaryAddress PrimaryAddress {get;set;} 
		public String Subtype {get;set;} 
		public String TaxID {get;set;} 

		public AccountHolderContact(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'EntityCompany') {
							EntityCompany = new EntityCompany(parser);
						} else if (text == 'EntityPerson') {
							EntityPerson = new EntityPerson(parser);
						} else if (text == 'OfficialIDType') {
							OfficialIDType = parser.getText();
						} else if (text == 'PrimaryAddress') {
							PrimaryAddress = new PrimaryAddress(parser);
						} else if (text == 'Subtype') {
							Subtype = parser.getText();
						} else if (text == 'TaxID') {
							TaxID = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AccountHolderContact consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EntityPerson {
		public String DateOfBirth {get;set;} 
		public Boolean DateOfBirthSpecified {get;set;} 
		public Boolean EntityPerson {get;set;} 
		public String FirstName {get;set;} 
		public String Gender {get;set;} 
		public String LastName {get;set;} 

		public EntityPerson(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'DateOfBirth') {
							DateOfBirth = parser.getText();
						} else if (text == 'DateOfBirthSpecified') {
							DateOfBirthSpecified = parser.getBooleanValue();
						} else if (text == 'EntityPerson') {
							EntityPerson = parser.getBooleanValue();
						} else if (text == 'FirstName') {
							FirstName = parser.getText();
						} else if (text == 'Gender') {
							Gender = parser.getText();
						} else if (text == 'LastName') {
							LastName = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EntityPerson consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Account Account {get;set;} 
	public String StartDate {get;set;} 
	public String PolicyTermCode {get;set;} 
	public Integer PaymentFees {get;set;} 
	public String PaymentMethodCode {get;set;} 
	public String CurrencyCode {get;set;} 
	public String Paquete {get;set;} 
	public String OfferingCode {get;set;} 
	public String ScopeCoverageCode {get;set;} 
	public String OfferingPlanCode {get;set;} 
	public String OccupationCode {get;set;} 

	public SCAccidentesPersonalesRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Account') {
						Account = new Account(parser);
					} else if (text == 'StartDate') {
						StartDate = parser.getText();
					} else if (text == 'PolicyTermCode') {
						PolicyTermCode = parser.getText();
					} else if (text == 'PaymentFees') {
						PaymentFees = parser.getIntegerValue();
					} else if (text == 'PaymentMethodCode') {
						PaymentMethodCode = parser.getText();
					} else if (text == 'CurrencyCode') {
						CurrencyCode = parser.getText();
					} else if (text == 'Paquete') {
						Paquete = parser.getText();
					} else if (text == 'OfferingCode') {
						OfferingCode = parser.getText();
					} else if (text == 'ScopeCoverageCode') {
						ScopeCoverageCode = parser.getText();
					} else if (text == 'OfferingPlanCode') {
						OfferingPlanCode = parser.getText();
					} else if (text == 'OccupationCode') {
						OccupationCode = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'SCAccidentesPersonalesRequest consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class EntityCompany {
		public String Ext_ActivityStartDate {get;set;} 
		public Boolean Ext_ActivityStartDateSpecified {get;set;} 

		public EntityCompany(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Ext_ActivityStartDate') {
							Ext_ActivityStartDate = parser.getText();
						} else if (text == 'Ext_ActivityStartDateSpecified') {
							Ext_ActivityStartDateSpecified = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'EntityCompany consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SCAccidentesPersonalesRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCAccidentesPersonalesRequest(parser);
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