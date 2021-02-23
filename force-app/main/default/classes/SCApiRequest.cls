public with sharing class SCApiRequest {

	public SCApiRequest(){}
	
	public class TypeOfContracting {
		public TypeOfContracting(){}
		public String Code {get;set;} 

		public TypeOfContracting(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TypeOfContracting consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String ProducerCode {get;set;} 
	public String StartDate {get;set;} 
	public Integer Age {get;set;} 
	public Integer PostalCodeRiskLocation {get;set;} 
	public String StateRiskLocation {get;set;} 
	public String PolicyTermCode {get;set;} 
	public String PaymentFees {get;set;} 
	public Integer CommercialAlternative {get;set;} 
	public String PaymentMethodCode {get;set;} 
	public Vehiculo Vehiculo {get;set;} 
	public List<Versiones> Versiones {get;set;} 
	public TypeOfContracting TypeOfContracting {get;set;} 
	public Boolean Nuevo {get;set;} 
	public String OfficialIDType {get;set;} 
	public String TaxID {get;set;} 
	public String Gender {get;set;} 

	public SCApiRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'ProducerCode') {
						ProducerCode = parser.getText();
					} else if (text == 'StartDate') {
						StartDate = parser.getText();
					} else if (text == 'Age') {
						Age = parser.getIntegerValue();
					} else if (text == 'PostalCodeRiskLocation') {
						PostalCodeRiskLocation = parser.getIntegerValue();
					} else if (text == 'StateRiskLocation') {
						StateRiskLocation = parser.getText();
					} else if (text == 'PolicyTermCode') {
						PolicyTermCode = parser.getText();
					} else if (text == 'PaymentFees') {
						PaymentFees = parser.getText();
					} else if (text == 'CommercialAlternative') {
						CommercialAlternative = parser.getIntegerValue();
					} else if (text == 'PaymentMethodCode') {
						PaymentMethodCode = parser.getText();
					} else if (text == 'Vehiculo') {
						Vehiculo = new Vehiculo(parser);
					} else if (text == 'Versiones') {
						Versiones = arrayOfVersiones(parser);
					} else if (text == 'TypeOfContracting') {
						TypeOfContracting = new TypeOfContracting(parser);
					} else if (text == 'Nuevo') {
						Nuevo = parser.getBooleanValue();
					} else if (text == 'OfficialIDType') {
						OfficialIDType = parser.getText();
					} else if (text == 'TaxID') {
						TaxID = parser.getText();
					} else if (text == 'Gender') {
						Gender = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Versiones {
		public Versiones(){}
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
	
	public class Vehiculo {
		public Vehiculo(){}
		public String CodigoInfoAuto {get;set;} 
		public Integer Year {get;set;} 
		public Integer StatedAmount {get;set;} 
		public String Usage {get;set;} 
		public String AutomaticAdjust {get;set;} 
		public Integer AccesoryAmount {get;set;} 
		public Boolean HasGPS {get;set;} 
		public String Category {get;set;} 
		public String FuelType {get;set;} 
		public String Origen {get;set;} 

		public Vehiculo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CodigoInfoAuto') {
							CodigoInfoAuto = parser.getText();
						} else if (text == 'Year') {
							Year = parser.getIntegerValue();
						} else if (text == 'StatedAmount') {
							StatedAmount = parser.getIntegerValue();
						} else if (text == 'Usage') {
							Usage = parser.getText();
						} else if (text == 'AutomaticAdjust') {
							AutomaticAdjust = parser.getText();
						} else if (text == 'AccesoryAmount') {
							AccesoryAmount = parser.getIntegerValue();
						} else if (text == 'HasGPS') {
							HasGPS = parser.getBooleanValue();
						} else if (text == 'Category') {
							Category = parser.getText();
						} else if (text == 'FuelType') {
							FuelType = parser.getText();
						} else if (text == 'Origen') {
							Origen = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Vehiculo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SCApiRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCApiRequest(parser);
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
}