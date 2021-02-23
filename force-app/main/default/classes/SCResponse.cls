public class SCResponse {

	public SCResponse(){
		this.Vehiculos = new List<Vehiculos>();
	}

	public class Versiones {
		public Versiones(){

		}
		
		public String CA7Product {get;set;} 

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
	
	public String AccountNumber {get;set;} 
	public String StartDate {get;set;} 
	public String PostalCodeRiskLocation {get;set;} 
	public String PolicyTermCode {get;set;} 
	public Integer PaymentFees {get;set;} 
	public String CommercialAlternative {get;set;} 
	public String PaymentMethodCode {get;set;} 
	public String CurrencyCode {get;set;} 
	public List<Vehiculos> Vehiculos {get;set;} 
	public List<Versiones> Versiones {get;set;} 

	public SCResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'AccountNumber') {
						AccountNumber = parser.getText();
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
						System.debug(LoggingLevel.WARN, 'SCResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Vehiculos {
		public Vehiculos(){

		}

		public String CodigoInfoAuto {get;set;} 
		public Integer Year {get;set;} 
		public Boolean Is0Km {get;set;} 
		public Integer StatedAmount {get;set;} 
		public String Usage {get;set;} 
		public String AutomaticAdjust {get;set;} 
		public String Category {get;set;} 
		public Integer AccesoryAmount {get;set;} 

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
	
	
	public static SCResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCResponse(parser);
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