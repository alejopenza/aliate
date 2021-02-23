public class SCEndosoUpdateVehicleReq {

	public String PolicyNumber {get;set;} 
	public String VehicleNumber {get;set;} 
	public String LicensePlate {get;set;} 
	public String VIN {get;set;} 
	public String EngineNumber {get;set;} 

	public SCEndosoUpdateVehicleReq(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'PolicyNumber') {
						PolicyNumber = parser.getText();
					} else if (text == 'VehicleNumber') {
						VehicleNumber = parser.getText();
					} else if (text == 'LicensePlate') {
						LicensePlate = parser.getText();
					} else if (text == 'VIN') {
						VIN = parser.getText();
					} else if (text == 'EngineNumber') {
						EngineNumber = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoUpdateVehicleReq consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static SCEndosoUpdateVehicleReq parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoUpdateVehicleReq(parser);
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