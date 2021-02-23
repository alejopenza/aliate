public class SCEndosoFormaPagoResponse {

	public class SummaryDetail {
		public Object AddressDescription {get;set;} 
		public Object AddressType {get;set;} 
		public Object ChangeInCost {get;set;} 
		public Object CommissionBroker {get;set;} 
		public Object CommissionOrg {get;set;} 
		public Object CommissionProd {get;set;} 
		public String EffectiveDate {get;set;} 
		public Object Error {get;set;} 
		public Object Insured {get;set;} 
		public Object JobNumberLabel {get;set;} 
		public Object JobRenewalNumber {get;set;} 
		public Object NetPremium {get;set;} 
		public Object OverrideCommissionBroker {get;set;} 
		public Object OverrideCommissionOrg {get;set;} 
		public Object OverrideCommissionProd {get;set;} 
		public String PaymentDate {get;set;} 
		public Integer PaymentFees {get;set;} 
		public Object PaymentMethod {get;set;} 
		public String PeriodEnd {get;set;} 
		public String PeriodStart {get;set;} 
		public Object PolicyPeriodId {get;set;} 
		public Object PolicyTerm {get;set;} 
		public Object Taxes {get;set;} 
		public Object TotalCommission {get;set;} 
		public Object TotalCommissionOrg {get;set;} 
		public Object TotalCost {get;set;} 
		public Object TotalPremium {get;set;} 
		public Object TransactionDescription {get;set;} 
		public Object UWCompany {get;set;} 
		public Object Validity {get;set;} 
		public Integer BranchNumber {get;set;} 
		public Object ProductOfferingCALine {get;set;} 
		public Object DeductibleType {get;set;} 
		public Object DirectDeductible {get;set;} 
		public Object DeductiblePercentage {get;set;} 
		public Object TelefonoFijo {get;set;} 
		public Object TelefonoCelular {get;set;} 
		public Object Email {get;set;} 
		public Object DireccionPapeleria {get;set;} 
		public Object InstallmentPlan {get;set;} 

		public SummaryDetail(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AddressDescription') {
							AddressDescription = parser.readValueAs(Object.class);
						} else if (text == 'AddressType') {
							AddressType = parser.readValueAs(Object.class);
						} else if (text == 'ChangeInCost') {
							ChangeInCost = parser.readValueAs(Object.class);
						} else if (text == 'CommissionBroker') {
							CommissionBroker = parser.readValueAs(Object.class);
						} else if (text == 'CommissionOrg') {
							CommissionOrg = parser.readValueAs(Object.class);
						} else if (text == 'CommissionProd') {
							CommissionProd = parser.readValueAs(Object.class);
						} else if (text == 'EffectiveDate') {
							EffectiveDate = parser.getText();
						} else if (text == 'Error') {
							Error = parser.readValueAs(Object.class);
						} else if (text == 'Insured') {
							Insured = parser.readValueAs(Object.class);
						} else if (text == 'JobNumberLabel') {
							JobNumberLabel = parser.readValueAs(Object.class);
						} else if (text == 'JobRenewalNumber') {
							JobRenewalNumber = parser.readValueAs(Object.class);
						} else if (text == 'NetPremium') {
							NetPremium = parser.readValueAs(Object.class);
						} else if (text == 'OverrideCommissionBroker') {
							OverrideCommissionBroker = parser.readValueAs(Object.class);
						} else if (text == 'OverrideCommissionOrg') {
							OverrideCommissionOrg = parser.readValueAs(Object.class);
						} else if (text == 'OverrideCommissionProd') {
							OverrideCommissionProd = parser.readValueAs(Object.class);
						} else if (text == 'PaymentDate') {
							PaymentDate = parser.getText();
						} else if (text == 'PaymentFees') {
							PaymentFees = parser.getIntegerValue();
						} else if (text == 'PaymentMethod') {
							PaymentMethod = parser.readValueAs(Object.class);
						} else if (text == 'PeriodEnd') {
							PeriodEnd = parser.getText();
						} else if (text == 'PeriodStart') {
							PeriodStart = parser.getText();
						} else if (text == 'PolicyPeriodId') {
							PolicyPeriodId = parser.readValueAs(Object.class);
						} else if (text == 'PolicyTerm') {
							PolicyTerm = parser.readValueAs(Object.class);
						} else if (text == 'Taxes') {
							Taxes = parser.readValueAs(Object.class);
						} else if (text == 'TotalCommission') {
							TotalCommission = parser.readValueAs(Object.class);
						} else if (text == 'TotalCommissionOrg') {
							TotalCommissionOrg = parser.readValueAs(Object.class);
						} else if (text == 'TotalCost') {
							TotalCost = parser.readValueAs(Object.class);
						} else if (text == 'TotalPremium') {
							TotalPremium = parser.readValueAs(Object.class);
						} else if (text == 'TransactionDescription') {
							TransactionDescription = parser.readValueAs(Object.class);
						} else if (text == 'UWCompany') {
							UWCompany = parser.readValueAs(Object.class);
						} else if (text == 'Validity') {
							Validity = parser.readValueAs(Object.class);
						} else if (text == 'BranchNumber') {
							BranchNumber = parser.getIntegerValue();
						} else if (text == 'ProductOfferingCALine') {
							ProductOfferingCALine = parser.readValueAs(Object.class);
						} else if (text == 'DeductibleType') {
							DeductibleType = parser.readValueAs(Object.class);
						} else if (text == 'DirectDeductible') {
							DirectDeductible = parser.readValueAs(Object.class);
						} else if (text == 'DeductiblePercentage') {
							DeductiblePercentage = parser.readValueAs(Object.class);
						} else if (text == 'TelefonoFijo') {
							TelefonoFijo = parser.readValueAs(Object.class);
						} else if (text == 'TelefonoCelular') {
							TelefonoCelular = parser.readValueAs(Object.class);
						} else if (text == 'Email') {
							Email = parser.readValueAs(Object.class);
						} else if (text == 'DireccionPapeleria') {
							DireccionPapeleria = parser.readValueAs(Object.class);
						} else if (text == 'InstallmentPlan') {
							InstallmentPlan = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'SummaryDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Messages {
		public String NombreServicio {get;set;} 
		public String VersionServicio {get;set;} 
		public String Description {get;set;} 
		public String MessageBeautiful {get;set;} 
		public Object StackTrace {get;set;} 
		public Integer ErrorLevel {get;set;} 

		public Messages(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'NombreServicio') {
							NombreServicio = parser.getText();
						} else if (text == 'VersionServicio') {
							VersionServicio = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'MessageBeautiful') {
							MessageBeautiful = parser.getText();
						} else if (text == 'StackTrace') {
							StackTrace = parser.readValueAs(Object.class);
						} else if (text == 'ErrorLevel') {
							ErrorLevel = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Messages consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public SummaryDetail SummaryDetail {get;set;} 
	public Boolean HasError {get;set;} 
	public Boolean HasWarning {get;set;} 
	public Boolean HasInformation {get;set;} 
	public List<Messages> Messages {get;set;} 

	public SCEndosoFormaPagoResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'SummaryDetail') {
						SummaryDetail = new SummaryDetail(parser);
					} else if (text == 'HasError') {
						HasError = parser.getBooleanValue();
					} else if (text == 'HasWarning') {
						HasWarning = parser.getBooleanValue();
					} else if (text == 'HasInformation') {
						HasInformation = parser.getBooleanValue();
					} else if (text == 'Messages') {
						Messages = arrayOfMessages(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoFormaPagoResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static SCEndosoFormaPagoResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoFormaPagoResponse(parser);
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
	

    private static List<Messages> arrayOfMessages(System.JSONParser p) {
        List<Messages> res = new List<Messages>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Messages(p));
        }
        return res;
    }
}