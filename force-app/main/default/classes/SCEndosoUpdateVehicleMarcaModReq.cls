public class SCEndosoUpdateVehicleMarcaModReq {

	public String PolicyNumber {get;set;} 
	public String CodInfoAuto {get;set;} 
	public String Anio {get;set;} 
	public String EffectiveDate {get;set;} 

	public SCEndosoUpdateVehicleMarcaModReq(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'PolicyNumber') {
						PolicyNumber = parser.getText();
					} else if (text == 'CodInfoAuto') {
						CodInfoAuto = parser.getText();
					} else if (text == 'Anio') {
						Anio = parser.getText();
					} else if (text == 'EffectiveDate') {
						EffectiveDate = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoUpdateVehicleMarcaModReq consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static SCEndosoUpdateVehicleMarcaModReq parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoUpdateVehicleMarcaModReq(parser);
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