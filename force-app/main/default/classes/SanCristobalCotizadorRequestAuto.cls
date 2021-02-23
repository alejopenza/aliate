public class SanCristobalCotizadorRequestAuto {

	public SanCristobalCotizadorRequestAuto(){
		this.Vehiculos = new List<Vehiculos>();
		this.Versiones = new List<Versiones>();
	}

	public class Account {
		public Object AccountNumber {get;set;} 
		public AccountHolderContact AccountHolderContact {get;set;} 
		public String OriginationDate {get;set;} 
		public Boolean OriginationDateSpecified {get;set;} 
		public PrimaryAddress PrimaryLocation {get;set;} 
		public String ProducerCode {get;set;} 

		public Account(){}

		public Account(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AccountNumber') {
							AccountNumber = parser.readValueAs(Object.class);
						} else if (text == 'AccountHolderContact') {
							AccountHolderContact = new AccountHolderContact(parser);
						} else if (text == 'OriginationDate') {
							OriginationDate = parser.getText();
						} else if (text == 'OriginationDateSpecified') {
							OriginationDateSpecified = parser.getBooleanValue();
						} else if (text == 'PrimaryLocation') {
							PrimaryLocation = new PrimaryAddress(parser);
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
		public Integer PostalCode {get;set;} 
		public String State {get;set;} 

		public PrimaryAddress() {}

		public PrimaryAddress(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PostalCode') {
							PostalCode = parser.getIntegerValue();
						} else if (text == 'State') {
							State = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PrimaryAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Versiones {
		public String CA7Product {get;set;} 

		public Versiones() {}

		public Versiones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CA7Product') {
							CA7Product = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Versiones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Account Account {get;set;} 
	public String StartDate {get;set;} 
	public String PostalCodeRiskLocation {get;set;} 
	public String PolicyTermCode {get;set;} 
	public Integer PaymentFees {get;set;} 
	public String CommercialAlternative {get;set;} 
	public String PaymentMethodCode {get;set;} 
	public String CurrencyCode {get;set;} 
	public List<Vehiculos> Vehiculos {get;set;} 
	public List<Versiones> Versiones {get;set;} 

	public SanCristobalCotizadorRequestAuto(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Account') {
						Account = new Account(parser);
					} else if (text == 'StartDate') {
						StartDate = parser.getText();
					} else if (text == 'PostalCodeRiskLocation') {
						PostalCodeRiskLocation = parser.getText();
					} else if (text == 'PolicyTermCode') {
						PolicyTermCode = parser.getText();
					} else if (text == 'PaymentFees') {
						PaymentFees = parser.getIntegerValue();
					} else if (text == 'CommercialAlternative') {
						CommercialAlternative = parser.getText();
					} else if (text == 'PaymentMethodCode') {
						PaymentMethodCode = parser.getText();
					} else if (text == 'CurrencyCode') {
						CurrencyCode = parser.getText();
					} else if (text == 'Vehiculos') {
						Vehiculos = arrayOfVehiculos(parser);
					} else if (text == 'Versiones') {
						Versiones = arrayOfVersiones(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SanCristobalCotizadorRequestAuto consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class AccountHolderContact {
		public EntityPerson EntityPerson {get;set;} 
		public String OfficialIDType {get;set;} 
		public PrimaryAddress PrimaryAddress {get;set;} 
		public String Subtype {get;set;} 
		public String TaxID {get;set;} 
		public EntityCompany EntityCompany {get;set;} 

		public AccountHolderContact() {}

		public AccountHolderContact(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'EntityPerson') {
							EntityPerson = new EntityPerson(parser);
						} else if (text == 'OfficialIDType') {
							OfficialIDType = parser.getText();
						} else if (text == 'PrimaryAddress') {
							PrimaryAddress = new PrimaryAddress(parser);
						} else if (text == 'Subtype') {
							Subtype = parser.getText();
						} else if (text == 'TaxID') {
							TaxID = parser.getText();
						} else if (text == 'EntityCompany') {
							EntityCompany = new EntityCompany(parser);
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
		public String FirstName {get;set;} 
		public String Gender {get;set;} 
		public String LastName {get;set;} 
		public String DateOfBirth {get;set;} 
		public Boolean DateOfBirthSpecified {get;set;} 

		public EntityPerson() {}

		public EntityPerson(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'FirstName') {
							FirstName = parser.getText();
						} else if (text == 'Gender') {
							Gender = parser.getText();
						} else if (text == 'LastName') {
							LastName = parser.getText();
						} else if (text == 'DateOfBirth') {
							DateOfBirth = parser.getText();
						} else if (text == 'DateOfBirthSpecified') {
							DateOfBirthSpecified = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'EntityPerson consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EntityCompany {
		public String Ext_ActivityStartDate {get;set;} 
		public Boolean Ext_ActivityStartDateSpecified {get;set;} 

		public EntityCompany() {}

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
	
	public class Vehiculos {
		public String CodigoInfoAuto {get;set;} 
		public Integer Year {get;set;} 
		public Boolean Is0Km {get;set;} 
		public Integer StatedAmount {get;set;} 
		public String Usage {get;set;} 
		public String AutomaticAdjust {get;set;} 
		public String Category {get;set;} 
		public Integer AccesoryAmount {get;set;} 

		public Vehiculos() {}

		public Vehiculos(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CodigoInfoAuto') {
							CodigoInfoAuto = parser.getText();
						} else if (text == 'Year') {
							Year = parser.getIntegerValue();
						} else if (text == 'Is0Km') {
							Is0Km = parser.getBooleanValue();
						} else if (text == 'StatedAmount') {
							StatedAmount = parser.getIntegerValue();
						} else if (text == 'Usage') {
							Usage = parser.getText();
						} else if (text == 'AutomaticAdjust') {
							AutomaticAdjust = parser.getText();
						} else if (text == 'Category') {
							Category = parser.getText();
						} else if (text == 'AccesoryAmount') {
							AccesoryAmount = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Vehiculos consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SanCristobalCotizadorRequestAuto parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SanCristobalCotizadorRequestAuto(parser);
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
	

    private static List<Versiones> arrayOfVersiones(System.JSONParser p) {
        List<Versiones> res = new List<Versiones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Versiones(p));
        }
        return res;
    }

    private static List<Vehiculos> arrayOfVehiculos(System.JSONParser p) {
        List<Vehiculos> res = new List<Vehiculos>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Vehiculos(p));
        }
        return res;
    }

}